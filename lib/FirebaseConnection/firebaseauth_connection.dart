import 'package:flutter/material.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';

class MyFirebaseAuth {
  FirestoreUsersDbRepository firestoreUsersDbRepository =
      FirestoreUsersDbRepository();

  bool login({
    // required void Function() errorMessage,
    required String emailAddress,
    required String password,
  })  {
    try {
      final userList = firestoreUsersDbRepository.usersList;

      final fetchedEmail =
          userList
              .where((element) => element["email"] == emailAddress)
              .toList()
              .first;

      if (fetchedEmail.isNotEmpty) {
        return fetchedEmail["password"] == password ? true : false;
      }
      return false;
    } catch (e) {
      //This is error code
      // ignore: avoid_print
      // errorMessage();
      return false;
    }
  }

  void signOut()  {}

  // get the signed in user
  String getCurrentUserEmail(String userEmail)  {
    String currentUserEmail = '';
    try {
      return userEmail;
    } catch (e) {
      return currentUserEmail;
    }
  }

  //add user to authentication
  void addUserToAuth(
    BuildContext context,
    void Function() weakPass,
    void Function() alreadyExist,
    String userEmailAddress,
    String userName,
    String userPosition,
    String userAddress,
    String userPassword,
    int userContactNo,
  )  {
    try {
      
      // add the user to the deatabase
      FirestoreUsersDbRepository().addUserToDB(
        // ignore: use_build_context_synchronously
        context,
        userEmailAddress,
        userName,
        userPosition,
        userAddress,
        userPassword,
        "this is the uid of the account",
        userContactNo,
      );
    }  catch (e) {
      //This is error code
      // ignore: avoid_print
      print(e);
    }
  }

  String fetchAuthenticatedUserData(String? email)  {
    FirestoreUsersDbRepository firestoreUsersDbRepository = FirestoreUsersDbRepository();
    final users = firestoreUsersDbRepository.usersList;
    final username = users.where((element)=>element["email"]==email).toList().first;
    return username["name"];
  }
}
