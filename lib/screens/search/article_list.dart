import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:echo_flutter_news/models/response.dart';
import 'package:echo_flutter_news/screens/articles/article_list_item.dart';
import 'package:echo_flutter_news/models/article.dart';
import 'package:echo_flutter_news/services/news_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final _newsApi = NewsAPI(dotenv.env['API_KEY']!);

class ArticleListBuilder extends StatefulWidget {
  const ArticleListBuilder({
    super.key,
    required this.loadedArticles,
    this.selectedCategory,
    required this.searchQuery,
    required this.selectedSortBy,
  });

  final List<Article> loadedArticles;
  final String? selectedCategory;
  final String searchQuery;
  final String selectedSortBy;

  @override
  State<ArticleListBuilder> createState() => _ArticleListBuilderState();
}

class _ArticleListBuilderState extends State<ArticleListBuilder> {
  final _scrollController = ScrollController();

  final pageSize = 10;
  int _currentPage = 0;
  ResponseModel? _responseData;
  bool _isLoading = false;
  List<Article> _loadedArticles = []; // Local mutable list

  @override
  void initState() {
    super.initState();
    _loadedArticles =
        List.from(widget.loadedArticles); // Initialize with passed data
    _getArticles().then((_) {
      _scrollController.addListener(_loadMoreData);
    });
  }

  @override
  void didUpdateWidget(covariant ArticleListBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset state if important parameters change
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.selectedCategory != widget.selectedCategory ||
        oldWidget.selectedSortBy != widget.selectedSortBy) {
      setState(() {
        _currentPage = 0;
        _loadedArticles = [];
      });
      _getArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    // No response from API yet
    if (_responseData == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

    // Error response from API
    if (_responseData!.status == "error") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_responseData!.message!),
          TextButton(
            onPressed: _getArticles,
            child: const Text("Retry"),
          ),
        ],
      );
    }

    // No articles found
    if (_responseData!.status == "ok" && _responseData!.totalResults == 0) {
      return const Center(
        child: Text("No articles found"),
      );
    }

    // Articles found
    return ListView.builder(
      itemCount: _loadedArticles.length,
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: false,
      controller: _scrollController,
      itemBuilder: (context, index) {
        final article = _loadedArticles[index];

        return Column(
          children: [
            ArticleListItem(article: article),
            if (index == _loadedArticles.length - 1 && _isLoading)
              const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SpinKitThreeBounce(
                    color: Colors.blue,
                    size: 20.0,
                  )),
          ],
        );
      },
    );
  }

  void _loadMoreData() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _responseData != null &&
        _loadedArticles.length < _responseData!.totalResults!) {
      setState(() {
        _isLoading = true;
      });
      _getArticles();
    }
  }

  Future<void> _getArticles() async {
    _currentPage++;
    final responseModel = await _newsApi.getArticles(
      sortBy: widget.selectedSortBy,
      query: widget.searchQuery,
      category: widget.selectedCategory,
      pageSize: pageSize,
      page: _currentPage,
    );

    if (responseModel.status != "ok") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseModel.message!),
        ),
      );
      setState(() {
        _loadedArticles.clear();
        _responseData = responseModel;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _loadedArticles.addAll(responseModel.articles!);
      _responseData = responseModel;
      _isLoading = false;
    });
  }
}
