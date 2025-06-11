import 'package:flutter/material.dart';

// this is the warning screen stating thet the current user does not have authority use this application
class NotAuthorizedScreen extends StatelessWidget {
  const NotAuthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Sorry You Dont Have Any Authority To Use This System",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "OK",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
