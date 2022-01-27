// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_novel_categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelCategories _$NovelCategoriesFromJson(Map<String, dynamic> json) =>
    NovelCategories(
      (json['male'] as List<dynamic>)
          .map((e) => Male.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['female'] as List<dynamic>)
          .map((e) => Female.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['picture'] as List<dynamic>)
          .map((e) => Picture.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['press'] as List<dynamic>)
          .map((e) => Press.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['ok'] as bool,
    );

Map<String, dynamic> _$NovelCategoriesToJson(NovelCategories instance) =>
    <String, dynamic>{
      'male': instance.male,
      'female': instance.female,
      'picture': instance.picture,
      'press': instance.press,
      'ok': instance.ok,
    };

Male _$MaleFromJson(Map<String, dynamic> json) => Male(
      json['name'] as String,
      json['bookCount'] as int,
      json['monthlyCount'] as int,
      json['icon'] as String,
      (json['bookCover'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MaleToJson(Male instance) => <String, dynamic>{
      'name': instance.name,
      'bookCount': instance.bookCount,
      'monthlyCount': instance.monthlyCount,
      'icon': instance.icon,
      'bookCover': instance.bookCover,
    };

Female _$FemaleFromJson(Map<String, dynamic> json) => Female(
      json['name'] as String,
      json['bookCount'] as int,
      json['monthlyCount'] as int,
      json['icon'] as String,
      (json['bookCover'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FemaleToJson(Female instance) => <String, dynamic>{
      'name': instance.name,
      'bookCount': instance.bookCount,
      'monthlyCount': instance.monthlyCount,
      'icon': instance.icon,
      'bookCover': instance.bookCover,
    };

Picture _$PictureFromJson(Map<String, dynamic> json) => Picture(
      json['name'] as String,
      json['bookCount'] as int,
      json['monthlyCount'] as int,
      json['icon'] as String,
      (json['bookCover'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PictureToJson(Picture instance) => <String, dynamic>{
      'name': instance.name,
      'bookCount': instance.bookCount,
      'monthlyCount': instance.monthlyCount,
      'icon': instance.icon,
      'bookCover': instance.bookCover,
    };

Press _$PressFromJson(Map<String, dynamic> json) => Press(
      json['name'] as String,
      json['bookCount'] as int,
      json['monthlyCount'] as int,
      json['icon'] as String,
      (json['bookCover'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PressToJson(Press instance) => <String, dynamic>{
      'name': instance.name,
      'bookCount': instance.bookCount,
      'monthlyCount': instance.monthlyCount,
      'icon': instance.icon,
      'bookCover': instance.bookCover,
    };
