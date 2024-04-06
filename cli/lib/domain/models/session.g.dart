// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      idToken: json['idToken'] as String,
      apiKey: json['apiKey'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as String,
    );

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'apiKey': instance.apiKey,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };
