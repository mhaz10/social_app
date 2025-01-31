import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message/message_model.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';

class ChatDetailsScreen extends StatelessWidget {

  UserModel userModel;

  ChatDetailsScreen({super.key, required this.userModel});

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {

          SocialAppCubit.get(context).getMassage(receiverId: userModel.uId!);

          return BlocConsumer<SocialAppCubit, SocialAppState>(
            listener: (context, state) {},

            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: userModel.image != '' ? NetworkImage(userModel.image!) : AssetImage('assets/images/user_image.png'),
                      ),
                      SizedBox(width: 15,),
                      Text(userModel.name!)
                    ],
                  ),
                ),

                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SocialAppCubit.get(context).messages.length > 0 ?

                      Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  var message = SocialAppCubit.get(context).messages[index];

                                  if (SocialAppCubit.get(context).userModel!.uId == message.senderId)
                                    return myMessage(message);

                                  return receiveMessage(message);
                                },
                                separatorBuilder: (context, index) => SizedBox(height: 14,),
                                itemCount: SocialAppCubit.get(context).messages.length)) :

                      Expanded(child: SizedBox()),

                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: TextFormField(
                              controller: textController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'write your message here ..... ',
                              ),
                            )),
                            Container(
                                height: 50,
                                color: Colors.blue,
                                child: MaterialButton(
                                  minWidth: 1,
                                  onPressed: () {
                                    SocialAppCubit.get(context).sendMessage(
                                        receiverId: userModel.uId!,
                                        dateTime: Timestamp.now(),
                                        text: textController.text);
                                  },
                                  child: Icon(
                                      Icons.send, size: 18,
                                      color: Colors.white),))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Widget myMessage(MessageModel message) =>
      Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
              vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.blue.withOpacity(.3),
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
                bottomStart: Radius.circular(10),
              )
          ),
          child: Text(message.text!),
        ),
      );

  Widget receiveMessage(MessageModel message) =>
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
              vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
                bottomEnd: Radius.circular(10),
              )
          ),
          child: Text(message.text!),
        ),
      );
}