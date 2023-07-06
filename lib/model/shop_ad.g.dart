// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_ad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopAd _$ShopAdFromJson(Map<String, dynamic> json) => ShopAd()
  ..id = json['id'] as int?
  ..shopId = json['shopId'] as int?
  ..branchName = json['branchName'] as String
  ..startedAt = DateTime.parse(json['startedAt'] as String)
  ..endedAt = DateTime.parse(json['endedAt'] as String)
  ..content = json['content'] as String
  ..keywordList =
      (json['keywordList'] as List<dynamic>).map((e) => e as String).toList()
  ..createdAt = json['createdAt'] as String?
  ..updatedAt = json['updatedAt'] as String?;

Map<String, dynamic> _$ShopAdToJson(ShopAd instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('shopId', instance.shopId);
  val['branchName'] = instance.branchName;
  val['startedAt'] = instance.startedAt.toIso8601String();
  val['endedAt'] = instance.endedAt.toIso8601String();
  val['content'] = instance.content;
  val['keywordList'] = instance.keywordList;
  writeNotNull('createdAt', instance.createdAt);
  writeNotNull('updatedAt', instance.updatedAt);
  return val;
}
