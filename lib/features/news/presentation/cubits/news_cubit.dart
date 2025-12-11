import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/logging_service.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/news_article_entity.dart';
import '../../domain/usecases/get_cached_news_usecase.dart';
import '../../domain/usecases/get_top_headlines_usecase.dart';
import '../../domain/usecases/search_news_usecase.dart';
import 'news_states.dart';

class NewsCubit extends Cubit<NewsStates> {
  final GetTopHeadlinesUsecase getTopHeadlinesUsecase;
  final SearchNewsUsecase searchNewsUsecase;
  final GetCachedNewsUsecase getCachedNewsUsecase;
  final NetworkInfo networkInfo;

  NewsCubit({
    required this.getTopHeadlinesUsecase,
    required this.searchNewsUsecase,
    required this.getCachedNewsUsecase,
    required this.networkInfo,
  }) : super(const NewsStates.initial());

  List<NewsArticleEntity> _currentArticles = [];
  int _currentPage = 1;
  String? _currentCategory;
  String? _currentSearchQuery;
  bool _isSearchMode = false;

  Future<void> fetchTopHeadlines({String? category}) async {
    emit(const NewsStates.loading());
    _currentPage = 1;
    _currentCategory = category;
    _currentSearchQuery = null;
    _isSearchMode = false;

    LoggingServicePrinter.log(
      '🔄 Cubit: Fetching top headlines - category: $category',
    );

    final isConnected = await networkInfo.isConnected;

    final result = await getTopHeadlinesUsecase(
      TopHeadlinesParams(
        page: _currentPage,
        pageSize: AppConstants.newsPageSize,
        category: category,
      ),
    );

    result.fold(
      (failure) {
        LoggingServicePrinter.log('❌ Cubit: Failed - ${failure.message}');
        emit(NewsStates.error(message: failure.message));
      },
      (articles) {
        _currentArticles = articles;
        LoggingServicePrinter.log('✅ Cubit: Success - ${articles.length} articles');
        emit(NewsStates.success(
          articles,
          hasMore: articles.length >= AppConstants.newsPageSize,
          isOffline: !isConnected,
        ));
      },
    );
  }

  Future<void> searchNews(String query) async {
    if (query.trim().isEmpty) {
      fetchTopHeadlines();
      return;
    }

    emit(const NewsStates.loading());
    _currentPage = 1;
    _currentSearchQuery = query;
    _currentCategory = null;
    _isSearchMode = true;

    LoggingServicePrinter.log('🔍 Cubit: Searching - query: $query');

    final result = await searchNewsUsecase(
      SearchNewsParams(
        query: query,
        page: _currentPage,
        pageSize: AppConstants.newsPageSize,
      ),
    );

    result.fold(
      (failure) {
        LoggingServicePrinter.log('❌ Cubit: Search failed - ${failure.message}');
        emit(NewsStates.error(message: failure.message));
      },
      (articles) {
        _currentArticles = articles;
        LoggingServicePrinter.log('✅ Cubit: Found ${articles.length} articles');
        emit(NewsStates.success(
          articles,
          hasMore: articles.length >= AppConstants.newsPageSize,
          isOffline: false,
        ));
      },
    );
  }

  Future<void> loadMore() async {
    if (state is! Success) return;

    final currentState = state as Success;
    if (!currentState.hasMore) return;

    emit(const NewsStates.loadingMore());
    _currentPage++;

    LoggingServicePrinter.log('🔄 Cubit: Loading more - page: $_currentPage');

    final result = _isSearchMode && _currentSearchQuery != null
        ? await searchNewsUsecase(
            SearchNewsParams(
              query: _currentSearchQuery!,
              page: _currentPage,
              pageSize: AppConstants.newsPageSize,
            ),
          )
        : await getTopHeadlinesUsecase(
            TopHeadlinesParams(
              page: _currentPage,
              pageSize: AppConstants.newsPageSize,
              category: _currentCategory,
            ),
          );

    result.fold(
      (failure) {
        _currentPage--; // Revert page increment
        emit(NewsStates.success(
          _currentArticles,
          hasMore: true,
          isOffline: currentState.isOffline,
        ));
      },
      (newArticles) {
        _currentArticles.addAll(newArticles);
        emit(NewsStates.success(
          _currentArticles,
          hasMore: newArticles.length >= AppConstants.newsPageSize,
          isOffline: currentState.isOffline,
        ));
      },
    );
  }

  Future<void> refresh() async {
    if (_isSearchMode && _currentSearchQuery != null) {
      await searchNews(_currentSearchQuery!);
    } else {
      await fetchTopHeadlines(category: _currentCategory);
    }
  }

  void resetState() {
    _currentArticles = [];
    _currentPage = 1;
    _currentCategory = null;
    _currentSearchQuery = null;
    _isSearchMode = false;
    emit(const NewsStates.initial());
  }
}
