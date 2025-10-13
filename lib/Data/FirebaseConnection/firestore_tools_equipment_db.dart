import 'package:flutter/foundation.dart';

class FirestoreToolsEquipmentDBRepository {
  // Read/Get all item
  List<Map<String, dynamic>> toolsEquipmentsData() {
    try {
      final filteredData =
          toolsEquipmentList
              .where((element) => element["isArchive"] == false)
              .toList();
      return filteredData;
    } catch (e) {
      if (kDebugMode) {
        print("General Exception: $e");
      }
      return [];
    }
  }

  List<Map<String, dynamic>> toolsEquipmentCount() {
    List<Map<String, dynamic>> datas = toolsEquipmentsData();

    try {
      Map<String, Map<String, dynamic>> uniqueDataMap = {};
      for (var data in datas) {
        String name = data['name'];
        if (uniqueDataMap.containsKey(name)) {
          uniqueDataMap[name]?['count'] += 1;
        } else {
          uniqueDataMap[name] = {...data, 'count': 1};
        }
      }
      return uniqueDataMap.values.toList();
    } catch (e) {
      return [];
    }
  }

  Map<String, dynamic> filterToolsEquipmentsByExactName(String name) {
    try {
      final filteredData =
          toolsEquipmentList
              .where(
                (element) => (element["name"] as String).toUpperCase() == name,
              )
              .toList();
      return filteredData.first;
    } catch (e) {
      // Handle the error (e.g., log it or show a message)
      if (kDebugMode) {
        print("Error fetching tools/equipments: $e");
      }
      // return {};
    }

    return {};
  }

  List<Map<String, dynamic>> filterToolsEquipmentsByName(String name) {
    try {
      final List<Map<String, dynamic>> toolsEquipmentData =
          toolsEquipmentsData();
      // Convert the search term to lowercase for case-insensitive matching.
      final String searchUperCase = name.toUpperCase();

      List<Map<String, dynamic>> filteredToolsEquipmentData =
          toolsEquipmentData
              .where(
                (tool) => (tool["name"] as String).toUpperCase().contains(
                  searchUperCase,
                ),
              )
              .toList();

      return filteredToolsEquipmentData;
    } catch (e) {
      // Handle errors appropriately. Important for production code.
      if (kDebugMode) {
        print("Error filtering tools: $e"); // Log the error
      }
      return []; // Return an empty list or throw an exception as needed.
    }
  }

  Map<String, dynamic> filterToolsEquipmentsByExactId(String id) {
    try {
      final filteredDataById =
          toolsEquipmentList
              .where(
                (element) =>
                    element["id"].toString().toUpperCase() == id.toUpperCase(),
              )
              .toList();
      return filteredDataById.first;
    } catch (e) {
      // Handle the error (e.g., log it or show a message)
      if (kDebugMode) {
        print("Error fetching tools/equipments: $e");
      }
      // return {};
    }

    return {};
  }

  List<Map<String, dynamic>> filterToolsEquipmentsByID(String id) {
    try {
      final List<Map<String, dynamic>> toolsEquipmentData =
          toolsEquipmentsData();
      // Convert the search term to lowercase for case-insensitive matching.
      final String searchUperCase = id.toUpperCase();

      List<Map<String, dynamic>> filteredToolsEquipmentData =
          toolsEquipmentData
              .where(
                (tool) => (tool["id"] as String).toUpperCase().contains(
                  searchUperCase,
                ),
              )
              .toList();

      return filteredToolsEquipmentData;
    } catch (e) {
      // 3. Handle errors appropriately.  Important for production code.
      if (kDebugMode) {
        print("Error filtering tools: $e");
      } // Log the error
      return []; // Return an empty list or throw an exception as needed.  Important to avoid crashing the app.
    }
  }

  // Filter tools
  List<Map<String, dynamic>> filterToolsEquipmentsByStatus(
    String status,
    String name,
  ) {
    try {
      final List<Map<String, dynamic>> filteredData =
          toolsEquipmentsData()
              .where(
                (element) =>
                    element["name"] == name && element["status"] == status,
              )
              .toList();

      return filteredData;
    } catch (e) {
      if (kDebugMode) {
        print("Error filtering tools: $e");
      }
      return [];
    }
  }

