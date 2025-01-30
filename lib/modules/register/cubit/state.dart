abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

// user register
class UserRegisterLoadingState extends RegisterState {}

class UserRegisterSuccessState extends RegisterState {
  final String uId;

  UserRegisterSuccessState(this.uId);
}

class UserRegisterErrorState extends RegisterState {}

// change password visibility
class ChangePasswordVisibilityState extends RegisterState {}

// user Create
class UserCreateLoadingState extends RegisterState {}

class UserCreateSuccessState extends RegisterState {}

class UserCreateErrorState extends RegisterState {}