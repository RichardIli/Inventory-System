import 'package:flutter/material.dart';
import 'package:inventory_system/Data/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/Config/Routes/routes.dart';

class SignOutConfirmationWindow extends StatelessWidget {
  const SignOutConfirmationWindow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MyFirebaseAuth myAuth = MyFirebaseAuth();
    return AlertDialog(
      title: Center(child: Text("Sign Out")),
      content: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Are you sure you want to sign out?",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
      actions: [
        Row(
          spacing: 10,
          children: [
            SizedBox(
              width: 200,
              child: TextButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "NO",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: TextButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  backgroundColor:
                      WidgetStatePropertyAll(Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  myAuth.signOut();
                  // This is the proper way
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    loginScreen,
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text(
                  "YES",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
