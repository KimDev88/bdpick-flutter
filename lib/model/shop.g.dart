// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shop _$ShopFromJson(Map<String, dynamic> json) => Shop()
  ..id = json['id'] as int?
  ..userId = json['userId'] as String?
  ..registNumber = json['registNumber'] as String
  ..name = json['name'] as String
  ..ownerName = json['ownerName'] as String
  ..type = json['type'] as String
  ..tel = json['tel'] as String
  ..addressId = json['addressId'] as int?
  ..addressFullName = json['addressFullName'] as String
  ..addressName = json['addressName'] as String
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?;

Map<String, dynamic> _$ShopToJson(Shop instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('userId', instance.userId);
  val['registNumber'] = instance.registNumber;
  val['name'] = instance.name;
  val['ownerName'] = instance.ownerName;
  val['type'] = instance.type;
  val['tel'] = instance.tel;
  writeNotNull('addressId', instance.addressId);
  val['addressFullName'] = instance.addressFullName;
  val['addressName'] = instance.addressName;
  writeNotNull('createdAt', instance.createdAt);
  writeNotNull('updatedAt', instance.updatedAt);
  return val;
}
