import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:inventory_system/Routes/routes.dart';
import 'package:inventory_system/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/SharedComponents/custom_footer.dart';
import 'package:inventory_system/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SelectedItemCubit/selected_item_cubit.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/GroupOfToolsEquipmentsCountByNameBloc/group_of_tools_equipments_count_bloc.dart';

class ToolsEquipmentsCountScreen extends StatefulWidget {
  const ToolsEquipmentsCountScreen({super.key});

  @override
  State<ToolsEquipmentsCountScreen> createState() =>
      _ToolsEquipmentsCountScreenState();
}

class _ToolsEquipmentsCountScreenState
    extends State<ToolsEquipmentsCountScreen> {
  @override
  void initState() {
    // fetch the tools/equipment
    context
        .read<GroupOfToolsEquipmentsCountByNameBloc>()
        .add(FetchGroupOfToolsEquipmentsCountByNameEvent());
    super.initState();
  }

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
                            "Tools and Equipments Count",
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
                          Titles(displayText: "Name"),
                          Titles(displayText: "Stored Amount"),
                          Titles(displayText: "On Field Amount"),
                          Titles(displayText: "Total Amount"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: BlocBuilder<
                            GroupOfToolsEquipmentsCountByNameBloc,
                            GroupOfToolsEquipmentsCountByNameState>(
                          builder: (context, state) {
                            if (state
                                is GroupOfToolsEquipmentsCountByNameInitial) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state
                                is GroupOfToolsEquipmentsCountByNameLoading) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state
                                is GroupOfToolsEquipmentsCountByNameLoaded) {
                              final datas = state.datas;

                              // importToolsEquipment(datas);

                              // group item list
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: datas.length,
                                  itemBuilder: (context, index) {
                                    final itemName = datas[index]["name"];
                                    final itemCount = datas[index]["count"].toString();
                                    return ListRow(
                                        itemName: itemName,
                                        itemCount: itemCount);
                                  });
                            }
                            return Container();
                          },
                        ),
                      ),
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

class ListRow extends StatelessWidget {
  const ListRow({
    super.key,
    required this.itemName,
    required this.itemCount,
  });

  final dynamic itemName;
  final String itemCount;

  @override
  Widget build(BuildContext context) {
    final toolsEquipmentsRepo =
        RepositoryProvider.of<FirestoreToolsEquipmentDBRepository>(context);

    Future<List> fetchData() async {
      final List<Map<String, dynamic>> storedItem =  toolsEquipmentsRepo
          .filterToolsEquipmentsByStatus("STORE ROOM", itemName);
      final List<Map<String, dynamic>> outsideItem =  toolsEquipmentsRepo
          .filterToolsEquipmentsByStatus("OUTSIDE", itemName);
      return [storedItem, outsideItem];
    }

    // instead of using bloc, I use future builder for async data
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final storedItem = snapshot.data![0];
            final outsideItem = snapshot.data![1];

            return GestureDetector(
              onTap: () {
                final data = {
                  "itemName": itemName,
                };
                // selecting item from the list and view its details
                context.read<SelectedItemCubit>().setSelectedItem(passedData: data);

                Navigator.pushNamed(context, specificToolsEquipmentsScreen);
              },
              child: Container(
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
                  children: [
                    ListRowContent(displayText: itemName),
                    ListRowContent(displayText: storedItem.length.toString()),
                    ListRowContent(displayText: outsideItem.length.toString()),
                    ListRowContent(displayText: itemCount),
                  ],
                ),
              ),
            );
          }
        });
  }
}

class ListRowContent extends StatelessWidget {
  const ListRowContent({
    super.key,
    required this.displayText,
  });

  final dynamic displayText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          displayText,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
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
