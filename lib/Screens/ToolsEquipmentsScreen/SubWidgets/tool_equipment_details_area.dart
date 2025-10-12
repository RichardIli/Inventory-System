import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SaveQRCodeButtonBloc/save_qr_code_button_bloc.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/ToolsEquipmentsHistoryBloc/tools_equipments_history_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/QRGeneratorBloc/qr_generator_bloc.dart';

class ToolsEquipmentsDetailsArea extends StatefulWidget {
  const ToolsEquipmentsDetailsArea({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.itemStatus,
  });

  final String itemId;
  final String itemName;
  final String itemStatus;

  @override
  State<ToolsEquipmentsDetailsArea> createState() =>
      _ToolsEquipmentsDetailsAreaState();
}

class _ToolsEquipmentsDetailsAreaState
    extends State<ToolsEquipmentsDetailsArea> {
  GlobalKey repaintBoundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ToolsEquipmentsHistoryBloc(
            // RepositoryProvider.of<FirestoreToolsEquipmentDBRepository>(context)
            transmitalHistoryDb:
                RepositoryProvider.of<FirestoreTransmitalHistoryRepo>(context),
          ),
      child: BlocListener<SaveQrCodeButtonBloc, SaveQrCodeButtonState>(
        listener: (context, state) {
          if (state is SavedQrCodeButton) {
            if (state.success) {
              context.read<SaveQrCodeButtonBloc>().add(
                ResetSaveQrCodeButtonEvent(),
              );
            }
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 5,
                    children: [
                      DetailsField(fieldLabel: "ID", itemId: widget.itemId),
                      DetailsField(fieldLabel: "NAME", itemId: widget.itemName),
                      DetailsField(
                        fieldLabel: "STATUS",
                        itemId: widget.itemStatus,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox.square(
                        dimension: 300,
                        child: RepaintBoundary(
                          key: repaintBoundaryKey,
                          child: BlocBuilder<QrGeneratorBloc, QrGeneratorState>(
                            builder: (context, state) {
                              if (state is QrGeneratorInitial) {
                                context.read<QrGeneratorBloc>().add(
                                  GenerateQREvent(
                                    itemID: widget.itemId,
                                    itemName: widget.itemName,
                                  ),
                                );
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is QrGeneratorLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is QrGeneratorLoaded) {
                                return Card(
                                  child: Column(
                                    children: [
                                      Expanded(child: state.customQR),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 5,
                                        ),
                                        child: Text(
                                          "id: ${widget.itemId},\nname: ${widget.itemName}",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (state is QrGeneratorStateError) {
                                return Center(child: Text(state.error));
                              } else {
                                return Center(
                                  child: Text(
                                    "Something went Wrong, Consult your IT",
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      BlocBuilder<SaveQrCodeButtonBloc, SaveQrCodeButtonState>(
                        builder: (context, state) {
                          if (state is SaveQrCodeButtonInitial) {
                            return CustomSaveQRCodeButton(
                              repaintBoundaryKey: repaintBoundaryKey,
                              qrCodeName:
                                  "id:${widget.itemId},name:${widget.itemName}",
                            );
                          } else if (state is SavingQrCodeButton) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is SavedQrCodeButton) {
                            return CustomSaveQRCodeButton(
                              repaintBoundaryKey: repaintBoundaryKey,
                              qrCodeName:
                                  "id:${widget.itemId},name:${widget.itemName}",
                            );
                          } else if (state is SaveQrCodeButtonStateError) {
                            // ignore: avoid_print
                            print(state.error);
                            return Center(
                              child: Text(
                                "Something wen't wrong. Consult your IT",
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                "Something wen't wrong. Consult your IT",
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("HISTORY:"),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ListLabel(displayLabel: "Processed By"),
                            ListLabel(displayLabel: "Out By"),
                            ListLabel(displayLabel: "Request By"),
                            ListLabel(displayLabel: "Received On Site By"),
                            ListLabel(displayLabel: "In By"),
                            ListLabel(displayLabel: "In Date"),
                            ListLabel(displayLabel: "Out Date"),
                          ],
                        ),
                        BlocBuilder<
                          ToolsEquipmentsHistoryBloc,
                          ToolsEquipmentsHistoryState
                        >(
                          builder: (context, state) {
                            if (state is ToolsEquipmentsHistoryInitial) {
                              context.read<ToolsEquipmentsHistoryBloc>().add(
                                FetchToolsEquipmentsHistoryEvent(
                                  itemId: widget.itemId,itemName: widget.itemName
                                ),
                              );
                              return Center(child: CircularProgressIndicator());
                            } else if (state is ToolsEquipmentsHistoryLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is ToolsEquipmentsHistoryLoaded) {
                              String formatDate(String? isoString) {
                                if (isoString == null || isoString.isEmpty) {
                                  return ""; // Return a default value if the date is null or empty.
                                }
                                // 1. Parse the ISO 8601 string into a DateTime object.
                                // The 'Z' at the end indicates UTC time, so use parseUtc().
                                final DateTime dateTime =
                                    DateTime.parse(isoString).toLocal();

                                // 2. Define the desired format: dd-mm-yy (e.g., 10-03-24).
                                // Use 'dd-MM-yy' where 'MM' is for the month number (padded).
                                final DateFormat formatter = DateFormat(
                                  'dd-MM-yy',
                                );

                                // 3. Apply the format and return the string.
                                return formatter.format(dateTime);
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.data.length,
                                itemBuilder: (context, index) {
                                  final item = state.data[index];
                                  final String processedBy =
                                      item["processedBy"] != null
                                          ? item["processedBy"].toString()
                                          : "";
                                  final String outBy =
                                      item["outBy"] != null
                                          ? item["outBy"].toString()
                                          : "";
                                  final String requestBy =
                                      item["requestBy"] != null
                                          ? item["requestBy"].toString()
                                          : "";
                                  final String receivedOnSiteBy =
                                      item["receivedOnSiteBy"] != null
                                          ? item["receivedOnSiteBy"].toString()
                                          : "";
                                  final String inBy =
                                      item["inBy"] != null
                                          ? item["inBy"].toString()
                                          : "";
                                  final String inDate =
                                      item["inDate"] != null
                                          ? item["inDate"].toString()
                                          : "";
                                  final String outDate =
                                      item["releaseDate"] != null
                                          ? item["releaseDate"].toString()
                                          : "";
                                  return Row(
                                    children: [
                                      ListContent(displayText: processedBy),
                                      ListContent(displayText: outBy),
                                      ListContent(displayText: requestBy),
                                      ListContent(
                                        displayText: receivedOnSiteBy,
                                      ),
                                      ListContent(displayText: inBy),
                                      ListContent(displayText: formatDate(inDate)),
                                      ListContent(displayText: formatDate(outDate)),
                                    ],
                                  );
                                },
                              );
                            } else if (state is ToolsEquipmentsHistoryError) {
                              return Text('Error: ${state.error}');
                            } else {
                              return Center(child: Text("No Data"));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSaveQRCodeButton extends StatelessWidget {
  const CustomSaveQRCodeButton({
    super.key,
    required this.repaintBoundaryKey,
    required this.qrCodeName,
  });

  final GlobalKey repaintBoundaryKey;
  final String qrCodeName;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        context.read<SaveQrCodeButtonBloc>().add(
          PressedSaveQrCodeButtonEvent(
            repaintBoundaryKey: repaintBoundaryKey,
            qrCodeName: qrCodeName,
          ),
        );
      },
      child: Text("Save QR Code"),
    );
  }
}

class DetailsField extends StatelessWidget {
  const DetailsField({
    super.key,
    required this.fieldLabel,
    required this.itemId,
  });

  final String fieldLabel;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text("$fieldLabel: ")),
        Container(
          width: 150,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
          ),
          child: Center(child: Text(itemId)),
        ),
      ],
    );
  }
}

class ListLabel extends StatelessWidget {
  const ListLabel({super.key, required this.displayLabel});

  final String displayLabel;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Center(child: Text(displayLabel)));
  }
}

class ListContent extends StatelessWidget {
  const ListContent({super.key, required this.displayText});

  final String displayText;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Center(child: Text(displayText)));
  }
}
