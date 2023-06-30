// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['id'] as String
  ..password = json['password'] as String
  ..email = json['email'] as String
  ..type = $enumDecode(_$UserTypeEnumMap, json['type'])
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'password': instance.password,
      'email': instance.email,
      'type': _$UserTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$UserTypeEnumMap = {
  UserType.N: 'N',
  UserType.O: 'O',
};
