import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/helpers/logging_service.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/news_article_entity.dart';
import '../../domain/repositories/news_repo.dart';
import '../datasources/news_local_datasource.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepoImpl implements NewsRepo {
  final NewsRemoteDatasource remoteDatasource;
  final NewsLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  NewsRepoImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NewsArticleEntity>>> getTopHeadlines({
    required int page,
    required int pageSize,
    String? category,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final articles = await remoteDatasource.getTopHeadlines(
          page: page,
          pageSize: pageSize,
          category: category,
        );

        // Cache the articles
        await localDatasource.cacheArticles(articles, category: category);

        return Right(articles.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        LoggingServicePrinter.log('❌ News Repo: Server error - ${e.message}');
        return Left(ServerFailure(e.message));
      } catch (e) {
        LoggingServicePrinter.log('❌ News Repo: Unexpected error - $e');
        return Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      // Offline: return cached data
      try {
        final cachedArticles = await localDatasource.getCachedArticles();
        return Right(cachedArticles.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<NewsArticleEntity>>> searchNews({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return const Left(
        NetworkFailure('No internet connection. Search is not available offline.'),
      );
    }

    try {
      final articles = await remoteDatasource.searchNews(
        query: query,
        page: page,
        pageSize: pageSize,
      );

      return Right(articles.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      LoggingServicePrinter.log('❌ News Repo: Search error - ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      LoggingServicePrinter.log('❌ News Repo: Unexpected error - $e');
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<NewsArticleEntity>>> getCachedNews() async {
    try {
      final cachedArticles = await localDatasource.getCachedArticles();
      return Right(cachedArticles.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
