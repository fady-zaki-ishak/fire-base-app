import 'package:chat_app_firebase/core/utils/style/screen_size.dart';
import 'package:chat_app_firebase/data/user_types.dart';
import 'package:chat_app_firebase/features/Auth/cubit/auth_cubit.dart';
import 'package:chat_app_firebase/features/Auth/views/login_view.dart';
import 'package:chat_app_firebase/features/Auth/widgets/header_widget.dart';
import 'package:chat_app_firebase/features/Auth/widgets/normal_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static String routeName = "register-view";
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  UserType? selectedUserType;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.pushReplacementNamed(context, LoginView.routeName);
        } else if (state is RegisterError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is RegisterLoading,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Padding(
              padding: EdgeInsets.only(top: ScreenSize.height / 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderWidget(
                      title: "Join Us Today",
                      subtitle:
                          "Sign up now and enjoy connecting with people around you in an easy and secure way.",
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenSize.height / 15,
                        left: ScreenSize.width / 30,
                        right: ScreenSize.width / 30,
                      ),
                      child: Column(
                        children: [
                          NormalTextField(
                            title: "Name",
                            controller: nameController,
                            formKey: nameFormKey,
                          ),
                          SizedBox(height: ScreenSize.height / 20),
                          NormalTextField(
                            title: "Email Address",
                            controller: emailController,
                            formKey: emailFormKey,
                          ),
                          SizedBox(height: ScreenSize.height / 20),
                          NormalTextField(
                            title: "Password",
                            controller: passwordController,
                            formKey: passwordFormKey,
                          ),
                          SizedBox(height: ScreenSize.height / 20),
                          Row(
                            children: [
                              Text(
                                "Select Your Position",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenSize.height / 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio<UserType>(
                                fillColor: WidgetStateProperty.all(
                                  Theme.of(context).primaryColor,
                                ),
                                value: UserType.instructor,
                                // ignore: deprecated_member_use
                                groupValue: selectedUserType,
                                // ignore: deprecated_member_use
                                onChanged: (v) {
                                  setState(() {
                                    selectedUserType = v;
                                  });
                                },
                              ),
                              const Text('Instructor'),
                              SizedBox(width: ScreenSize.width / 50),
                              Radio<UserType>(
                                fillColor: WidgetStateProperty.all(
                                  Theme.of(context).primaryColor,
                                ),
                                value: UserType.student,
                                // ignore: deprecated_member_use
                                groupValue: selectedUserType,
                                // ignore: deprecated_member_use
                                onChanged: (v) {
                                  setState(() {
                                    selectedUserType = v;
                                  });
                                },
                              ),
                              const Text('Student'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio<UserType>(
                                fillColor: WidgetStateProperty.all(
                                  Theme.of(context).primaryColor,
                                ),
                                value: UserType.developer,
                                // ignore: deprecated_member_use
                                groupValue: selectedUserType,
                                // ignore: deprecated_member_use
                                onChanged: (v) {
                                  setState(() {
                                    selectedUserType = v;
                                  });
                                },
                              ),
                              const Text('Developer'),
                            ],
                          ),
                          SizedBox(height: ScreenSize.height / 50),
                          SizedBox(
                            width: ScreenSize.width / 1.2,
                            child: ElevatedButton(
                              style: Theme.of(
                                context,
                              ).elevatedButtonTheme.style,
                              onPressed: () {
                                if (nameFormKey.currentState!.validate() &&
                                    emailFormKey.currentState!.validate() &&
                                    passwordFormKey.currentState!.validate() &&
                                    selectedUserType != null) {
                                  context.read<AuthCubit>().register(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                    position: selectedUserType!.name,
                                  );
                                }
                              },
                              child: const Text("Sign Up"),
                            ),
                          ),
                          SizedBox(height: ScreenSize.height / 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    LoginView.routeName,
                                  );
                                },
                                child: const Text("Sign In"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
