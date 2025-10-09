// ignore_for_file: avoid_print, deprecated_member_use, avoid_web_libraries_in_flutter

import 'package:flutter/foundation.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/Models/supply_model.dart';

import 'dart:html' as html;

class FirestoreOfficeSupplies {
  final FirestoreTransmitalHistoryRepo _transmitalHistoryRepo =
      FirestoreTransmitalHistoryRepo();

  void _newHistory(String id, String name, Map<String, dynamic> data) {
    // Find the item in the list by its ID
    final itemIndex = officeSuppliesList.indexWhere((item) => item['id'] == id);
    final history =
        officeSuppliesList[itemIndex]["history"] as List<Map<String, dynamic>>;

    data["id"] = history.length;

    officeSuppliesList[itemIndex]["history"].add(data);

    _transmitalHistoryRepo.recordHistory(data);
  }

  String createUniqueId() {
    // Get the current year
    final currentYear = DateTime.now().year.toString();

    final supplies = fetchItems();

    int c = 0;

    for (var element in supplies) {
      final String id = element.id!;
      final String y = id.length >= 4 ? id.substring(0, 4) : id;
      if (y == currentYear) {
        c += 1;
      }
    }

    // Generate the new unique ID
    final newId = '$currentYear${(c + 1)}';

    return newId;
  }

  List<SupplyDataModel> fetchItems() {
    try {
      List<SupplyDataModel> data =
          officeSuppliesList
              // .map((doc) => doc.data())
              .map(
                (doc) => SupplyDataModel(
                  amount: doc["amount"],
                  id: doc["id"].toString(),
                  name: doc["name"],
                  unit: doc["unit"],
                ),
              )
              .toList();

      return data;
    } catch (e) {
      html.window.alert(e.toString());
      return [];
    }
  }

  // Create new Supply
  bool addNewOfficeSupply(SupplyDataModel supplyData) {
    try {
      String uniqueID = officeSuppliesList.length.toString();

      Map<String, dynamic> supplyDatas = {
        "id": uniqueID,
        "name": supplyData.name.toUpperCase(),
        "amount": supplyData.amount,
        "unit": supplyData.unit.toUpperCase(),
      };

      Map<String, dynamic> historyData = {
        'processedBy': supplyData.processedBy,
        "inDate": DateTime.now(),
        "inAmount": supplyData.amount,
      };

      officeSuppliesList.add(supplyDatas);

      _newHistory(uniqueID, supplyData.name.toUpperCase(), historyData);

      return true;
    } catch (e) {
      return false;
    }
  }

  bool pickupSupply(
    String id,
    String processedBy,
    double pickupAmount,
    String requestBy,
    String outBy,
    String receivedOnSiteBy,
  ) {
    Map<String, dynamic> filteredSupply = filterSupplyByExactId(id);

    double storedAmount = filteredSupply["amount"];
    Map<String, dynamic> historyData = {
      "outBy": outBy,
      'processedBy': processedBy,
      "receivedOnSiteBy": receivedOnSiteBy,
      "releaseDate": DateTime.now(),
      "requestBy": requestBy,
      "requestAmount": pickupAmount,
    };

    double newAmount = storedAmount - pickupAmount;

    final itemIndex = officeSuppliesList.indexWhere((item) => item['id'] == id);

    officeSuppliesList[itemIndex]["amount"] = newAmount;

    _newHistory(id, filteredSupply['name'], historyData);

    return true;
  }

  Map<String, dynamic> filterSupplyByExactId(String id) {
    try {
      final datas =
          officeSuppliesList
              .where((element) => element["id"] == id)
              .toList()
              .first;
      return datas;
      //If querySnapshot is empty, data will remain {} and be returned.
    } catch (e) {
      if (kDebugMode) {
        print("General Exception: $e");
      }
      return {};
    }
  }

  Map<String, dynamic> filterSupplyByExactName(String name) {
    try {
      final datas =
          officeSuppliesList
              .where((element) => element["name"] == name)
              .toList()
              .first;
      return datas;
      //If querySnapshot is empty, data will remain {} and be returned.
    } catch (e) {
      if (kDebugMode) {
        print("General Exception: $e");
      }
      return {};
    }
  }

  bool restockSupply(String processedBy, String id, double inAmount) {
    try {
      Map<String, dynamic> filteredSupply = filterSupplyByExactId(id);

      double storedAmount = filteredSupply["amount"];

      double newAmount = storedAmount + inAmount;

      Map<String, dynamic> historyData = {
        'processedBy': processedBy.toUpperCase(),
        "inAmount": inAmount,
        "inDate": DateTime.now(),
      };

      final itemIndex = officeSuppliesList.indexWhere(
        (item) => item['id'] == id,
      );

      officeSuppliesList[itemIndex]["amount"] = newAmount;

      _newHistory(id, filteredSupply['name'], historyData);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  List<Map<String, dynamic>> filterSuppliesById(String id) {
    try {
      final List<Map<String, dynamic>> suppliesData = officeSuppliesList;

      final String searchUperCase = id.toUpperCase();

      List<Map<String, dynamic>> filteredToolsEquipmentData =
          suppliesData
              .where(
                (tool) => (tool["id"] as String).toUpperCase().contains(
                  searchUperCase,
                ),
              )
              .toList();

      return filteredToolsEquipmentData;
    } catch (e) {
      if (kDebugMode) {
        print("General Exception: $e");
      }
      return [];
    }
  }

  List<Map<String, dynamic>> filterSuppliesByName(String name) {
    try {
      final List<Map<String, dynamic>> suppliesData = officeSuppliesList;

      final String searchUperCase = name.toUpperCase();

      List<Map<String, dynamic>> filteredToolsEquipmentData =
          suppliesData
              .where(
                (tool) => (tool["name"] as String).toUpperCase().contains(
                  searchUperCase,
                ),
              )
              .toList();

      return filteredToolsEquipmentData;
    } catch (e) {
      if (kDebugMode) {
        print("General Exception: $e");
      }
      return [];
    }
  }

  List<Map<String, dynamic>> supplyHistory(String id) {
    List<Map<String, dynamic>> history = [];
    try {
      // Find the item in the list by its ID
      final item = officeSuppliesList.firstWhere(
        (item) => item['id'] == id,
        orElse: () => {}, // Provide an empty map if not found to avoid error
      );

      // Check if the item was found and if it has a 'history' key
      if (item.isNotEmpty &&
          item.containsKey('history') &&
          item['history'] is List) {
        history = List<Map<String, dynamic>>.from(item['history']);
      } else {
        print('Item with ID $id not found or has no history.');
        return []; // Return an empty list if not found or no history
      }
      history.sort((a, b) => a['id'].compareTo(b['id']));
      return history;
    } catch (e) {
      // this is an error code
      print(e);
      return history;
    }
  }

  List<Map<String, dynamic>> officeSuppliesList = [
    {'amount': 100, 'id': '0', 'name': 'Pens (Blue Ink)', 'unit': 'PCS'},
    {'amount': 50, 'id': '1', 'name': 'Notebooks (A4)', 'unit': 'PCS'},
    {'amount': 20, 'id': '2', 'name': 'Stapler', 'unit': 'PCS'},
    {'amount': 1000, 'id': '3', 'name': 'Staples', 'unit': 'PCS'},
    {'amount': 5, 'id': '4', 'name': 'Highlighters (Assorted)', 'unit': 'PCS'},
    {'amount': 10, 'id': '5', 'name': 'Correction Fluid', 'unit': 'PCS'},
    {'amount': 2, 'id': '6', 'name': 'Printer Paper (Ream)', 'unit': 'PCS'},
    {'amount': 15, 'id': '7', 'name': 'Sticky Notes', 'unit': 'PCS'},
    {'amount': 3, 'id': '8', 'name': 'Scissors', 'unit': 'PCS'},
    {'amount': 1, 'id': '9', 'name': 'Desk Organizer', 'unit': 'PCS'},
  ];
}
