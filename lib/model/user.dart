import 'package:bd_pick/const/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  late String id = '';
  late String password ='';
  late String email = '';
  late UserType type = UserType.N;
  String? createdAt;
  String? updatedAt;

  User();
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

enum KeyNamesUser {
  id,
  userId,
  userType,
  uuid
}
