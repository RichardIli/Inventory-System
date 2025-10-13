import 'package:flutter/foundation.dart';
// import 'dart:html' as html;

class FirestoreSuppliesDb {

  // Read/Get all item
  List<Map<String, dynamic>> suppliesData() {
    return suppliesList;
  }

  // void _newHistory(String id, String name, Map<String, dynamic> data) {
  //   // Find the item in the list by its ID
  //   final itemIndex = suppliesList.indexWhere((item) => item['id'] == id);
  //   final history =
  //       suppliesList[itemIndex]["history"] as List<Map<String, dynamic>>;

  //   data["id"] = history.length;

  //   suppliesList[itemIndex]["history"].add(data);

  //   _transmitalHistoryRepo.recordHistory(data);
  // }

  Map<String, dynamic> filterSupplyByExactName(String name) {
    try {
      final datas =
          suppliesList
              .where((element) => element["name"].toString().toUpperCase() == name)
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

  List<Map<String, dynamic>> filterSuppliesByName(String name) {
    try {
      final List<Map<String, dynamic>> suppliesDataLocal = suppliesData();

      final String searchUperCase = name.toUpperCase();

      List<Map<String, dynamic>> filteredToolsEquipmentData =
          suppliesDataLocal
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

  Map<String, dynamic> filterSupplyByExactId(String id) {
    try {
      final datas =
          suppliesList.where((element) => element["id"] == id).toList().first;
      return datas;
      //If querySnapshot is empty, data will remain {} and be returned.
    } catch (e) {
      if (kDebugMode) {
        print("General Exception: $e");
      }
      return {};
    }
  }

  List<Map<String, dynamic>> filterSuppliesById(String id) {
    try {
      final List<Map<String, dynamic>> suppliesDataLocal = suppliesData();

      final String searchUperCase = id.toUpperCase();

      List<Map<String, dynamic>> filteredToolsEquipmentData =
          suppliesDataLocal
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

  // Create new Supply
  bool addNewSupply(Map<String, dynamic> supplyDatas) {
    try {
      suppliesList.add(supplyDatas);

      // _newHistory(uniqueID, supplyName.toUpperCase(), historyData);

      return true;
    } catch (e) {
      return false;
    }
  }

  bool pickupSupply(String id, double storedAmount, double pickupAmount) {
    try {
      double newAmount = storedAmount - pickupAmount;

      final itemIndex = suppliesList.indexWhere((item) => item['id'] == id);

      suppliesList[itemIndex]["amount"] = newAmount;

      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error in pickupSupply: $e');
      }
      return false;
    }
  }

  bool restockSupply(String id, double storedAmount, double inAmount) {
    try {
      // make a new amount after adding the restock amount to the current amount in the storage
      final double newAmount = storedAmount + inAmount;

      final int itemIndex = suppliesList.indexWhere((item) => item['id'] == id);

      // assign a new value or update the value
      suppliesList[itemIndex]["amount"] = newAmount;

      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false;
    }
  }

  List<Map<String, dynamic>> supplyHistory(String id) {
    List<Map<String, dynamic>> history = [];
    try {
      // Find the item in the list by its ID
      final item = suppliesList.firstWhere(
        (item) => item['id'] == id,
        orElse: () => {}, // Provide an empty map if not found to avoid error
      );

      // Check if the item was found and if it has a 'history' key
      if (item.isNotEmpty &&
          item.containsKey('history') &&
          item['history'] is List) {
        history = List<Map<String, dynamic>>.from(item['history']);
      } else {
        if (kDebugMode) {
          print('Item with ID $id not found or has no history.');
        }
        return []; // Return an empty list if not found or no history
      }
      history.sort((a, b) => a['id'].compareTo(b['id']));
      return history;
    } catch (e) {
      // this is an error code
      // ignore: avoid_print
      print(e);
      return history;
    }
  }

  List<Map<String, dynamic>> suppliesList = [
    {'amount': 100, 'id': '0', 'name': 'Cement Bags', 'unit': 'BAGS'},
    {'amount': 500, 'id': '1', 'name': 'Sand (Cubic Meters)', 'unit': 'CUM'},
    {'amount': 500, 'id': '2', 'name': 'Gravel (Cubic Meters)', 'unit': 'CUM'},
    {'amount': 20, 'id': '3', 'name': 'Rebar (12mm)', 'unit': 'PCS'},
    {
      'amount': 15,
      'id': '4',
      'name': 'Plywood Sheets (1/2 inch)',
      'unit': 'PCS',
    },
    {'amount': 10, 'id': '5', 'name': 'Lumber (2x4x12)', 'unit': 'PCS'},
    {'amount': 50, 'id': '6', 'name': 'Bricks', 'unit': 'PCS'},
    {
      'amount': 5,
      'id': '7',
      'name': 'Roofing Shingles (Bundle)',
      'unit': 'BUNDLE',
    },
    {
      'amount': 10,
      'id': '8',
      'name': 'Electrical Wires (Roll)',
      'unit': 'ROLL',
    },
    {'amount': 20, 'id': '9', 'name': 'PVC Pipes (2 inch)', 'unit': 'PCS'},
    {'amount': 10, 'id': '10', 'name': 'Paint (Gallon)', 'unit': 'GALLON'},
    {'amount': 5, 'id': '11', 'name': 'Paint Thinner (Liter)', 'unit': 'LITER'},
    {'amount': 30, 'id': '12', 'name': 'Drywall Sheets (4x8)', 'unit': 'PCS'},
    {'amount': 100, 'id': '13', 'name': 'Nails (Box)', 'unit': 'BOX'},
    {'amount': 50, 'id': '14', 'name': 'Screws (Box)', 'unit': 'BOX'},
    {'amount': 5, 'id': '15', 'name': 'Insulation Rolls', 'unit': 'ROLL'},
    {'amount': 2, 'id': '16', 'name': 'Safety Cones', 'unit': 'PCS'},
    {'amount': 10, 'id': '17', 'name': 'Tarps (Large)', 'unit': 'PCS'},
    {'amount': 1, 'id': '18', 'name': 'First Aid Kit', 'unit': 'PCS'},
    {'amount': 20, 'id': '19', 'name': 'Duct Tape', 'unit': 'ROLL'},
    {'amount': 5, 'id': '20', 'name': 'Caulk Tubes', 'unit': 'PCS'},
    {'amount': 10, 'id': '21', 'name': 'Work Lights', 'unit': 'PCS'},
    {'amount': 3, 'id': '22', 'name': 'Extension Cords', 'unit': 'PCS'},
  ];
}
