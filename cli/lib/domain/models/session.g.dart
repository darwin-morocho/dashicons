// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Session _$$_SessionFromJson(Map<String, dynamic> json) => _$_Session(
      idToken: json['idToken'] as String,
      apiKey: json['apiKey'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as String,
    );

Map<String, dynamic> _$$_SessionToJson(_$_Session instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'apiKey': instance.apiKey,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };
