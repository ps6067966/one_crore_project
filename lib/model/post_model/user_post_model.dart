class UserModel {
  int? id;
  String? userName;
  String? email;
  String? fullName;
  String? photoUrl;
  String? mobileNumber;

  UserModel({
    this.id,
    this.userName,
    this.email,
    this.fullName,
    this.photoUrl,
    this.mobileNumber,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    userName = json['user_name'] as String?;
    email = json['email'] as String?;
    fullName = json['full_name'] as String?;
    photoUrl = json['photo_url'] as String?;
    mobileNumber = json['mobile_number'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['user_name'] = userName;
    json['email'] = email;
    json['full_name'] = fullName;
    json['photo_url'] = photoUrl;
    json['mobile_number'] = mobileNumber;
    return json;
  }
}
