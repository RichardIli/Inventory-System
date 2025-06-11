import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Routes/routes.dart';
import 'package:inventory_system/Theme/theme.dart';
import 'package:inventory_system/bloc/UserScreenBlocs/SelectedUserBloc/selected_user_bloc.dart';
import 'package:inventory_system/bloc/UserScreenBlocs/UsersBloc/users_bloc.dart';

class UsersList extends StatelessWidget {
  const UsersList({
    super.key,
    required this.scaffoldMessKey,
  });

  final GlobalKey<ScaffoldMessengerState> scaffoldMessKey;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectedUserBloc, SelectedUserState>(
      listener: (context, state) {
        if (state is SelectedUserLoaded) {
          Navigator.pushNamed(context, userProfile);
        } else if (state is SelectedUserError) {
          scaffoldMessKey.currentState!.showSnackBar(SnackBar(
            backgroundColor: AppColors.errorColor,
            content: Text(
              state.error,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
            action: SnackBarAction(
                label: "Close",
                onPressed: () =>
                    scaffoldMessKey.currentState!.hideCurrentMaterialBanner()),
          ));
        }
      },
      child: Column(
        children: [
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Titles(displayText: "ID"),
                Titles(displayText: "User Name"),
                Titles(displayText: "Position"),
              ],
            ),
          ),
          BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              if (state is UsersStateInitial) {
                context.read<UsersBloc>().add(FetchUsersEvent());
                return Center(child: CircularProgressIndicator());
              } else if (state is UsersStateLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is UsersStateLoaded) {
                final usersList = state.data;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: usersList.length,
                  itemBuilder: (context, index) {
                    final user = usersList[index];
                    final String userid = user["id"] != null
                        ? user["id"].toString()
                        : "User ID not Found";
                    final String userName = user["name"];
                    final String userPosition = user["position"];
                    final String userEmail = user["email"];
                    final String userAddress = user["address"];
                    final String userContactNo = user["contact no"].toString();
                    return GestureDetector(
                      onTap: () {
                        final userData = {
                          "userId": userid,
                          "userName": userName,
                          "userPosition": userPosition,
                          "userEmail": userEmail,
                          "userAddress": userAddress,
                          "userContactNo": userContactNo
                        };
                        context
                            .read<SelectedUserBloc>()
                            .add(SelectSelectedUserEvent(userData: userData));
                        // Navigator.pushNamed(context, userProfile);
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RowContent(displayText: userid),
                            RowContent(displayText: userName),
                            RowContent(displayText: userPosition),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is UsersStateError) {
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
