import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Manages UI state persistence across app sessions
class StatePersistenceManager {
  static const String _scrollPositionKey = 'scroll_positions';
  static const String _filterStatesKey = 'filter_states';
  static const String _formDataKey = 'form_data';
  static const String _uiStateKey = 'ui_state';

  // Scroll position persistence
  Future<void> saveScrollPosition(String screenId, double position) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scrollData = prefs.getString(_scrollPositionKey) ?? '{}';
      final scrollPositions = Map<String, dynamic>.from(json.decode(scrollData));
      scrollPositions[screenId] = position;
      await prefs.setString(_scrollPositionKey, json.encode(scrollPositions));
    } catch (e) {
      // Silently handle errors
    }
  }

  Future<double> getScrollPosition(String screenId, {double defaultValue = 0.0}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scrollData = prefs.getString(_scrollPositionKey) ?? '{}';
      final scrollPositions = Map<String, dynamic>.from(json.decode(scrollData));
      return (scrollPositions[screenId] as num?)?.toDouble() ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  // Filter state persistence
  Future<void> saveFilterState(String screenId, Map<String, dynamic> filterState) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filterData = prefs.getString(_filterStatesKey) ?? '{}';
      final filterStates = Map<String, dynamic>.from(json.decode(filterData));
      filterStates[screenId] = filterState;
      await prefs.setString(_filterStatesKey, json.encode(filterStates));
    } catch (e) {
      // Silently handle errors
    }
  }

  Future<Map<String, dynamic>> getFilterState(String screenId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filterData = prefs.getString(_filterStatesKey) ?? '{}';
      final filterStates = Map<String, dynamic>.from(json.decode(filterData));
      return Map<String, dynamic>.from(filterStates[screenId] ?? {});
    } catch (e) {
      return {};
    }
  }

  // Form data persistence
  Future<void> saveFormData(String formId, Map<String, dynamic> formData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final formDataJson = prefs.getString(_formDataKey) ?? '{}';
      final allFormData = Map<String, dynamic>.from(json.decode(formDataJson));
      allFormData[formId] = formData;
      await prefs.setString(_formDataKey, json.encode(allFormData));
    } catch (e) {
      // Silently handle errors
    }
  }

  Future<Map<String, dynamic>> getFormData(String formId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final formDataJson = prefs.getString(_formDataKey) ?? '{}';
      final allFormData = Map<String, dynamic>.from(json.decode(formDataJson));
      return Map<String, dynamic>.from(allFormData[formId] ?? {});
    } catch (e) {
      return {};
    }
  }

  Future<void> clearFormData(String formId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final formDataJson = prefs.getString(_formDataKey) ?? '{}';
      final allFormData = Map<String, dynamic>.from(json.decode(formDataJson));
      allFormData.remove(formId);
      await prefs.setString(_formDataKey, json.encode(allFormData));
    } catch (e) {
      // Silently handle errors
    }
  }

  // General UI state persistence
  Future<void> saveUIState(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uiStateData = prefs.getString(_uiStateKey) ?? '{}';
      final uiState = Map<String, dynamic>.from(json.decode(uiStateData));
      uiState[key] = value;
      await prefs.setString(_uiStateKey, json.encode(uiState));
    } catch (e) {
      // Silently handle errors
    }
  }

  Future<T?> getUIState<T>(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uiStateData = prefs.getString(_uiStateKey) ?? '{}';
      final uiState = Map<String, dynamic>.from(json.decode(uiStateData));
      return uiState[key] as T?;
    } catch (e) {
      return null;
    }
  }

  // Clear all persisted data
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_scrollPositionKey);
      await prefs.remove(_filterStatesKey);
      await prefs.remove(_formDataKey);
      await prefs.remove(_uiStateKey);
    } catch (e) {
      // Silently handle errors
    }
  }

  // Clear data for specific screen
  Future<void> clearScreenData(String screenId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear scroll position
      final scrollData = prefs.getString(_scrollPositionKey) ?? '{}';
      final scrollPositions = Map<String, dynamic>.from(json.decode(scrollData));
      scrollPositions.remove(screenId);
      await prefs.setString(_scrollPositionKey, json.encode(scrollPositions));

      // Clear filter state
      final filterData = prefs.getString(_filterStatesKey) ?? '{}';
      final filterStates = Map<String, dynamic>.from(json.decode(filterData));
      filterStates.remove(screenId);
      await prefs.setString(_filterStatesKey, json.encode(filterStates));
    } catch (e) {
      // Silently handle errors
    }
  }
}
