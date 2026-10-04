import 'package:chat_app_firebase/core/utils/style/screen_size.dart';
import 'package:chat_app_firebase/features/profile/cubit/profile_cubit.dart';
import 'package:chat_app_firebase/features/profile/views/update_image.dart';
import 'package:chat_app_firebase/features/profile/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  static String routeName = '/profile';
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getUser(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is GetProfileSuccess) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        UpdateImage.routeName,
                        arguments: state.userModel.image,
                      );
                    },
                    child: CircleAvatar(
                      radius: ScreenSize.width / 3,
                      backgroundImage: NetworkImage(state.userModel.image!),
                    ),
                  ),
                  ProfileCardWidget(vKey: "Name", value: state.userModel.name),
                  ProfileCardWidget(
                    vKey: "Email",
                    value: state.userModel.email,
                  ),
                  ProfileCardWidget(
                    vKey: "Position",
                    value: state.userModel.postiton,
                  ),
                ],
              );
            } else if (state is GetProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("Error"));
            }
          },
        ),
      ),
    );
  }
}
