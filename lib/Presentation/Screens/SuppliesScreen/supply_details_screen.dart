import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Config/Routes/routes.dart';
import 'package:inventory_system/Presentation/Screens/SuppliesScreen/SubWidgets/supply_details_area.dart';
import 'package:inventory_system/Presentation/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/Presentation/SharedComponents/custom_footer.dart';
import 'package:inventory_system/Presentation/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Config/Theme/theme.dart';
import 'package:inventory_system/Presentation/bloc/SharedComponentsBlocs/SelectedItemCubit/selected_item_cubit.dart';

class SupplyDetailsScreen extends StatelessWidget {
  const SupplyDetailsScreen({super.key});

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
                                  suppliesScreen,
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
                              child: SupplyDetailsArea(
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
