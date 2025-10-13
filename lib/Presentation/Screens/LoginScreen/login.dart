// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:inventory_system/FirebaseConnection/firebaseauth_connection.dart';
// import 'package:inventory_system/FirebaseConnection/firestore_users_db.dart';
// import 'package:inventory_system/Routes/routes.dart';
// import 'package:inventory_system/bloc/SharedComponentsBlocs/AppbarUserNameBloc/user_name_appbar_bloc.dart';
// import 'widgets.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController useremailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool usernameError = false;
//   bool passwordError = false;
//   String errorMessage = '';
//   bool showPassword = false;

//   // login is divided to multiple part for multiple action when logging in
//   void login() {
//     setState(() {
//       usernameError = useremailController.text.isEmpty;
//       passwordError = passwordController.text.isEmpty;
//       errorMessage = '';

//       if (usernameError || passwordError) {
//         errorMessage = 'Please fill in all fields';
//         return;
//       }
//     });

//     loginProcess1();
//   }

//   void loginProcess1()  {
//     MyFirebaseAuth myAuth = RepositoryProvider.of<MyFirebaseAuth>(context);

//     bool isValid =  myAuth.login(
//         emailAddress: useremailController.text,
//         password: passwordController.text);

//     // ignore: use_build_context_synchronously
//     loginProcess2(isValid, context, myAuth);
//   }

//   void loginProcess2(
//       bool isValid, BuildContext context, MyFirebaseAuth myAuth)  {
//     // ignore: use_build_context_synchronously
//     FirestoreUsersDbRepository users =
//         RepositoryProvider.of<FirestoreUsersDbRepository>(context);

//     if (isValid) {
//       final userName =  myAuth.fetchAuthenticatedUserData();
//       final data = users.searchUserData(userName);

//       // only the admin, ceo and it can access this system
//       if (data.first["position"] != "ADMIN" &&
//           data.first["position"] != "CEO" &&
//           data.first["position"] != "IT") {
//         // ignore: use_build_context_synchronously
//         Navigator.pushNamed(context, notAuthorizedScreen);
//       } else {
//         // ignore: use_build_context_synchronously
//         context.read<UserNameAppbarBloc>().add(FetchUserNameAppbarEvent());
//         // ignore: use_build_context_synchronously
//         Navigator.pushNamed(context, dashboardScreen);
//       }
//     } else {
//       setState(() {
//         errorMessage = 'Incorrect email or password';
//         usernameError = true;
//         passwordError = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Expanded(
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: AppLogo(),
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 5.0),
//                       child: Text(
//                         'Inventory System',
//                         style: Theme.of(context).textTheme.titleLarge,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const Divider(),
//                     Text(
//                       'Login',
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     Text(
//                       'Sign into your account',
//                       style: TextStyle(
//                           fontSize: 14, color: Theme.of(context).primaryColor),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10),
//                       child: CustomTextField(
//                         controller: useremailController,
//                         label: 'Username',
//                         isError: usernameError,
//                         login: login,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20),
//                       child: CustomTextField(
//                         controller: passwordController,
//                         label: 'Password',
//                         isPassword: true,
//                         isError: passwordError,
//                         showPassword: showPassword,
//                         togglePasswordVisibility: () {
//                           setState(() {
//                             showPassword = !showPassword;
//                           });
//                         },
//                         login: login,
//                       ),
//                     ),
//                     if (errorMessage.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10),
//                         child: Text(
//                           errorMessage,
//                           style:
//                               const TextStyle(color: Colors.red, fontSize: 14),
//                         ),
//                       ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20),
//                       child: SizedBox(
//                         width: 150,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             login();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Theme.of(context).primaryColor,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             'Login',
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     useremailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
// }

// ignore_for_file: unnecessary_null_comparison, await_only_futures

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Data/FirebaseConnection/firebaseauth_connection.dart';
import 'package:inventory_system/Data/FirebaseConnection/firestore_users_db.dart';
import 'package:inventory_system/Config/Routes/routes.dart';
import 'package:inventory_system/Presentation/bloc/SharedComponentsBlocs/AppbarUserNameBloc/user_name_appbar_bloc.dart';
import 'widgets.dart'; // Assuming this contains CustomTextField and AppLogo

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController useremailController = TextEditingController(text: "user1@example.com");
  final TextEditingController passwordController = TextEditingController(text: "password123");
  bool usernameError = false;
  bool passwordError = false;
  String errorMessage = '';
  bool showPassword = false;
  bool _isLoading = false; // New state to manage loading indicator

  Future<void> login() async {
    // Made async
    setState(() {
      usernameError = useremailController.text.isEmpty;
      passwordError = passwordController.text.isEmpty;
      errorMessage = '';
      _isLoading = false; // Reset loading on initial validation
    });

    if (usernameError || passwordError) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      MyFirebaseAuth myAuth = RepositoryProvider.of<MyFirebaseAuth>(context);
      FirestoreUsersDbRepository users =
          RepositoryProvider.of<FirestoreUsersDbRepository>(context);

      // Await the asynchronous login operation
      bool isValid = await myAuth.login(
        emailAddress: useremailController.text,
        password: passwordController.text,
      );

      if (!mounted) return; // Check if the widget is still in the tree

      if (isValid) {
        final userName =
            await myAuth.fetchAuthenticatedUserData(useremailController.text); // Await fetch user data

        if (userName == null || userName.isEmpty) {
          setState(() {
            errorMessage = 'Failed to retrieve user data after login.';
            _isLoading = false;
          });
          return;
        }

        final List<Map<String, dynamic>> userData = await users.searchUserData(
          userName,
        ); // Await search user data

        if (!mounted) return; // Check if the widget is still in the tree

        if (userData.isEmpty) {
          setState(() {
            errorMessage = 'User data not found.';
            _isLoading = false;
          });
          return;
        }

        // only the admin, ceo and it can access this system
        final String? position = userData.first["position"];
        if (position != "Admin" && position != "CEO" && position != "IT") {
          Navigator.pushNamed(context, notAuthorizedScreen);
        } else {
          context.read<UserNameAppbarBloc>().add(FetchUserNameAppbarEvent(emailAddress: useremailController.text));
          Navigator.pushNamed(context, dashboardScreen);
        }
      } else {
        setState(() {
          errorMessage = 'Incorrect email or password';
          usernameError = true;
          passwordError = true;
        });
      }
    } catch (e) {
      // Handle any exceptions that occur during Firebase/Firestore operations
      setState(() {
        errorMessage = 'An error occurred: ${e.toString()}';
        usernameError = true;
        passwordError = true;
      });
      if (kDebugMode) {
        print('Login Error: $e');
      } // Log the error for debugging
    } finally {
      setState(() {
        _isLoading = false; // Stop loading regardless of success or failure
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AppLogo(),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'Inventory System',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Divider(),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Sign into your account',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CustomTextField(
                        controller: useremailController,
                        label: 'Username',
                        isError: usernameError,
                        login: login,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomTextField(
                        controller: passwordController,
                        label: 'Password',
                        isPassword: true,
                        isError: passwordError,
                        showPassword: showPassword,
                        togglePasswordVisibility: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        login: login,
                      ),
                    ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () {
                                    // Disable button when loading
                                    login();
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  ) // Show loading indicator
                                  : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    useremailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
