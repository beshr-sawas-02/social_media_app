class UserModel {
  final String username;
  final String email;
  final String phone;
  final String uid;
  final String image;
  final String bio;
  final String coverImage;

  UserModel({
    required this.username,
    required this.email,
    required this.phone,
    required this.uid,
    required this.image,
    this.bio = '',
    this.coverImage = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      uid: json['uid']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "phone": phone,
      "uid": uid,
      "image": image,
      "bio": bio,
      "coverImage": coverImage,
    };
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? phone,
    String? uid,
    String? image,
    String? bio,
    String? coverImage,
  }) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      uid: uid ?? this.uid,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      coverImage: coverImage ?? this.coverImage,
    );
  }
}
