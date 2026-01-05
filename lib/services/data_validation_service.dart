import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'app_logging_service.dart';

/// Comprehensive data validation and security system
class DataValidationService {
  static final DataValidationService _instance = DataValidationService._internal();
  factory DataValidationService() => _instance;
  DataValidationService._internal();

  final Map<String, ValidationRule> _validationRules = {};
  final List<SecurityEvent> _securityEvents = [];
  final Map<String, int> _failedAttempts = {};

  // Security thresholds
  static const int maxFailedAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const int maxSecurityEvents = 1000;

  void initialize() {
    _initializeDefaultRules();
    AppLogging.logInfo('Data validation service initialized');
  }

  /// Validate data against multiple rules
  ValidationResult validateData(dynamic data, String dataType, {Map<String, dynamic>? context}) {
    final rules = _validationRules[dataType];
    if (rules == null) {
      return ValidationResult.success();
    }

    final errors = <String>[];
    final warnings = <String>[];

    for (final rule in rules.rules) {
      try {
        final result = rule.validate(data, context);
        if (!result.isValid) {
          if (result.severity == ValidationSeverity.error) {
            errors.add(result.message ?? 'Validation failed');
          } else {
            warnings.add(result.message ?? 'Validation warning');
          }
        }
      } catch (e, stackTrace) {
        AppLogging.logError('Validation rule failed', error: e, stackTrace: stackTrace);
        errors.add('Validation error: ${e.toString()}');
      }
    }

    final isValid = errors.isEmpty;
    final validationResult = ValidationResult(isValid: isValid, errors: errors, warnings: warnings, dataType: dataType, timestamp: DateTime.now());

    if (!isValid) {
      _recordSecurityEvent(SecurityEvent(type: SecurityEventType.validationFailure, message: 'Data validation failed for $dataType', severity: SecuritySeverity.medium, details: {'errors': errors, 'warnings': warnings}));
    }

    return validationResult;
  }

  /// Sanitize input data
  dynamic sanitizeData(dynamic data, String dataType) {
    if (data is String) {
      return _sanitizeString(data);
    } else if (data is Map<String, dynamic>) {
      return _sanitizeMap(data, dataType);
    } else if (data is List) {
      return _sanitizeList(data, dataType);
    } else if (data is int || data is double) {
      return _sanitizeNumber(data);
    }

    return data;
  }

  /// Validate and sanitize user input
  ValidationResult validateUserInput(String input, {InputType type = InputType.text}) {
    final errors = <String>[];
    final warnings = <String>[];

    // Basic checks
    if (input.isEmpty) {
      errors.add('Input cannot be empty');
    }

    // Length checks
    if (input.length > 1000) {
      errors.add('Input too long (max 1000 characters)');
    }

    // Type-specific checks
    switch (type) {
      case InputType.email:
        if (!_isValidEmail(input)) {
          errors.add('Invalid email format');
        }
        break;
      case InputType.password:
        if (input.length < 8) {
          errors.add('Password must be at least 8 characters');
        }
        if (!_containsUppercase(input)) {
          warnings.add('Password should contain uppercase letters');
        }
        if (!_containsNumbers(input)) {
          warnings.add('Password should contain numbers');
        }
        if (!_containsSpecialChars(input)) {
          warnings.add('Password should contain special characters');
        }
        break;
      case InputType.username:
        if (input.length < 3) {
          errors.add('Username must be at least 3 characters');
        }
        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(input)) {
          errors.add('Username can only contain letters, numbers, and underscores');
        }
        break;
      case InputType.url:
        if (!_isValidUrl(input)) {
          errors.add('Invalid URL format');
        }
        break;
      case InputType.text:
        // Basic text validation already done above
        break;
    }

