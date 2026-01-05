import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

/// Manages search functionality with debouncing, history, and suggestions
class SearchManager extends ChangeNotifier {
  Timer? _debounceTimer;
  String _searchQuery = '';
  bool _isSearching = false;
  List<String> _searchHistory = [];
  static const int _maxHistoryItems = 10;

  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;
  List<String> get searchHistory => List.unmodifiable(_searchHistory);
  List<String> get suggestions => _getSuggestions();

  void onSearchChanged(String value, {Duration debounceTime = const Duration(milliseconds: 300)}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceTime, () {
      _searchQuery = value.trim();
      if (_searchQuery.isNotEmpty) {
        _addToHistory(_searchQuery);
      }
      notifyListeners();
    });
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    if (!_isSearching) {
      _searchQuery = '';
      _debounceTimer?.cancel();
    }
    notifyListeners();
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _searchQuery = '';
    _isSearching = false;
    notifyListeners();
  }

  void setSearchImmediate(String query) {
    _debounceTimer?.cancel();
    _searchQuery = query.trim();
    if (_searchQuery.isNotEmpty) {
      _addToHistory(_searchQuery);
    }
    notifyListeners();
  }

  bool get hasActiveSearch => _searchQuery.isNotEmpty || _isSearching;

  Future<void> loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('search_history') ?? [];
      _searchHistory = history.take(_maxHistoryItems).toList();
      notifyListeners();
    } catch (e) {
      // Silently handle errors
    }
  }

  Future<void> _saveSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('search_history', _searchHistory);
    } catch (e) {
      // Silently handle errors
    }
  }

  void _addToHistory(String query) {
    if (query.trim().isEmpty) return;

    final trimmedQuery = query.trim();
    _searchHistory.remove(trimmedQuery); // Remove if exists
    _searchHistory.insert(0, trimmedQuery); // Add to front

    // Keep only the most recent items
    if (_searchHistory.length > _maxHistoryItems) {
      _searchHistory = _searchHistory.take(_maxHistoryItems).toList();
    }

    _saveSearchHistory();
  }

  void removeFromHistory(String query) {
    _searchHistory.remove(query);
    _saveSearchHistory();
    notifyListeners();
  }

  void clearHistory() {
    _searchHistory.clear();
    _saveSearchHistory();
    notifyListeners();
  }

  List<String> _getSuggestions() {
    if (_searchQuery.isEmpty) return _searchHistory;

    final query = _searchQuery.toLowerCase();
    final suggestions = <String>[];

    // Add matching history items
    for (final historyItem in _searchHistory) {
      if (historyItem.toLowerCase().contains(query)) {
        suggestions.add(historyItem);
        if (suggestions.length >= 5) break;
      }
    }

    return suggestions;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
