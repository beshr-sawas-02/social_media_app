class UserModel {
  final String username;
  final String email;
  final String phone;
  final String uid;
  final String image;

  UserModel({
      required this.username,
      required this.email,
      required this.phone,
      required this.uid,
      required this.image
  });

 factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
        username: json ['username'],
        email: json['email'],
        phone: json['phone'],
        uid: json['uid'],
        image: json['image']
    );
  }


  Map<String,dynamic> toJson() {
    return {
      "username":username,
      "email":email,
      "phone":phone,
      "uid":uid,
      "image":image,
    };
  }


}
