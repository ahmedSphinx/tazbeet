// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tazbeet/blocs/auth/auth_bloc.dart';
import 'package:tazbeet/blocs/auth/auth_event.dart';
import 'package:tazbeet/blocs/auth/auth_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/services/app_logging_service.dart';
import 'package:tazbeet/services/firebase_service_wrapper.dart';
import 'package:tazbeet/ui/themes/app_themes.dart';
import 'package:tazbeet/ui/screens/home/main_screen.dart';
import 'package:tazbeet/ui/screens/registration_screen.dart';
import 'package:tazbeet/ui/widgets/floating_shapes.dart'; // We'll create this later
import 'package:tazbeet/ui/widgets/password_strength_indicator.dart'; // We'll create this later

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isBiometricAvailable = false;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));
    _animationController.forward();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      _isBiometricAvailable = await _localAuth.canCheckBiometrics && await _localAuth.isDeviceSupported();
    } catch (e) {
      _isBiometricAvailable = false;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark ? [const Color(0xFF0F172A), const Color(0xFF1E293B), const Color(0xFF334155)] : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)],
              ),
            ),
          ),

          // Floating shapes background
          Positioned.fill(child: FloatingShapes(color: Theme.of(context).colorScheme.primary, numberOfShapes: 8)),

          // Main content
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                setState(() => _isLoading = true);
              } else {
                setState(() => _isLoading = false);
              }

              // Handle successful authentication
              if (state is AuthAuthenticated) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainScreen()), (Route<dynamic> route) => false);
              }

              if (state is AuthError) {
                _showErrorSnackBar(context, state.message);
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return _buildLoginContent(context, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppThemes.getPrimaryGradient(Theme.of(context).brightness == Brightness.dark)),
      child: Center(
        child: AnimationConfiguration.staggeredList(
          position: 0,
          duration: const Duration(milliseconds: 600),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppThemes.getAccentGradient(Theme.of(context).brightness == Brightness.dark),
                      boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
                    ),
                    child: const Icon(Icons.task_alt, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Signing you in..',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(width: 40, height: 40, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginContent(BuildContext context, bool isDark) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: height * 0.05),
                // Animated Logo Section
                AnimationConfiguration.staggeredList(
                  position: 0,
                  duration: const Duration(milliseconds: 800),
                  child: SlideAnimation(
                    verticalOffset: 30.0,
                    child: FadeInAnimation(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppThemes.getPrimaryGradient(isDark),
                          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 25, spreadRadius: 5)],
                        ),
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: const Icon(Icons.task_alt, size: 60, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),

                // Animated Title Section
                AnimationConfiguration.staggeredList(
                  position: 1,
                  duration: const Duration(milliseconds: 800),
                  child: SlideAnimation(
                    verticalOffset: 30.0,
                    child: FadeInAnimation(
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.appTitle,
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, foreground: Paint()..shader = AppThemes.getPrimaryGradient(isDark).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Text(
                              'Your Personal Task Manager',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),

                // Animated Email/Password Form
                AnimationConfiguration.staggeredList(
                  position: 2,
                  duration: const Duration(milliseconds: 800),
                  child: SlideAnimation(
                    verticalOffset: 30.0,
                    child: FadeInAnimation(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildEmailField(),
                            const SizedBox(height: 20),
                            _buildPasswordField(),
                            //const SizedBox(height: 16),
                            //_buildRememberMeAndForgotPassword(),
                            const SizedBox(height: 32),
                            _buildLoginButton(),
                            const SizedBox(height: 24),
                            _buildRegisterLink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.04),

                // Animated Social Sign In
                AnimationConfiguration.staggeredList(
                  position: 3,
                  duration: const Duration(milliseconds: 800),
                  child: SlideAnimation(
                    verticalOffset: 30.0,
                    child: FadeInAnimation(child: Column(children: [_buildDivider(context), const SizedBox(height: 16), _buildAppleSignInButton(context), const SizedBox(height: 16), _buildGoogleSignInButton(context)])),
                  ),
                ),
                SizedBox(height: height * 0.05),

                // Animated Terms Text
                AnimationConfiguration.staggeredList(
                  position: 3,
                  duration: const Duration(milliseconds: 800),
                  child: SlideAnimation(
                    verticalOffset: 30.0,
                    child: FadeInAnimation(
                      child: Text(
                        'By signing in, you agree to our Terms of Service and Privacy Policy',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          try {
            HapticFeedback.mediumImpact();
            AppLogging.logInfo('Google Sign-In button tapped', name: 'LoginScreen');

            // Check if Firebase is initialized
            if (FirebaseServiceWrapper.firebaseAuth == null) {
              AppLogging.logError('Firebase Auth not initialized', name: 'LoginScreen');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Authentication service not available. Please try again.'), backgroundColor: Colors.red));
              return;
            }

            context.read<AuthBloc>().add(AuthSignInRequested());
          } catch (e) {
            AppLogging.logError('Error in Google Sign-In button', name: 'LoginScreen', error: e);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred. Please try again.'), backgroundColor: Colors.red));
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Image.asset('assets/images/google.png', height: 24)),
              Text(
                AppLocalizations.of(context)!.signInWithGoogle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppleSignInButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          try {
            HapticFeedback.mediumImpact();
            AppLogging.logInfo('Apple Sign-In button tapped', name: 'LoginScreen');

            // Check if Firebase is initialized
            if (FirebaseServiceWrapper.firebaseAuth == null) {
              AppLogging.logError('Firebase Auth not initialized', name: 'LoginScreen');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Authentication service not available. Please try again.'), backgroundColor: Colors.red));
              return;
            }

            context.read<AuthBloc>().add(AuthAppleSignInRequested());
          } catch (e) {
            AppLogging.logError('Error in Apple Sign-In button', name: 'LoginScreen', error: e);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred. Please try again.'), backgroundColor: Colors.red));
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.apple, color: Colors.white, size: 28),
              const SizedBox(width: 16),
              Text(
                AppLocalizations.of(context)!.signInWithApple,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  } /* 
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.apple,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Text(
                  AppLocalizations.of(context)!.signInWithApple,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
      ),

      child: IconButton(
        onPressed: () {
          context.read<AuthBloc>().add(AuthAppleSignInRequested());
        },
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apple, color: Colors.white),
            const SizedBox(width: 16),
            Text(AppLocalizations.of(context)!.signInWithA*pple, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
 */
  // Facebook sign-in UI removed

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.0), Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)])),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3), Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.0)])),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          _validateEmail();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [Theme.of(context).colorScheme.surface.withOpacity(0.7), Theme.of(context).colorScheme.surface.withOpacity(0.4)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), width: 1.5),
          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'your@email.com',
            errorText: _emailError,
            prefixIcon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _emailError != null ? Icons.error_outline : Icons.email_outlined,
                color: _emailError != null ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary.withOpacity(0.7),
                key: ValueKey(_emailError != null),
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
          onChanged: (value) {
            if (_emailError != null) {
              setState(() => _emailError = null);
            }
            // Add haptic feedback
            HapticFeedback.selectionClick();
          },
          validator: (value) => _validateEmail(),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          _validatePassword();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(colors: [Theme.of(context).colorScheme.surface.withOpacity(0.7), Theme.of(context).colorScheme.surface.withOpacity(0.4)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), width: 1.5),
              boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.shadow.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleLogin(),
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                errorText: _passwordError,
                prefixIcon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _passwordError != null ? Icons.error_outline : Icons.lock_outline,
                    color: _passwordError != null ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    key: ValueKey(_passwordError != null),
                  ),
                ),
                suffixIcon: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), key: ValueKey(_obscurePassword)),
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                    HapticFeedback.selectionClick();
                  },
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
              onChanged: (value) {
                if (_passwordError != null) {
                  setState(() => _passwordError = null);
                }
                // Add haptic feedback
                HapticFeedback.selectionClick();
                // Trigger rebuild for password strength
                setState(() {});
              },
              validator: (value) => _validatePassword(),
            ),
          ),
          if (_passwordController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: PasswordStrengthIndicator(password: _passwordController.text),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isLoading ? [] : [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5), spreadRadius: 0)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading
              ? null
              : () {
                  HapticFeedback.mediumImpact();
                  _handleLogin();
                },
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: _isLoading
                    ? [Theme.of(context).colorScheme.onSurface.withOpacity(0.3), Theme.of(context).colorScheme.onSurface.withOpacity(0.3)]
                    : [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isLoading
                      ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary)))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary),
                            ),
                            if (_isBiometricAvailable) ...[const SizedBox(width: 8), Icon(Icons.fingerprint, color: Theme.of(context).colorScheme.onPrimary)],
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      children: [
        // Remember Me Checkbox
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: _isLoading ? null : (value) => setState(() => _rememberMe = value ?? false),
              activeColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            Text('Remember me', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8))),
          ],
        ),
        const Spacer(),
        // Forgot Password Link
        TextButton(
          onPressed: _isLoading ? null : _handleForgotPassword,
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Text(
            'Forgot Password?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.dontHaveAccount, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                },
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Text(
            'Register',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  String? _validateEmail() {
    final value = _emailController.text.trim();
    if (value.isEmpty) {
      setState(() => _emailError = 'Please enter your email address');
      return _emailError;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      setState(() => _emailError = 'Please enter a valid email address');
      return _emailError;
    }
    setState(() => _emailError = null);
    return null;
  }

  String? _validatePassword() {
    final value = _passwordController.text;
    if (value.isEmpty) {
      setState(() => _passwordError = 'Please enter your password');
      return _passwordError;
    }
    if (value.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      return _passwordError;
    }
    setState(() => _passwordError = null);
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(AuthEmailSignInRequested(_emailController.text.trim(), _passwordController.text));
    }
  }

  void _handleForgotPassword() {
    // For now, show a simple dialog. In a real app, this would send a reset email
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: const Text('Password reset functionality will be implemented soon. Please contact support for assistance.'),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
