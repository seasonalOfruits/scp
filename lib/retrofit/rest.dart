import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';


part 'rest.g.dart';


@RestApi(baseUrl: 'https://hacker-news.firebaseio.com/v0')
abstract class RestClient {


  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/topstories.json')
  Future<List<int>> getTopNews();

}

@JsonSerializable()
class News {
  int id;
  String title;
  String type;
  String url;

  News({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
  });

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}