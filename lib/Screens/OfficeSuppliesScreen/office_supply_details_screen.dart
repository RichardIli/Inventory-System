import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Routes/routes.dart';
import 'package:inventory_system/Screens/OfficeSuppliesScreen/SubWidgets/office_supply_details_area.dart';
import 'package:inventory_system/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/SharedComponents/custom_footer.dart';
import 'package:inventory_system/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SelectedItemCubit/selected_item_cubit.dart';

class OfficeSupplyDetailsScreen extends StatelessWidget {
  const OfficeSupplyDetailsScreen({super.key});

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
                            "Item Details",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<SelectedItemCubit, SelectedItemState>(
                      builder: (context, state) {
                        if (state is SelectedItem) {
                          final passedData = state.passedData;
                          return Expanded(
                            child: SingleChildScrollView(
                              child: OfficeSupplyDetailsArea(
                                supplyId: passedData["supplyId"],
                                supplyName: passedData["supplyName"],
                                supplyUnit: passedData["supplyUnit"],
                              ),
                            ),
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
