import 'package:echo_flutter_news/models/article.dart';

class ResponseModel {
  final String status;
  final int? totalResults;
  final List<Article>? articles;
  final String? code;
  final String? message;

  ResponseModel(
      this.status, this.totalResults, this.articles, this.code, this.message);

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      json["status"].toString(),
      json["totalResults"],
      Article.parseList(json["articles"] ?? []),
      json["code"],
      json["message"],
    );
  }
}
