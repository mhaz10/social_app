import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/modules/edit_profile/edit_profile.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppState>(
      listener: (context, state) {},

      builder: (context, state) {
        UserModel? userModel;

        if (SocialAppCubit.get(context).userModel != null) {
          userModel = SocialAppCubit.get(context).userModel!;
        }

        return userModel != null ?  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: userModel.cover != '' ? Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(userModel.cover!),
                            )
                        ),
                      ) : SizedBox(),
                    ),

                    CircleAvatar(
                        radius: 65,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: userModel.image == '' ? AssetImage('assets/images/user_image.png') : NetworkImage(userModel.image!),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Text(userModel.name!, style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10,),
              Text(userModel.bio!, style: Theme.of(context).textTheme.bodyMedium),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text('100'),
                            Text('Post' , style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text('265'),
                            Text('Photo' , style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text('10K'),
                            Text('Followers' , style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text('64'),
                            Text('Following' , style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: (){}, child: Text('Add Photos', style: TextStyle(color: Colors.blue),))),
                  SizedBox(width: 10,),
                  OutlinedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                  }, child: Icon(Icons.edit, color: Colors.blue,))
                ],
              )
            ],
          ),
        ) : Center(child: CircularProgressIndicator(color: Colors.blue));
      },
    );
  }
}