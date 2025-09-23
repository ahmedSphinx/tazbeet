import 'dart:io';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  DateTime? _birthday;
  String? _profileImageUrl;
  File? _profileImageFile;

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
    _nameController.text = user.name;
    _birthday = user.birthday;
    _profileImageUrl = user.profileImageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
        _profileImageUrl = null; // Clear URL if new image picked
      });
    }
  }

  Future<void> _selectBirthday() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _birthday = pickedDate;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final userState = context.read<UserBloc>().state;
      if (userState is UserLoaded) {
        final updatedUser = userState.user.copyWith(
          name: _nameController.text.trim(),
          birthday: _birthday,
          // For profileImageUrl, if _profileImageFile is set, upload logic needed
          // For now, keep existing URL or null
          profileImageUrl: _profileImageUrl,
          updatedAt: DateTime.now(),
        );
        dev.log('Saving user profile: ${updatedUser.toJson()}');
        context.read<UserBloc>().add(UpdateUser(updatedUser));
       
        Navigator.of(context).pop();
      }
    } else {
      dev.log('Profile form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).pleaseFixErrors)),
      );
    }
  }

  Widget _buildProfileImage() {
    if (_profileImageFile != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_profileImageFile!),
      );
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(_profileImageUrl!),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        child: Icon(Icons.person, size: 50),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).profileScreenTitle),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            dev.log('User error: ${state.message}', name: 'ProfileScreen');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
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
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).nameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context).nameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: _selectBirthday,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).birthdayLabel,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _birthday != null
                          ? '${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}'
                          : AppLocalizations.of(context).selectBirthday,
                      style: TextStyle(
                        color: _birthday != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurface.withAlpha(100),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    final isLoading = state is UserLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _saveProfile,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(AppLocalizations.of(context).saveButton),
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
