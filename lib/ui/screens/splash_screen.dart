import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/auth/auth_state.dart';
import 'package:tazbeet/blocs/auth/auth_bloc.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/ui/screens/home_screen.dart';
import 'package:tazbeet/ui/screens/login_screen.dart';
import 'package:tazbeet/ui/screens/profile_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _textController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _fadeController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));

    _logoRotationAnimation = Tween<double>(begin: -0.5, end: 0.0).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));

    // Text animations
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _textController.forward();
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated || state is AuthUnauthenticated || state is AuthProfileIncomplete) {
          Future.delayed(const Duration(milliseconds: 3500), () {
            if (mounted) {
              Widget nextScreen;
              if (state is AuthAuthenticated) {
                nextScreen = const HomeScreen();
              } else if (state is AuthProfileIncomplete) {
                nextScreen = const ProfileScreen(isProfileCompletion: true);
              } else {
                nextScreen = const LoginScreen();
              }

              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOutCubic;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(position: offsetAnimation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 800),
                ),
              );
            }
          });
        }
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: Listenable.merge([_logoController, _textController, _fadeController]),
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.8), Theme.of(context).colorScheme.secondary.withValues(alpha: 0.6), Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.4)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Animated background particles
                    ...List.generate(15, (index) {
                      return Positioned(
                        left: (index * 60.0) % MediaQuery.of(context).size.width,
                        top: (index * 80.0) % MediaQuery.of(context).size.height,
                        child: AnimatedOpacity(
                          opacity: (_logoController.value * 0.3).clamp(0.0, 1.0),
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            width: 4 + (index % 3) * 2.0,
                            height: 4 + (index % 3) * 2.0,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                          ),
                        ),
                      );
                    }),

                    // Main content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo/Icon animation
                          Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Transform.rotate(
                              angle: _logoRotationAnimation.value,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.9), Colors.white.withValues(alpha: 0.7)]),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 5)],
                                ),
                                child: Icon(Icons.task_alt, size: 60, color: Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // App name
                          SlideTransition(
                            position: _textSlideAnimation,
                            child: Opacity(
                              opacity: _textOpacityAnimation.value,
                              child: Text(
                                'Tazbeet',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                  shadows: [Shadow(color: Colors.black.withValues(alpha: 0.3), offset: const Offset(2, 2), blurRadius: 4)],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Tagline
                          SlideTransition(
                            position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
                              CurvedAnimation(
                                parent: _textController,
                                curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
                              ),
                            ),
                            child: Opacity(
                              opacity: Tween<double>(begin: 0.0, end: 1.0)
                                  .animate(
                                    CurvedAnimation(
                                      parent: _textController,
                                      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
                                    ),
                                  )
                                  .value,
                              child: Text(
                                AppLocalizations.of(context)!.splashTagline,
                                style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w300, letterSpacing: 1),
                              ),
                            ),
                          ),

                          const SizedBox(height: 60),

                          // Loading indicator
                          Opacity(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(
                                  CurvedAnimation(
                                    parent: _textController,
                                    curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
                                  ),
                                )
                                .value,
                            child: Transform.scale(
                              scale: Tween<double>(begin: 0.5, end: 1.0)
                                  .animate(
                                    CurvedAnimation(
                                      parent: _textController,
                                      curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
                                    ),
                                  )
                                  .value,
                              child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.8)))),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom branding
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Opacity(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(
                                  CurvedAnimation(
                                    parent: _textController,
                                    curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
                                  ),
                                )
                                .value,
                            child: Text(
                              AppLocalizations.of(context)!.splashBranding,
                              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w300),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Opacity(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(
                                  CurvedAnimation(
                                    parent: _textController,
                                    curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
                                  ),
                                )
                                .value,
                            child: Text(AppLocalizations.of(context)!.splashVersion, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
