import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/cubit/state.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';

import '../../layout/social_app/layout_screen.dart';
import '../../shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is UserRegisterSuccessState) {
            showToast(text: 'Register Success', state: ToastStates.SUCCESS);
            CacheHelper.saveData(key: 'token', value: state.uId).then((value) {
              token = state.uId;
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LayoutScreen()), (route) => false);
            });
          } else if (state is UserRegisterErrorState) {
            showToast(text: 'Register Failed', state: ToastStates.ERROR);
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
                        Text('Register', style: TextStyle(fontSize: 50)),
                        SizedBox(height: 20.0),
                        defultTextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            label: 'Name',
                            prefixIcon: Icon(Icons.person)),
                        SizedBox(height: 15.0),
                        defultTextFormField(
                            controller: phoneController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            label: 'Phone Number',
                            prefixIcon: Icon(Icons.phone)),
                        SizedBox(height: 15.0),
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
                            isPassword: RegisterCubit.get(context).isPassword,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  RegisterCubit.get(context)
                                      .changePasswordVisibility();
                                },
                                icon: Icon(RegisterCubit.get(context).isPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility))),
                        SizedBox(height: 15.0),
                        state is! UserRegisterLoadingState ? defultButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            widget: Text('Register',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20))) : defultButton(onPressed: (){}, widget: CircularProgressIndicator(color: Colors.white,)),
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
