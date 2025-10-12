import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_supplies.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';
import 'package:inventory_system/Screens/SuppliesScreen/SubWidgets/restock_window.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SaveQRCodeButtonBloc/save_qr_code_button_bloc.dart';
import 'package:inventory_system/bloc/SuppliesScreenBlocs/SuppliesBloc/supplies_bloc.dart';
import 'package:inventory_system/bloc/SuppliesScreenBlocs/SupplyHistoryBloc/supply_history_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/QRGeneratorBloc/qr_generator_bloc.dart';
import 'package:inventory_system/bloc/SuppliesScreenBlocs/RestockSupplyButtonBloc/restock_supply_button_bloc.dart';

class SupplyDetailsArea extends StatelessWidget {
  const SupplyDetailsArea({
    super.key,
    required this.supplyId,
    required this.supplyName,
    required this.supplyUnit,
  });

  final String supplyId;
  final String supplyName;
  final String supplyUnit;

  @override
  Widget build(BuildContext context) {
    final FirestoreSuppliesDb suppliesRepo =
        RepositoryProvider.of<FirestoreSuppliesDb>(context);
    final FirestoreUsersDbRepository usersDbRepo =
        RepositoryProvider.of<FirestoreUsersDbRepository>(context);
    final MyFirebaseAuth authDbRepo = RepositoryProvider.of<MyFirebaseAuth>(
      context,
    );
    final FirestoreTransmitalHistoryRepo transmitalHistoryRepo =
        RepositoryProvider.of<FirestoreTransmitalHistoryRepo>(context);

    GlobalKey repaintBoundaryKey = GlobalKey();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => RestockSupplyButtonBloc(
                suppliesDbRepo: suppliesRepo,
                usersDbRepo: usersDbRepo,
                auth: authDbRepo,
                transmitalHistoryRepo: transmitalHistoryRepo,
              ),
        ),
        BlocProvider(
          create:
              (context) => SupplyHistoryBloc(
                RepositoryProvider.of<FirestoreSuppliesDb>(context),
                RepositoryProvider.of<FirestoreTransmitalHistoryRepo>(context),
              ),
        ),
      ],
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
        child: Builder(
          builder: (builderContext) {
            return Container(
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
                          DetailsField(fieldLabel: "ID", fieldValue: supplyId),
                          DetailsField(
                            fieldLabel: "NAME",
                            fieldValue: supplyName,
                          ),
                          BlocListener<
                            RestockSupplyButtonBloc,
                            RestockSupplyButtonState
                          >(
                            listener: (context, state) {
                              // TODO: check if this will update the list after restocking
                              if (state is RestockSupplyButtonLoaded) {
                                if (state.success) {
                                  context.read<SuppliesBloc>().add(
                                    FetchSuppliesEvent(search: ""),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Insertion failed')),
                                  );
                                }
                              }
                            },
                            child: BlocBuilder<SuppliesBloc, SuppliesState>(
                              builder: (context, state) {
                                if (state is SuppliesInitial) {
                                  context.read<SuppliesBloc>().add(
                                    FetchSuppliesEvent(search: ""),
                                  );
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is SuppliesLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is SuppliesLoaded) {
                                  final rawSupplyData = state.data.where(
                                    (item) => item["id"] == supplyId,
                                  );
                                  final supplyAmount =
                                      rawSupplyData.first["amount"];
                                  final supplyUnit =
                                      rawSupplyData.first["unit"];

                                  return DetailsField(
                                    fieldLabel: "STOCK AMOUNT",
                                    fieldValue: "$supplyAmount - $supplyUnit",
                                  );
                                } else if (state is SuppliesStateError) {
                                  return Center(child: Text(state.error));
                                } else {
                                  return Center(
                                    child: Text(
                                      "Something Went Wrong Consult your IT",
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextButton.icon(
                              onPressed: () {
                                GlobalKey<FormState> frmKey =
                                    GlobalKey<FormState>();
                                showDialog(
                                  context: builderContext,
                                  builder: (context) {
                                    return RestockWindow(
                                      builderContext: builderContext,
                                      frmKey: frmKey,
                                      supplyId: supplyId,
                                      supplyName: supplyName,
                                      supplyUnit: supplyUnit,
                                    );
                                  },
                                );
                              },
                              label: Text(
                                "Restock",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              icon: Icon(Icons.add_rounded),
                              style: ButtonStyle(
                                iconColor: WidgetStatePropertyAll(Colors.black),
                                side: WidgetStatePropertyAll(
                                  BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox.square(
                            dimension: 300,
                            child: RepaintBoundary(
                              key: repaintBoundaryKey,
                              child: BlocBuilder<
                                QrGeneratorBloc,
                                QrGeneratorState
                              >(
                                builder: (context, state) {
                                  if (state is QrGeneratorInitial) {
                                    context.read<QrGeneratorBloc>().add(
                                      GenerateQREvent(
                                        itemID: supplyId,
                                        itemName: supplyName,
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
                                              "id: $supplyId\nname: $supplyName",
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
                          BlocBuilder<
                            SaveQrCodeButtonBloc,
                            SaveQrCodeButtonState
                          >(
                            builder: (context, state) {
                              if (state is SaveQrCodeButtonInitial) {
                                return CustomSaveQRCodeButton(
                                  repaintBoundaryKey: repaintBoundaryKey,
                                  qrCodeName: "id:$supplyId,name:$supplyName",
                                );
                              } else if (state is SavingQrCodeButton) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is SavedQrCodeButton) {
                                return CustomSaveQRCodeButton(
                                  repaintBoundaryKey: repaintBoundaryKey,
                                  qrCodeName: "id:$supplyId,name:$supplyName",
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
                        height: 500,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: BlocListener<
                          RestockSupplyButtonBloc,
                          RestockSupplyButtonState
                        >(
                          listener: (context, state) {
                            if (state is RestockSupplyButtonLoaded) {
                              if (state.success) {
                                context.read<SupplyHistoryBloc>().add(
                                  FetchSupplyHistoryEvent(
                                    supplyID: supplyId,
                                    supplyName: supplyName,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Insertion failed')),
                                );
                              }
                            }
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ListLabel(displayLabel: "Processed By"),
                                  ListLabel(displayLabel: "In Date"),
                                  ListLabel(displayLabel: "In Amount"),
                                  ListLabel(displayLabel: "Out By"),
                                  ListLabel(displayLabel: "Out Date"),
                                  ListLabel(displayLabel: "Out Amount"),
                                  ListLabel(displayLabel: "Request By"),
                                  ListLabel(displayLabel: "Receive On Site By"),
                                ],
                              ),
                              BlocBuilder<
                                SupplyHistoryBloc,
                                SupplyHistoryState
                              >(
                                builder: (context, state) {
                                  if (state is SupplyHistoryInitial) {
                                    context.read<SupplyHistoryBloc>().add(
                                      FetchSupplyHistoryEvent(
                                        supplyID: supplyId,
                                        supplyName: supplyName,
                                      ),
                                    );
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is SupplyHistoryLoading) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is SupplyHistoryLoaded) {
                                    String formatDate(String? isoString) {
                                      if (isoString == null ||
                                          isoString.isEmpty) {
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

                                      return formatter.format(dateTime);
                                    }

                                    return Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: state.data.length,
                                        itemBuilder: (context, index) {
                                          final item = state.data[index];
                                          final String processedBy =
                                              item["processedBy"] != null
                                                  ? item["processedBy"]
                                                      .toString()
                                                  : "";
                                          final String outBy =
                                              item["outBy"] != null
                                                  ? item["outBy"].toString()
                                                  : "";
                                          final String outDate =
                                              item["releaseDate"] != null
                                                  ? item["releaseDate"]
                                                      .toString()
                                                  : "";
                                          final String inDate =
                                              item["inDate"] != null
                                                  ? item["inDate"].toString()
                                                  : "";
                                          final String requestBy =
                                              item["requestBy"] != null
                                                  ? item["requestBy"].toString()
                                                  : "";
                                          final String inAmount =
                                              item["inAmount"] != null
                                                  ? item["inAmount"].toString()
                                                  : "";
                                          final String outAmount =
                                              item["requestAmount"] != null
                                                  ? item["requestAmount"]
                                                      .toString()
                                                  : "";
                                          final String receivedOnSiteBy =
                                              item["receivedOnSiteBy"] != null
                                                  ? item["receivedOnSiteBy"]
                                                      .toString()
                                                  : "";

                                          return Row(
                                            children: [
                                              ListContent(
                                                displayText: processedBy,
                                              ),
                                              ListContent(
                                                displayText: formatDate(inDate),
                                              ),
                                              ListContent(
                                                displayText: inAmount,
                                              ),
                                              ListContent(displayText: outBy),
                                              ListContent(
                                                displayText: formatDate(
                                                  outDate,
                                                ),
                                              ),

                                              ListContent(
                                                displayText: outAmount,
                                              ),
                                              ListContent(
                                                displayText: requestBy,
                                              ),
                                              ListContent(
                                                displayText: receivedOnSiteBy,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  } else if (state is SupplyHistoryStateError) {
                                    return Text('Error: ${state.error}');
                                  } else {
                                    return Center(child: Text("No Data"));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
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
    required this.fieldValue,
  });

  final String fieldLabel;
  final String fieldValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 150, child: Text("$fieldLabel: ")),
        Container(
          width: 150,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
          ),
          child: Center(child: Text(fieldValue)),
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
