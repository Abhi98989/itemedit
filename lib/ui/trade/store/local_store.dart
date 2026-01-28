import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/product_class.dart';

class LocalStore {
  static const String _draftsKey = 'saved_drafts';
  Future<List<DraftOrder>> loadDrafts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftsJson = prefs.getString(_draftsKey);

      if (draftsJson != null) {
        final List<dynamic> decoded = jsonDecode(draftsJson);
        return decoded.map((json) => DraftOrder.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  /// Save draft orders to local storage
  Future<bool> saveDrafts(List<DraftOrder> draftOrders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftsJson = jsonEncode(
        draftOrders.map((d) => d.toJson()).toList(),
      );
      await prefs.setString(_draftsKey, draftsJson);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  /// Add a new draft order to the existing list
  Future<bool> addDraft(DraftOrder newDraft) async {
    try {
      final existingDrafts = await loadDrafts();
      existingDrafts.add(newDraft);
      return await saveDrafts(existingDrafts);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  /// Remove a draft order by ID
  Future<bool> removeDraft(String draftId) async {
    try {
      final existingDrafts = await loadDrafts();
      existingDrafts.removeWhere((draft) => draft.id == draftId);
      return await saveDrafts(existingDrafts);
    } catch (e) {
     log(e.toString());
      return false;
    }
  }

  /// Clear all draft orders from local storage
  Future<bool> clearAllDrafts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftsKey);
      return true;
    } catch (e) {
     log(e.toString());
      return false;
    }
  }

  /// Get the count of saved drafts
  Future<int> getDraftCount() async {
    final drafts = await loadDrafts();
    return drafts.length;
  }
}
