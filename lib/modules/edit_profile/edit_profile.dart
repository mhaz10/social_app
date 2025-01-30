import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppState>(
      listener: (context, state) {},

      builder: (context, state) {

        UserModel? userModel;

        if (SocialAppCubit.get(context).userModel != null) {
          userModel = SocialAppCubit.get(context).userModel!;
        }

        File? profileImage;
        if (SocialAppCubit.get(context).profileImage != null) {
          profileImage = SocialAppCubit.get(context).profileImage!;
        }

        File? coverImage;
        if (SocialAppCubit.get(context).coverImage != null){
          coverImage = SocialAppCubit.get(context).coverImage!;
        }

        nameController.text = userModel!.name!;
        phoneController.text = userModel.phone!;
        bioController.text = userModel.bio!;

        return Scaffold(
          appBar: defaultAppBar(context: context, title: Text('Edit Profile'), actions: [TextButton(onPressed: (){
            SocialAppCubit.get(context).updateData(name: nameController.text, phone: phoneController.text, bio: bioController.text);
          }, child: Text('UPDATE', style: TextStyle(color: Colors.blue),))]),

          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if(state is SocialAppUpdateUserDataLoadingState)
                    LinearProgressIndicator(),
                  if(state is SocialAppUpdateUserDataLoadingState)
                   SizedBox(height: 15,),

                  Container(
                    height: 190,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: coverImage == null ? NetworkImage(userModel.cover!) : FileImage(coverImage), onError: (exception, stackTrace) => SizedBox(),)
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5 , right: 5),
                                child: InkWell(
                                  onTap: () {
                                    SocialAppCubit.get(context).selectCoverImage();
                                  },
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.camera_alt, color: Colors.black,),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        CircleAvatar(
                            radius: 65,
                            backgroundColor: Theme
                                .of(context)
                                .scaffoldBackgroundColor,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: profileImage == null ? userModel.image != '' ? NetworkImage(userModel.image!) : AssetImage('assets/images/user_image.png') : FileImage(profileImage),
                                ),
                                InkWell(
                                  onTap: () {
                                    SocialAppCubit.get(context).selectProfileImage();
                                  },
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.camera_alt, color: Colors.black,),
                                  ),
                                )
                              ],
                            )
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),
                  if (SocialAppCubit.get(context).profileImage != null || SocialAppCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if(profileImage != null)
                          Expanded(child: defultButton(onPressed: () {
                            SocialAppCubit.get(context).uploadProfileImage();
                          }, widget: Text('upload profile image', style: TextStyle(color: Colors.white),))),

                        SizedBox(width: 10,),

                        if(coverImage != null)
                          Expanded(child: defultButton(onPressed: (){
                            SocialAppCubit.get(context).uploadCoverImage();
                          }, widget: Text('upload cover image', style: TextStyle(color: Colors.white),)))
                      ],
                    ),

                  SizedBox(height: 10,),

                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        )
                    ),
                  ),

                  SizedBox(height: 15,),

                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Phone',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        )
                    ),
                  ),

                  SizedBox(height: 15,),

                  TextFormField(
                    controller: bioController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        hintText: 'Bio',
                        prefixIcon: Icon(Icons.info_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        )
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}