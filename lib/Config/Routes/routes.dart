import 'package:flutter/material.dart';
import 'package:inventory_system/Presentation/Screens/DashboardScreen/dashboard_screen.dart';
import 'package:inventory_system/Presentation/Screens/LoginScreen/login.dart';
import 'package:inventory_system/Presentation/Screens/NotAuthorized/not_authorized_screen.dart';
import 'package:inventory_system/Presentation/Screens/OfficeSuppliesScreen/office_supplies_screen.dart';
import 'package:inventory_system/Presentation/Screens/OfficeSuppliesScreen/office_supply_details_screen.dart';
import 'package:inventory_system/Presentation/Screens/OfficeSuppliesScreen/pull_out_office_supplies_screen.dart';
import 'package:inventory_system/Presentation/Screens/SplashScreen/splash_screen.dart';
import 'package:inventory_system/Presentation/Screens/SuppliesScreen/pull_out_supplies_screen.dart';
import 'package:inventory_system/Presentation/Screens/SuppliesScreen/supplies_screen.dart';
import 'package:inventory_system/Presentation/Screens/SuppliesScreen/supply_details_screen.dart';
import 'package:inventory_system/Presentation/Screens/ToolsEquipmentsScreen/release_tools_equipments_screen.dart';
import 'package:inventory_system/Presentation/Screens/ToolsEquipmentsScreen/return_tools_equipments_screen.dart';
import 'package:inventory_system/Presentation/Screens/ToolsEquipmentsScreen/specific_tools_equipments_screen.dart';
import 'package:inventory_system/Presentation/Screens/ToolsEquipmentsScreen/tool_equipment_details_screen.dart';
import 'package:inventory_system/Presentation/Screens/ToolsEquipmentsScreen/tools_equipment_screen.dart';
import 'package:inventory_system/Presentation/Screens/ToolsEquipmentsScreen/tools_equipments_counts_screen.dart';
import 'package:inventory_system/Presentation/Screens/TransmitalHistoryScree/transmital_history_screen.dart';
import 'package:inventory_system/Presentation/Screens/UserManagementScreen/SubWidgets/profile.dart';
import 'package:inventory_system/Presentation/Screens/UserManagementScreen/user_management_screen.dart';
import 'package:page_transition/page_transition.dart';

// provides the routes
const String splashScreen = 'splashScreen';

const String loginScreen = "loginScreen";

const String notAuthorizedScreen = "notAuthorizedScreen";

const String dashboardScreen = "dashboardScreen";

const String userManagementScreen = "usermanagementScreen";
const String userProfile = "userProfile";

const String toolsEquipmentsScreen = "itemsScreen";
const String toolsEquipmentCountScreen = "toolsEquipmentCountScreen";
const String releaseToolsEquipmentsScreen = "pulloutToolsEquipmentsScreen";
const String returnToolsEquipmentsScreen = "returnToolsEquipmentsScreen";
const String specificToolsEquipmentsScreen = "specificToolsEquipmentsScreen";
const String itemDetailsScreen = "itemDetailsScreen";

const String suppliesScreen = "suppliesScreen";
const String supplyDetailsScreen = "supplyDetailsScreen";
const String pullOutSupplyScreen = "pullOutSupplyScreen";

const String officeSuppliesScreen = "officeSuppliesScreen";
const String officeSupplyDetailsScreen = "officeSupplyDetailsScreen";
const String pullOutOfficeSuppliesScreen = "pullOutOfficeSuppliesScreen";

const String workersScreen = "workersScreen";

const String transmitalHistoryScreen = "transmitalHistoryScreen";

// this controll the transition animation
Route? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashScreen:
      return PageTransition(
        type: PageTransitionType.fade,
        child: SplashScreen(),
      );

    case loginScreen:
      return PageTransition(type: PageTransitionType.fade, child: LoginPage());

    case notAuthorizedScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: NotAuthorizedScreen());
    case dashboardScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: DashboardScreen());

    case userManagementScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: UserManagementScreen());
    case userProfile:
      return PageTransition(type: PageTransitionType.fade, child: Profile());

    case toolsEquipmentsScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: ToolsEquipmentScreen());
    case toolsEquipmentCountScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: ToolsEquipmentsCountScreen());
    case releaseToolsEquipmentsScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: ReleaseToolsEquipmentsScreen());
    case returnToolsEquipmentsScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: ReturnToolsEquipmentsScreen());
    case specificToolsEquipmentsScreen:
      return PageTransition(
          type: PageTransitionType.fade,
          child: SpecificToolsEquipmentsScreen());
    case itemDetailsScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: ItemsDetailsScreen());

    case suppliesScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: SuppliesScreen());
    case supplyDetailsScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: SupplyDetailsScreen());
    case pullOutSupplyScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: PullOutSuppliesScreen());

    case officeSuppliesScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: OfficeSuppliesScreen());
    case officeSupplyDetailsScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: OfficeSupplyDetailsScreen());
    case pullOutOfficeSuppliesScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: PullOutOfficeSuppliesScreen());

    case transmitalHistoryScreen:
      return PageTransition(
          type: PageTransitionType.fade, child: TransmitalHistoryScreen());
    default:
      // ignore: avoid_print
      print("error in route");
      return MaterialPageRoute(
        builder: (_) =>
            DashboardScreen(), // You can replace this with any fallback screen
      );
  }
}
