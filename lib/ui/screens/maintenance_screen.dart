import 'package:flutter/material.dart';
import '../../models/app_settings.dart';
import '../../l10n/app_localizations.dart';

/// شاشة الصيانة - تظهر عندما يكون التطبيق في وضع الصيانة
/// UI راقي وجميل مع رسوم متحركة
class MaintenanceScreen extends StatelessWidget {
  final AppSettings settings;

  const MaintenanceScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    try {
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;

      // Validate settings
      if (settings.maintenanceMessage.isEmpty) {
        _handleMaintenanceError(context, 'Maintenance message is empty');
      }

      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1A237E), // Dark blue
                      const Color(0xFF283593),
                      const Color(0xFF3F51B5),
                    ]
                  : [
                      const Color(0xFF667eea), // Purple blue
                      const Color(0xFF764ba2), // Purple
                      const Color(0xFFf093fb), // Pink
                    ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // أيقونة متحركة
                    _buildAnimatedIcon(isDark),

                    const SizedBox(height: 40),

                    // العنوان
                    _buildTitle(context),

                    const SizedBox(height: 16),

                    // الرسالة
                    _buildMaintenanceMessage(context, isDark),

                    const SizedBox(height: 40),

                    // معلومات الدعم
                    _buildSupportCard(context, isDark),

                    const SizedBox(height: 24),

                    // نص إضافي
                    _buildPatienceMessage(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      _handleMaintenanceError(context, 'Error building maintenance screen: $e');
      return _buildErrorFallback(context);
    }
  }

  // Enhanced helper methods with error handling
  Widget _buildTitle(BuildContext context) {
    try {
      return Text(
        AppLocalizations.of(context)!.maintenanceMode,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(offset: const Offset(0, 2), blurRadius: 8, color: Colors.black.withValues(alpha: 0.3))],
        ),
        textAlign: TextAlign.center,
      );
    } catch (e) {
      return const Text(
        '🔧 Maintenance Mode',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _buildMaintenanceMessage(BuildContext context, bool isDark) {
    try {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          children: [
            Text(
              settings.maintenanceMessage.isNotEmpty ? settings.maintenanceMessage : 'System is currently under maintenance. We\'ll be back shortly!',
              style: const TextStyle(fontSize: 18, color: Colors.white, height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // مؤشر التحميل
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(backgroundColor: Colors.white.withValues(alpha: 0.2), valueColor: AlwaysStoppedAnimation<Color>(isDark ? Colors.orange : Colors.white)),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
        child: const Text(
          'Unable to load maintenance message. Please try again later.',
          style: TextStyle(fontSize: 16, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _buildPatienceMessage(BuildContext context) {
    try {
      return Text(
        AppLocalizations.of(context)!.thankYouForYourPatience,
        style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
      );
    } catch (e) {
      return Text(
        'Thank you for your patience 💙',
        style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
      );
    }
  }

  void _handleMaintenanceError(BuildContext context, String error) {
    try {
      debugPrint('Maintenance Screen Error: $error');
      // You could also log to a service here
      // LoggingService.logError('MaintenanceScreen', error);
    } catch (e) {
      // Silent fail for error handling to prevent infinite loops
      debugPrint('Failed to handle maintenance error: $e');
    }
  }

  Widget _buildErrorFallback(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Maintenance Mode',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'We\'re currently working on improvements. Please check back later.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          return Transform.rotate(
            angle: value * 6.3, // Full rotation
            child: Icon(Icons.construction, size: 100, color: isDark ? Colors.orange : Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.email, color: isDark ? Colors.orange : Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.needHelp,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            settings.supportEmail,
            style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9), decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }
}
