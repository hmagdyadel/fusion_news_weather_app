import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../domain/entities/news_article_entity.dart';

class NewsDetailsPage extends StatefulWidget {
  final NewsArticleEntity article;

  const NewsDetailsPage({super.key, required this.article});

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.article.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('read_full_article'.tr()),
      ),
      body: Column(
        children: [
          // Article info
          Container(
            padding: EdgeInsets.all(16.w),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.article.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    if (widget.article.author != null) ...[
                      Icon(Icons.person, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        widget.article.author!,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      SizedBox(width: 16.w),
                    ],
                    Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      DateFormat.yMMMd().add_jm().format(widget.article.publishedAt),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
                if (widget.article.sourceName != null) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.source, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        widget.article.sourceName!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),

          // WebView
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
