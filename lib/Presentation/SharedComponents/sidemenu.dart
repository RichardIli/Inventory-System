import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Config/Routes/routes.dart';
import 'package:inventory_system/Presentation/SharedComponents/sign_out_confirmation_window.dart';
import 'package:inventory_system/Presentation/bloc/SideMenuBloc/side_menu_bloc.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              //Menu Buttons Container
              child: Card(
                elevation: 0,
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: BlocBuilder<SideMenuBloc, SideMenuState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          CustomMenuButtons(
                            displayIcon: Icons.dashboard_outlined,
                            displayLabel: "Dashboard",
                            isSelected: state.initialScreen == 0 ? true : false,
                            ontap: () {
                              context
                                  .read<SideMenuBloc>()
                                  .add(NavigateToDashboardEvent());
                              Navigator.pushNamed(context, dashboardScreen);
                            },
                          ),
                          CustomMenuButtons(
                            displayIcon: Icons.supervised_user_circle_outlined,
                            displayLabel: "Users",
                            isSelected: state.initialScreen == 1 ? true : false,
                            ontap: () {
                              context
                                  .read<SideMenuBloc>()
                                  .add(NavigateToUsersEvent());
                              Navigator.pushNamed(
                                  context, userManagementScreen);
                            },
                          ),
                          CustomMenuButtons(
                            displayIcon: Icons.handyman_outlined,
                            displayLabel: "Tools/Equipments",
                            isSelected: state.initialScreen == 2 ? true : false,
                            ontap: () {
                              context
                                  .read<SideMenuBloc>()
                                  .add(NavigateToToolsEquipmentsEvent());
                              Navigator.pushNamed(
                                  context, toolsEquipmentsScreen);
                            },
                          ),
                          CustomMenuButtons(
                            displayIcon: Icons.inventory_2_outlined,
                            displayLabel: "Supplies",
                            isSelected: state.initialScreen == 3 ? true : false,
                            ontap: () {
                              context
                                  .read<SideMenuBloc>()
                                  .add(NavigateToSuppliesEvent());
                              Navigator.pushNamed(context, suppliesScreen);
                            },
                          ),
                          CustomMenuButtons(
                            displayIcon: Icons.inventory_rounded,
                            displayLabel: "Office Supplies",
                            isSelected: state.initialScreen == 4 ? true : false,
                            ontap: () {
                              context
                                  .read<SideMenuBloc>()
                                  .add(NavigateToOfficeSuppliesEvent());
                              Navigator.pushNamed(
                                  context, officeSuppliesScreen);
                            },
                          ),
                          CustomMenuButtons(
                            displayIcon: Icons.history,
                            displayLabel: "Transmital History",
                            isSelected: state.initialScreen == 5 ? true : false,
                            ontap: () {
                              context
                                  .read<SideMenuBloc>()
                                  .add(NavigateToTransmitalHistoryEvent());
                              Navigator.pushNamed(
                                  context, transmitalHistoryScreen);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            //Sign Out/Logout Button
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 30,
              ),
              width: double.infinity,
              height: 50,
              child: TextButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Theme.of(context).primaryColor),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SignOutConfirmationWindow();
                      });
                },
                label: Text(
                  "Sign Out",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                icon: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomMenuButtons extends StatelessWidget {
  const CustomMenuButtons({
    super.key,
    required this.displayIcon,
    required this.displayLabel,
    required this.isSelected,
    required this.ontap,
  });

  final IconData displayIcon;
  final String displayLabel;
  final bool isSelected;
  final void Function() ontap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: isSelected ? Theme.of(context).primaryColor : null,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () {
          ontap();
        },
        selected: isSelected,
        selectedColor: Colors.white,
        leading: Icon(displayIcon),
        title: Text(
          displayLabel,
        ),
      ),
    );
  }
}
