import 'package:sqflite/sqflite.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/helpers/logging_service.dart';
import '../../../../core/services/database_service.dart';
import '../models/news_article_model.dart';

abstract class NewsLocalDatasource {
  Future<void> cacheArticles(List<NewsArticleModel> articles, {String? category});
  Future<List<NewsArticleModel>> getCachedArticles();
  Future<void> clearCache();
}

class NewsLocalDatasourceImpl implements NewsLocalDatasource {
  @override
  Future<void> cacheArticles(
    List<NewsArticleModel> articles, {
    String? category,
  }) async {
    try {
      final db = await DatabaseService.database;

      await db.transaction((txn) async {
        for (final article in articles) {
          await txn.insert(
            'news_articles',
            article.toMap(category: category),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      LoggingServicePrinter.log('✅ Cached ${articles.length} articles');
    } catch (e) {
      LoggingServicePrinter.logError('❌ Failed to cache articles', error: e);
      throw CacheException('Failed to cache articles');
    }
  }

  @override
  Future<List<NewsArticleModel>> getCachedArticles() async {
    try {
      final db = await DatabaseService.database;

      final List<Map<String, dynamic>> maps = await db.query(
        'news_articles',
        orderBy: 'published_at DESC',
        limit: 100,
      );

      LoggingServicePrinter.log('✅ Retrieved ${maps.length} cached articles');

      return maps.map((map) => NewsArticleModel.fromMap(map)).toList();
    } catch (e) {
      LoggingServicePrinter.logError('❌ Failed to get cached articles', error: e);
      throw CacheException('Failed to retrieve cached articles');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final db = await DatabaseService.database;
      await db.delete('news_articles');
      LoggingServicePrinter.log('✅ News cache cleared');
    } catch (e) {
      LoggingServicePrinter.logError('❌ Failed to clear cache', error: e);
      throw CacheException('Failed to clear cache');
    }
  }
}
