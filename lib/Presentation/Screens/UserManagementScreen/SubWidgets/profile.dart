import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/Presentation/SharedComponents/custom_appbar.dart';
import 'package:inventory_system/Presentation/SharedComponents/custom_footer.dart';
import 'package:inventory_system/Presentation/SharedComponents/sidemenu.dart';
import 'package:inventory_system/Config/Theme/theme.dart';
import 'package:inventory_system/Presentation/bloc/UserScreenBlocs/SelectedUserBloc/selected_user_bloc.dart';

class Profile extends StatelessWidget {
  const Profile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(),
        body: Row(
          children: [
            SideMenu(),
            Expanded(
              child: Padding(
                padding: contentPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.arrow_back),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Profile",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          BlocBuilder<SelectedUserBloc, SelectedUserState>(
                            builder: (context, state) {
                              if (state is SelectedUserInitial) {
                                return CircularProgressIndicator();
                              } else if (state is SelectedUserLoading) {
                                return CircularProgressIndicator();
                              } else if (state is SelectedUserLoaded) {
                                final passedData = state.userData;
                                return _userDetailsWidgets(passedData);
                              } else if (state is SelectedUserError) {
                                return Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.error_outline_rounded),
                                      Text(
                                        state.error,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    CustomFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _userDetailsWidgets(Map<String, dynamic> passedData) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Icon(
              Icons.person_outline_rounded,
              size: 200,
              color: Colors.grey,
            ),
            _DetailsField(
              displayLabel: "ID:",
              displayContent: passedData["userId"] ?? "",
              customWidth: 300,
            ),
            _DetailsField(
              displayLabel: "Name:",
              displayContent: passedData["userName"] ?? "",
              customWidth: 300,
            ),
            _DetailsField(
              displayLabel: "Position",
              displayContent: passedData["userPosition"] ?? "",
              customWidth: 300,
            ),
            Row(
              spacing: 20,
              children: [
                _DetailsField(
                  displayLabel: "Email Address",
                  displayContent: passedData["userEmail"] ?? "",
                  customWidth: 300,
                ),
                _DetailsField(
                  displayLabel: "Contact No",
                  displayContent: passedData["userContactNo"] ?? "",
                  customWidth: 300,
                )
              ],
            ),
            _DetailsField(
              displayLabel: "Address",
              displayContent: passedData["userAddress"] ?? "",
              customWidth: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsField extends StatelessWidget {
  const _DetailsField({
    required this.displayLabel,
    required this.displayContent,
    required this.customWidth,
  });

  final String displayLabel;
  final String displayContent;
  final double customWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 1,
      children: [
        Text(
          displayLabel,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Container(
          padding: EdgeInsets.all(10),
          // height: 30,
          width: customWidth,
          decoration: BoxDecoration(
            color: Color(0XFFE6E6E6),
            border: Border.all(color: Colors.black, width: .5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              displayContent,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        )
      ],
    );
  }
}
