import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/create_post/create_post_model.dart';
import 'package:social_app/models/get_posts/get_posts_model.dart';
import 'package:social_app/models/message/message_model.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SocialAppCubit extends Cubit<SocialAppState> {
  SocialAppCubit() : super(SocialAppInitialState());

  static SocialAppCubit get(context) => BlocProvider.of(context);

  int index = 0;

  void changeBottomNav({required int index}) {
    {
      if (index == 1) {
        getAllUsers();
      }
      this.index = index;
      emit(SocialAppChangeBottomNavState());
    }
  }

  UserModel? userModel;

  // get user data
  void getUserData() {
    emit(SocialAppGetUserDataLoadingState());

    FirebaseFirestore.instance.collection('users').doc(token).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      print(Timestamp.now.toString());
      emit(SocialAppGetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialAppGetUserDataErrorState());
    });
  }

  final picker = ImagePicker();

  File? profileImage;
  Future selectProfileImage () async{
    final pickedFiled = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFiled != null) {
      profileImage = File(pickedFiled.path);
      emit(SocialAppImagePickerSuccessState());
    } else {
      print('No image selected');
      emit(SocialAppImagePickerErrorState());
    }
  }

  File? coverImage;
  Future selectCoverImage () async{
    final pickedFiled = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFiled != null) {
      coverImage = File(pickedFiled.path);
      emit(SocialAppImagePickerSuccessState());
    } else {
      print('No image selected');
      emit(SocialAppImagePickerErrorState());
    }
  }

  void uploadProfileImage () {
    final path = 'profile images/${Uri.file(profileImage!.path).pathSegments.last}';

    Supabase.instance.client.storage.from('social_app').upload(path, profileImage!).then((value) {
      updateData(profileImage: Supabase.instance.client.storage.from('social_app').getPublicUrl(path));
      emit(SocialAppUploadProfileImageSuccessState());
    },).catchError((error) {
      print(error.toString());
      emit(SocialAppUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage () {
    final path = 'cover images/${Uri.file(coverImage!.path).pathSegments.last}';

    Supabase.instance.client.storage.from('social_app').upload(path, coverImage!).then((value) {
      updateData(coverImage: Supabase.instance.client.storage.from('social_app').getPublicUrl(path));
      emit(SocialAppUploadCoverImageSuccessState());
    },).catchError((error){
      print(error.toString());
      emit(SocialAppUploadCoverImageErrorState());
    });
  }

  void updateData ({String? name,String? phone, String? bio, String? profileImage, String? coverImage}) {

    emit(SocialAppUpdateUserDataLoadingState());

    UserModel userModel = UserModel(
      name: name ?? this.userModel!.name,
      phone: phone ?? this.userModel!.phone,
      uId: token,
      bio: bio ?? this.userModel!.bio,
      email: this.userModel!.email,
      image: profileImage ?? this.userModel!.image,
      cover: coverImage ?? this.userModel!.cover,
    );

    FirebaseFirestore.instance.collection('users').doc(this.userModel!.uId!).update(userModel.toMap()).then((value) {
      getUserData();
      emit(SocialAppUpdateUserDataSuccessState());
    }).catchError((error) {
      emit(SocialAppUpdateUserDataErrorState());
    });
  }


  File? postImage;
  Future selectPostImage () async{
    final pickedFiled = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFiled != null) {
      postImage = File(pickedFiled.path);
      emit(SocialAppImagePickerSuccessState());
    } else {
      print('No image selected');
      emit(SocialAppImagePickerErrorState());
    }
  }

  void removePostImage()
  {
    postImage = null;
    emit(SocialAppRemoveImagePickerState());
  }

  void uploadPostImage({required String postText,required String dateTime,}) {

    final path = 'post images/${Uri.file(postImage!.path).pathSegments.last}';

    Supabase.instance.client.storage.from('social_app').upload(path, postImage!).then((value) {
      createPost(postText: postText,dateTime: dateTime,postImage: Supabase.instance.client.storage.from('social_app').getPublicUrl(path));
      emit(SocialAppUploadPostImageSuccessState());
    },).catchError((error) {
      print(error.toString());
      emit(SocialAppUploadPostImageErrorState());
    });
  }

  void createPost({required String postText,required String dateTime, String? postImage}) {

    emit(SocialAppCreatePostLoadingState());

    CreatePostModel createPostModel = CreatePostModel(
      name: userModel!.name!,
      uId: userModel!.uId!,
      image: userModel!.image!,
      dateTime: dateTime,
      postText: postText,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance.collection('posts').add(createPostModel.toMap()).then((value){
      emit(SocialAppCreatePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialAppCreatePostErrorState());
    });
  }

  List<PostsModel> postsModel = [];
  List<String> postsUid = [];
  List<int> likes = [];
  List<int> comments = [];

  void getPost() {
    emit(SocialAppGetPostLoadingState());

    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        postsUid.add(element.id);

        element.reference.collection('like').get().then((value) {
          likes.add(value.docs.length);
          element.reference.collection('comments').get().then((value) {
            comments.add(value.docs.length);
            postsModel.add(PostsModel.fromJson(element.data()));
            emit(SocialAppGetPostSuccessState());
          },);
        },);
      });
    },).catchError((error) {
      print(error.toString());
      emit(SocialAppGetPostErrorState());
    });
  }

  bool like = true;

  void likePost ({required String postId}) {

    like = !like;

    if (like == true) {
      FirebaseFirestore.instance.collection('posts').doc(postId).collection('like').doc(userModel!.uId).set({'like' : like}).then((value) {
        emit(SocialAppLikePostSuccessState());
      },).catchError((error) {
        print(error.toString());
        emit(SocialAppLikePostErrorState());
      });
    } else {
      FirebaseFirestore.instance.collection('posts').doc(postId).collection('like').doc(userModel!.uId).delete().then((value) {
        emit(SocialAppLikePostSuccessState());
      },).catchError((error) {
        print(error.toString());
        emit(SocialAppLikePostErrorState());
      });
    }

  }


  void commentPost({required String postId, required String comment}) {
    FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc(userModel!.uId).set({'comment' : comment, 'name' : userModel!.name, 'image' : userModel!.image}).then((value) {
      emit(SocialAppCommentPostSuccessState());
    },).catchError((error) {
      emit(SocialAppCommentPostErrorState());
    });
  }

  List<Map<String, dynamic>> comment = [];

  void getComments({required String postId}) {
    FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').get().then((value) {
      value.docs.forEach((element) => comment.add(element.data()));
      print(comment[0]['name']);
      emit(SocialAppGetCommentsSuccessState());
    },).catchError((error) {
      print(error.toString());
      emit(SocialAppGetCommentsErrorState());
    });
  }

  List<UserModel> allUsers = [];

  void getAllUsers() {
    emit(SocialAppGetAllUsersLoadingState());

    if (allUsers.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] !=  userModel!.uId)
            allUsers.add(UserModel.fromJson(element.data()));
          emit(SocialAppGetAllUsersSuccessState());
        });
      },).catchError((error) {
        print(error.toString());
        emit(SocialAppGetAllUsersErrorState());
      });
  }

  void sendMessage ({required String receiverId, required Timestamp dateTime, required String text,}) {

    MessageModel messageModel = MessageModel(
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );

    // set my chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialAppSendMessageSuccessState());
    })
        .catchError((error) {
      emit(SocialAppSendMessageSuccessState());
    });


    // set receiver chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialAppSendMessageSuccessState());
    })
        .catchError((error) {
      emit(SocialAppSendMessageSuccessState());
    });
  }

  List<MessageModel> messages = [];

  void getMassage({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      },);
      emit(SocialAppGetMessageSuccessState());
    },);
  }

}