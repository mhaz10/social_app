import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';


class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppState>(
      listener: (context, state) {},

      builder: (context, state) {
        return SocialAppCubit.get(context).allUsers.isNotEmpty ?

          ListView.separated(
              itemBuilder: (context, index) => chatItem(SocialAppCubit.get(context).allUsers[index], context),
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Divider(),
              ),
              itemCount: SocialAppCubit.get(context).allUsers.length) :

        LinearProgressIndicator(color: Colors.amber,);
      },
    );
  }


  Widget chatItem(UserModel userModel, context) {
    return InkWell(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailsScreen(userModel: userModel)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(userModel.image!),
            ),
            SizedBox(width: 15,),

            Expanded(
              child: Text(userModel.name!, style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}