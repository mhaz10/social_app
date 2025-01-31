import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/get_posts/get_posts_model.dart';
import 'package:social_app/modules/add_post/add_post.dart';
import 'package:social_app/modules/comments/comments_screen.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppState>(
      listener: (context, state) {},
      
      builder: (context, state) {
        return SingleChildScrollView(
          child:
          SocialAppCubit.get(context).postsModel.length > 0 &&  SocialAppCubit.get(context).postsUid.length > 0 && SocialAppCubit.get(context).likes.length > 0 && SocialAppCubit.get(context).comments.length > 0 ?
          Column(
            children: [
              addPost(SocialAppCubit.get(context).userModel!.image,context),

              ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => buildPostItem(context, index, SocialAppCubit.get(context).postsModel[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemCount: SocialAppCubit.get(context).postsModel.length),

            ],
          ) : Center(child: LinearProgressIndicator(color: Colors.amber)),
        );
      },
    );
  }

  Widget addPost(String? userImage,context) => GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
              new CupertinoPageRoute<bool>(
                  fullscreenDialog: true,
                  builder: (BuildContext context) => AddPostScreen()));
        },
        child: Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: Container(
            height: 80,
            width: double.infinity,
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: userImage != '' ? NetworkImage(userImage!) : AssetImage('assets/images/user_image.png'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(child: Text('What is in your mind?',
                      style: TextStyle(color: Colors.black),)),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget buildPostItem(context, int index , PostsModel postModel) => Card(
  clipBehavior: Clip.antiAliasWithSaveLayer,
  elevation: 10.0,
  margin: EdgeInsets.all(10),
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(postModel.image!),
            ),
            SizedBox(width: 15,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(postModel.name!),
                      SizedBox(width: 5,),
                      Icon(Icons.check_circle, color: Colors.blue, size: 20,)
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(postModel.dateTime!, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
            SizedBox(width: 15,),
            IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(postModel.postText!),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 5 , bottom: 5),
        //   child: Container(
        //     padding: EdgeInsets.symmetric(vertical: 10),
        //     width: double.infinity,
        //     child: Wrap(
        //       children: [
        //         Container( padding:  EdgeInsets.only(right: 5) ,  height: 20, child: MaterialButton(onPressed: (){}, minWidth: 1, padding: EdgeInsets.zero , child: Text('#software', style: TextStyle(color: Colors.blue)),)),
        //       ],
        //     ),
        //   ),
        // ),
        if (postModel.postImage != "" && postModel.postImage!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(postModel.postImage!))
              ),
            ),
          ),

        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: InkWell(
                  onTap: (){
                    SocialAppCubit.get(context).likePost(postId: SocialAppCubit.get(context).postsUid[index]);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border, color: Colors.red,),
                      SizedBox(width: 5,),
                      Text('${SocialAppCubit.get(context).likes[index]}  Likes')
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: InkWell(
                  onTap: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.chat, color: Colors.amber,),
                      SizedBox(width: 5,),
                      Text('${SocialAppCubit.get(context).comments[index]} comments')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Divider(),
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: SocialAppCubit.get(context).userModel!.image != '' ? NetworkImage(SocialAppCubit.get(context).userModel!.image!) : AssetImage('assets/images/user_image.png'),
                    ),
                    SizedBox(width: 15,),
                    Text('write a comment'),
                  ],
                ),
                onTap: () {
                  SocialAppCubit.get(context).getComments(postId: SocialAppCubit.get(context).postsUid[index]);
                  Navigator.of(context, rootNavigator: true).push(
                     CupertinoPageRoute<bool>(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => CommentsPage(postId: SocialAppCubit.get(context).postsUid[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ],
    ),
  ),
);
}
