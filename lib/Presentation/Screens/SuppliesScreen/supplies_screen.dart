import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_supplies.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/Config/Routes/routes.dart';
import 'package:inventory_system/Presentation/Screens/SuppliesScreen/SubWidgets/add_supply_window.dart';
import 'package:inventory_system/Presentation/Screens/SuppliesScreen/SubWidgets/supply_list.dart';
import 'package:inventory_system/Presentation/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/Presentation/SharedComponents/custom_footer.dart';
import 'package:inventory_system/Presentation/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Config/Theme/theme.dart';
import 'package:inventory_system/Presentation/bloc/SuppliesScreenBlocs/AddNewSupplyButtonBloc/add_new_supply_button_bloc.dart';
import 'package:inventory_system/Presentation/bloc/SharedComponentsBlocs/SearchBarBloc/search_bar_bloc.dart';

class SuppliesScreen extends StatelessWidget {
  const SuppliesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldMessengerState> scaffoldMessStateKey = GlobalKey();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => AddNewSupplyButtonBloc(
                RepositoryProvider.of<FirestoreSuppliesDb>(context),
                RepositoryProvider.of<FirestoreTransmitalHistoryRepo>(context),
              ),
        ),
        BlocProvider(create: (context) => SearchBarBloc()),
      ],
      child: Builder(
        builder: (builderContext) {
          return SafeArea(
            child: ScaffoldMessenger(
              key: scaffoldMessStateKey,
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
                              "Supplies",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomSearchBox(),
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed:
                                          () => Navigator.pushNamed(
                                            context,
                                            pullOutSupplyScreen,
                                          ),
                                      label: Text(
                                        "Pull-Out Supply",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.inventory_rounded,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                      iconAlignment: IconAlignment.end,
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: builderContext,
                                          builder: (context) {
                                            return AddSupplyWindow(
                                              builderContext: builderContext,
                                            );
                                          },
                                        );
                                      },
                                      label: Text(
                                        "ADD Supply",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.add_box_outlined,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                      iconAlignment: IconAlignment.end,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(child: SupplyList()),
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
      ),
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
        // onChanged: (value) {
        //   if (value.isNotEmpty) {
        //     context.read<SearchBarBloc>().add(
        //           FetchSearchBarFilteredItemEvent(
        //             searchItem: value.toUpperCase(),
        //           ),
        //         );
        //   } else {
        //     context.read<SearchBarBloc>().add(
        //           FetchSearchBarFilteredItemEvent(
        //             searchItem: "",
        //           ),
        //         );
        //   }
        // },
        onChanged: _onSearchChanged,
        leading: Icon(Icons.search_rounded),
        hintText: "Search...",
        hintStyle: WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
      ),
    );
  }
}
