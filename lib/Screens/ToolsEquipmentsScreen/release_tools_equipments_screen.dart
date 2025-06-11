import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';
import 'package:inventory_system/Routes/routes.dart';
import 'package:inventory_system/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/SharedComponents/custom_footer.dart';
import 'package:inventory_system/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/PullOutToolsEquipmentsFromDbBloc/pull_out_tools_equipments_from_db_bloc.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/PullOutToolsEquipmentsListBloc/pull_out_tools_equipments_list_bloc.dart';

class ReleaseToolsEquipmentsScreen extends StatelessWidget {
  const ReleaseToolsEquipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PullOutToolsEquipmentsListBloc(
              toolsEquipmentsDbRepo:
                  RepositoryProvider.of<FirestoreToolsEquipmentDBRepository>(
                      context)),
        ),
        BlocProvider(
          create: (context) => PullOutToolsEquipmentsFromDbBloc(
              toolsEquipmentsRepo: FirestoreToolsEquipmentDBRepository(),
              auth: RepositoryProvider.of<MyFirebaseAuth>(context),
              userDbRepo:
                  RepositoryProvider.of<FirestoreUsersDbRepository>(context)),
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
    TextEditingController receivedOnSiteByController = TextEditingController();
    TextEditingController requestByController = TextEditingController();
    TextEditingController outByController = TextEditingController();

    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

    final pulloutToolsEquipmentsList =
        context.read<PullOutToolsEquipmentsListBloc>();
    final pulloutToolsEquipmentsFromDbBloc =
        context.read<PullOutToolsEquipmentsFromDbBloc>();

    return BlocListener<PullOutToolsEquipmentsFromDbBloc,
        PullOutToolsEquipmentsFromDbState>(
      listener: (context, state) {
        if (state is PulledOutToolsEquipmentsFromDb) {
          if (state.success) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (contetx) {
                return AlertDialog(
                  title: Text("Record Sucessful"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            toolsEquipmentsScreen,
                            (Route<dynamic> route) => false,
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
                                "Release Tools/Equipments",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Form(
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
                                  controller: requestByController,
                                  decoration: customInputDecoration.copyWith(
                                    labelText: "Request by",
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
                                  controller: outByController,
                                  decoration: customInputDecoration.copyWith(
                                    labelText: "Out By",
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
                                  controller: receivedOnSiteByController,
                                  decoration: customInputDecoration.copyWith(
                                    labelText: "Received On Site By",
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
                                  receivedOnSiteByController:
                                      receivedOnSiteByController,
                                  pulloutToolsEquipmentsList:
                                      pulloutToolsEquipmentsList,
                                  pulloutToolsEquipmentsFromDbBloc:
                                      pulloutToolsEquipmentsFromDbBloc,
                                  requestByController: requestByController,
                                  outByController: outByController,
                                ),
                                Expanded(
                                  child: BlocListener<
                                      PullOutToolsEquipmentsListBloc,
                                      PullOutToolsEquipmentsListState>(
                                    listener: (context, state) {
                                      if (state
                                          is PullOutToolsEquipmentsListStateError) {
                                        scaffoldMessengerKey.currentState!
                                            .showSnackBar(SnackBar(
                                                content: Text(state.error)));
                                        context
                                            .read<
                                                PullOutToolsEquipmentsListBloc>()
                                            .add(
                                                ResetPullOutToolsEquipmentsListEvent());
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
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
                                          BlocBuilder<
                                              PullOutToolsEquipmentsListBloc,
                                              PullOutToolsEquipmentsListState>(
                                            builder: (context, state) {
                                              {
                                                if (state
                                                    is PullOutToolsEquipmentsListStateInitial) {
                                                  final currentToolsEquipmentsList =
                                                      state
                                                          .items; // Get items from initial state

                                                  return ItemList(
                                                      currentToolsEquipmentsList:
                                                          currentToolsEquipmentsList);
                                                } else if (state
                                                    is PullOutToolsEquipmentsListStateError) {
                                                  final currentToolsEquipmentsList =
                                                      state
                                                          .items; // Get items from initial state

                                                  return ItemList(
                                                      currentToolsEquipmentsList:
                                                          currentToolsEquipmentsList);
                                                } else {
                                                  return Center(
                                                    child: Container(),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
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
    required this.receivedOnSiteByController,
    required this.pulloutToolsEquipmentsList,
    required this.pulloutToolsEquipmentsFromDbBloc,
    required this.requestByController,
    required this.outByController,
  });

  final GlobalKey<FormState> frmKey;
  final TextEditingController toolsEquipmentsIdNameController;
  final TextEditingController receivedOnSiteByController;
  final PullOutToolsEquipmentsListBloc pulloutToolsEquipmentsList;
  final PullOutToolsEquipmentsFromDbBloc pulloutToolsEquipmentsFromDbBloc;
  final TextEditingController requestByController;
  final TextEditingController outByController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            if (frmKey.currentState!.validate()) {
              context.read<PullOutToolsEquipmentsListBloc>().add(
                    AddItemToPullOutToolsEquipmentsListEvent(
                      idorName:
                          toolsEquipmentsIdNameController.text.toUpperCase(),
                    ),
                  );
            }
          },
          style: ButtonStyle(
            side: WidgetStatePropertyAll(BorderSide(color: Colors.grey)),
          ),
          child: Text("Add Item to List"),
        ),
        BlocBuilder<PullOutToolsEquipmentsFromDbBloc,
            PullOutToolsEquipmentsFromDbState>(
          builder: (context, state) {
            if (state is PullOutToolsEquipmentsFromDbInitial) {
              return PullOutButton(
                frmKey: frmKey,
                pulloutToolsEquipmentsList: pulloutToolsEquipmentsList,
                pulloutToolsEquipmentsFromDbBloc:
                    pulloutToolsEquipmentsFromDbBloc,
                receivedOnSiteByController: receivedOnSiteByController,
                requestByController: requestByController,
                outByController: outByController,
              );
            } else if (state is PullingOutToolsEquipmentsFromDb) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PulledOutToolsEquipmentsFromDb) {
              return Center(
                child: Icon(Icons.check_rounded),
              );
            } else if (state is PullOutToolsEquipmentsFromDbStateError) {
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

class PullOutButton extends StatelessWidget {
  const PullOutButton(
      {super.key,
      required this.frmKey,
      required this.pulloutToolsEquipmentsList,
      required this.pulloutToolsEquipmentsFromDbBloc,
      required this.receivedOnSiteByController,
      required this.requestByController,
      required this.outByController});

  final GlobalKey<FormState> frmKey;
  final PullOutToolsEquipmentsListBloc pulloutToolsEquipmentsList;
  final PullOutToolsEquipmentsFromDbBloc pulloutToolsEquipmentsFromDbBloc;
  final TextEditingController receivedOnSiteByController;
  final TextEditingController requestByController;
  final TextEditingController outByController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (frmKey.currentState!.validate()) {
            final state = pulloutToolsEquipmentsList.state;
            if (state is PullOutToolsEquipmentsListStateInitial) {
              final currentItems = state.items;
              if (currentItems.isNotEmpty || currentItems != []) {
                pulloutToolsEquipmentsFromDbBloc.add(
                    StartPullOutToolsEquipmentsFromDbEvent(
                        items: currentItems,
                        receivedOnSiteBy: receivedOnSiteByController.text,
                        requestBy: requestByController.text,
                        outby: outByController.text.toUpperCase()));
              }
            }
          }
        },
        style: ButtonStyle(
          side: WidgetStatePropertyAll(BorderSide(color: Colors.grey)),
        ),
        child: Text("Pull Out Items"));
  }
}

class ItemList extends StatelessWidget {
  const ItemList({super.key, required this.currentToolsEquipmentsList});

  final List<Map<String, dynamic>> currentToolsEquipmentsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: currentToolsEquipmentsList.length,
      itemBuilder: (context, index) {
        final toolsEquipmentsName = currentToolsEquipmentsList[index]["name"];
        final toolsEquipmentsId = currentToolsEquipmentsList[index]["id"];
        return Row(
          children: [
            ListRowContent(displayTxt: toolsEquipmentsId),
            ListRowContent(displayTxt: toolsEquipmentsName),
            SizedBox(
              width: 100,
              child: IconButton(
                onPressed: () => context
                    .read<PullOutToolsEquipmentsListBloc>()
                    .add(RemoveItemFormPullOutToolsEquipmentsListEvent(
                        index: index)),
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
              ),
            ),
          ],
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
