import 'package:flutter/material.dart';
import '../../models/app_settings.dart';

/// شاشة الصيانة - تظهر عندما يكون التطبيق في وضع الصيانة
/// UI راقي وجميل مع رسوم متحركة
class MaintenanceScreen extends StatelessWidget {
  final AppSettings settings;

  const MaintenanceScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                  Text(
                    '🔧 وضع الصيانة',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(offset: const Offset(0, 2), blurRadius: 8, color: Colors.black.withOpacity(0.3))],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // الرسالة
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Column(
                      children: [
                        Text(
                          settings.maintenanceMessage,
                          style: const TextStyle(fontSize: 18, color: Colors.white, height: 1.6),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        // مؤشر التحميل
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(backgroundColor: Colors.white.withOpacity(0.2), valueColor: AlwaysStoppedAnimation<Color>(isDark ? Colors.orange : Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // معلومات الدعم
                  _buildSupportCard(isDark),

                  const SizedBox(height: 24),

                  // نص إضافي
                  Text(
                    'شكراً لصبرك 💙',
                    style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
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
        color: Colors.white.withOpacity(0.2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))],
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

  Widget _buildSupportCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.email, color: isDark ? Colors.orange : Colors.white, size: 28),
          const SizedBox(height: 12),
          const Text(
            'تحتاج مساعدة؟',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            settings.supportEmail,
            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9), decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }
}
