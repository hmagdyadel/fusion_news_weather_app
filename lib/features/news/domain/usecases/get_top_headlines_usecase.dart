import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/news_article_entity.dart';
import '../repositories/news_repo.dart';

class GetTopHeadlinesUsecase
    implements UseCase<List<NewsArticleEntity>, TopHeadlinesParams> {
  final NewsRepo repository;

  GetTopHeadlinesUsecase({required this.repository});

  @override
  Future<Either<Failure, List<NewsArticleEntity>>> call(
    TopHeadlinesParams params,
  ) async {
    return await repository.getTopHeadlines(
      page: params.page,
      pageSize: params.pageSize,
      category: params.category,
    );
  }
}

class TopHeadlinesParams extends Equatable {
  final int page;
  final int pageSize;
  final String? category;

  const TopHeadlinesParams({
    required this.page,
    required this.pageSize,
    this.category,
  });

  @override
  List<Object?> get props => [page, pageSize, category];
}
