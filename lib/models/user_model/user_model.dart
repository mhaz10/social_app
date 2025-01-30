class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? cover;
  String? bio;

  UserModel({this.name, this.email, this.phone, this.uId, this.image, this.bio, this.cover});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json ['name'];
    email = json ['email'];
    phone = json ['phone'];
    uId = json ['uId'];
    image = json ['image'];
    bio = json ['bio'];
    cover = json ['cover'];
  }


  Map<String, dynamic> toMap () {
    return {
      'name' : name,
      'email' : email,
      'phone' : phone,
      'uId' : uId,
      'image' : image ?? '',
      'bio' : bio ?? '',
      'cover' : cover ?? '',
    };
  }
}