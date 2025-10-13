import 'package:flutter/foundation.dart';

class FirestoreTransmitalHistoryRepo {
  void recordHistory(Map<String, dynamic> data) {
    try {
      final transmitalCollectionDb = transmitalList;
      final docId = transmitalCollectionDb.length;
      data['docId'] = docId.toString();

      transmitalList.add(data);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void recordNewItemHistory(Map<String, dynamic> data) {
    try {
      final transmitalCollectionDb = transmitalList;
      final docId = transmitalCollectionDb.length;
      data['docId'] = docId.toString();

      transmitalList.add(data);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  List fetchTransmitalHistory() {
    try {
      final fetchedData = transmitalList;
      fetchedData.sort(
        (a, b) => double.parse(b['docId']).compareTo(double.parse(a['docId'])),
      );
      return fetchedData;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return [];
    }
  }

  // List<Map<String, dynamic>> itemHistory({required String itemId}) {
  //   try {
  //     final fetchedData =
  //         transmitalList.where((item) => item['id'] == itemId).toList();
  //     return fetchedData;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return [];
  //   }
  // }

  List<Map<String, dynamic>> itemHistoryComplete({
    required String itemId,
    required String itemName,
  }) {
    try {
      final fetchedData =
          transmitalList
              .where((item) => item['id'] == itemId && item["name"] == itemName)
              .toList();
      return fetchedData;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  List<Map<String, dynamic>> transmitalList = [
    // Item ID: 0 - Cement Bags (100 bags total)
    {
      "docId": "0",
      "id": "0",
      "name": "Cement Bags",
      "processedBy": "Alice Smith",
      "inDate": "2024-01-15T08:30:00.000Z",
      "inAmount": 50,
    },
    {
      "docId": "1",
      "id": "0",
      "name": "Cement Bags",
      "processedBy": "Alice Smith",
      "inDate": "2024-02-20T10:15:00.000Z",
      "inAmount": 30,
    },
    {
      "docId": "2",
      "id": "0",
      "name": "Cement Bags",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-03-05T14:20:00.000Z",
      "requestBy": "John Doe",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Jane Doe",
      "requestAmount": 25,
    },
    {
      "docId": "3",
      "id": "0",
      "name": "Cement Bags",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-18T09:45:00.000Z",
      "inAmount": 45,
    },
    // Total for ID 0: 50 + 30 + 45 - 25 = 100 ✓

    // Item ID: 1 - Sand (Cubic Meters) (500 CUM total)
    {
      "docId": "4",
      "id": "1",
      "name": "Sand (Cubic Meters)",
      "processedBy": "Bob Wilson",
      "inDate": "2024-01-10T07:00:00.000Z",
      "inAmount": 200,
    },
    {
      "docId": "5",
      "id": "1",
      "name": "Sand (Cubic Meters)",
      "processedBy": "Bob Wilson",
      "inDate": "2024-02-14T11:30:00.000Z",
      "inAmount": 150,
    },
    {
      "docId": "6",
      "id": "1",
      "name": "Sand (Cubic Meters)",
      "processedBy": "Bob Wilson",
      "releaseDate": "2024-02-28T13:45:00.000Z",
      "requestBy": "Michael Johnson",
      "outBy": "Bob Wilson",
      "receivedOnSiteBy": "Emily Davis",
      "requestAmount": 80,
    },
    {
      "docId": "7",
      "id": "1",
      "name": "Sand (Cubic Meters)",
      "processedBy": "Bob Wilson",
      "inDate": "2024-03-25T08:20:00.000Z",
      "inAmount": 230,
    },
    // Total for ID 1: 200 + 150 + 230 - 80 = 500 ✓

    // Item ID: 2 - Gravel (Cubic Meters) (500 CUM total)
    {
      "docId": "8",
      "id": "2",
      "name": "Gravel (Cubic Meters)",
      "processedBy": "Bob Wilson",
      "inDate": "2024-01-12T09:15:00.000Z",
      "inAmount": 250,
    },
    {
      "docId": "9",
      "id": "2",
      "name": "Gravel (Cubic Meters)",
      "processedBy": "Bob Wilson",
      "inDate": "2024-02-18T10:30:00.000Z",
      "inAmount": 200,
    },
    {
      "docId": "10",
      "id": "2",
      "name": "Gravel (Cubic Meters)",
      "processedBy": "Bob Wilson",
      "releaseDate": "2024-03-08T15:10:00.000Z",
      "requestBy": "Chris Brown",
      "outBy": "Bob Wilson",
      "receivedOnSiteBy": "Sarah Wilson",
      "requestAmount": 100,
    },
    {
      "docId": "11",
      "id": "2",
      "name": "Gravel (Cubic Meters)",
      "processedBy": "Bob Wilson",
      "inDate": "2024-03-28T07:45:00.000Z",
      "inAmount": 150,
    },
    // Total for ID 2: 250 + 200 + 150 - 100 = 500 ✓

    // Item ID: 3 - Rebar (12mm) (20 PCS total)
    {
      "docId": "12",
      "id": "3",
      "name": "Rebar (12mm)",
      "processedBy": "Carlos Martinez",
      "inDate": "2024-02-05T08:00:00.000Z",
      "inAmount": 15,
    },
    {
      "docId": "13",
      "id": "3",
      "name": "Rebar (12mm)",
      "processedBy": "Carlos Martinez",
      "releaseDate": "2024-03-12T11:30:00.000Z",
      "requestBy": "David Smith",
      "outBy": "Carlos Martinez",
      "receivedOnSiteBy": "Laura Taylor",
      "requestAmount": 8,
    },
    {
      "docId": "14",
      "id": "3",
      "name": "Rebar (12mm)",
      "processedBy": "Carlos Martinez",
      "inDate": "2024-03-22T13:15:00.000Z",
      "inAmount": 13,
    },
    // Total for ID 3: 15 + 13 - 8 = 20 ✓

    // Item ID: 4 - Plywood Sheets (1/2 inch) (15 PCS total)
    {
      "docId": "15",
      "id": "4",
      "name": "Plywood Sheets (1/2 inch)",
      "processedBy": "Carlos Martinez",
      "inDate": "2024-02-08T09:30:00.000Z",
      "inAmount": 10,
    },
    {
      "docId": "16",
      "id": "4",
      "name": "Plywood Sheets (1/2 inch)",
      "processedBy": "Carlos Martinez",
      "inDate": "2024-03-15T14:45:00.000Z",
      "inAmount": 5,
    },
    // Total for ID 4: 10 + 5 = 15 ✓

    // Item ID: 5 - Lumber (2x4x12) (10 PCS total)
    {
      "docId": "17",
      "id": "5",
      "name": "Lumber (2x4x12)",
      "processedBy": "Carlos Martinez",
      "inDate": "2024-02-10T10:20:00.000Z",
      "inAmount": 6,
    },
    {
      "docId": "18",
      "id": "5",
      "name": "Lumber (2x4x12)",
      "processedBy": "Carlos Martinez",
      "releaseDate": "2024-03-18T09:50:00.000Z",
      "requestBy": "John Doe",
      "outBy": "Carlos Martinez",
      "receivedOnSiteBy": "Jane Doe",
      "requestAmount": 3,
    },
    {
      "docId": "19",
      "id": "5",
      "name": "Lumber (2x4x12)",
      "processedBy": "Carlos Martinez",
      "inDate": "2024-03-30T11:00:00.000Z",
      "inAmount": 7,
    },
    // Total for ID 5: 6 + 7 - 3 = 10 ✓

    // Item ID: 6 - Bricks (50 PCS total)
    {
      "docId": "20",
      "id": "6",
      "name": "Bricks",
      "processedBy": "Diana Chen",
      "inDate": "2024-01-20T08:45:00.000Z",
      "inAmount": 30,
    },
    {
      "docId": "21",
      "id": "6",
      "name": "Bricks",
      "processedBy": "Diana Chen",
      "releaseDate": "2024-02-25T12:20:00.000Z",
      "requestBy": "Michael Johnson",
      "outBy": "Diana Chen",
      "receivedOnSiteBy": "Emily Davis",
      "requestAmount": 15,
    },
    {
      "docId": "22",
      "id": "6",
      "name": "Bricks",
      "processedBy": "Diana Chen",
      "inDate": "2024-03-12T09:30:00.000Z",
      "inAmount": 35,
    },
    // Total for ID 6: 30 + 35 - 15 = 50 ✓

    // Item ID: 7 - Roofing Shingles (Bundle) (5 BUNDLE total)
    {
      "docId": "23",
      "id": "7",
      "name": "Roofing Shingles (Bundle)",
      "processedBy": "Diana Chen",
      "inDate": "2024-02-15T13:00:00.000Z",
      "inAmount": 3,
    },
    {
      "docId": "24",
      "id": "7",
      "name": "Roofing Shingles (Bundle)",
      "processedBy": "Diana Chen",
      "inDate": "2024-03-20T10:15:00.000Z",
      "inAmount": 2,
    },
    // Total for ID 7: 3 + 2 = 5 ✓

    // Item ID: 8 - Electrical Wires (Roll) (10 ROLL total)
    {
      "docId": "25",
      "id": "8",
      "name": "Electrical Wires (Roll)",
      "processedBy": "Edward Lee",
      "inDate": "2024-02-01T08:30:00.000Z",
      "inAmount": 6,
    },
    {
      "docId": "26",
      "id": "8",
      "name": "Electrical Wires (Roll)",
      "processedBy": "Edward Lee",
      "releaseDate": "2024-03-10T14:40:00.000Z",
      "requestBy": "Chris Brown",
      "outBy": "Edward Lee",
      "receivedOnSiteBy": "Sarah Wilson",
      "requestAmount": 4,
    },
    {
      "docId": "27",
      "id": "8",
      "name": "Electrical Wires (Roll)",
      "processedBy": "Edward Lee",
      "inDate": "2024-03-26T09:00:00.000Z",
      "inAmount": 8,
    },
    // Total for ID 8: 6 + 8 - 4 = 10 ✓

    // Item ID: 9 - PVC Pipes (2 inch) (20 PCS total)
    {
      "docId": "28",
      "id": "9",
      "name": "PVC Pipes (2 inch)",
      "processedBy": "Edward Lee",
      "inDate": "2024-02-03T11:15:00.000Z",
      "inAmount": 12,
    },
    {
      "docId": "29",
      "id": "9",
      "name": "PVC Pipes (2 inch)",
      "processedBy": "Edward Lee",
      "releaseDate": "2024-03-14T10:25:00.000Z",
      "requestBy": "David Smith",
      "outBy": "Edward Lee",
      "receivedOnSiteBy": "Laura Taylor",
      "requestAmount": 7,
    },
    {
      "docId": "30",
      "id": "9",
      "name": "PVC Pipes (2 inch)",
      "processedBy": "Edward Lee",
      "inDate": "2024-03-28T13:30:00.000Z",
      "inAmount": 15,
    },
    // Total for ID 9: 12 + 15 - 7 = 20 ✓

    // Item ID: 10 - Paint (Gallon) (10 GALLON total)
    {
      "docId": "31",
      "id": "10",
      "name": "Paint (Gallon)",
      "processedBy": "Fiona Green",
      "inDate": "2024-02-12T09:45:00.000Z",
      "inAmount": 6,
    },
    {
      "docId": "32",
      "id": "10",
      "name": "Paint (Gallon)",
      "processedBy": "Fiona Green",
      "inDate": "2024-03-16T14:20:00.000Z",
      "inAmount": 4,
    },
    // Total for ID 10: 6 + 4 = 10 ✓

    // Item ID: 11 - Paint Thinner (Liter) (5 LITER total)
    {
      "docId": "33",
      "id": "11",
      "name": "Paint Thinner (Liter)",
      "processedBy": "Fiona Green",
      "inDate": "2024-02-12T09:50:00.000Z",
      "inAmount": 3,
    },
    {
      "docId": "34",
      "id": "11",
      "name": "Paint Thinner (Liter)",
      "processedBy": "Fiona Green",
      "releaseDate": "2024-03-20T11:15:00.000Z",
      "requestBy": "John Doe",
      "outBy": "Fiona Green",
      "receivedOnSiteBy": "Jane Doe",
      "requestAmount": 1,
    },
    {
      "docId": "35",
      "id": "11",
      "name": "Paint Thinner (Liter)",
      "processedBy": "Fiona Green",
      "inDate": "2024-03-29T10:30:00.000Z",
      "inAmount": 3,
    },
    // Total for ID 11: 3 + 3 - 1 = 5 ✓

    // Item ID: 12 - Drywall Sheets (4x8) (30 PCS total)
    {
      "docId": "36",
      "id": "12",
      "name": "Drywall Sheets (4x8)",
      "processedBy": "George Harris",
      "inDate": "2024-01-25T08:00:00.000Z",
      "inAmount": 20,
    },
    {
      "docId": "37",
      "id": "12",
      "name": "Drywall Sheets (4x8)",
      "processedBy": "George Harris",
      "releaseDate": "2024-03-02T13:30:00.000Z",
      "requestBy": "Michael Johnson",
      "outBy": "George Harris",
      "receivedOnSiteBy": "Emily Davis",
      "requestAmount": 12,
    },
    {
      "docId": "38",
      "id": "12",
      "name": "Drywall Sheets (4x8)",
      "processedBy": "George Harris",
      "inDate": "2024-03-18T11:45:00.000Z",
      "inAmount": 22,
    },
    // Total for ID 12: 20 + 22 - 12 = 30 ✓

    // Item ID: 13 - Nails (Box) (100 BOX total)
    {
      "docId": "39",
      "id": "13",
      "name": "Nails (Box)",
      "processedBy": "George Harris",
      "inDate": "2024-01-18T10:00:00.000Z",
      "inAmount": 50,
    },
    {
      "docId": "40",
      "id": "13",
      "name": "Nails (Box)",
      "processedBy": "George Harris",
      "releaseDate": "2024-02-20T09:30:00.000Z",
      "requestBy": "Chris Brown",
      "outBy": "George Harris",
      "receivedOnSiteBy": "Sarah Wilson",
      "requestAmount": 20,
    },
    {
      "docId": "41",
      "id": "13",
      "name": "Nails (Box)",
      "processedBy": "George Harris",
      "inDate": "2024-03-10T12:15:00.000Z",
      "inAmount": 30,
    },
    {
      "docId": "42",
      "id": "13",
      "name": "Nails (Box)",
      "processedBy": "George Harris",
      "releaseDate": "2024-03-25T14:50:00.000Z",
      "requestBy": "David Smith",
      "outBy": "George Harris",
      "receivedOnSiteBy": "Laura Taylor",
      "requestAmount": 15,
    },
    {
      "docId": "43",
      "id": "13",
      "name": "Nails (Box)",
      "processedBy": "George Harris",
      "inDate": "2024-04-01T08:30:00.000Z",
      "inAmount": 55,
    },
    // Total for ID 13: 50 + 30 + 55 - 20 - 15 = 100 ✓

    // Item ID: 14 - Screws (Box) (50 BOX total)
    {
      "docId": "44",
      "id": "14",
      "name": "Screws (Box)",
      "processedBy": "Hannah White",
      "inDate": "2024-01-22T09:20:00.000Z",
      "inAmount": 30,
    },
    {
      "docId": "45",
      "id": "14",
      "name": "Screws (Box)",
      "processedBy": "Hannah White",
      "releaseDate": "2024-02-28T10:45:00.000Z",
      "requestBy": "John Doe",
      "outBy": "Hannah White",
      "receivedOnSiteBy": "Jane Doe",
      "requestAmount": 15,
    },
    {
      "docId": "46",
      "id": "14",
      "name": "Screws (Box)",
      "processedBy": "Hannah White",
      "inDate": "2024-03-20T13:00:00.000Z",
      "inAmount": 35,
    },
    // Total for ID 14: 30 + 35 - 15 = 50 ✓

    // Item ID: 15 - Insulation Rolls (5 ROLL total)
    {
      "docId": "47",
      "id": "15",
      "name": "Insulation Rolls",
      "processedBy": "Hannah White",
      "inDate": "2024-02-25T11:30:00.000Z",
      "inAmount": 3,
    },
    {
      "docId": "48",
      "id": "15",
      "name": "Insulation Rolls",
      "processedBy": "Hannah White",
      "inDate": "2024-03-22T09:15:00.000Z",
      "inAmount": 2,
    },
    // Total for ID 15: 3 + 2 = 5 ✓

    // Item ID: 16 - Safety Cones (2 PCS total)
    {
      "docId": "49",
      "id": "16",
      "name": "Safety Cones",
      "processedBy": "Ian Cooper",
      "inDate": "2024-01-15T08:00:00.000Z",
      "inAmount": 2,
    },
    // Total for ID 16: 2 = 2 ✓

    // Item ID: 17 - Tarps (Large) (10 PCS total)
    {
      "docId": "50",
      "id": "17",
      "name": "Tarps (Large)",
      "processedBy": "Ian Cooper",
      "inDate": "2024-02-05T10:30:00.000Z",
      "inAmount": 6,
    },
    {
      "docId": "51",
      "id": "17",
      "name": "Tarps (Large)",
      "processedBy": "Ian Cooper",
      "releaseDate": "2024-03-15T12:00:00.000Z",
      "requestBy": "Michael Johnson",
      "outBy": "Ian Cooper",
      "receivedOnSiteBy": "Emily Davis",
      "requestAmount": 3,
    },
    {
      "docId": "52",
      "id": "17",
      "name": "Tarps (Large)",
      "processedBy": "Ian Cooper",
      "inDate": "2024-03-28T14:20:00.000Z",
      "inAmount": 7,
    },
    // Total for ID 17: 6 + 7 - 3 = 10 ✓

    // Item ID: 18 - First Aid Kit (1 PCS total)
    {
      "docId": "53",
      "id": "18",
      "name": "First Aid Kit",
      "processedBy": "Ian Cooper",
      "inDate": "2024-01-10T09:00:00.000Z",
      "inAmount": 1,
    },
    // Total for ID 18: 1 = 1 ✓

    // Item ID: 19 - Duct Tape (20 ROLL total)
    {
      "docId": "54",
      "id": "19",
      "name": "Duct Tape",
      "processedBy": "Julia Adams",
      "inDate": "2024-02-01T11:45:00.000Z",
      "inAmount": 12,
    },
    {
      "docId": "55",
      "id": "19",
      "name": "Duct Tape",
      "processedBy": "Julia Adams",
      "releaseDate": "2024-03-08T13:20:00.000Z",
      "requestBy": "Chris Brown",
      "outBy": "Julia Adams",
      "receivedOnSiteBy": "Sarah Wilson",
      "requestAmount": 5,
    },
    {
      "docId": "56",
      "id": "19",
      "name": "Duct Tape",
      "processedBy": "Julia Adams",
      "inDate": "2024-03-24T10:00:00.000Z",
      "inAmount": 13,
    },
    // Total for ID 19: 12 + 13 - 5 = 20 ✓

    // Item ID: 20 - Caulk Tubes (5 PCS total)
    {
      "docId": "57",
      "id": "20",
      "name": "Caulk Tubes",
      "processedBy": "Julia Adams",
      "inDate": "2024-02-18T12:30:00.000Z",
      "inAmount": 3,
    },
    {
      "docId": "58",
      "id": "20",
      "name": "Caulk Tubes",
      "processedBy": "Julia Adams",
      "inDate": "2024-03-26T15:10:00.000Z",
      "inAmount": 2,
    },
    // Total for ID 20: 3 + 2 = 5 ✓

    // Item ID: 21 - Work Lights (10 PCS total)
    {
      "docId": "59",
      "id": "21",
      "name": "Work Lights",
      "processedBy": "Kevin Brown",
      "inDate": "2024-02-10T09:00:00.000Z",
      "inAmount": 6,
    },
    {
      "docId": "60",
      "id": "21",
      "name": "Work Lights",
      "processedBy": "Kevin Brown",
      "releaseDate": "2024-03-12T11:45:00.000Z",
      "requestBy": "David Smith",
      "outBy": "Kevin Brown",
      "receivedOnSiteBy": "Laura Taylor",
      "requestAmount": 3,
    },
    {
      "docId": "61",
      "id": "21",
      "name": "Work Lights",
      "processedBy": "Kevin Brown",
      "inDate": "2024-03-30T13:25:00.000Z",
      "inAmount": 7,
    },
    // Total for ID 21: 6 + 7 - 3 = 10 ✓

    // Item ID: 22 - Extension Cords (3 PCS total)
    {
      "docId": "62",
      "id": "22",
      "name": "Extension Cords",
      "processedBy": "Kevin Brown",
      "inDate": "2024-02-08T10:40:00.000Z",
      "inAmount": 2,
    },
    {
      "docId": "63",
      "id": "22",
      "name": "Extension Cords",
      "processedBy": "Kevin Brown",
      "releaseDate": "2024-03-18T14:15:00.000Z",
      "requestBy": "John Doe",
      "outBy": "Kevin Brown",
      "receivedOnSiteBy": "Jane Doe",
      "requestAmount": 1,
    },
    {
      "docId": "64",
      "id": "22",
      "name": "Extension Cords",
      "processedBy": "Kevin Brown",
      "inDate": "2024-03-29T11:50:00.000Z",
      "inAmount": 2,
    },
    // Total for ID 22: 2 + 2 - 1 = 3 ✓

    // ========== CONTINUATION FROM ORIGINAL TRANSMITTAL LIST ==========

    // Item ID: 0 - Hammer
    {
      "docId": "65",
      "id": "0",
      "name": "Hammer",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-10T09:00:00.000Z",
    },
    {
      "docId": "66",
      "id": "0",
      "name": "Hammer",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-16T12:00:00.000Z",
      "requestBy": "John Doe",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Jane Doe",
    },

    // Item ID: 1 - Screwdriver Set
    {
      "docId": "67",
      "id": "1",
      "name": "Screwdriver Set",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-10T09:00:00.000Z",
    },

    // Item ID: 2 - Measuring Tape
    {
      "docId": "68",
      "id": "2",
      "name": "Measuring Tape",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-11T10:15:00.000Z",
    },
    {
      "docId": "69",
      "id": "2",
      "name": "Measuring Tape",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-17T08:30:00.000Z",
      "requestBy": "Michael Johnson",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Emily Davis",
    },

    // Item ID: 3 - Utility Knife
    {
      "docId": "70",
      "id": "3",
      "name": "Utility Knife",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-11T10:15:00.000Z",
    },

    // Item ID: 4 - Pliers
    {
      "docId": "71",
      "id": "4",
      "name": "Pliers",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-12T11:45:00.000Z",
    },
    {
      "docId": "72",
      "id": "4",
      "name": "Pliers",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-18T14:45:00.000Z",
      "requestBy": "Chris Brown",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Sarah Wilson",
    },

    // Item ID: 5 - Wrench Set
    {
      "docId": "73",
      "id": "5",
      "name": "Wrench Set",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-12T11:45:00.000Z",
    },

    // Item ID: 6 - Level
    {
      "docId": "74",
      "id": "6",
      "name": "Level",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-13T08:00:00.000Z",
    },
    {
      "docId": "75",
      "id": "6",
      "name": "Level",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-19T10:10:00.000Z",
      "requestBy": "David Smith",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Laura Taylor",
    },

    // Item ID: 7 - Circular Saw
    {
      "docId": "76",
      "id": "7",
      "name": "Circular Saw",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-13T08:00:00.000Z",
    },

    // Item ID: 8 - Drill (Cordless)
    {
      "docId": "77",
      "id": "8",
      "name": "Drill (Cordless)",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-14T13:30:00.000Z",
    },
    {
      "docId": "78",
      "id": "8",
      "name": "Drill (Cordless)",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-20T16:50:00.000Z",
      "requestBy": "John Doe",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Jane Doe",
    },

    // Item ID: 9 - Jigsaw
    {
      "docId": "79",
      "id": "9",
      "name": "Jigsaw",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-14T13:30:00.000Z",
    },

    // Item ID: 10 - Angle Grinder
    {
      "docId": "80",
      "id": "10",
      "name": "Angle Grinder",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-15T09:40:00.000Z",
    },
    {
      "docId": "81",
      "id": "10",
      "name": "Angle Grinder",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-21T07:25:00.000Z",
      "requestBy": "Michael Johnson",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Emily Davis",
    },

    // Item ID: 11 - Safety Glasses
    {
      "docId": "82",
      "id": "11",
      "name": "Safety Glasses",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-15T09:40:00.000Z",
    },

    // Item ID: 12 - Work Gloves
    {
      "docId": "83",
      "id": "12",
      "name": "Work Gloves",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-18T14:00:00.000Z",
    },
    {
      "docId": "84",
      "id": "12",
      "name": "Work Gloves",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-24T13:15:00.000Z",
      "requestBy": "Chris Brown",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Sarah Wilson",
    },

    // Item ID: 13 - Hard Hat
    {
      "docId": "85",
      "id": "13",
      "name": "Hard Hat",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-18T14:00:00.000Z",
    },

    // Item ID: 14 - Wheelbarrow
    {
      "docId": "86",
      "id": "14",
      "name": "Wheelbarrow",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-19T09:30:00.000Z",
    },
    {
      "docId": "87",
      "id": "14",
      "name": "Wheelbarrow",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-25T09:55:00.000Z",
      "requestBy": "David Smith",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Laura Taylor",
    },

    // Item ID: 15 - Shovel
    {
      "docId": "88",
      "id": "15",
      "name": "Shovel",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-19T09:30:00.000Z",
    },

    // Item ID: 16 - Pickaxe
    {
      "docId": "89",
      "id": "16",
      "name": "Pickaxe",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-20T11:00:00.000Z",
    },
    {
      "docId": "90",
      "id": "16",
      "name": "Pickaxe",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-26T11:20:00.000Z",
      "requestBy": "John Doe",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Jane Doe",
    },

    // Item ID: 17 - Ladder
    {
      "docId": "91",
      "id": "17",
      "name": "Ladder",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-20T11:00:00.000Z",
    },

    // Item ID: 18 - Paint Roller Set
    {
      "docId": "92",
      "id": "18",
      "name": "Paint Roller Set",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-21T15:00:00.000Z",
    },
    {
      "docId": "93",
      "id": "18",
      "name": "Paint Roller Set",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-27T15:40:00.000Z",
      "requestBy": "Michael Johnson",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Emily Davis",
    },

    // Item ID: 19 - Caulking Gun
    {
      "docId": "94",
      "id": "19",
      "name": "Caulking Gun",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-21T15:00:00.000Z",
    },
  ];

}
