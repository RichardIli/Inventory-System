import 'package:flutter/material.dart';
import 'package:inventory_system/Presentation/Screens/UserManagementScreen/Functions/user_management_screen_functions.dart';
import 'package:inventory_system/Presentation/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/Presentation/SharedComponents/custom_footer.dart';
import 'package:inventory_system/Presentation/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Config/Theme/theme.dart';
import 'package:inventory_system/Presentation/Screens/UserManagementScreen/SubWidgets/users_list.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldMessengerState> scaffoldMessKey = GlobalKey();
    return SafeArea(
      child: ScaffoldMessenger(
        key: scaffoldMessKey,
        child: Scaffold(
          appBar: CustomAppbar(),
          body: Row(
            children: [
              SideMenu(),
              Container(
                width: 2,
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Padding(
                  padding: contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        "USER MANAGEMENT",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      // NOTE: Onty activate it when you add a new users. This is only for System admin use only
                      // add user button
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            UserManagementScreenFunctions(
                                    scaffoldContext: context)
                                .addNewUserDialog(context);
                          },
                          label: Text(
                            "ADD USER",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                          icon: Icon(
                            Icons.person_add_alt_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                          iconAlignment: IconAlignment.end,
                        ),
                      ),
                      Expanded(
                        child: UsersList(
                          scaffoldMessKey: scaffoldMessKey,
                        ),
                      ),
                      CustomFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
