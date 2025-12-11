import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fusion_news_weather_app/features/news/presentation/cubits/news_cubit.dart';
import 'package:fusion_news_weather_app/features/news/presentation/cubits/news_states.dart';
import '../../domain/entities/news_article_entity.dart';
import 'news_details_page.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String? _selectedCategory;

  final List<String> _categories = [
    'all',
    'technology',
    'business',
    'sports',
    'entertainment',
    'health',
    'science',
  ];

  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().fetchTopHeadlines();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<NewsCubit>().loadMore();
    }
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category == 'all' ? null : category;
    });
    context.read<NewsCubit>().fetchTopHeadlines(category: _selectedCategory);
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      context.read<NewsCubit>().fetchTopHeadlines(category: _selectedCategory);
    } else {
      context.read<NewsCubit>().searchNews(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('news'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<NewsCubit>().refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'search_news'.tr(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
              ),
              onSubmitted: _onSearch,
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Category filters
          SizedBox(
            height: 50.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = (category == 'all' && _selectedCategory == null) ||
                    category == _selectedCategory;

                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: FilterChip(
                    label: Text(category.tr()),
                    selected: isSelected,
                    onSelected: (_) => _onCategorySelected(category),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 8.h),

          // News list
          Expanded(
            child: BlocBuilder<NewsCubit, NewsStates>(
              builder: (context, state) {
                return state.when(
                  initial: () => Center(child: Text('welcome'.tr())),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  loadingMore: () => _buildNewsList(
                    context.read<NewsCubit>(),
                    isLoadingMore: true,
                  ),
                  success: (articles, hasMore, isOffline) {
                    if (articles.isEmpty) {
                      return Center(child: Text('no_news_found'.tr()));
                    }

                    return Column(
                      children: [
                        if (isOffline)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8.h),
                            color: Colors.orange,
                            child: Text(
                              'offline_mode'.tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => context.read<NewsCubit>().refresh(),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: articles.length + (hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= articles.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                return _NewsCard(article: articles[index]);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(message),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () => context.read<NewsCubit>().refresh(),
                          child: Text('retry'.tr()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList(NewsCubit cubit, {bool isLoadingMore = false}) {
    // This is a placeholder for loadingMore state
    return const Center(child: CircularProgressIndicator());
  }
}

class _NewsCard extends StatelessWidget {
  final NewsArticleEntity article;

  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetailsPage(article: article),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.urlToImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage!,
                    width: 100.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, _, _) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    if (article.sourceName != null)
                      Text(
                        article.sourceName!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat.yMMMd().format(article.publishedAt),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
