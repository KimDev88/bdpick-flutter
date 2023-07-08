import 'package:json_annotation/json_annotation.dart';

part 'shop_ad.g.dart';

@JsonSerializable(includeIfNull: false)
class ShopAd {
  int? id;
  int? shopId;
  late String branchName;
  late DateTime startedAt;
  late DateTime endedAt;
  late String content;
  String? createdAt;
  String? updatedAt;
  late List<String> keywordList = List.empty();
  String? keywords;
  String? fileUri;

  ShopAd();

  factory ShopAd.fromJson(Map<String, dynamic> json) => _$ShopAdFromJson(json);

  Map<String, dynamic> toJson() => _$ShopAdToJson(this);
}

enum KeyNamesShopAd {
  id,
  branchName,
  startedAt,
  endedAt,
  content,
  keywordList,
  keyword,
  // userId,
  // userType,
  // uuid
}