    // Security checks
    if (_containsSuspiciousContent(input)) {
      errors.add('Input contains suspicious content');
      _recordSecurityEvent(SecurityEvent(type: SecurityEventType.suspiciousInput, message: 'Suspicious input detected', severity: SecuritySeverity.high, details: {'input': input.substring(0, 100)}));
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors, warnings: warnings, dataType: 'user_input', timestamp: DateTime.now());
  }

  /// Check for SQL injection patterns
  bool containsSqlInjection(String input) {
    final sqlPatterns = [
      r"('|(\\')|(;)|(\\;))",
      r"((\%27)|(\'))((\%6F)|o|(\%4F))((\%72)|r|(\%52))",
      r"((\%27)|(\'))union",
      r"exec(\s|\+)+(s|x)p\w+",
      r"UNION.*SELECT",
      r"INSERT.*INTO",
      r"DELETE.*FROM",
      r"UPDATE.*SET",
      r"DROP.*TABLE",
    ];

    for (final pattern in sqlPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(input)) {
        _recordSecurityEvent(SecurityEvent(type: SecurityEventType.sqlInjection, message: 'SQL injection pattern detected', severity: SecuritySeverity.critical, details: {'pattern': pattern}));
        return true;
      }
    }

    return false;
  }

  /// Check for XSS patterns
  bool containsXss(String input) {
    final xssPatterns = [r"<script[^>]*>.*?</script>", r"javascript:", r"on\w+\s*=", r"<iframe", r"<object", r"<embed", r"<link", r"<meta", r"<style", r"<img.*src", r"eval\s*\(", r"expression\s*\("];

    for (final pattern in xssPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(input)) {
        _recordSecurityEvent(SecurityEvent(type: SecurityEventType.xss, message: 'XSS pattern detected', severity: SecuritySeverity.critical, details: {'pattern': pattern}));
        return true;
      }
    }

    return false;
  }

  /// Generate secure hash
  String generateSecureHash(String data, {String salt = ''}) {
    final bytes = utf8.encode(data + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify data integrity
  bool verifyDataIntegrity(String data, String hash, {String salt = ''}) {
    final computedHash = generateSecureHash(data, salt: salt);
    return computedHash == hash;
  }

  /// Rate limiting check
  bool isRateLimited(String identifier, {int maxAttempts = 10, Duration window = const Duration(minutes: 1)}) {
    final key = identifier;
    final attempts = _failedAttempts[key] ?? 0;

    if (attempts >= maxAttempts) {
      _recordSecurityEvent(
        SecurityEvent(type: SecurityEventType.rateLimitExceeded, message: 'Rate limit exceeded for $identifier', severity: SecuritySeverity.high, details: {'attempts': attempts, 'maxAttempts': maxAttempts}),
      );
      return true;
    }

    return false;
  }

  /// Record failed attempt
  void recordFailedAttempt(String identifier) {
    _failedAttempts[identifier] = (_failedAttempts[identifier] ?? 0) + 1;

    // Reset after lockout duration
    Future.delayed(lockoutDuration, () {
      _failedAttempts.remove(identifier);
    });
  }

  /// Get security report
  Map<String, dynamic> getSecurityReport() {
    final now = DateTime.now();
    final recentEvents = _securityEvents.where((e) => now.difference(e.timestamp) < const Duration(hours: 24)).toList();

    final eventsByType = <SecurityEventType, int>{};
    final eventsBySeverity = <SecuritySeverity, int>{};

    for (final event in recentEvents) {
      eventsByType[event.type] = (eventsByType[event.type] ?? 0) + 1;
      eventsBySeverity[event.severity] = (eventsBySeverity[event.severity] ?? 0) + 1;
    }

    return {
      'total_events': recentEvents.length,
      'events_by_type': eventsByType.map((k, v) => MapEntry(k.name, v)),
      'events_by_severity': eventsBySeverity.map((k, v) => MapEntry(k.name, v)),
      'critical_events': eventsBySeverity[SecuritySeverity.critical] ?? 0,
      'high_events': eventsBySeverity[SecuritySeverity.high] ?? 0,
      'failed_attempts': _failedAttempts,
      'validation_rules_count': _validationRules.length,
      'security_score': _calculateSecurityScore(eventsBySeverity),
    };
  }

  /// Add custom validation rule
  void addValidationRule(String dataType, ValidationRuleItem rule) {
    _validationRules.putIfAbsent(dataType, () => ValidationRule([])).rules.add(rule);
    AppLogging.logInfo('Added validation rule for $dataType');
  }

  /// Clear security events
  void clearSecurityEvents() {
    _securityEvents.clear();
    _failedAttempts.clear();
    AppLogging.logInfo('Security events cleared');
  }

  // Private methods

  void _initializeDefaultRules() {
    // Task validation rules
    _validationRules['task'] = ValidationRule([
      ValidationRuleItem(
        validate: (data, context) {
          if (data is Map && data['title'] != null) {
            final title = data['title'] as String;
            return ValidationResultItem(isValid: title.isNotEmpty && title.length <= 100, message: title.isEmpty ? 'Task title cannot be empty' : 'Task title too long', severity: ValidationSeverity.error);
          }
          return ValidationResultItem(isValid: true);
        },
      ),
      ValidationRuleItem(
        validate: (data, context) {
          if (data is Map && data['dueDate'] != null) {
            final dueDate = data['dueDate'];
            if (dueDate is String) {
              final date = DateTime.tryParse(dueDate);
              return ValidationResultItem(isValid: date != null && !date.isBefore(DateTime.now().subtract(const Duration(days: 1))), message: 'Invalid due date', severity: ValidationSeverity.error);
            }
          }
          return ValidationResultItem(isValid: true);
        },
      ),
    ]);

    // User validation rules
    _validationRules['user'] = ValidationRule([
      ValidationRuleItem(
        validate: (data, context) {
          if (data is Map && data['email'] != null) {
            final email = data['email'] as String;
            return ValidationResultItem(isValid: _isValidEmail(email), message: 'Invalid email format', severity: ValidationSeverity.error);
          }
          return ValidationResultItem(isValid: true);
        },
      ),
    ]);
  }

  void _recordSecurityEvent(SecurityEvent event) {
    _securityEvents.add(event);
    if (_securityEvents.length > maxSecurityEvents) {
      _securityEvents.removeAt(0);
    }

    AppLogging.logWarning('Security event: ${event.type.name} - ${event.message}');
  }

  String _sanitizeString(String input) {
    return input.trim().replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false), '').replaceAll(RegExp(r'javascript:', caseSensitive: false), '').replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '');
  }

  Map<String, dynamic> _sanitizeMap(Map<String, dynamic> data, String dataType) {
    final sanitized = <String, dynamic>{};
    for (final entry in data.entries) {
      sanitized[entry.key] = sanitizeData(entry.value, dataType);
    }
    return sanitized;
  }

  List<dynamic> _sanitizeList(List<dynamic> data, String dataType) {
    return data.map((item) => sanitizeData(item, dataType)).toList();
  }

  dynamic _sanitizeNumber(dynamic data) {
    if (data is double) {
      // Check for NaN or infinity
      if (data.isNaN || data.isInfinite) {
        return 0.0;
      }
      // Clamp to reasonable range
      return data.clamp(-1000000.0, 1000000.0);
    } else if (data is int) {
      return data.clamp(-1000000, 1000000);
    }
    return data;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  bool _containsUppercase(String input) {
    return input.contains(RegExp(r'[A-Z]'));
  }

  bool _containsNumbers(String input) {
    return input.contains(RegExp(r'[0-9]'));
  }

  bool _containsSpecialChars(String input) {
    return input.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  bool _containsSuspiciousContent(String input) {
    final suspiciousPatterns = [r'<script', r'javascript:', r'onload=', r'onerror=', r'eval(', r'expression(', r'@import', r'vbscript:'];

    for (final pattern in suspiciousPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  double _calculateSecurityScore(Map<SecuritySeverity, int> eventsBySeverity) {
    final critical = eventsBySeverity[SecuritySeverity.critical] ?? 0;
    final high = eventsBySeverity[SecuritySeverity.high] ?? 0;
    final medium = eventsBySeverity[SecuritySeverity.medium] ?? 0;
    final low = eventsBySeverity[SecuritySeverity.low] ?? 0;

    // Start with 100 and deduct points based on severity
    double score = 100.0;
    score -= critical * 20;
    score -= high * 10;
    score -= medium * 5;
    score -= low * 1;

    return score.clamp(0.0, 100.0);
  }
}

// Supporting classes

class ValidationRule {
  final List<ValidationRuleItem> rules;

  ValidationRule(this.rules);
}

class ValidationRuleItem {
  final ValidationResultItem Function(dynamic data, Map<String, dynamic>? context) validate;

  ValidationRuleItem({required this.validate});
}

class ValidationResultItem {
  final bool isValid;
  final String? message;
  final ValidationSeverity severity;

  ValidationResultItem({required this.isValid, this.message, this.severity = ValidationSeverity.error});
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final String dataType;
  final DateTime timestamp;

  ValidationResult({required this.isValid, this.errors = const [], this.warnings = const [], required this.dataType, required this.timestamp});

  static ValidationResult success() {
    return ValidationResult(isValid: true, dataType: 'unknown', timestamp: DateTime.now());
  }
}

enum ValidationSeverity { error, warning, info }

enum InputType { text, email, password, username, url }

enum SecurityEventType { validationFailure, suspiciousInput, sqlInjection, xss, rateLimitExceeded, authenticationFailure, dataCorruption }

enum SecuritySeverity { low, medium, high, critical }

class SecurityEvent {
  final SecurityEventType type;
  final String message;
  final SecuritySeverity severity;
  final DateTime timestamp;
  final Map<String, dynamic>? details;

  SecurityEvent({required this.type, required this.message, required this.severity, this.details}) : timestamp = DateTime.now();
}
