import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/FirebaseConnection/firestore_office_supplies.dart';
import 'package:inventory_system/FirebaseConnection/firestore_supplies.dart';
import 'package:inventory_system/FirebaseConnection/firestore_tools_equipment_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_transmital_history_db.dart';
import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';
import 'package:inventory_system/QRGeneratorCapture/qr_code_generator.dart';
import 'package:inventory_system/Routes/routes.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/DashboardScreenBlocs/DashboardToolsEquipmentOutItemListBloc/dashboard_tools_equipments_outside_list_bloc.dart';
import 'package:inventory_system/bloc/DashboardScreenBlocs/DashboardUsersCountBloc/dashboard_users_count_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/QRGeneratorBloc/qr_generator_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SaveQRCodeButtonBloc/save_qr_code_button_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/SelectedItemCubit/selected_item_cubit.dart';
import 'package:inventory_system/bloc/SideMenuBloc/side_menu_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/AppbarUserNameBloc/user_name_appbar_bloc.dart';
import 'package:inventory_system/bloc/SuppliesScreenBlocs/SuppliesBloc/supplies_bloc.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/GroupOfToolsEquipmentsCountByNameBloc/group_of_tools_equipments_count_bloc.dart';
import 'package:inventory_system/bloc/ToolsEquipmentsScreenBlocs/ToolsEquipmentBloc/tools_equipment_bloc.dart';
import 'package:inventory_system/bloc/TransmitalHistoryScreenBlocs/TransmitalHistoryListBloc/transmital_history_list_bloc.dart';
import 'package:inventory_system/bloc/UserScreenBlocs/AddUserCubit/add_user_cubit.dart';
import 'package:inventory_system/bloc/UserScreenBlocs/SelectedUserBloc/selected_user_bloc.dart';
import 'package:inventory_system/bloc/UserScreenBlocs/UsersBloc/users_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // provide some of the repository
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => QrCodeGeneratorRepository()),
        RepositoryProvider(create: (context) => MyFirebaseAuth()),
        RepositoryProvider(create: (context) => FirestoreUsersDbRepository()),
        RepositoryProvider(
          create: (context) => FirestoreToolsEquipmentDBRepository(),
        ),
        RepositoryProvider(create: (context) => FirestoreSuppliesDb()),
        RepositoryProvider(create: (context) => FirestoreSuppliesDb()),
        RepositoryProvider(
          create: (context) => FirestoreTransmitalHistoryRepo(),
        ),
        RepositoryProvider(create: (context) => FirestoreOfficeSupplies()),
      ],
      // provide some of the bloc so the will persist in the whole application runtime
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SideMenuBloc()),
          BlocProvider(
            create:
                (context) => UserNameAppbarBloc(
                  auth: RepositoryProvider.of<MyFirebaseAuth>(context),
                  userRepository:
                      RepositoryProvider.of<FirestoreUsersDbRepository>(
                        context,
                      ),
                ),
          ),
          BlocProvider(
            create:
                (context) => DashboardUsersCountBloc(
                  RepositoryProvider.of<FirestoreUsersDbRepository>(context),
                ),
          ),

          BlocProvider(create: (context) => SelectedUserBloc()),
          BlocProvider(
            create:
                (context) => DashboardToolsEquipmentsOutsideListBloc(
                  RepositoryProvider.of<FirestoreToolsEquipmentDBRepository>(
                    context,
                  ),
                ),
          ),
          BlocProvider(
            create:
                (context) => QrGeneratorBloc(
                  RepositoryProvider.of<QrCodeGeneratorRepository>(context),
                ),
          ),
          BlocProvider(
            create:
                (context) => SuppliesBloc(
                  RepositoryProvider.of<FirestoreSuppliesDb>(context),
                ),
          ),
          BlocProvider(
            create:
                (context) => SaveQrCodeButtonBloc(
                  qrCodeGeneratorRepository:
                      RepositoryProvider.of<QrCodeGeneratorRepository>(context),
                ),
          ),
          BlocProvider(
            create:
                (context) => ToolsEquipmentBloc(
                  RepositoryProvider.of<FirestoreToolsEquipmentDBRepository>(
                    context,
                  ),
                ),
          ),
          BlocProvider(
            create:
                (context) => GroupOfToolsEquipmentsCountByNameBloc(
                  toolsEquipmentsRepository: RepositoryProvider.of<
                    FirestoreToolsEquipmentDBRepository
                  >(context),
                ),
          ),
          BlocProvider(
            create:
                (context) => TransmitalHistoryListBloc(
                  transmitalHistoryRepo:
                      RepositoryProvider.of<FirestoreTransmitalHistoryRepo>(
                        context,
                      ),
                ),
          ),
          BlocProvider(
            create:
                (context) => UsersBloc(
                  RepositoryProvider.of<FirestoreUsersDbRepository>(context),
                ),
          ),
          BlocProvider(create: (context) => SelectedItemCubit()),
          BlocProvider(
            create:
                (context) => AddUserCubit(
                  myFirebaseAuth: RepositoryProvider.of<MyFirebaseAuth>(
                    context,
                  ),
                  userDbrepository:
                      RepositoryProvider.of<FirestoreUsersDbRepository>(
                        context,
                      ),
                ),
          ),
        ],
        child: MaterialApp(
          title: 'Inventory System',
          theme: customTheme,
          initialRoute: splashScreen,
          onGenerateRoute: generateRoute,
        ),
      ),
    );
  }
}
