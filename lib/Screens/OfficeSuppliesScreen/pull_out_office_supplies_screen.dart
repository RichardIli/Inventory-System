import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_office_supplies.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';
import 'package:inventory_system/Routes/routes.dart';
import 'package:inventory_system/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/SharedComponents/custom_footer.dart';
import 'package:inventory_system/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/OfficeSuppliesScreenBlocs/PullOutOfficeSuppliesFromDbBloc/pull_out_office_supplies_from_db_bloc.dart';
import 'package:inventory_system/bloc/OfficeSuppliesScreenBlocs/PullOutOfficeSuppliesListBloc%20copy/pull_out_office_supplies_list_bloc.dart';

class PullOutOfficeSuppliesScreen extends StatelessWidget {
  const PullOutOfficeSuppliesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => PullOutOfficeSuppliesListBloc(
                firestoreOfficeSupplies:
                    RepositoryProvider.of<FirestoreOfficeSupplies>(context),
              ),
        ),
        BlocProvider(
          create:
              (context) => PullOutOfficeSuppliesFromDbBloc(
                auth: RepositoryProvider.of<MyFirebaseAuth>(context),
                userDbRepo: RepositoryProvider.of<FirestoreUsersDbRepository>(
                  context,
                ),
                transmitalHistoryDb:
                    RepositoryProvider.of<FirestoreTransmitalHistoryRepo>(
                      context,
                    ),
                firestoreOfficeSupplies: RepositoryProvider.of<FirestoreOfficeSupplies>(
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
    TextEditingController supplyIdNameController = TextEditingController();
    TextEditingController supplyAmountController = TextEditingController();
    TextEditingController requestByController = TextEditingController();
    TextEditingController outByController = TextEditingController();
    TextEditingController receivedOnSiteByController = TextEditingController();

    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

    final pulloutOfficeSuppliesList = context.read<PullOutOfficeSuppliesListBloc>();
    final pulloutOfficeSuppliesFromDbBloc = context.read<PullOutOfficeSuppliesFromDbBloc>();

    bool isNumber(value) {
      return double.tryParse(value) != null;
    }

    return SafeArea(
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
                              onPressed:
                                  () => Navigator.pushNamed(
                                    context,
                                    officeSuppliesScreen,
                                  ),
                              icon: Icon(Icons.arrow_back),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Pull-Out Supplies",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Form(
                          key: frmKey,
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: 20,
                              children: [
                                TextFormField(
                                  controller: supplyIdNameController,
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
                                  controller: supplyAmountController,
                                  decoration: customInputDecoration.copyWith(
                                    labelText: "Enter Amount",
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This Field is Required';
                                    } else if (!isNumber(value)) {
                                      return "Enter A Valid Amount";
                                    } else if (double.parse(value) <= 0) {
                                      return "Enter A Valid Amount";
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
                                    labelText: "Receive On Site By",
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
                                  supplyIdNameController:
                                      supplyIdNameController,
                                  supplyAmountController:
                                      supplyAmountController,
                                  pulloutSuppliesList: pulloutOfficeSuppliesList,
                                  pulloutSuppliesFromDbBloc:
                                      pulloutOfficeSuppliesFromDbBloc,
                                  requestByController: requestByController,
                                  outByController: outByController,
                                  receivedOnSiteByController:
                                      receivedOnSiteByController,
                                ),
                                BlocListener<
                                  PullOutOfficeSuppliesListBloc,
                                  PullOutOfficeSuppliesListState
                                >(
                                  listener: (context, state) {
                                    if (state
                                        is PullOutOfficeSuppliesListStateError) {
                                      scaffoldMessengerKey.currentState!
                                          .showSnackBar(
                                            SnackBar(
                                              content: Text(state.error),
                                            ),
                                          );
                                      context
                                          .read<PullOutOfficeSuppliesListBloc>()
                                          .add(ResetPullOutOfficeSuppliesListEvent());
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              TableTitle(displayText: "ID"),
                                              TableTitle(displayText: "NAME"),
                                              TableTitle(
                                                displayText: "REQUEST AMOUNT",
                                              ),
                                              TableTitle(
                                                displayText: "STORED AMOUNT",
                                              ),
                                              SizedBox(width: 100),
                                            ],
                                          ),
                                        ),
                                        BlocBuilder<
                                          PullOutOfficeSuppliesListBloc,
                                          PullOutOfficeSuppliesListState
                                        >(
                                          builder: (context, state) {
                                            {
                                              if (state
                                                  is PullOutOfficeSuppliesListStateInitial) {
                                                final currentSupplyList =
                                                    state
                                                        .items; // Get items from initial state

                                                return ItemList(
                                                  currentSupplyList:
                                                      currentSupplyList,
                                                );
                                              } else if (state
                                                  is PullOutOfficeSuppliesListStateError) {
                                                final currentSupplyList =
                                                    state
                                                        .items; // Get items from initial state

                                                return ItemList(
                                                  currentSupplyList:
                                                      currentSupplyList,
                                                );
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
                              ],
                            ),
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
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.frmKey,
    required this.supplyIdNameController,
    required this.supplyAmountController,
    required this.pulloutSuppliesList,
    required this.pulloutSuppliesFromDbBloc,
    required this.requestByController,
    required this.outByController,
    required this.receivedOnSiteByController,
  });

  final GlobalKey<FormState> frmKey;
  final TextEditingController supplyIdNameController;
  final TextEditingController supplyAmountController;
  final PullOutOfficeSuppliesListBloc pulloutSuppliesList;
  final PullOutOfficeSuppliesFromDbBloc pulloutSuppliesFromDbBloc;
  final TextEditingController requestByController;
  final TextEditingController outByController;
  final TextEditingController receivedOnSiteByController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            if (frmKey.currentState!.validate()) {
              context.read<PullOutOfficeSuppliesListBloc>().add(
                AddItemToPullOutOfficeSuppliesListEvent(
                  idorName: supplyIdNameController.text.toUpperCase(),
                  amount: double.parse(supplyAmountController.text),
                ),
              );
            }
          },
          style: ButtonStyle(
            side: WidgetStatePropertyAll(BorderSide(color: Colors.grey)),
          ),
          child: Text("Add Item to List"),
        ),
        ElevatedButton(
          onPressed: () {
            if (frmKey.currentState!.validate()) {
              final state = pulloutSuppliesList.state;
              if (state is PullOutOfficeSuppliesListStateInitial) {
                final currentItems = state.items;
                if (currentItems.isNotEmpty || currentItems != []) {
                  pulloutSuppliesFromDbBloc.add(
                    StartPullOutOfficeSuppliesFromDbEvent(
                      items: currentItems,
                      requestBy: requestByController.text,
                      outBy: outByController.text.toUpperCase(),
                      receivedOnSiteBy:
                          receivedOnSiteByController.text.toUpperCase(),
                    ),
                  );
                  showDialog(
                    context: context,
                    builder: (contetx) {
                      return AlertDialog(
                        title: Text("Record Sucessful"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                suppliesScreen,
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            }
          },
          style: ButtonStyle(
            side: WidgetStatePropertyAll(BorderSide(color: Colors.grey)),
          ),
          child: Text("Pull Out Items"),
        ),
      ],
    );
  }
}

class ItemList extends StatelessWidget {
  const ItemList({super.key, required this.currentSupplyList});

  final List<Map<String, dynamic>> currentSupplyList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: currentSupplyList.length,
      itemBuilder: (context, index) {
        final supplyName = currentSupplyList[index]["name"];
        final supplyId = currentSupplyList[index]["id"];
        final storedAmount = currentSupplyList[index]["amount"].toString();
        final requestAmount =
            currentSupplyList[index]["request amount"].toString();
        return Row(
          children: [
            ListRowContent(displayTxt: supplyId),
            ListRowContent(displayTxt: supplyName),
            ListRowContent(displayTxt: requestAmount),
            ListRowContent(displayTxt: storedAmount),
            SizedBox(
              width: 100,
              child: IconButton(
                onPressed:
                    () => context.read<PullOutOfficeSuppliesListBloc>().add(
                      RemoveItemFormPullOutSuppliesListEvent(index: index),
                    ),
                icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ListRowContent extends StatelessWidget {
  const ListRowContent({super.key, required this.displayTxt});

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
  const TableTitle({super.key, required this.displayText});

  final String displayText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          displayText,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
