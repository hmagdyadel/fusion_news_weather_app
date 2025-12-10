import 'package:equatable/equatable.dart';

class NewsArticleEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final String? sourceName;
  final String? author;
  final DateTime publishedAt;
  final String? category;

  const NewsArticleEntity({
    required this.id,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.sourceName,
    this.author,
    required this.publishedAt,
    this.category,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        url,
        urlToImage,
        sourceName,
        author,
        publishedAt,
        category,
      ];
}
