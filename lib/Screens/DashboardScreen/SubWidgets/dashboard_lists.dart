import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/bloc/DashboardScreenBlocs/DashboardToolsEquipmentOutItemListBloc/dashboard_tools_equipments_outside_list_bloc.dart';

class ItemsOutside extends StatelessWidget {
  const ItemsOutside({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 400,
      height: 400,
      child: Card(
        elevation: 10,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "LIST OF ITEMS OUTSIDE",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     // For future
                  //     // TODO: Make a function that will show the data of this items. In the data will include the item name,requestby,dateout,outby,sitepersonel
                  //   },
                  //   icon: Icon(Icons.open_in_full_rounded),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Name",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Center(
                  //     child: Text(
                  //       "Date Out",
                  //       style: Theme.of(context)
                  //           .textTheme
                  //           .bodyMedium!
                  //           .copyWith(fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            BlocBuilder<DashboardToolsEquipmentsOutsideListBloc,
                DashboardToolsEquipmentsOutsideListState>(
              builder: (context, state) {
                if (state is DashboardToolsEquipmentsOutsideListInitial) {
                  
                  context
                      .read<DashboardToolsEquipmentsOutsideListBloc>()
                      .add(FetchDashboardToolsEquipmentsOutsideListEvent());
                  return Center(child: CircularProgressIndicator());
                } else if (state
                    is DashboardToolsEquipmentsOutsideListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is DashboardToolsEquipmentsOutsideListLoaded) {
                  final item = state.data;
                  // this is the actual list aof the items
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              item[index]["name"],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            // Text(
                            //   item[index]["date"],
                            //   style: Theme.of(context).textTheme.bodyMedium,
                            // )
                          ],
                        );
                      });
                } else if (state is DashboardToolsEquipmentsOutsideListError) {
                  return Text('Error: ${state.error}');
                } else {
                  return Center(
                    child: Text("No Data"),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

// TODO: Make a bloc for this
// class InventoryNotice extends StatelessWidget {
//   const InventoryNotice({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => DashboardToolsEquipmentsOutsideListBloc(
//           RepositoryProvider.of<FirestoreToolsEquipmentDBRepository>(context)),
//       child: SizedBox(
//         width: 400,
//         height: 400,
//         child: Card(
//           elevation: 10,
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(10),
//                   ),
//                   color: Colors.white,
//                 ),
//                 padding: EdgeInsets.all(10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "INVENTORY NOTICE",
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyLarge!
//                           .copyWith(fontWeight: FontWeight.bold),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         // TODO: Make a function that will show the data of this items. In the data will include the item name,requestby,dateout,outby,sitepersonel
//                       },
//                       icon: Icon(Icons.open_in_full_rounded),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           "Name",
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyMedium!
//                               .copyWith(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           "Remarks",
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyMedium!
//                               .copyWith(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               BlocBuilder<DashboardToolsEquipmentsOutsideListBloc,
//                   DashboardToolsEquipmentsOutsideListState>(
//                 builder: (context, state) {
//                   if (state is DashboardToolsEquipmentsOutsideListInitial) {
//                     context
//                         .read<DashboardToolsEquipmentsOutsideListBloc>()
//                         .add(FetchDashboardToolsEquipmentsOutsideListEvent());
//                     return Center(child: CircularProgressIndicator());
//                   } else if (state
//                       is DashboardToolsEquipmentsOutsideListLoading) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (state
//                       is DashboardToolsEquipmentsOutsideListLoaded) {
//                     final item = state.data;
//                     return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: item.length,
//                         itemBuilder: (context, index) {
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text(
//                                 item[index]["name"],
//                                 style: Theme.of(context).textTheme.bodyMedium,
//                               ),
//                               Text(
//                                 item[index]["outDate"],
//                                 style: Theme.of(context).textTheme.bodyMedium,
//                               )
//                             ],
//                           );
//                         });
//                   } else if (state
//                       is DashboardToolsEquipmentsOutsideListError) {
//                     return Text('Error: ${state.error}');
//                   } else {
//                     return Center(
//                       child: Text("No Data"),
//                     );
//                   }
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
