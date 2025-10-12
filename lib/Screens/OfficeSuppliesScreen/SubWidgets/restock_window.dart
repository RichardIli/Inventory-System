import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/OfficeSuppliesScreenBlocs/RestockOfficeSupplyButtonBloc/restock_office_supply_button_bloc.dart';

class OfficeSupplyRestockWindow extends StatelessWidget {
  const OfficeSupplyRestockWindow({
    super.key,
    required this.builderContext,
    required this.frmKey,
    required this.supplyId,
    required this.supplyName,
    required this.supplyUnit,
  });

  final BuildContext builderContext;
  final GlobalKey<FormState> frmKey;
  final String supplyId;
  final String supplyName;
  final String supplyUnit;

  @override
  Widget build(BuildContext context) {
    TextEditingController supplyAmountController = TextEditingController();

    bool isNumber(value) {
      return int.tryParse(value) != null;
    }

    return BlocProvider.value(
      value: builderContext.read<RestockOfficeSupplyButtonBloc>(),
      child: Form(
        key: frmKey,
        child: AlertDialog(
          title: Text("Restock $supplyName"),
          content: Row(
            spacing: 10,
            children: [
              Text("Amount: "),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: supplyAmountController,
                  decoration: customInputDecoration.copyWith(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
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
              Text(supplyUnit),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<
                    RestockOfficeSupplyButtonBloc,
                    RestockOfficeSupplyButtonState
                  >(
                    builder: (context, state) {
                      if (state is RestockOfficeSupplyButtonInitial) {
                        return AddButton(
                          frmKey: frmKey,
                          onPressed: () {
                            if (frmKey.currentState!.validate()) {
                              final double inAmount = double.parse(
                                supplyAmountController.text,
                              );
                              context.read<RestockOfficeSupplyButtonBloc>().add(
                                PressedRestockOfficeSupplyButtonEvent(
                                  inAmount: inAmount,
                                  supplyID: supplyId,
                                  supplyName: supplyName,
                                ),
                              );
                            } else {}
                          },
                        );
                      } else if (state is RestockOfficeSupplyButtonLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is RestockOfficeSupplyButtonLoaded) {
                        return IconButton(
                          onPressed: () {
                            context.read<RestockOfficeSupplyButtonBloc>().add(
                              ResetRestockOfficeSupplyButtonEvent(),
                            );
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.check_rounded),
                        );
                      } else if (state is RestockOfficeSupplyButtonStateError) {
                        return Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Close and Try Again"),
                          ),
                        );
                      } else {
                        return Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Close and Try Again"),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("NO"),
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

class AddButton extends StatelessWidget {
  const AddButton({super.key, required this.frmKey, required this.onPressed});

  final GlobalKey<FormState> frmKey;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text("Add"));
  }
}
