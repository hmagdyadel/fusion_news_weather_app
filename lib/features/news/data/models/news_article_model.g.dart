// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsArticleModel _$NewsArticleModelFromJson(Map<String, dynamic> json) =>
    NewsArticleModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      source: json['source'] == null
          ? null
          : SourceModel.fromJson(json['source'] as Map<String, dynamic>),
      author: json['author'] as String?,
      publishedAt: json['publishedAt'] as String?,
    );

Map<String, dynamic> _$NewsArticleModelToJson(NewsArticleModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'urlToImage': instance.urlToImage,
      'source': instance.source,
      'author': instance.author,
      'publishedAt': instance.publishedAt,
    };

SourceModel _$SourceModelFromJson(Map<String, dynamic> json) =>
    SourceModel(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$SourceModelToJson(SourceModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

NewsApiResponse _$NewsApiResponseFromJson(Map<String, dynamic> json) =>
    NewsApiResponse(
      status: json['status'] as String?,
      totalResults: (json['totalResults'] as num?)?.toInt(),
      articles: (json['articles'] as List<dynamic>?)
          ?.map((e) => NewsArticleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NewsApiResponseToJson(NewsApiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'totalResults': instance.totalResults,
      'articles': instance.articles,
    };
