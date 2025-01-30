import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(UserLoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
      emit(UserLoginSuccessState(value.user!.uid));
    }).catchError((error) {
      print(error.toString());
      emit(UserLoginErrorState());
    },);
  }


  bool isPassword = true;

  changePasswordVisibility(){
    isPassword = !isPassword;
    emit(ChangePasswordVisibilityState());
  }
}