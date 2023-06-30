import 'package:json_annotation/json_annotation.dart';

part 'shop.g.dart';

@JsonSerializable(includeIfNull: false)
class Shop {
  int? id;
  String? userId;
  String registNumber = '';
  String name = '';
  String ownerName = '';
  String type = '';
  String tel = '';

  int? addressId;
  String addressFullName = '';
  String addressName = '';
  String? createdAt;
  String? updatedAt;
  // Address? address;

  Shop();

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  Map<String, dynamic> toJson() => _$ShopToJson(this);
}

enum KeyNamesShop {
  id,
  userId,
  registNumber,
  name,
  ownerName,
  type,
  tel,
  addressFullName,
  addressName,
}
