import 'package:flutter/material.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

/// Manages navigation state and logic for MainScreen
class NavigationController extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _isSearching = false;
  String _searchQuery = '';

  int get selectedIndex => _selectedIndex;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;

  void navigateToTab(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      _resetSearchState();
      notifyListeners();
    }
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    if (!_isSearching) {
      _searchQuery = '';
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void _resetSearchState() {
    _isSearching = false;
    _searchQuery = '';
  }

  String getAppBarTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_selectedIndex) {
      case 0:
        return l10n.appTitle;
      case 1:
        return l10n.progressSaved;
      case 2:
        return l10n.pomodoroSection;
      case 3:
        return l10n.allCategories;
      default:
        return l10n.moodTracking;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
