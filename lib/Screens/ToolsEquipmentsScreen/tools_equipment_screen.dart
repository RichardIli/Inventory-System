import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';
import 'package:inventory_system/Routes/routes.dart';
import 'package:inventory_system/Screens/ToolsEquipmentsScreen/SubWidgets/add_tool_equipment_window.dart';
import 'package:inventory_system/Screens/ToolsEquipmentsScreen/SubWidgets/tools_equipments_list.dart';
import 'package:inventory_system/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/SharedComponents/custom_footer.dart';
import 'package:inventory_system/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/AddToolsEquipmentsButtonBloc/add_tools_equipments_button_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SearchBarBloc/search_bar_bloc.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/PullOutToolsEquipmentsFromDbBloc/pull_out_tools_equipments_from_db_bloc.dart';

class ToolsEquipmentScreen extends StatelessWidget {
  const ToolsEquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => AddToolsEquipmentsButtonBloc(
                RepositoryProvider.of<FirestoreToolsEquipmentDBRepository>(
                  context,
                ),
                RepositoryProvider.of<FirestoreTransmitalHistoryRepo>(context),
              ),
        ),
        BlocProvider<SearchBarBloc>(create: (context) => SearchBarBloc()),
        BlocProvider(
          create:
              (context) => PullOutToolsEquipmentsFromDbBloc(
                toolsEquipmentsRepo: FirestoreToolsEquipmentDBRepository(),
                auth: RepositoryProvider.of<MyFirebaseAuth>(context),
                userDbRepo: RepositoryProvider.of<FirestoreUsersDbRepository>(
                  context,
                ),
                transmitalHistoryDb:
                    RepositoryProvider.of<FirestoreTransmitalHistoryRepo>(
                      context,
                    ),
              ),
        ),
      ],
      child: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldMessengerState> scaffoldMessStateKey = GlobalKey();

    return Builder(
      builder: (builderContext) {
        return ScaffoldMessenger(
          key: scaffoldMessStateKey,
          child: SafeArea(
            child: Scaffold(
              appBar: CustomAppbar(),
              body: Row(
                children: [
                  SideMenu(),
                  Container(width: 2, color: Theme.of(context).primaryColor),
                  Expanded(
                    child: Padding(
                      padding: contentPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Text(
                            "Tools and Equipments",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          // search box
                          CustomSearchBox(),
                          Center(
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: [
                                CustomActionButtons(
                                  displayLabel: "ADD ITEM",
                                  customIcon: Icons.add_box_outlined,
                                  onPressed: () {
                                    // pop-up windows for ading a new item
                                    showDialog(
                                      // used a cutom context from the parent BuilderWidget to pass the bloc instance
                                      context: builderContext,
                                      builder: (context) {
                                        return AddToolEquipmentScreen(
                                          builderContext: builderContext,
                                        );
                                      },
                                    );
                                  },
                                ),
                                CustomActionButtons(
                                  displayLabel: "RETURN TOOLS/EQUIPMENTS",
                                  customIcon: Icons.inventory_rounded,
                                  onPressed:
                                      () => Navigator.pushNamed(
                                        context,
                                        returnToolsEquipmentsScreen,
                                      ),
                                ),
                                CustomActionButtons(
                                  displayLabel: "RELEASE TOOLS/EQUIPMENTS",
                                  customIcon: Icons.outbox_outlined,
                                  onPressed:
                                      () => Navigator.pushNamed(
                                        context,
                                        releaseToolsEquipmentsScreen,
                                      ),
                                ),
                                CustomActionButtons(
                                  displayLabel:
                                      "GROUP TOOLS/EQUIPMENT PER TYPE",
                                  customIcon: Icons.group_work_outlined,
                                  onPressed:
                                      () => Navigator.pushNamed(
                                        context,
                                        toolsEquipmentCountScreen,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: ItemsList()),
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
      },
    );
  }
}

class CustomActionButtons extends StatelessWidget {
  const CustomActionButtons({
    super.key,
    required this.displayLabel,
    required this.customIcon,
    required this.onPressed,
  });

  final String displayLabel;
  final IconData customIcon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      label: Text(
        displayLabel,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).primaryColor),
      ),
      icon: Icon(customIcon, size: 30, color: Colors.black),
      iconAlignment: IconAlignment.end,
    );
  }
}

class CustomSearchBox extends StatefulWidget {
  const CustomSearchBox({super.key});

  @override
  State<CustomSearchBox> createState() => _CustomSearchBoxState();
}

class _CustomSearchBoxState extends State<CustomSearchBox> {
  Timer? _debounce;

  void _onSearchChanged(String query) {
    // Cancel the previous timer if it exists
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Call your search function here
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    // Implement your search logic here
    context.read<SearchBarBloc>().add(
      FetchSearchBarFilteredItemEvent(searchItem: query.toUpperCase()),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 400,
      child: SearchBar(
        onChanged: _onSearchChanged,
        leading: Icon(Icons.search_rounded),
        hintText: "Search...",
        hintStyle: WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
      ),
    );
  }
}
