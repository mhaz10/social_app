import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defultTextFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  FormFieldValidator<String>? validator,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onFieldSubmitted,
  required String label,
  required Icon prefixIcon,
  IconButton? suffixIcon,
  bool isPassword = false,
  GestureTapCallback? onTap,
}) => TextFormField(
  onTap: onTap,
  controller: controller,
  keyboardType: keyboardType,
  obscureText: isPassword,
  onFieldSubmitted: onFieldSubmitted,
  onChanged: onChanged,
  validator: validator,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: prefixIcon,
    border: OutlineInputBorder(),
    suffixIcon: suffixIcon != null ? suffixIcon : null,
  ),
);


Widget defultButton({
  double width = double.infinity,
  var background = Colors.blue,
  required VoidCallback onPressed,
  required Widget widget,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: background,
      ),
      child: MaterialButton(
        height: 50,
        onPressed: onPressed,
        child: widget,
      ),
    );

enum ToastStates {SUCCESS, ERROR, WARNING}

chooseToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.SUCCESS:
      return Colors.green;
    case ToastStates.ERROR:
      return Colors.red;
    case ToastStates.WARNING:
      return Colors.amber;
  }
}

Future<bool?> showToast({
required String text,
required ToastStates state
}) => Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
);

PreferredSizeWidget defaultAppBar ({required BuildContext context,Widget? title, List<Widget>? actions}) {
  return AppBar(
    leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),
    title: title,
    actions: actions,
  );
}