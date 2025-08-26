import 'package:json_annotation/json_annotation.dart';

part 'tooltip_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TooltipModel {
  @JsonKey(name: 'Element_000')
  final TooltipElement? element000;

  @JsonKey(name: 'Element_001')
  final TooltipElement? element001;

  @JsonKey(name: 'Element_002')
  final TooltipElement? element002;

  @JsonKey(name: 'Element_003')
  final TooltipElement? element003;

  @JsonKey(name: 'Element_004')
  final TooltipElement? element004;

  @JsonKey(name: 'Element_005')
  final TooltipElement? element005;

  @JsonKey(name: 'Element_006')
  final TooltipElement? element006;

  @JsonKey(name: 'Element_007')
  final TooltipElement? element007;

  @JsonKey(name: 'Element_008')
  final TooltipElement? element008;

  @JsonKey(name: 'Element_009')
  final TooltipElement? element009;

  @JsonKey(name: 'Element_010')
  final TooltipElement? element010;

  @JsonKey(name: 'Element_011')
  final TooltipElement? element011;

  @JsonKey(name: 'Element_012')
  final TooltipElement? element012;

  @JsonKey(name: 'Element_013')
  final TooltipElement? element013;

  @JsonKey(name: 'Element_014')
  final TooltipElement? element014;

  @JsonKey(name: 'Element_015')
  final TooltipElement? element015;

  @JsonKey(name: 'Element_016')
  final TooltipElement? element016;

  TooltipModel({
    this.element000,
    this.element001,
    this.element002,
    this.element003,
    this.element004,
    this.element005,
    this.element006,
    this.element007,
    this.element008,
    this.element009,
    this.element010,
    this.element011,
    this.element012,
    this.element013,
    this.element014,
    this.element015,
    this.element016,
  });

  factory TooltipModel.fromJson(Map<String, dynamic> json) =>
      _$TooltipModelFromJson(json);

  Map<String, dynamic> toJson() => _$TooltipModelToJson(this);
}

@JsonSerializable()
class TooltipElement {
  final String? type;
  final dynamic value;

  TooltipElement({
    this.type,
    this.value,
  });

  factory TooltipElement.fromJson(Map<String, dynamic> json) =>
      _$TooltipElementFromJson(json);

  Map<String, dynamic> toJson() => _$TooltipElementToJson(this);

  /// HTML 태그 제거 후 텍스트만 반환
  String? get plainText {
    if (value is String) {
      return (value as String).replaceAll(RegExp(r'<[^>]*>'), '');
    }
    return null;
  }

  /// +숫자 강화 수치 추출
  String? get enhancementLevel {
    final text = plainText;
    if (text == null) return null;
    final match = RegExp(r'\+(\d+)').firstMatch(text);
    return match?.group(0); // "+20" 형태로 반환
  }
}
