import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Presentation/Screens/UserManagementScreen/SubWidgets/details_field.dart';
import 'package:inventory_system/Presentation/bloc/UserScreenBlocs/AddUserCubit/add_user_cubit.dart';
import 'package:inventory_system/Presentation/bloc/UserScreenBlocs/UsersBloc/users_bloc.dart';

class UserManagementScreenFunctions {
  UserManagementScreenFunctions({required this.scaffoldContext});

  final BuildContext scaffoldContext;

  Future<dynamic> addNewUserDialog(BuildContext context) {
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
                          context.read<AddUserCubit>().addNewUser(
                            weakPass,
                            emailAlreadyExist,
                            userEmailController.text,
                            userNameController.text,
                            userPasswordController.text,
                            userPositionController.text,
                            userAddressController.text,
                            userContactNoController.text,
                            userNameAlreadyExist,
                            notContactNo,
                            notEmailAddress,
                            () {
                              // refresh the user list
                              context.read<UsersBloc>().add(FetchUsersEvent());
                            },
                            () {
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          showCustomSnackbar(
                            // context: context,
                            message: "Fill all the Field",
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      ),
                      child: Text(
                        "ADD",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      side: WidgetStatePropertyAll(
                        BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
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
      SnackBar(content: Text(message), duration: Duration(seconds: 5)),
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
}
