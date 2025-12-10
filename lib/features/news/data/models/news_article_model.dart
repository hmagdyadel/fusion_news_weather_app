import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/news_article_entity.dart';

part 'news_article_model.g.dart';

@JsonSerializable()
class NewsArticleModel {
  final String? title;
  final String? description;
  final String? url;
  @JsonKey(name: 'urlToImage')
  final String? urlToImage;
  final SourceModel? source;
  final String? author;
  @JsonKey(name: 'publishedAt')
  final String? publishedAt;

  NewsArticleModel({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.source,
    this.author,
    this.publishedAt,
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsArticleModelToJson(this);

  // Convert from database map
  factory NewsArticleModel.fromMap(Map<String, dynamic> map) {
    return NewsArticleModel(
      title: map['title'] as String?,
      description: map['description'] as String?,
      url: map['url'] as String,
      urlToImage: map['url_to_image'] as String?,
      source: map['source_name'] != null
          ? SourceModel(name: map['source_name'] as String)
          : null,
      author: map['author'] as String?,
      publishedAt: map['published_at'] as String,
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap({String? category}) {
    final id = url?.hashCode.toString() ?? DateTime.now().toString();
    return {
      'id': id,
      'title': title ?? '',
      'description': description,
      'url': url ?? '',
      'url_to_image': urlToImage,
      'source_name': source?.name,
      'author': author,
      'published_at': publishedAt ?? DateTime.now().toIso8601String(),
      'category': category,
      'cached_at': DateTime.now().toIso8601String(),
    };
  }

  // Convert to entity
  NewsArticleEntity toEntity() {
    return NewsArticleEntity(
      id: url?.hashCode.toString() ?? DateTime.now().toString(),
      title: title ?? 'No Title',
      description: description,
      url: url ?? '',
      urlToImage: urlToImage,
      sourceName: source?.name,
      author: author,
      publishedAt: publishedAt != null
          ? DateTime.parse(publishedAt!)
          : DateTime.now(),
      category: null,
    );
  }
}

@JsonSerializable()
class SourceModel {
  final String? id;
  final String? name;

  SourceModel({this.id, this.name});

  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      _$SourceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SourceModelToJson(this);
}

@JsonSerializable()
class NewsApiResponse {
  final String? status;
  final int? totalResults;
  final List<NewsArticleModel>? articles;

  NewsApiResponse({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory NewsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NewsApiResponseToJson(this);
}
