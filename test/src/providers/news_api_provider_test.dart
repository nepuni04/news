import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:http/testing.dart';
import 'dart:convert';
import 'package:news/src/resources/news_api_provider.dart';

void main() {
  test('FetchTopIds returns a list of IDs', () async {
    final newsApi = NewsApiProvider();

    newsApi.client = MockClient((Request request) async {
      return Response(json.encode([1,2,3,4,5]), 200);
    });

    final ids = await newsApi.fetchTopIds();

    expect(ids, [1,2,3,4,5]);
  });

  test("FetchItem should return an item", () async {
    final newsApi = NewsApiProvider();
    
    newsApi.client = MockClient((Request request) async {
      final jsonMap = { 'id': 123 };
      return Response(jsonEncode(jsonMap), 200);
    });

    final item = await newsApi.fetchItem(999);
    expect(item.id, 123);
  });
}