import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Screens/ToolsEquipmentsScreen/SubWidgets/tool_equipment_details_area.dart';
import 'package:inventory_system/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/SharedComponents/custom_footer.dart';
import 'package:inventory_system/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SelectedItemBloc/selected_item_bloc.dart';

class ItemsDetailsScreen extends StatelessWidget {
  const ItemsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Item Details",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<SelectedItemBloc, SelectedItemState>(
                      builder: (context, state) {
                        if (state is SelectedItemInitial) {
                          return CircularProgressIndicator();
                        } else if (state is SelectedItemLoading) {
                          return CircularProgressIndicator();
                        } else if (state is SelectedItemLoaded) {
                          final passedData = state.passedData;
                          return Expanded(
                            child: SingleChildScrollView(
                              child: ToolsEquipmentsDetailsArea(
                                itemId: passedData["itemId"],
                                itemName: passedData["itemName"],
                                itemStatus: passedData["itemStatus"],
                              ),
                            ),
                          );
                        } else if (state is SelectedItemError) {
                          return Column(
                            children: [
                              Icon(Icons.error_outline_rounded),
                              Text(
                                state.error,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          );
                        }
                        return Container();
                      },
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
