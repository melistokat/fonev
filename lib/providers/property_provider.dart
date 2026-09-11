import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _properties = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get properties => _properties;
  bool get isLoading => _isLoading;

  Future<void> loadProperties() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
      await _firestore.collection('properties').get();

      _properties = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    } catch (e) {
      debugPrint('Error loading properties: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProperty(
      Map<String, dynamic> propertyData,
      ) async {
    try {
      await _firestore
          .collection('properties')
          .add(propertyData);

      await loadProperties();
    } catch (e) {
      debugPrint('Error adding property: $e');
    }
  }

  Future<void> deleteProperty(String id) async {
    try {
      await _firestore
          .collection('properties')
          .doc(id)
          .delete();

      await loadProperties();
    } catch (e) {
      debugPrint('Error deleting property: $e');
    }
  }

  Future<void> updateProperty(
      String id,
      Map<String, dynamic> propertyData,
      ) async {
    try {
      await _firestore
          .collection('properties')
          .doc(id)
          .update(propertyData);

      await loadProperties();
    } catch (e) {
      debugPrint('Error updating property: $e');
    }
  }
}