import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/bloc/DashboardScreenBlocs/DashboardUsersCountBloc/dashboard_users_count_bloc.dart';

class UsersCard extends StatelessWidget {
  const UsersCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: BlocBuilder<DashboardUsersCountBloc, DashboardUsersCountState>(
        builder: (context, state) {
          if (state is DashboardUsersCountInitial) {
            context
                .read<DashboardUsersCountBloc>()
                .add(FetchDashboardUsersCountEvent());
            return Center(child: CircularProgressIndicator());
          } else if (state is DashboardUsersCountLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DashboardUsersCountLoaded) {
            return CustomCard(
              cardDisplayLabel: "USERS",
              countDisplayLabel: "User Counts: ",
              displayCount: state.count.toString(),
            );
          } else if (state is DashboardUsersCountError) {
            return Text('Error: ${state.error}');
          } else {
            return Center(
              child: Text("No Data"),
            );
          }
        },
      ),
    );
  }
}


class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.cardDisplayLabel,
    required this.countDisplayLabel,
    required this.displayCount,
  });

  final String cardDisplayLabel;
  final String countDisplayLabel;
  final String displayCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 300,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:  10,horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardDisplayLabel,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(countDisplayLabel),
                  Text(
                    displayCount,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
