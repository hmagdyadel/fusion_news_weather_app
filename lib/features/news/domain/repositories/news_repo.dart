import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/news_article_entity.dart';

abstract class NewsRepo {
  Future<Either<Failure, List<NewsArticleEntity>>> getTopHeadlines({
    required int page,
    required int pageSize,
    String? category,
  });

  Future<Either<Failure, List<NewsArticleEntity>>> searchNews({
    required String query,
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, List<NewsArticleEntity>>> getCachedNews();
}
