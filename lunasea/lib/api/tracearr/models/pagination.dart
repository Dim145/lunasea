import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable()
class TracearrPaginationMeta {
  final int total;
  final int page;
  final int pageSize;

  const TracearrPaginationMeta({
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory TracearrPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$TracearrPaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$TracearrPaginationMetaToJson(this);
}
