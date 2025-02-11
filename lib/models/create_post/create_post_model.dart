class CreatePostModel {
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? postText;
  String? postImage;

  CreatePostModel({this.name, this.uId, this.image, this.dateTime, this.postText, this.postImage,});

  CreatePostModel.fromJson(Map<String, dynamic> json) {
    name = json ['name'];
    uId = json ['uId'];
    image = json ['image'];
    dateTime = json ['dateTime'];
    postText = json ['postText'];
    postImage = json ['postImage'];
  }


  Map<String, dynamic> toMap () {
    return {
      'name' : name,
      'uId' : uId,
      'image' : image,
      'dateTime' : dateTime,
      'postText' : postText,
      'postImage' : postImage,
    };
  }
}