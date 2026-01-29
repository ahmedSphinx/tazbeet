import 'package:flutter/material.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

class LocalizationUtils {
  static AppLocalizations? of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  static String getString(BuildContext context, String Function(AppLocalizations) getter, {String fallback = ''}) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return fallback;
    try {
      return getter(l10n);
    } catch (e) {
      return fallback;
    }
  }

  static bool isRTL(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return l10n?.localeName == 'ar';
  }

  static TextDirection getTextDirection(BuildContext context) {
    return isRTL(context) ? TextDirection.rtl : TextDirection.ltr;
  }
}
