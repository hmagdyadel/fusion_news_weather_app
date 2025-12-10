import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/news_article_entity.dart';
import '../repositories/news_repo.dart';

class SearchNewsUsecase
    implements UseCase<List<NewsArticleEntity>, SearchNewsParams> {
  final NewsRepo repository;

  SearchNewsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<NewsArticleEntity>>> call(
    SearchNewsParams params,
  ) async {
    return await repository.searchNews(
      query: params.query,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class SearchNewsParams extends Equatable {
  final String query;
  final int page;
  final int pageSize;

  const SearchNewsParams({
    required this.query,
    required this.page,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [query, page, pageSize];
}
