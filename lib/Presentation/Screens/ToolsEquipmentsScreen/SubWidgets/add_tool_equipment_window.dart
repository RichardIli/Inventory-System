import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Config/Theme/theme.dart';
import 'package:inventory_system/Presentation/bloc/ToolsEquipmentsScreenBlocs/AddToolsEquipmentsButtonBloc/add_tools_equipments_button_bloc.dart';

class AddToolEquipmentScreen extends StatelessWidget {
  const AddToolEquipmentScreen({
    super.key,
    required this.builderContext,
  });

  final BuildContext builderContext;

  @override
  Widget build(BuildContext context) {
    TextEditingController itemNameController = TextEditingController();

    final GlobalKey<FormState> toolEquipmentFormKey = GlobalKey<FormState>();

    return BlocProvider.value(
      value: builderContext.read<AddToolsEquipmentsButtonBloc>(),
      child: Form(
        key: toolEquipmentFormKey,
        child: AlertDialog(
          title: Text("Add Tool or Equipment"),
          content: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tool/Equipmant Name:"),
                SizedBox(
                  width: 500,
                  child: TextFormField(
                    controller: itemNameController,
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
          ),
          actions: [
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: BlocBuilder<AddToolsEquipmentsButtonBloc,
                      AddToolsEquipmentsButtonState>(
                    builder: (context, state) {
                      if (state is AddToolsEquipmentsButtonInitial) {
                        return TextButton(
                          onPressed: () {
                            // validating the field of item name
                            if (toolEquipmentFormKey.currentState!.validate()) {
                              // proceed to add the item in the databse
                              context.read<AddToolsEquipmentsButtonBloc>().add(
                                  PressedAddToolsEquipmentsButtonEvent(
                                      itemName: itemNameController.text));
                            } else {}
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blue)),
                          child: Text("ADD",
                              style: Theme.of(context).textTheme.bodyMedium),
                        );
                      } else if (state is AddToolsEquipmentsButtonLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is AddToolsEquipmentsButtonLoaded) {
                        return IconButton(
                            onPressed: () {
                              // reset the state of the the button to initial from the current state "loaded state"
                              context
                                  .read<AddToolsEquipmentsButtonBloc>()
                                  .add(ResetAddToolsEquipmentsButtonEvent());
                              // pop the current pop-up window
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.check_rounded));
                      } else if (state is AddToolsEquipmentsButtonError) {
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
