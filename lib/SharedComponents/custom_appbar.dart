import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/bloc/SharedComponentsBlocs/AppbarUserNameBloc/user_name_appbar_bloc.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50,
            child: Image.asset(
              'logo.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            elevation: 0,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                spacing: 10,
                children: [
                  BlocBuilder<UserNameAppbarBloc, UserNameAppbarState>(
                    builder: (context, state) {
                      if (state is UserNameAppbarInitial) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is UserNameAppbarLoading) {
                        return state.loadingState;
                      } else if (state is UserNameAppbarLoaded) {
                        return Text(
                          state.userName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white),
                        );
                      } else if (state is UserNameAppbarStateError) {
                        return state.error;
                      } else {
                        return Center(
                          child: Text(
                              "Something went Wrong. Get advice From your IT"),
                        );
                      }
                    },
                  ),
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
