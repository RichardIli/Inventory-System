import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Routes/routes.dart';
import 'package:inventory_system/bloc/OfficeSuppliesScreenBlocs/AddNewOfficeSupplyButtonBloc/add_new_office_supply_button_bloc.dart';
import 'package:inventory_system/bloc/OfficeSuppliesScreenBlocs/OfficeSuppliesBloc/office_supplies_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SearchBarBloc/search_bar_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SelectedItemCubit/selected_item_cubit.dart';

class OfficeSupplyList extends StatefulWidget {
  const OfficeSupplyList({super.key});

  @override
  State<OfficeSupplyList> createState() => _OfficeSupplyListState();
}

class _OfficeSupplyListState extends State<OfficeSupplyList> {
  @override
  void initState() {
    context.read<OfficeSuppliesBloc>().add(
      FetchOfficeSuppliesEvent(search: ""),
    );
    super.initState();
  }

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
                      context.read<OfficeSuppliesBloc>().add(
                        FetchOfficeSuppliesEvent(search: state.searchedItem),
                      );
                      // FetchToolsEquipmentsData(search: state.searchedItem)
                    }
                  },
                ),
                BlocListener<
                  AddNewOfficeSupplyButtonBloc,
                  AddNewOfficeSupplyButtonState
                >(
                  listener: (context, state) {
                    if (state is AddNewOfficeSupplyButtonLoaded) {
                      if (state.success) {
                        context.read<OfficeSuppliesBloc>().add(
                          FetchOfficeSuppliesEvent(search: ""),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Insertion failed')),
                        );
                      }
                    }
                  },
                ),
              ],
              child: BlocBuilder<OfficeSuppliesBloc, OfficeSuppliesState>(
                builder: (context, state) {
                  if (state is OfficeSuppliesInitial) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is OfficeSuppliesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is OfficeSuppliesLoaded) {
                    final supplyList = state.data;
                    // importData(supplyList);

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: supplyList.length,
                      itemBuilder: (context, index) {
                        final supply = supplyList[index];
                        final String supplyId =
                            supply["id"] != null
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
                            context.read<SelectedItemCubit>().setSelectedItem(
                              passedData: data,
                            );
                            // The navigation is in the listener
                            Navigator.pushNamed(context, officeSupplyDetailsScreen);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RowContent(displayText: supplyId),
                                RowContent(displayText: supplyName),
                                RowContent(
                                  displayText: "$supplyAmount - $supplyUnit",
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is OfficeSuppliesStateError) {
                    return Text('Error: ${state.error}');
                  } else {
                    return Center(child: Text("No Data"));
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Titles extends StatelessWidget {
  const Titles({super.key, required this.displayText});

  final String displayText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        textAlign: TextAlign.center,
        displayText,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class RowContent extends StatelessWidget {
  const RowContent({super.key, required this.displayText});

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
