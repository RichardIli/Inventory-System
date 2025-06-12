import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Routes/routes.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SelectedItemCubit/selected_item_cubit.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/AddToolsEquipmentsButtonBloc/add_tools_equipments_button_bloc.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/ToolsEquipmentBloc/tools_equipment_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SearchBarBloc/search_bar_bloc.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({
    super.key,
  });

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
              Titles(displayText: "Name"),
              Titles(displayText: "Current Status"),
            ],
          ),
        ),
        MultiBlocListener(
          listeners: [
            BlocListener<SearchBarBloc, SearchBarState>(
              listener: (context, state) {
                if (state is SearchBarInitial) {
                  context.read<ToolsEquipmentBloc>().add(
                      FetchToolsEquipmentsData(search: state.searchedItem));
                }
              },
            ),
            BlocListener<AddToolsEquipmentsButtonBloc,
                AddToolsEquipmentsButtonState>(
              listener: (context, state) {
                if (state is AddToolsEquipmentsButtonLoaded) {
                  if (state.success) {
                    context
                        .read<ToolsEquipmentBloc>()
                        .add(FetchToolsEquipmentsData(search: ""));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Insertion failed')),
                    );
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<ToolsEquipmentBloc, ToolsEquipmentsState>(
            builder: (context, state) {
              if (state is ToolsEquipmentsInitial) {
                context
                    .read<ToolsEquipmentBloc>()
                    .add(FetchToolsEquipmentsData(search: ""));
                return Center(child: CircularProgressIndicator());
              } else if (state is ToolsEquipmentsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ToolsEquipmentsLoaded) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      final item = state.data[index];
                      final String itemId = item["id"] != null
                          ? item["id"].toString()
                          : "User ID not Found";
                      final String itemName = item["name"];
                      final String itemStatus = item["status"];
                      return GestureDetector(
                        onTap: () {
                          final data = {
                            "itemId": itemId,
                            "itemName": itemName,
                            "itemStatus": itemStatus
                          };
                          context.read<SelectedItemCubit>().setSelectedItem(passedData: data);

                          Navigator.pushNamed(context, itemDetailsScreen);
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
                              RowContent(displayText: itemId),
                              RowContent(displayText: itemName),
                              RowContent(displayText: itemStatus),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is ToolsEquipmentsError) {
                return Text('Error: ${state.error}');
              } else {
                return Center(
                  child: Text("No Data"),
                );
              }
            },
          ),
        ),
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
