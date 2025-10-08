import 'package:flutter/foundation.dart';

class FirestoreUsersDbRepository {
  // Create new User
  void addUserToDB(
    // BuildContext context,
    String emailAddress,
    String name,
    String position,
    String address,
    String password,
    String uid,
    int contactNo,
    void Function() refreshList,
    void Function() closePopup,
  ) {
    int id = usersList.length + 1;

    Map<String, dynamic> userData = {
      "id": id,
      "name": name,
      "password": password,
      "position": position,
      "email": emailAddress,
      "contact no": contactNo,
      "address": address,
      "isActive": true,
      "uid": uid,
    };

    usersList.add(userData);

    refreshList();

    closePopup();

    // ignore: use_build_context_synchronously
    // Navigator.pop(context);
  }

  // Read/Get all user
  List<Map<String, dynamic>> usersData() {
    // List<Map<String, dynamic>>? rawDatas = [];

    try {
      final List<Map<String, dynamic>> activeAccount =
          usersList.where((item) => item["isActive"] == true).toList();

      return activeAccount;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
    // This is how you access the data
    // print(datas[0]["name"]);
  }

  // Use a query to filter documents based on the "name" field
  List<Map<String, dynamic>> searchUserData(String searchedName) {
    List<Map<String, dynamic>>? datas = [];

    try {
      final searchedUser =
          usersList
              .where((element) => element["name"] == searchedName)
              .toList();
      return searchedUser;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return datas;
    }
  }

  // Use a query to filter documents based on the "name" field
  List<Map<String, dynamic>> getUserDataBasedOnEmail(String emailAddress) {
    List<Map<String, dynamic>>? datas = [];

    try {
      final userData =
          usersList
              .where((element) => element["email"] == emailAddress)
              .toList();
      return userData;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return datas;
    }
  }

  final List<Map<String, dynamic>> usersList = [
    {
      'address': '123 Main St, Anytown',
      'contactNo': '09123456789',
      'email': 'user1@example.com',
      'id': '0',
      'isActive': true,
      'name': 'Alice Smith',
      'password': 'password123',
      'position': 'Admin',
      'uid': 'uid_alice_123',
    },
    {
      'address': '456 Oak Ave, Otherville',
      'contactNo': '09234567890',
      'email': 'user2@example.com',
      'id': '1',
      'isActive': true,
      'name': 'Bob Johnson',
      'password': 'password456',
      'position': 'Employee',
      'uid': 'uid_bob_456',
    },
    {
      'address': '789 Pine Ln, Villagetown',
      'contactNo': null,
      'email': 'user3@example.com',
      'id': '2',
      'isActive': false,
      'name': 'Charlie Brown',
      'password': 'password789',
      'position': 'Guest',
      'uid': 'uid_charlie_789',
    },
    {
      'address': '101 Elm St, Cityville',
      'contactNo': '09456789012',
      'email': 'user4@example.com',
      'id': '3',
      'isActive': true,
      'name': 'Diana Prince',
      'password': 'passwordabc',
      'position': 'Manager',
      'uid': 'uid_diana_abc',
    },
    {
      'address': '222 Birch Ct, Townsville',
      'contactNo': '09567890123',
      'email': 'user5@example.com',
      'id': '4',
      'isActive': true,
      'name': 'Ethan Hunt',
      'password': 'passwordxyz',
      'position': 'Employee',
      'uid': 'uid_ethan_xyz',
    },
  ];
}
