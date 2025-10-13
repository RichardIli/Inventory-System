import 'package:flutter/material.dart';
import 'package:inventory_system/Presentation/Screens/DashboardScreen/SubWidgets/custom_cards.dart';
import 'package:inventory_system/Presentation/Screens/DashboardScreen/SubWidgets/dashboard_lists.dart';
import 'package:inventory_system/Presentation/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/Presentation/SharedComponents/custom_footer.dart';
import 'package:inventory_system/Presentation/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Config/Theme/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(),
        body: Row(
          children: [
            SideMenu(),
            // Line Decor
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
                    // Screen Title
                    Text(
                      "Dashboard",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    // Cards
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              spacing: 20,
                              children: [
                                UsersCard(),
                                // WorkersCard(),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Row(
                                spacing: 20,
                                children: [
                                  // This is the list of items thats currently outside
                                  ItemsOutside(),
                                  // This is for future.
                                  // InventoryNotice(),
                                ],
                              ),
                            ),
                          ],
                        ),
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
    );
  }
}
