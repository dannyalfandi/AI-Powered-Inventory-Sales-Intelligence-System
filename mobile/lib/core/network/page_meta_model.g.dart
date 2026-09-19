// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageMetaModel _$PageMetaModelFromJson(Map<String, dynamic> json) =>
    _PageMetaModel(
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$PageMetaModelToJson(_PageMetaModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'page_size': instance.pageSize,
      'total': instance.total,
    };
