import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/news_article_entity.dart';

part 'news_states.freezed.dart';

@Freezed()
class NewsStates<T> with _$NewsStates<T> {
  const factory NewsStates.initial() = Initial;
  const factory NewsStates.loading() = Loading;
  const factory NewsStates.loadingMore() = LoadingMore;
  const factory NewsStates.success(List<NewsArticleEntity> articles, {
    required bool hasMore,
    required bool isOffline,
  }) = Success<T>;
  const factory NewsStates.error({required String message}) = Error;
}
