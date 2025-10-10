// TODO: MAKE SURE THAT IN THE DATA THAT WILL BE USED INSERT HAS THE ITEMID. ITS DIFFERENT FROM THE HISTORY ID
// the reutrn tools and equipment is done
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

  List<Map<String, dynamic>> itemHistory({required String itemId}) {
    try {
      final fetchedData =
          transmitalList.where((item) => item['id'] == itemId).toList();
      return fetchedData;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  // TODO: MAKE A DKEY NAMED RETURN BY
  List<Map<String, dynamic>> transmitalList = [
    // Item ID: 0 - Hammer
    {
      "docId": "0",
      "id": "0",
      "name": "Hammer",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-10T09:00:00.000Z",
    },
    {
      "docId": "1",
      "id": "0",
      "name": "Hammer",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-16T12:00:00.000Z", // Original release date
      "requestBy": "John Doe",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Jane Doe",
    },
    // Item ID: 1 - Screwdriver Set
    {
      "docId": "2",
      "id": "1",
      "name": "Screwdriver Set",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-10T09:00:00.000Z",
    },
    // Item ID: 2 - Measuring Tape
    {
      "docId": "3",
      "id": "2",
      "name": "Measuring Tape",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-11T10:15:00.000Z", // Changed inDate
    },
    {
      "docId": "4",
      "id": "2",
      "name": "Measuring Tape",
      "processedBy": "Alice Smith",
      "releaseDate": "2024-06-17T08:30:00.000Z", // Changed releaseDate
      "requestBy": "Michael Johnson",
      "outBy": "Alice Smith",
      "receivedOnSiteBy": "Emily Davis",
    },
    // Item ID: 3 - Utility Knife
    {
      "docId": "5",
      "id": "3",
      "name": "Utility Knife",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-11T10:15:00.000Z",
    },
    // Item ID: 4 - Pliers
    {
      "docId": "6",
      "id": "4",
      "name": "Pliers",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-12T11:45:00.000Z",
    },
    {
      "docId": "7",
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
      "docId": "8",
      "id": "5",
      "name": "Wrench Set",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-12T11:45:00.000Z",
    },
    // Item ID: 6 - Level
    {
      "docId": "9",
      "id": "6",
      "name": "Level",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-13T08:00:00.000Z",
    },
    {
      "docId": "10",
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
      "docId": "11",
      "id": "7",
      "name": "Circular Saw",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-13T08:00:00.000Z",
    },
    // Item ID: 8 - Drill (Cordless)
    {
      "docId": "12",
      "id": "8",
      "name": "Drill (Cordless)",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-14T13:30:00.000Z",
    },
    {
      "docId": "13",
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
      "docId": "14",
      "id": "9",
      "name": "Jigsaw",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-14T13:30:00.000Z",
    },
    // Item ID: 10 - Angle Grinder
    {
      "docId": "15",
      "id": "10",
      "name": "Angle Grinder",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-15T09:40:00.000Z",
    },
    {
      "docId": "16",
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
      "docId": "17",
      "id": "11",
      "name": "Safety Glasses",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-15T09:40:00.000Z",
    },
    // Item ID: 12 - Work Gloves
    {
      "docId": "18",
      "id": "12",
      "name": "Work Gloves",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-18T14:00:00.000Z",
    },
    {
      "docId": "19",
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
      "docId": "20",
      "id": "13",
      "name": "Hard Hat",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-18T14:00:00.000Z",
    },
    // Item ID: 14 - Wheelbarrow
    {
      "docId": "21",
      "id": "14",
      "name": "Wheelbarrow",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-19T09:30:00.000Z",
    },
    {
      "docId": "22",
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
      "docId": "23",
      "id": "15",
      "name": "Shovel",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-19T09:30:00.000Z",
    },
    // Item ID: 16 - Pickaxe
    {
      "docId": "24",
      "id": "16",
      "name": "Pickaxe",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-20T11:00:00.000Z",
    },
    {
      "docId": "25",
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
      "docId": "26",
      "id": "17",
      "name": "Ladder",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-20T11:00:00.000Z",
    },
    // Item ID: 18 - Paint Roller Set
    {
      "docId": "27",
      "id": "18",
      "name": "Paint Roller Set",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-21T15:00:00.000Z",
    },
    {
      "docId": "28",
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
      "docId": "29",
      "id": "19",
      "name": "Caulking Gun",
      "processedBy": "Alice Smith",
      "inDate": "2024-03-21T15:00:00.000Z",
    },
  ];
}
