import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:inventory_system/FirebaseConnection/firestore_items_repo.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SelectedItemBloc/selected_item_bloc.dart';
import 'package:inventory_system/bloc/SuppliesScreenBlocs/AddNewSupplyButtonBloc/add_new_supply_button_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SearchBarBloc/search_bar_bloc.dart';
import 'package:inventory_system/bloc/SuppliesScreenBlocs/SuppliesBloc/supplies_bloc.dart';

class SupplyList extends StatefulWidget {
  const SupplyList({
    super.key,
  });

  @override
  State<SupplyList> createState() => _SupplyListState();
}

class _SupplyListState extends State<SupplyList> {
  @override
  void initState() {
    context.read<SuppliesBloc>().add(FetchSuppliesEvent(search: ""));
    super.initState();
  }

  // Future<void> importData(List<Map<String, dynamic>> data) async {
  //   try {
  //     final FirestoreItemsRepo firestoreItemsRepo = FirestoreItemsRepo();

  //     await firestoreItemsRepo.importSupplies(data);
  //   } catch (e) {
  //     print("error: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Titles(displayText: "ID"),
              Titles(displayText: "Supply Name"),
              Titles(displayText: "Remainig Amount"),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: MultiBlocListener(
              listeners: [
                BlocListener<SearchBarBloc, SearchBarState>(
                  listener: (context, state) {
                    if (state is SearchBarInitial) {
                      context
                          .read<SuppliesBloc>()
                          .add(FetchSuppliesEvent(search: state.searchedItem));
                      // FetchToolsEquipmentsData(search: state.searchedItem)
                    }
                  },
                ),
                BlocListener<AddNewSupplyButtonBloc, AddNewSupplyButtonState>(
                  listener: (context, state) {
                    if (state is AddNewSupplyButtonLoaded) {
                      if (state.success) {
                        context
                            .read<SuppliesBloc>()
                            .add(FetchSuppliesEvent(search: ""));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Insertion failed')),
                        );
                      }
                    }
                  },
                ),
              ],
              child: BlocBuilder<SuppliesBloc, SuppliesState>(
                builder: (context, state) {
                  if (state is SuppliesInitial) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SuppliesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SuppliesLoaded) {
                    final supplyList = state.data;
                    // importData(supplyList);

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: supplyList.length,
                      itemBuilder: (context, index) {
                        final supply = supplyList[index];
                        final String supplyId = supply["id"] != null
                            ? supply["id"].toString()
                            : "Supply ID not Found";
                        final String supplyName = supply["name"];
                        final String supplyAmount = supply["amount"].toString();
                        final String supplyUnit = supply["unit"];
                        return GestureDetector(
                          onTap: () {
                            final data = {
                              "supplyId": supplyId,
                              "supplyName": supplyName,
                              "supplyUnit": supplyUnit,
                              "listIndex": index,
                            };
                            context
                                .read<SelectedItemBloc>()
                                .add(SelectSelectedItemEvent(passedData: data));
                            // The navigation is in the listener
                            // Navigator.pushNamed(context, supplyDetailsScreen);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RowContent(displayText: supplyId),
                                RowContent(displayText: supplyName),
                                RowContent(
                                    displayText: "$supplyAmount - $supplyUnit"),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is SuppliesStateError) {
                    return Text('Error: ${state.error}');
                  } else {
                    return Center(
                      child: Text("No Data"),
                    );
                  }
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Titles extends StatelessWidget {
  const Titles({
    super.key,
    required this.displayText,
  });

  final String displayText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        textAlign: TextAlign.center,
        displayText,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class RowContent extends StatelessWidget {
  const RowContent({
    super.key,
    required this.displayText,
  });

  final String displayText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        displayText,
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