  void updateItemStatus({required String id, required String status}) {
    try {
      // Find the item in the list by its ID
      final itemIndex = toolsEquipmentList.indexWhere(
        (item) => item['id'] == id,
      );

      // Check if item was found before updating
      if (itemIndex != -1) {
        toolsEquipmentList[itemIndex]["status"] = status;
      } else {
        if (kDebugMode) {
          print('Status error: Item with id $id not found');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Status error: $e');
      }
    }
  }

  List addNewItem(
    // String itemName,
    // String processedBy
    Map<String, dynamic> itemData,
  ) {
    try {
      String uniqueID = toolsEquipmentList.length.toString();

      itemData['id'] = uniqueID;

      toolsEquipmentList.add(itemData);

      return [true, itemData];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [false];
    }
  }

  // Use a query to filter documents based on the item status
  List<Map<String, dynamic>> itemsOutside() {
    try {
      final datas =
          toolsEquipmentList
              .where((element) => element["status"] == "OUTSIDE")
              .toList();

      return datas;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return [];
    }
  }

  List<Map<String, dynamic>> toolsEquipmentList = [
    {
      'amountReleased': 0,
      'id': '0',
      'isSupply': false,
      'name': 'Hammer',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'OUTSIDE',
    },
    {
      'amountReleased': 0,
      'id': '1',
      'isSupply': false,
      'name': 'Screwdriver Set',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'STORE ROOM',
    },
    {
      'amountReleased': 0,
      'id': '2',
      'isSupply': false,
      'name': 'Measuring Tape',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'OUTSIDE',
    },
    {
      'amountReleased': 0,
      'id': '3',
      'isSupply': false,
      'name': 'Utility Knife',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'STORE ROOM',
    },
    {
      'amountReleased': 0,
      'id': '4',
      'isSupply': false,
      'name': 'Pliers',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'OUTSIDE',
    },
    {
      'amountReleased': 0,
      'id': '5',
      'isSupply': false,
      'name': 'Wrench Set',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'STORE ROOM',
    },
    {
      'amountReleased': 0,
      'id': '6',
      'isSupply': false,
      'name': 'Level',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'OUTSIDE',
    },
    {
      'amountReleased': 0,
      'id': '7',
      'isSupply': false,
      'name': 'Circular Saw',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'STORE ROOM',
    },
    {
      'amountReleased': 0,
      'id': '8',
      'isSupply': false,
      'name': 'Drill (Cordless)',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'OUTSIDE',
    },
    {
      'amountReleased': 0,
      'id': '9',
      'isSupply': false,
      'name': 'Jigsaw',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'STORE ROOM',
    },
    {
      'amountReleased': 0,
      'id': '10',
      'isSupply': false,
      'name': 'Angle Grinder',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'OUTSIDE',
    },
    {
      'amountReleased': 0,
      'id': '11',
      'isSupply': false,
      'name': 'Safety Glasses',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'STORE ROOM',
    },
    {
      'amountReleased': 0,
      'id': '12',
      'isSupply': false,
      'name': 'Work Gloves',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'OUTSIDE',
    },
    {
      'amountReleased': 0,
      'id': '13',
      'isSupply': false,
      'name': 'Hard Hat',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'STORE ROOM',
    },
    {
      'amountReleased': 0,
      'id': '14',
      'isSupply': false,
      'name': 'Wheelbarrow',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'OUTSIDE',
    },
    {
      'amountReleased': 0,
      'id': '15',
      'isSupply': false,
      'name': 'Shovel',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'STORE ROOM',
    },
    {
      'amountReleased': 0,
      'id': '16',
      'isSupply': false,
      'name': 'Pickaxe',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'OUTSIDE',
    },
    {
      'amountReleased': 0,
      'id': '17',
      'isSupply': false,
      'name': 'Ladder',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'STORE ROOM',
    },
    {
      'amountReleased': 0,
      'id': '18',
      'isSupply': false,
      'name': 'Paint Roller Set',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'OUTSIDE',
    },
    {
      'amountReleased': 0,
      'id': '19',
      'isSupply': false,
      'name': 'Caulking Gun',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'STORE ROOM',
    },
  ];

}
