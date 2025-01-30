abstract class LoginState {}

class LoginInitialState extends LoginState {}

// user login
class UserLoginLoadingState extends LoginState {}

class UserLoginSuccessState extends LoginState {
  final String uId;

  UserLoginSuccessState(this.uId);
}

class UserLoginErrorState extends LoginState {}

// change password visibility
class ChangePasswordVisibilityState extends LoginState {}