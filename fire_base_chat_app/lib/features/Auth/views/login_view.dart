import 'package:chat_app_firebase/core/utils/style/screen_size.dart';
import 'package:chat_app_firebase/features/Auth/cubit/auth_cubit.dart';
import 'package:chat_app_firebase/features/Home/views/home_view.dart';
import 'package:chat_app_firebase/features/Auth/views/register_view.dart';
import 'package:chat_app_firebase/features/Auth/widgets/header_widget.dart';
import 'package:chat_app_firebase/features/Auth/widgets/normal_text_field.dart';
import 'package:chat_app_firebase/features/Auth/widgets/secret_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static String routeName = 'login-view';
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, HomeView.routeName);
        } else if (state is LoginError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is LoginLoading,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Padding(
              padding: EdgeInsets.only(top: ScreenSize.height / 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderWidget(
                      title: "Hello, Welcome Back",
                      subtitle:
                          "Happy to see you again, to use your account please login first.",
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
                            title: "Email Address",
                            controller: emailController,
                            formKey: emailFormKey,
                          ),
                          SizedBox(height: ScreenSize.height / 20),
                          SecretTextField(
                            title: "Password",
                            controller: passwordController,
                            formKey: passwordFormKey,
                          ),
                          SizedBox(height: ScreenSize.height / 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password?",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenSize.height / 20),
                          SizedBox(
                            width: ScreenSize.width / 1.2,
                            child: ElevatedButton(
                              onPressed: () {
                                if (emailFormKey.currentState!.validate() &&
                                    passwordFormKey.currentState!.validate()) {
                                  context.read<AuthCubit>().login(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              style: Theme.of(
                                context,
                              ).elevatedButtonTheme.style,
                              child: Text("Login"),
                            ),
                          ),
                          SizedBox(height: ScreenSize.height / 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    RegisterView.routeName,
                                  );
                                },
                                child: Text("Sign Up"),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenSize.height / 40),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.color,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenSize.width / 30,
                                ),
                                child: Text(
                                  "Or login with",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.color,
                                    fontSize: ScreenSize.width / 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.color,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenSize.height / 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: ScreenSize.width / 30,
                                child: Image.asset(
                                  "assets/images/google.png",
                                  width: ScreenSize.width / 15,
                                ),
                              ),
                              SizedBox(width: ScreenSize.width / 10),
                              CircleAvatar(
                                radius: ScreenSize.width / 30,
                                child: Image.asset(
                                  "assets/images/apple.png",
                                  width: ScreenSize.width / 15,
                                ),
                              ),
                              SizedBox(width: ScreenSize.width / 10),
                              CircleAvatar(
                                radius: ScreenSize.width / 30,
                                child: Image.asset(
                                  "assets/images/face.png",
                                  width: ScreenSize.width / 15,
                                ),
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
