import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:inventory_system/Routes/routes.dart';
import 'package:inventory_system/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/SharedComponents/custom_footer.dart';
import 'package:inventory_system/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/FilterDataByNameBloc/filter_db_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SelectedItemBloc/selected_item_bloc.dart';

class SpecificToolsEquipmentsScreen extends StatelessWidget {
  const SpecificToolsEquipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterDBBloc(
          RepositoryProvider.of<FirestoreToolsEquipmentDBRepository>(context)),
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppbar(),
          body: Row(
            children: [
              SideMenu(),
              Container(
                width: 2,
                color: Theme.of(context).primaryColor,
              ),
              BlocBuilder<SelectedItemBloc, SelectedItemState>(
                builder: (context, state) {
                  if (state is SelectedItemInitial) {
                    return CircularProgressIndicator();
                  } else if (state is SelectedItemLoading) {
                    return CircularProgressIndicator();
                  } else if (state is SelectedItemLoaded) {
                    final passedData = state.passedData;
                    return _mainContent(context, passedData);
                  } else if (state is SelectedItemError) {
                    return Column(
                      children: [
                        Icon(Icons.error_outline_rounded),
                        Text(
                          state.error,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _mainContent(BuildContext context, Map<String, dynamic> passedData) {
    return Expanded(
      child: Padding(
        padding: contentPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        passedData["itemName"],
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
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
                    children: [
                      Titles(displayText: "ID"),
                      Titles(displayText: "NAME"),
                      Titles(displayText: "STATUS"),
                    ],
                  ),
                ),
                BlocBuilder<FilterDBBloc, FilterDBState>(
                  builder: (context, state) {
                    if (state is FilterDbInitial) {
                      context
                          .read<FilterDBBloc>()
                          .add(FetchFiltedDBEvent(passedData["itemName"]));
                      return Center(child: CircularProgressIndicator());
                    } else if (state is FilterDbLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is FilteredDBLoaded) {
                      final datas = state.datas;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: datas.length,
                          itemBuilder: (context, index) {
                            final String itemId = datas[index]["id"].toString();
                            final String itemName = datas[index]["name"];
                            final String itemStatus = datas[index]["status"];

                            return GestureDetector(
                              onTap: () {
                                final data = {
                                  "itemId": itemId,
                                  "itemName": itemName,
                                  "itemStatus": itemStatus
                                };
                                context.read<SelectedItemBloc>().add(
                                    SelectSelectedItemEvent(passedData: data));
                                Navigator.pushNamed(
                                  context,
                                  itemDetailsScreen,
                                );
                              },
                              child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 1),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      RowContent(displayText: itemId),
                                      RowContent(displayText: itemName),
                                      RowContent(displayText: itemStatus),
                                    ],
                                  )),
                            );
                          });
                    } else if (state is FilterDbStateError) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Text("Something Went Wrong"),
                      );
                    }
                  },
                ),
              ],
            ),
            CustomFooter(),
          ],
        ),
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
