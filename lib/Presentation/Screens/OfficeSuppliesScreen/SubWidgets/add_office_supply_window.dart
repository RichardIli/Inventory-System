import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Config/Theme/theme.dart';
import 'package:inventory_system/Presentation/bloc/OfficeSuppliesScreenBlocs/AddNewOfficeSupplyButtonBloc/add_new_office_supply_button_bloc.dart';


class AddOfficeSupplyWindow extends StatelessWidget {
  const AddOfficeSupplyWindow({
    super.key,
    required this.builderContext,
  });

  final BuildContext builderContext;

  @override
  Widget build(BuildContext context) {
    TextEditingController supplyNameController = TextEditingController();
    TextEditingController supplyAmountController = TextEditingController();
    TextEditingController supplyUnitController = TextEditingController();

    final GlobalKey<FormState> toolEquipmentFormKey = GlobalKey<FormState>();

    bool isNumber(value) {
      return int.tryParse(value) != null;
    }

    return BlocProvider.value(
      value: builderContext.read<AddNewOfficeSupplyButtonBloc>(),
      child: Form(
        key: toolEquipmentFormKey,
        child: AlertDialog(
          title: Text("Add New Supply"),
          content: IntrinsicHeight(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Supply Name:"),
                SizedBox(
                  width: 500,
                  child: TextFormField(
                    controller: supplyNameController,
                    decoration: customInputDecoration.copyWith(
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
                ),
                Row(
                  spacing: 10,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Supply Amount:"),
                        SizedBox(
                          width: 245,
                          child: TextFormField(
                            controller: supplyAmountController,
                            decoration: customInputDecoration.copyWith(
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This Field is Required';
                              } else if (!isNumber(value)) {
                                return 'Enter a Valid Amount';
                              } else if (int.parse(value) <= 0) {
                                return 'Enter a Valid Amount';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Unit of Measurement:"),
                        SizedBox(
                          width: 245,
                          child: TextFormField(
                            controller: supplyUnitController,
                            decoration: customInputDecoration.copyWith(
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
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: BlocBuilder<AddNewOfficeSupplyButtonBloc,
                      AddNewOfficeSupplyButtonState>(
                    builder: (context, state) {
                      if (state is AddNewOfficeSupplyInitial) {
                        return TextButton(
                          onPressed: () {
                            if (toolEquipmentFormKey.currentState!.validate()) {
                              context
                                  .read<AddNewOfficeSupplyButtonBloc>()
                                  .add(PressedAddNewOfficeSupplyButtonEvent(
                                    supplyName: supplyNameController.text,
                                    supplyAmount: double.parse(
                                        supplyAmountController.text),
                                    unit: supplyUnitController.text,
                                  ));
                            } else {}
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blue)),
                          child: Text("ADD",
                              style: Theme.of(context).textTheme.bodyMedium),
                        );
                      } else if (state is AddNewOfficeSupplyButtonLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is AddNewOfficeSupplyButtonLoaded) {
                        return IconButton(
                            onPressed: () {
                              context
                                  .read<AddNewOfficeSupplyButtonBloc>()
                                  .add(ResetAddNewOfficeSupplyButtonEvent());
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.check_rounded));
                      } else if (state is AddNewOfficeSupplyButtonError) {
                        return Center(
                          child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Close and Try Again")),
                        );
                      } else {
                        return Center(
                          child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Close and Try Again")),
                        );
                      }
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                      side: WidgetStatePropertyAll(
                          BorderSide(color: Colors.black, width: 1))),
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
