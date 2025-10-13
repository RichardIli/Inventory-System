import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:inventory_system/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/SharedComponents/custom_footer.dart';
import 'package:inventory_system/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/TransmitalHistoryScreenBlocs/TransmitalHistoryListBloc/transmital_history_list_bloc.dart';

class TransmitalHistoryScreen extends StatelessWidget {
  const TransmitalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(),
        body: Row(
          children: [
            SideMenu(),
            Container(width: 2, color: Theme.of(context).primaryColor),
            Expanded(
              child: Padding(
                padding: contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      "Transmitals",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: TransmitalsList()),
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

class TransmitalsList extends StatefulWidget {
  const TransmitalsList({super.key});

  @override
  State<TransmitalsList> createState() => _TransmitalsListState();
}

class _TransmitalsListState extends State<TransmitalsList> {
  // INITIALIZE THE LIST
  @override
  void initState() {
    context.read<TransmitalHistoryListBloc>().add(
      FetchTransmitalHistoryListEvent(),
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
              Titles(displayText: "ITEM ID"),
              Titles(displayText: "NAME"),
              Titles(displayText: "PROCESSED BY"),
              Titles(displayText: "OUT DATE"),
              Titles(displayText: "RETURN BY"),
              Titles(displayText: "IN DATE"),
              Titles(displayText: "REQUEST BY"),
              Titles(displayText: "RECEIVED ON SITE BY"),
              Titles(displayText: "IN AMOUNT"),
              Titles(displayText: "OUT AMOUNT"),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: BlocBuilder<
              TransmitalHistoryListBloc,
              TransmitalHistoryListState
            >(
              builder: (context, state) {
                if (state is TransmitalHistoryListInitial) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TransmitalHistoryListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TransmitalHistoryListLoaded) {
                  String formatDate(String isoString) {
                    // 1. Parse the ISO 8601 string into a DateTime object.
                    // The 'Z' at the end indicates UTC time, so use parseUtc().
                    final DateTime dateTime =
                        DateTime.parse(isoString).toLocal();

                    // 2. Define the desired format: dd-mm-yy (e.g., 10-03-24).
                    // Use 'dd-MM-yy' where 'MM' is for the month number (padded).
                    final DateFormat formatter = DateFormat('dd-MM-yy');

                    // 3. Apply the format and return the string.
                    return formatter.format(dateTime);
                  }

                  return ListView.builder(
                    itemCount: state.history.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = state.history[index];
                      final String docId = item["docId"];
                      final String itemId = item["id"].toString();
                      final String itemName = item["name"];
                      final String inBy = item["inBy"] ?? '';
                      final String processedBy = item["processedBy"] ?? '';
                      final String inDate =
                          item['inDate'] != null
                              ? formatDate(item['inDate'])
                              : ' ';
                      final String outDate =
                          item['releaseDate'] != null
                              ? formatDate(item['releaseDate'])
                              : ' ';

                      // final String inDate = item['inDate'] != null
                      //     ? "${(item['inDate'] as Timestamp).toDate().year}-${(item['inDate'] as Timestamp).toDate().month}-${(item['inDate'] as Timestamp).toDate().day}"
                      //     : ' ';
                      // final String outDate = item['releaseDate'] != null
                      //     ? "${(item['releaseDate'] as Timestamp).toDate().year}-${(item['releaseDate'] as Timestamp).toDate().month}-${(item['releaseDate'] as Timestamp).toDate().day}"
                      //     : ' ';
                      final String requestBy = item["requestBy"] ?? '';
                      final String receivedOnSiteBy =
                          item["receivedOnSiteBy"] ?? '';
                      final String inAmount =
                          (item["inAmount"] ?? '').toString();
                      final String outAmount =
                          (item["requestAmount"] ?? '').toString();
                      return Container(
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
                            RowContent(displayText: docId),
                            RowContent(displayText: itemId),
                            RowContent(displayText: itemName),
                            RowContent(displayText: processedBy),
                            RowContent(displayText: outDate),
                            RowContent(displayText: inBy),
                            RowContent(displayText: inDate),
                            RowContent(displayText: requestBy),
                            RowContent(displayText: receivedOnSiteBy),
                            RowContent(displayText: inAmount),
                            RowContent(displayText: outAmount),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is TransmitalHistoryListStateError) {
                  return Text('Error: ${state.error}');
                } else {
                  return Center(child: Text("No Data"));
                }
              },
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
