import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/services/app_logging.dart';
import 'package:tazbeet/ui/screens/main_screen.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../models/user.dart';

class ProfileScreen extends StatefulWidget {
  final bool isProfileCompletion;

  const ProfileScreen({super.key, this.isProfileCompletion = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  DateTime? _birthday;
  String? _profileImageUrl;
  File? _profileImageFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    // Load user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = context.read<UserBloc>().state;
      if (userState is! UserLoaded) {
        // Load user if not already loaded
        final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          context.read<UserBloc>().add(LoadUser(/* firebaseUser.uid */));
        }
      } else {
        _updateUserData(userState.user);
      }
    });
  }

  void _updateUserData(User user) {
    setState(() {
      _nameController.text = user.name;
      _birthday = user.birthday;
      _profileImageUrl = user.profileImageUrl;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      // Check and request permissions for gallery access
      PermissionStatus status;
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        status = await Permission.photos.request();
      } else {
        // For Android and other platforms
        status = await Permission.storage.request();
      }

      if (status.isDenied || status.isPermanentlyDenied) {
        // Handle permission denial
        AppLogging.logInfo('Gallery permission denied', name: '_pickImage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gallery permission is required to select profile image'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () {
                openAppSettings();
              },
            ),
          ),
        );
        return;
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (pickedFile != null) {
        setState(() {
          _profileImageFile = File(pickedFile.path);
          _profileImageUrl = null; // Clear URL if new image picked
        });
        AppLogging.logInfo('Image picked successfully: ${pickedFile.path}', name: '_pickImage');
      } else {
        AppLogging.logInfo('No image selected', name: '_pickImage');
      }
    } catch (e) {
      AppLogging.logError('Error picking image: $e', name: '_pickImage', error: e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to access gallery. Please try again.')));
    }
  }

  Future<String?> _uploadProfileImage(String userId) async {
    if (_profileImageFile == null) {
      AppLogging.logInfo('No profile image file selected for upload', name: '_uploadProfileImage');
      return null;
    }

    AppLogging.logInfo('Starting profile image upload for user: $userId', name: '_uploadProfileImage');

    try {
      // Create a unique filename
      final fileName = '${userId}_profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(_profileImageFile!.path)}';
      AppLogging.logInfo('Generated filename: $fileName', name: '_uploadProfileImage');

      // Create reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');
      AppLogging.logInfo('Storage reference created: profile_images/$fileName', name: '_uploadProfileImage');

      // Upload file
      AppLogging.logInfo('Starting file upload...', name: '_uploadProfileImage');
      final uploadTask = storageRef.putFile(_profileImageFile!);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        AppLogging.logInfo('Upload progress: ${progress.toStringAsFixed(1)}%', name: '_uploadProfileImage');
      });

      // Wait for upload to complete
      AppLogging.logInfo('Waiting for upload completion...', name: '_uploadProfileImage');
      final snapshot = await uploadTask.whenComplete(() => null);
      AppLogging.logInfo('Upload task completed', name: '_uploadProfileImage');

      // Get download URL
      AppLogging.logInfo('Getting download URL...', name: '_uploadProfileImage');
      final downloadUrl = await snapshot.ref.getDownloadURL();

      AppLogging.logInfo('Profile image uploaded successfully: $downloadUrl', name: '_uploadProfileImage');
      return downloadUrl;
    } catch (e) {
      AppLogging.logError('Error uploading profile image: $e', name: '_uploadProfileImage', error: e);

      // Handle specific platform exceptions
      String errorMessage = 'Failed to upload image';
      if (e.toString().contains('channel-error')) {
        errorMessage = 'Connection error. Please check your internet connection and try again.';
      } else if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied. Please check your Firebase Storage permissions.';
      } else if (e.toString().contains('unauthorized')) {
        errorMessage = 'Authentication error. Please log in again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return null;
    }
  }

  Future<void> _selectBirthday() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(context: context, initialDate: _birthday ?? DateTime(now.year - 18), firstDate: DateTime(1900), lastDate: now);
    if (pickedDate != null) {
      setState(() {
        _birthday = pickedDate;
      });
    }
  }

  void _saveProfile() async {
    AppLogging.logInfo('Starting profile save process', name: '_saveProfile');

    // Additional validation for profile completion
    if (widget.isProfileCompletion) {
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name is required to complete your profile')));
        return;
      }
      if (_birthday == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Birthday is required to complete your profile')));
        return;
      }
    }

    if (_formKey.currentState?.validate() ?? false) {
      AppLogging.logInfo('Form validation passed', name: '_saveProfile');
      final userState = context.read<UserBloc>().state;
      if (userState is UserLoaded) {
        AppLogging.logInfo('User state is loaded, proceeding with save', name: '_saveProfile');

        // Show loading state during upload
        setState(() => _isUploading = true);
        AppLogging.logInfo('Set uploading state to true', name: '_saveProfile');

        String? newImageUrl = _profileImageUrl;
        AppLogging.logInfo('Initial image URL: $newImageUrl', name: '_saveProfile');

        // Upload profile image if a new file is selected
        if (_profileImageFile != null) {
          AppLogging.logInfo('New profile image file detected, starting upload', name: '_saveProfile');
          final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
          if (firebaseUser != null) {
            AppLogging.logInfo('Firebase user authenticated: ${firebaseUser.uid}', name: '_saveProfile');
            newImageUrl = await _uploadProfileImage(firebaseUser.uid);
            if (newImageUrl == null) {
              // Upload failed - show error and don't proceed with save
              AppLogging.logInfo('Image upload failed, aborting profile save', name: '_saveProfile');
              setState(() => _isUploading = false);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to upload image. Please try again.')));
              return; // Don't save profile if image upload failed
            } else {
              AppLogging.logInfo('Image upload successful, new URL: $newImageUrl', name: '_saveProfile');
            }
          } else {
            // No authenticated user - show error
            AppLogging.logInfo('No authenticated Firebase user found', name: '_saveProfile');
            setState(() => _isUploading = false);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not authenticated')));
            return;
          }
        } else {
          AppLogging.logInfo('No new profile image to upload', name: '_saveProfile');
        }

        setState(() => _isUploading = false);
        AppLogging.logInfo('Set uploading state to false', name: '_saveProfile');

        final updatedUser = userState.user.copyWith(name: _nameController.text.trim(), birthday: _birthday, profileImageUrl: newImageUrl, updatedAt: DateTime.now());
        AppLogging.logInfo('Created updated user object: ${updatedUser.toJson()}', name: '_saveProfile');
        context.read<UserBloc>().add(UpdateUser(updatedUser));
        AppLogging.logInfo('Dispatched UpdateUser event', name: '_saveProfile');

        if (widget.isProfileCompletion) {
          // Update auth state to authenticated
          context.read<AuthBloc>().add(AuthProfileCompleted());
          AppLogging.logInfo('Dispatched AuthProfileCompleted event', name: '_saveProfile');

          // Navigate to home screen after profile completion
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
          AppLogging.logInfo('Navigated to home screen after profile completion', name: '_saveProfile');
        } else {
          // Normal profile editing - go back
          Navigator.of(context).pop();
          AppLogging.logInfo('Navigated back from profile screen', name: '_saveProfile');
        }
      } else {
        AppLogging.logInfo('User state is not loaded: $userState', name: '_saveProfile');
      }
    } else {
      AppLogging.logInfo('Profile form validation failed', name: '_saveProfile');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.pleaseFixErrors)));
    }
  }

  Widget _buildProfileImage() {
    if (_profileImageFile != null) {
      return CircleAvatar(radius: 50, backgroundImage: FileImage(_profileImageFile!));
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          _profileImageUrl!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50));
          },
        ),
      );
    } else {
      return CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.profileScreenTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            AppLogging.logInfo('User error: ${state.message}', name: 'ProfileScreen');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is UserLoaded) {
            // Update UI with loaded user data
            _updateUserData(state.user);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      _buildProfileImage(),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: const Icon(Icons.edit, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.nameLabel, border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.nameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: _selectBirthday,
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.birthdayLabel, border: const OutlineInputBorder(), suffixIcon: const Icon(Icons.calendar_today)),
                    child: Text(
                      _birthday != null ? '${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}' : AppLocalizations.of(context)!.selectBirthday,
                      style: TextStyle(color: _birthday != null ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withAlpha(100)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    final isLoading = (state is UserLoading) || _isUploading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _saveProfile,
                      child: isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                          : Text(AppLocalizations.of(context)!.saveButton),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
