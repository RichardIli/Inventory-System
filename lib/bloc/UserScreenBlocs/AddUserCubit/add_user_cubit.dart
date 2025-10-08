import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';

part 'add_user_state.dart';

class AddUserCubit extends Cubit<AddUserState> {
  final MyFirebaseAuth myFirebaseAuth;
  final FirestoreUsersDbRepository userDbrepository;
  AddUserCubit({required this.myFirebaseAuth, required this.userDbrepository})
    : super(AddUserInitial());

  void addNewUser(
    void Function() weakPass,
    void Function() emailAlreadyExist,
    String userEmailAddress,
    String userName,
    String userPassword,
    String userPosition,
    String userAddress,
    String userContactNo,
    void Function() userNameAlreadyExist,
    void Function() notContactNo,
    void Function() notEmailAddress,
    void Function() refreshList,
    void Function() closePopup,
  ) {
    emit(AddUserLoading());
    try {
      // Simulate a network call or any async operation
      // Future.delayed(const Duration(seconds: 2), () {
      //   // Randomly decide if the operation was successful or failed
      //   if (Random().nextBool()) {
      //     emit(AddUserSuccess());
      //   } else {
      //     emit(AddUserFailure("Failed to add user. Please try again."));
      //   }
      // });

      _addUserToAuthAndDB(
        myFirebaseAuth,
        userDbrepository,
        weakPass,
        emailAlreadyExist,
        userEmailAddress,
        userName,
        userPassword,
        userPosition,
        userAddress,
        userContactNo,
        userNameAlreadyExist,
        notContactNo,
        notEmailAddress,
        refreshList,
        closePopup,
      );
    } catch (e) {
      emit(
        AddUserFailure(
          "An error occurred while adding the user.\nError: ${e.toString()}",
        ),
      );
    }
  }

  void _addUserToAuthAndDB(
    MyFirebaseAuth myFirebaseAuth,
    FirestoreUsersDbRepository userDbrepository,
    // BuildContext context,
    void Function() weakPass,
    void Function() emailAlreadyExist,
    String userEmailAddress,
    String userName,
    String userPassword,
    String userPosition,
    String userAddress,
    String userContactNo,
    void Function() userNameAlreadyExist,
    void Function() notContactNo,
    void Function() notEmailAddress,
    void Function() refreshList,
    void Function() closePopup,
  ) {
    // verification of emmail address
    if (_isEmail(userEmailAddress)) {
      // verrification of contact number
      if (_isNumber(userContactNo)) {
        // check if the user is already in the database to prevent data duplication
        var searchUser = userDbrepository.searchUserData(
          userName.toUpperCase(),
        );
        if (searchUser.isEmpty) {
          // convert the data from string to int
          final int contacNo = int.parse(userContactNo);
          // craeting user authentication
          myFirebaseAuth.addUserToAuth(
            // ignore: use_build_context_synchronously
            // context,
            weakPass,
            emailAlreadyExist,
            userEmailAddress,
            userName.toUpperCase(),
            userPosition.toUpperCase(),
            userAddress.toUpperCase(),
            userPassword,
            contacNo,
            refreshList,
            closePopup,
          );

          userDbrepository.addUserToDB(
            // ignore: use_build_context_synchronously
            // context,
            userEmailAddress,
            userName,
            userPosition,
            userAddress,
            userPassword,
            "this is the uid of the account",
            contacNo,
            refreshList,
            closePopup,
          );
        } else {
          userNameAlreadyExist();
        }
      } else {
        notContactNo();
      }
    } else {
      notEmailAddress();
    }
  }

  bool _isEmail(String userEmailAddress) {
    return EmailValidator.validate(userEmailAddress);
  }

  bool _isNumber(String str) {
    return int.tryParse(str) != null;
  }
}
