import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samsar/Widgets/widgets.dart';
import '../../Widgets/additional_info_dialog.dart';
import '../../helpers/user_manager.dart';
import '../bottom_navigator.dart';
import 'login.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return _loadingScreen();
        }

        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState != ConnectionState.done) {
                return _loadingScreen();
              }

              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final userData = userSnapshot.data!;
                final hasPhoneNumber = userData["phoneNumber"]?.isNotEmpty ?? false;

                if (hasPhoneNumber) {
                  return FutureBuilder<void>(
                    future: UserManager().loadUserData(),
                    builder: (context, dataSnapshot) {
                      if (dataSnapshot.connectionState == ConnectionState.done) {
                        return HomePage();
                      } else {
                        return _loadingScreen();
                      }
                    },
                  );
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showAdditionalInfoDialog(context, user.uid);
                  });
                  return LoginScreen();
                }
              } else {
                return LoginScreen();
              }
            },
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }

  Widget _loadingScreen() {
    return Scaffold(
      body: Center(
        child: CustomLoadingScreen(
          message: "Loading",
        ),
      ),
    );
  }
}

/*
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(snapshot.data?.uid).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.done) {
                if (userSnapshot.data != null && userSnapshot.data!.exists && userSnapshot.data?["phoneNumber"] != "" && userSnapshot.data?["phoneNumber"] != null) {
                  UserManager().loadUserData().then((_) => return HomePage());
                  return HomePage();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showAdditionalInfoDialog(context, snapshot.data!.uid);
                  });
                  return LoginScreen();
                }
              }
              return CustomLoadingScreen(
                message: "Loading",
              );
            },
          );
        } else {
          return Scaffold(
            body: Center(
              child: CustomLoadingScreen(
                message: "Loading",
              ),
            ),
          );
        }
      },
    );
  }
}
*/