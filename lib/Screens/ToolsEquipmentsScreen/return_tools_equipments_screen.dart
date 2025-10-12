import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';
import 'package:inventory_system/Routes/routes.dart';
import 'package:inventory_system/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/SharedComponents/custom_footer.dart';
import 'package:inventory_system/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/ReturnToolsEquipmentsListBloc/return_tools_equipments_list_bloc.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/ReturnToolsEquipmentsToDbBloc/return_tools_equipments_to_db_bloc.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/ToolsEquipmentBloc/tools_equipment_bloc.dart';

class ReturnToolsEquipmentsScreen extends StatelessWidget {
  const ReturnToolsEquipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ReturnToolsEquipmentsListBloc(
            toolsEquipmentsDbRepo:
                RepositoryProvider.of<FirestoreToolsEquipmentDBRepository>(
                    context),
            auth: RepositoryProvider.of<MyFirebaseAuth>(context),
            userDbRepo:
                RepositoryProvider.of<FirestoreUsersDbRepository>(context),
            transmitalHistoryDb: RepositoryProvider.of<FirestoreTransmitalHistoryRepo>(
                context),
          ),
        ),
        BlocProvider(
          create: (context) => ReturnToolsEquipmentsToDbBloc(
            toolsEquipmentsRepo:
                RepositoryProvider.of<FirestoreToolsEquipmentDBRepository>(
                    context),
            auth: RepositoryProvider.of<MyFirebaseAuth>(context),
            userDbRepo:
                RepositoryProvider.of<FirestoreUsersDbRepository>(context),
            transmitalHistoryDb: RepositoryProvider.of<FirestoreTransmitalHistoryRepo>(
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
    GlobalKey<FormState> frmKey = GlobalKey();
    TextEditingController toolsEqipmentsIdNameController =
        TextEditingController();
    TextEditingController returnByController = TextEditingController();

    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

    final returnToolsEquipmentsList =
        context.read<ReturnToolsEquipmentsListBloc>();
    final returnToolsEquipmentsFromDbBloc =
        context.read<ReturnToolsEquipmentsToDbBloc>();

    return BlocListener<ReturnToolsEquipmentsToDbBloc,
        ReturnToolsEquipmentsToDbState>(
      listener: (context, state) {
        if (state is ReturnedToolsEquipmentsToDb) {
          context.read<ToolsEquipmentBloc>().add(
                FetchToolsEquipmentsData(search: ""),
              );
          if (state.success) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (contetx) {
                return AlertDialog(
                  title: Text("Return Sucessful"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            toolsEquipmentsScreen
                          );
                        },
                        child: Text("OK")),
                  ],
                );
              },
            );
          }
        }
      },
      child: SafeArea(
        child: ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
            appBar: CustomAppbar(),
            body: Row(
              children: [
                SideMenu(),
                Expanded(
                  child: Padding(
                    padding: contentPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, toolsEquipmentsScreen),
                                icon: Icon(Icons.arrow_back),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Return Tools/Equipments",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Form(
                                key: frmKey,
                                child: Column(
                                  spacing: 20,
                                  children: [
                                    TextFormField(
                                      controller: toolsEqipmentsIdNameController,
                                      decoration: customInputDecoration.copyWith(
                                        labelText: "Enter Id or Name...",
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This Field is Required';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: returnByController,
                                      decoration: customInputDecoration.copyWith(
                                        labelText: "Return By...",
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This Field is Required';
                                        }
                                        return null;
                                      },
                                    ),
                                    ActionButtons(
                                      frmKey: frmKey,
                                      toolsEquipmentsIdNameController:
                                          toolsEqipmentsIdNameController,
                                      returnByController: returnByController,
                                      returnToolsEquipmentsList:
                                          returnToolsEquipmentsList,
                                      returnToolsEquipmentsToDbBloc:
                                          returnToolsEquipmentsFromDbBloc,
                                    ),
                                  ],
                                ),
                              ),

                              // list container moved outside the Form so its Expanded
                              // child has a bounded height from this Expanded sibling.
                              Expanded(
                                child: BlocListener<
                                    ReturnToolsEquipmentsListBloc,
                                    ReturnToolsEquipmentsListState>(
                                  listener: (context, state) {
                                    if (state
                                        is ReturnToolsEquipmentsListStateError) {
                                      scaffoldMessengerKey.currentState!
                                          .showSnackBar(SnackBar(
                                              content: Text(state.error)));
                                      context
                                          .read<ReturnToolsEquipmentsListBloc>()
                                          .add(
                                              ResetReturnToolsEquipmentsListEvent());
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 2))),
                                          child: Row(
                                            children: [
                                              TableTitle(displayText: "ID"),
                                              TableTitle(displayText: "NAME"),
                                              SizedBox(
                                                width: 100,
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: BlocBuilder<
                                              ReturnToolsEquipmentsListBloc,
                                              ReturnToolsEquipmentsListState>(
                                            builder: (context, state) {
                                              if (state
                                                  is ReturnToolsEquipmentsListStateInitial) {
                                                final currentToolsEquipmentsList =
                                                    state.items; // Get items from initial state

                                                return ItemList(
                                                    currentToolsEquipmentsList:
                                                        currentToolsEquipmentsList);
                                              } else if (state
                                                  is ReturnToolsEquipmentsListStateError) {
                                                final currentToolsEquipmentsList =
                                                    state.items; // Get items from initial state

                                                return ItemList(
                                                    currentToolsEquipmentsList:
                                                        currentToolsEquipmentsList);
                                              } else {
                                                return Center(
                                                  child: Container(),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.frmKey,
    required this.toolsEquipmentsIdNameController,
    required this.returnByController,
    required this.returnToolsEquipmentsList,
    required this.returnToolsEquipmentsToDbBloc,
  });

  final GlobalKey<FormState> frmKey;
  final TextEditingController toolsEquipmentsIdNameController;
  final TextEditingController returnByController;
  final ReturnToolsEquipmentsListBloc returnToolsEquipmentsList;
  final ReturnToolsEquipmentsToDbBloc returnToolsEquipmentsToDbBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            if (frmKey.currentState!.validate()) {
              context.read<ReturnToolsEquipmentsListBloc>().add(
                  AddItemToReturnToolsEquipmentsListEvent(
                      idorName:
                          toolsEquipmentsIdNameController.text.toUpperCase(),
                      willInBy: returnByController.text.toUpperCase()));
            }
          },
          style: ButtonStyle(
            side: WidgetStatePropertyAll(BorderSide(color: Colors.grey)),
          ),
          child: Text("Add Item to List"),
        ),
        BlocBuilder<ReturnToolsEquipmentsToDbBloc,
            ReturnToolsEquipmentsToDbState>(
          builder: (context, state) {
            if (state is ReturnToolsEquipmentsToDbInitial) {
              return ReturnItemsButton(
                  frmKey: frmKey,
                  returnByController: returnByController,
                  returnToolsEquipmentsList: returnToolsEquipmentsList,
                  returnToolsEquipmentsToDbBloc: returnToolsEquipmentsToDbBloc);
            } else if (state is ReturningToolsEquipmentsToDb) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ReturnedToolsEquipmentsToDb) {
              return Center(
                child: Icon(Icons.check_rounded),
              );
            } else if (state is ReturnToolsEquipmentsToDbStateError) {
              return Icon(Icons.warning_amber_rounded);
            } else {
              return Center(
                child: Text(
                  "Consult your IT",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class ReturnItemsButton extends StatelessWidget {
  const ReturnItemsButton({
    super.key,
    required this.frmKey,
    required this.returnByController,
    required this.returnToolsEquipmentsList,
    required this.returnToolsEquipmentsToDbBloc,
  });

  final GlobalKey<FormState> frmKey;
  final TextEditingController returnByController;
  final ReturnToolsEquipmentsListBloc returnToolsEquipmentsList;
  final ReturnToolsEquipmentsToDbBloc returnToolsEquipmentsToDbBloc;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (frmKey.currentState!.validate()) {
            final state = returnToolsEquipmentsList.state;
            if (state is ReturnToolsEquipmentsListStateInitial) {
              final currentItems = state.items;
              if (currentItems.isNotEmpty || currentItems != []) {
                returnToolsEquipmentsToDbBloc
                    .add(StartReturnToolsEquipmentsToDbEvent(
                  items: currentItems,
                  inBy: returnByController.text.toUpperCase(),
                ));
              }
            }
          }
        },
        style: ButtonStyle(
          side: WidgetStatePropertyAll(BorderSide(color: Colors.grey)),
        ),
        child: Text("Return Items"));
  }
}

class ItemList extends StatelessWidget {
  const ItemList({super.key, required this.currentToolsEquipmentsList});

  final List<Map<String, dynamic>> currentToolsEquipmentsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: currentToolsEquipmentsList.length,
      itemBuilder: (context, index) {
        final toolsEquipmentsName = currentToolsEquipmentsList[index]["name"];
        final toolsEquipmentsId = currentToolsEquipmentsList[index]["id"];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            children: [
              ListRowContent(displayTxt: toolsEquipmentsId),
              ListRowContent(displayTxt: toolsEquipmentsName),
              SizedBox(
                width: 100,
                child: IconButton(
                  onPressed: () => context
                      .read<ReturnToolsEquipmentsListBloc>()
                      .add(RemoveItemFormReturnToolsEquipmentsListEvent(
                          index: index)),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ListRowContent extends StatelessWidget {
  const ListRowContent({
    super.key,
    required this.displayTxt,
  });

  final String displayTxt;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(displayTxt, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}

class TableTitle extends StatelessWidget {
  const TableTitle({
    super.key,
    required this.displayText,
  });

  final String displayText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          displayText,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
