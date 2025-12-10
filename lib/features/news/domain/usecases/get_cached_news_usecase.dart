import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/news_article_entity.dart';
import '../repositories/news_repo.dart';

class GetCachedNewsUsecase
    implements UseCase<List<NewsArticleEntity>, NoParams> {
  final NewsRepo repository;

  GetCachedNewsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<NewsArticleEntity>>> call(NoParams params) async {
    return await repository.getCachedNews();
  }
}
