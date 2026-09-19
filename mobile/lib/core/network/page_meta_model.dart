import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_meta_model.freezed.dart';
part 'page_meta_model.g.dart';

/// `meta` object of paginated backend responses (backend pkg/response.PageMeta):
/// `{"page": 1, "page_size": 20, "total": 42}`.
@freezed
abstract class PageMetaModel with _$PageMetaModel {
  const factory PageMetaModel({
    required int page,
    required int pageSize,
    required int total,
  }) = _PageMetaModel;

  factory PageMetaModel.fromJson(Map<String, dynamic> json) => _$PageMetaModelFromJson(json);
}
