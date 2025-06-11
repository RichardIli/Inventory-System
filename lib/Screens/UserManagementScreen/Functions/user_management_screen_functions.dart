import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';
import 'package:inventory_system/Screens/UserManagementScreen/SubWidgets/details_field.dart';

class UserManagementScreenFunctions {
  UserManagementScreenFunctions({
    required this.scaffoldContext,
  });

  final BuildContext scaffoldContext;

  Future<dynamic> addNewUserDialog(
    BuildContext context,
  ) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController userPasswordController = TextEditingController();
    TextEditingController userPositionController = TextEditingController();
    TextEditingController userEmailController = TextEditingController();
    TextEditingController userAddressController = TextEditingController();
    TextEditingController userContactNoController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            title: Text("Add New User"),
            content: IntrinsicHeight(
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailsField(
                    customWidth: 500,
                    fieldLabel: "User Name:",
                    controller: userNameController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DetailsField(
                        customWidth: 240,
                        fieldLabel: "Password",
                        controller: userPasswordController,
                      ),
                      DetailsField(
                        customWidth: 240,
                        fieldLabel: "Position:",
                        controller: userPositionController,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      DetailsField(
                        customWidth: 240,
                        fieldLabel: "Email Address",
                        controller: userEmailController,
                      ),
                      DetailsField(
                        customWidth: 240,
                        fieldLabel: "Contact no",
                        controller: userContactNoController,
                      ),
                    ],
                  ),
                  DetailsField(
                    customWidth: 500,
                    fieldLabel: "Permanent Address",
                    controller: userAddressController,
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        // validating that all the neccessary field is filled
                        if (formKey.currentState!.validate()) {
                          // another layer of data validation
                           callAddUserFromBackEnd(
                            context,
                            weakPass,
                            emailAlreadyExist,
                            userEmailController.text,
                            userNameController.text,
                            userPasswordController.text,
                            userPositionController.text,
                            userAddressController.text,
                            userContactNoController.text,
                          );
                        } else {
                          showCustomSnackbar(
                              // context: context,
                              message: "Fill all the Field");
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                      child: Text("ADD",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                        side: WidgetStatePropertyAll(
                            BorderSide(color: Colors.black, width: 1))),
                    child: Text(
                      "Cancel",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showCustomSnackbar({required String message}) {
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void weakPass() {
    showCustomSnackbar(message: "Weak Password");
  }

  void emailAlreadyExist() {
    showCustomSnackbar(message: "Email Already Exist");
  }

  void notEmailAddress() {
    showCustomSnackbar(message: "Enter a valid Email Address");
  }

  void notContactNo() {
    showCustomSnackbar(message: "Enter a valid Contact Number");
  }

  void userNameAlreadyExist() {
    showCustomSnackbar(message: "User name already Exist");
  }

  void callAddUserFromBackEnd(
    BuildContext context,
    void Function() weakPass,
    void Function() emailAlreadyExist,
    String userEmailAddress,
    String userName,
    String userPassword,
    String userPosition,
    String userAddress,
    String userContactNo,
  )  {
    MyFirebaseAuth myFirebaseAuth =
        RepositoryProvider.of<MyFirebaseAuth>(context);

    FirestoreUsersDbRepository userDbrepository =
        RepositoryProvider.of<FirestoreUsersDbRepository>(context);

    // verification of emmail address
    if (isEmail(userEmailAddress)) {
      // verrification of contact number
      if (isNumber(userContactNo)) {
        // check if the user is already in the database to prevent data duplication
        var searchUser =
             userDbrepository.searchUserData(userName.toUpperCase());
        if (searchUser.isEmpty) {
          // convert the data from string to int
          final int contacNo = int.parse(userContactNo);
          // craeting user authentication
           myFirebaseAuth.addUserToAuth(
            // ignore: use_build_context_synchronously
            context,
            weakPass,
            emailAlreadyExist,
            userEmailAddress,
            userName.toUpperCase(),
            userPosition.toUpperCase(),
            userAddress.toUpperCase(),
            userPassword,
            contacNo,
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

  bool isEmail(String userEmailAddress) {
    return EmailValidator.validate(userEmailAddress);
  }

  bool isNumber(String str) {
    return int.tryParse(str) != null;
  }
}
