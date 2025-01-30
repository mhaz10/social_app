import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/layout_screen.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/state.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';

import '../../shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is UserLoginSuccessState) {
            showToast(text: 'Login Success', state: ToastStates.SUCCESS);
            CacheHelper.saveData(key: 'token', value: state.uId).then((value) {
              token = state.uId;
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LayoutScreen()), (route) => false);
            });
          } else if (state is UserLoginErrorState) {
            showToast(text: 'Login Failed', state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/login_image.png',
                            width: double.infinity, height: 350),
                        Text('Login', style: TextStyle(fontSize: 50)),
                        SizedBox(height: 20.0),
                        defultTextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email address';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            label: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined)),
                        SizedBox(height: 15.0),
                        defultTextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            label: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            isPassword: LoginCubit.get(context).isPassword,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  LoginCubit.get(context)
                                      .changePasswordVisibility();
                                },
                                icon: Icon(LoginCubit.get(context).isPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility))),
                        SizedBox(height: 15.0),
                        state is! UserLoginLoadingState ? defultButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            widget: Text('Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20))) : defultButton(onPressed: (){}, widget: CircularProgressIndicator(color: Colors.white,)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                              },
                              child: Text(
                                'Register Now',
                                style: TextStyle(color: Colors.amber),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
