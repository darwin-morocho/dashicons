// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackageImpl _$$PackageImplFromJson(Map<String, dynamic> json) =>
    _$PackageImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      fontFamily: json['fontFamily'] as String,
      fontPackage: json['fontPackage'] as String?,
      lastId: json['lastId'] as int,
      icons: (json['icons'] as List<dynamic>)
          .map((e) => SvgIcon.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PackageImplToJson(_$PackageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fontFamily': instance.fontFamily,
      'fontPackage': instance.fontPackage,
      'lastId': instance.lastId,
      'icons': _iconsToJsonList(instance.icons),
    };
