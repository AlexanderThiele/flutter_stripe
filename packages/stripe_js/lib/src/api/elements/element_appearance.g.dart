// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'element_appearance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ElementAppearance _$$_ElementAppearanceFromJson(Map json) =>
    _$_ElementAppearance(
      theme: $enumDecodeNullable(_$ElementThemeEnumMap, json['theme']) ??
          ElementTheme.stripe,
      variables: (json['variables'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      rules: (json['rules'] as Map?)?.map(
        (k, e) => MapEntry(k as String, Map<String, String>.from(e as Map)),
      ),
      label: json['label'] ?? ElementAppearanceLabel.above,
    );

Map<String, dynamic> _$$_ElementAppearanceToJson(
    _$_ElementAppearance instance) {
  final val = <String, dynamic>{
    'theme': _$ElementThemeEnumMap[instance.theme]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('variables', instance.variables);
  writeNotNull('rules', instance.rules);
  writeNotNull('label', instance.label);
  return val;
}

const _$ElementThemeEnumMap = {
  ElementTheme.stripe: 'stripe',
  ElementTheme.night: 'night',
  ElementTheme.flat: 'flat',
  ElementTheme.none: 'none',
};
