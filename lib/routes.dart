import 'package:flutter/material.dart';
import 'package:samsar/screens/main_screens/add_house.dart';
import 'package:samsar/screens/main_screens/chat_screen.dart';
import 'package:samsar/screens/main_screens/notifications_screen.dart';
import 'package:samsar/screens/main_screens/search.dart';
import 'package:samsar/screens/settings_screens/contact_support.dart';
import 'package:samsar/screens/settings_screens/edit_profile.dart';
import 'package:samsar/screens/settings_screens/favorite_houses.dart';
import 'package:samsar/screens/house_details/home_edit_screen.dart';
import 'package:samsar/screens/settings_screens/my_houses_page.dart';
import 'package:samsar/screens/settings_screens/settings_page.dart';
import 'package:samsar/screens/user_control/auth_wrapper.dart';
import 'package:samsar/screens/bottom_navigator.dart';
import 'package:samsar/screens/main_screens/home.dart';
import 'package:samsar/screens/house_details/house_details.dart';
import 'package:samsar/values/invalid.dart';
import 'screens/user_control/login.dart';
import 'screens/user_control/signup.dart';
import 'values/app_routes.dart';

class Routes {
  const Routes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Route<dynamic> getRoute({
      required Widget widget,
      bool fullscreenDialog = false,
    }) {
      return MaterialPageRoute<void>(
        builder: (context) => widget,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
      );
    }

    switch (settings.name) {
      case AppRoutes.login:
        return getRoute(widget: const LoginScreen());

      case AppRoutes.signup:
        return getRoute(widget: const SignupScreen());

      case AppRoutes.home:
        return getRoute(widget: const HomeScreen());

      case AppRoutes.searchScreen:
        return getRoute(widget: const SearchScreen());

      case AppRoutes.myHouses:
        return getRoute(widget: const MyHousesPage());

      case AppRoutes.editHouse:
        final houseId = settings.arguments as String;
        return getRoute(widget: HouseEditPage(houseId: houseId));

      case AppRoutes.uploadHouse:
        return getRoute(widget: const HouseUploadPage());

      case AppRoutes.notificationsScreen:
        return getRoute(widget: const NotificationsPage());

      case AppRoutes.chatScreen:
        return getRoute(widget: const ChatPage());

      case AppRoutes.authWrapper:
          return getRoute(widget: const AuthWrapper());

      case AppRoutes.favouriteHouses:
        return getRoute(widget: FavouriteHousesPage());

      case AppRoutes.houseDetails:
        final houseId = settings.arguments as String;
        return getRoute(widget: HouseDetailsPage(houseId: houseId));
        
      case AppRoutes.contactSupport:
        return getRoute(widget: const ContactSupportScreen());

      case AppRoutes.appSettings:
        return getRoute(widget: const SettingsPage());

      case AppRoutes.homePage:
        return getRoute(widget: const HomePage());

      case AppRoutes.editProfile:
        return getRoute(widget: const EditProfileScreen());

      default:
        return getRoute(widget: const InvalidRoute());
    }
  }
}
