import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/helpers/logging_service.dart';
import '../models/news_article_model.dart';

abstract class NewsRemoteDatasource {
  Future<List<NewsArticleModel>> getTopHeadlines({
    required int page,
    required int pageSize,
    String? category,
  });

  Future<List<NewsArticleModel>> searchNews({
    required String query,
    required int page,
    required int pageSize,
  });
}

class NewsRemoteDatasourceImpl implements NewsRemoteDatasource {
  final Dio dio;

  NewsRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<NewsArticleModel>> getTopHeadlines({
    required int page,
    required int pageSize,
    String? category,
  }) async {
    try {
      LoggingServicePrinter.log(
        '🔄 Fetching top headlines - page: $page, category: $category',
      );

      final response = await dio.get(
        ApiConstants.topHeadlines,
        queryParameters: {
          'country': 'us',
          if (category != null) 'category': category,
          'page': page,
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        final newsResponse = NewsApiResponse.fromJson(response.data);
        LoggingServicePrinter.log(
          '✅ Fetched ${newsResponse.articles?.length ?? 0} articles',
        );
        return newsResponse.articles ?? [];
      } else {
        throw ServerException('Failed to fetch news: ${response.statusCode}');
      }
    } on DioException catch (e) {
      LoggingServicePrinter.logError('❌ Dio error', error: e);
      throw ServerException(e.message ?? 'Network error occurred');
    } catch (e) {
      LoggingServicePrinter.logError('❌ Unexpected error', error: e);
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<List<NewsArticleModel>> searchNews({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    try {
      LoggingServicePrinter.log(
        '🔍 Searching news - query: $query, page: $page',
      );

      final response = await dio.get(
        ApiConstants.everything,
        queryParameters: {
          'q': query,
          'page': page,
          'pageSize': pageSize,
          'sortBy': 'publishedAt',
        },
      );

      if (response.statusCode == 200) {
        final newsResponse = NewsApiResponse.fromJson(response.data);
        LoggingServicePrinter.log(
          '✅ Found ${newsResponse.articles?.length ?? 0} articles',
        );
        return newsResponse.articles ?? [];
      } else {
        throw ServerException('Failed to search news: ${response.statusCode}');
      }
    } on DioException catch (e) {
      LoggingServicePrinter.logError('❌ Dio error', error: e);
      throw ServerException(e.message ?? 'Network error occurred');
    } catch (e) {
      LoggingServicePrinter.logError('❌ Unexpected error', error: e);
      throw ServerException('An unexpected error occurred');
    }
  }
}
