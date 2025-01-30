import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';

import '../../shared/cubit/state.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key});

  TextEditingController textController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppState>(
      listener: (context, state) {
        if (state is SocialAppCreatePostSuccessState || state is SocialAppUploadPostImageSuccessState){
          showToast(text: 'Post Success', state: ToastStates.SUCCESS);
          Navigator.pop(context);
          SocialAppCubit.get(context).removePostImage();
          textController.clear();
        }
      },

      builder: (context, state) {
        UserModel? userModel;

        if (SocialAppCubit.get(context).userModel != null) {
          userModel = SocialAppCubit.get(context).userModel!;
        }

        return Scaffold(
          appBar: defaultAppBar(context: context, title: Text('Craete Post'), actions: [TextButton(onPressed: (){
            if (SocialAppCubit.get(context).postImage == null){
              SocialAppCubit.get(context).createPost(dateTime: DateTime.now().toString(), postText: textController.text);
            } else {
              SocialAppCubit.get(context).uploadPostImage(postText: textController.text, dateTime: DateTime.now().toString(),);
            }
          }, child: Text('Post', style: TextStyle(color: Colors.blue, fontSize: 20),))]),

          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: userModel!.image != '' ? NetworkImage(userModel.image!) : AssetImage('assets/images/user_image.png'),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: Text(userModel.name!, style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      controller: textController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'what is on your mind ...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                if(SocialAppCubit.get(context).postImage != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(SocialAppCubit.get(context).postImage!))
                        ),
                      ),
                      IconButton(onPressed: (){
                        SocialAppCubit.get(context).removePostImage();
                      }, icon: Icon(Icons.cancel,size: 30, color: Colors.white,))
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: (){
                            SocialAppCubit.get(context).selectPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.photo, color: Colors.blue,), Text('Add Photo', style: TextStyle(color: Colors.blue),)],)),
                    ),
                    Expanded(
                      child: TextButton(onPressed: (){},
                          child: Text('# Tags', style: TextStyle(color: Colors.blue),)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}