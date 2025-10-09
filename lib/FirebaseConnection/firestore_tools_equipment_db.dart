import 'package:flutter/foundation.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';

class FirestoreToolsEquipmentDBRepository {
  final FirestoreTransmitalHistoryRepo _firestoreTransmitalHistoryRepo =
      FirestoreTransmitalHistoryRepo();

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
          toolsEquipmentList.where((element) => element["id"] == id).toList();
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

  void _newHistory(String id, Map<String, dynamic> data) {
    try {
      // Find the item in the list by its ID
      final itemIndex = toolsEquipmentList.indexWhere(
        (item) => item['id'] == id,
      );

      if (itemIndex != -1) {
        // If the item is found, add the new history entry to its 'history' list
        final history = toolsEquipmentList[itemIndex]['history'];
        print(history);
        print(history.runtimeType);
        history == null
            ? toolsEquipmentList[itemIndex]['history'] = [data]
            : toolsEquipmentList[itemIndex]['history'].add(data);

        if (kDebugMode) {
          print('History added successfully for item ID: $id');
        }
      } else {
        if (kDebugMode) {
          print('Item with ID $id not found.');
        }
      }

    } catch (e) {
      if (kDebugMode) {
        print('History error: $e');
      }
    }
  }

  List<Map<String, dynamic>> itemHistory(String id) {
    List<Map<String, dynamic>> history = [];
    try {
      // Find the item in the list by its ID
      final item = toolsEquipmentList.firstWhere(
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

      return history;
    } catch (e) {
      // this is an error code
      // ignore: avoid_print
      print(e);
      return history;
    }
  }

  void _updateItemStatus({required String id, required String status}) {
    try {
      // Find the item in the list by its ID
      final itemIndex = toolsEquipmentList.indexWhere(
        (item) => item['id'] == id,
      );
      toolsEquipmentList[itemIndex]["status"] = status;
    } catch (e) {
      if (kDebugMode) {
        print('Sattus error:$e');
      }
    }
  }

  bool addNewItem(String itemName, String processedBy) {
    try {
      String uniqueID = toolsEquipmentList.length.toString();

      Map<String, dynamic> itemData = {
        "id": uniqueID,
        "name": itemName,
        "isArchive": false,
        "status": "STORE ROOM",
      };

      toolsEquipmentList.add(itemData);

      Map<String, dynamic> historyData = {
        "processedBy": processedBy,
        "inDate": DateTime.now(),
      };

      // final Map<String, dynamic> datas = {
      //   "name": itemName,
      //   "processedBy": processedBy,
      //   "inDate": DateTime.now(),
      // };

      _newHistory(uniqueID.toString(), historyData);

      // _firestoreTransmitalHistoryRepo.recordNewItemHistory(uniqueID, datas);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  void outItem(String id, Map<String, dynamic> forHistoryDatas) {
    try {
      _updateItemStatus(id: id.toString(), status: "OUTSIDE");

      // _newHistory(id.toString(), forHistoryDatas);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void returnItem(String id, String processedBy, String inBy) {
    try {
      // Find the item in the list by its ID
      final itemIndex = toolsEquipmentList.indexWhere(
        (item) => item['id'] == id,
      );

      int subCollID =
          (toolsEquipmentList[itemIndex]['history']
                  as List<Map<String, dynamic>>)
              .length -
          1;
      // Update the existing history. Note that the first is out the it will update when you in an item
      final datas = {
        "id": subCollID,
        "processedBy": processedBy,
        "inBy": inBy,
        "inDate": DateTime.now(),
      };

      toolsEquipmentList.add(datas);

      _updateItemStatus(id: id.toString(), status: "STORE ROOM");

      _firestoreTransmitalHistoryRepo.recordHistory(datas);
    } catch (e) {
      // this is error code
      // ignore: avoid_print
      print(e);
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

  bool isValidForIn(String id, String processedBy, String willInBy) {
    bool isValidForIn;
    List<Map<String, dynamic>> history = itemHistory(id);
    Map<String, dynamic> datas = history.last;

    if (history.length == 1) {
      isValidForIn = false;
      return isValidForIn;
    } else {
      String outBy = datas["outBy"];

      if (willInBy == outBy) {
        isValidForIn = true;
        return isValidForIn;
      } else {
        isValidForIn = false;
        return isValidForIn;
      }
    }
  }

  final List<Map<String, dynamic>> toolsEquipmentList = [
    {
      'amountReleased': 0,
      'id': '0',
      'isSupply': false,
      'name': 'Hammer',
      'remainingAmount': 1,
      'totalAmount': 1,
      'isArchive': false,
      'status': 'OUTSIDE',
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
        {
          'outDate': "2024-06-16T12:00:00.000Z",
          'requestBy': "John Doe",
          'outBy': "Alice Smith",
          'receivedOnSiteBy': "Jane Doe",
        },
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
        {
          'outDate': "2024-06-16T12:00:00.000Z",
          'requestBy': "Michael Johnson",
          'outBy': "Alice Smith",

          'receivedOnSiteBy': "Emily Davis",
        },
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
        {
          'outDate': "2024-06-16T12:00:00.000Z",
          'requestBy': "Chris Brown",
          'outBy': "Alice Smith",

          'receivedOnSiteBy': "Sarah Wilson",
        },
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
        {
          'outDate': "2024-06-16T12:00:00.000Z",
          'requestBy': "David Smith",
          'outBy': "Alice Smith",

          'receivedOnSiteBy': "Laura Taylor",
        },
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
        {
          'outDate': "2024-06-16T12:00:00.000Z",
          'requestBy': "John Doe",
          'outBy': "Alice Smith",

          'receivedOnSiteBy': "Jane Doe",
        },
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
        {
          'outDate': "2024-06-16T12:00:00.000Z",
          'requestBy': "Michael Johnson",
          'outBy': "Alice Smith",
          'receivedOnSiteBy': "Emily Davis",
        },
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
        {
          'outDate': "2024-06-16T12:00:00.000Z",
          'requestBy': "Chris Brown",
          'outBy': "Alice Smith",
          'receivedOnSiteBy': "Sarah Wilson",
        },
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
        {
          'outDate': "2024-06-16T12:00:00.000Z",
          'requestBy': "David Smith",
          'outBy': "Alice Smith",
          'receivedOnSiteBy': "Laura Taylor",
        },
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
        {
          'outDate': "2024-06-16T12:00:00.000Z",
          'requestBy': "John Doe",
          'outBy': "Alice Smith",
          'receivedOnSiteBy': "Jane Doe",
        },
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
        {
          'outDate': "2024-06-16T12:00:00.000Z",
          'requestBy': "Michael Johnson",
          'outBy': "Alice Smith",
          'receivedOnSiteBy': "Emily Davis",
        },
      ],
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
      'history': [
        {"inDate": "2024-03-10T09:00:00.000Z", "processedBy": "Alice Smith"},
      ],
    },
  ];
}
