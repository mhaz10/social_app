import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';

class CommentsPage extends StatelessWidget {

  final String postId;

  CommentsPage({super.key, required this.postId});

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppState>(
      listener: (context, state) {},

      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Comments'),
            ),

            body: Column(
              children: [


                  SocialAppCubit.get(context).comment.isNotEmpty ? Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => commentItem(SocialAppCubit.get(context).comment[index]),
                        separatorBuilder: (context, index) => SizedBox(height: 20,),
                        itemCount: SocialAppCubit.get(context).comment.length),
                  ) : Expanded(child: Center(child: SizedBox())),



                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: commentController,
                          decoration: InputDecoration(
                              hintText: 'write a comment',
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              )
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){
                        SocialAppCubit.get(context).commentPost(postId: postId, comment: commentController.text);
                      }, icon: Icon(Icons.send))
                    ],
                  ),
                )
              ],
            )
        );
      },
    );
  }

  Widget commentItem(Map<String, dynamic> comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(comment['image']),
          ),
          SizedBox(width: 15,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment['name'], style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Text(comment['comment'], maxLines: 3, overflow: TextOverflow.ellipsis,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}