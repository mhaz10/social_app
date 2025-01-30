import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/cubit/state.dart';
import '../../../models/user_model/user_model.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(UserRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      userCreate(name: name, phone: phone, email: email, uId: value.user!.uid);
      emit(UserRegisterSuccessState( value.user!.uid));
    }).catchError((error) {
      print(error.toString());
      emit(UserRegisterErrorState());
    },);
  }

  void userCreate({
    required String name,
    required String phone,
    required String email,
    required String uId,
  }) {
    emit(UserCreateLoadingState());

    UserModel userModel = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
    );

    FirebaseFirestore.instance.collection('users').doc(uId).set(userModel.toMap()).then((value) {
      emit(UserCreateSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UserCreateErrorState());
    },);
  }


  bool isPassword = true;

  changePasswordVisibility(){
    isPassword = !isPassword;
    emit(ChangePasswordVisibilityState());
  }
}