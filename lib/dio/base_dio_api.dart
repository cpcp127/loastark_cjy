import 'package:cjylostark/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<BaseDioApi>((ref) {
  return BaseDioApi();
});

final baseUrl = 'https://developer-lostark.game.onstove.com';

class BaseDioApi {
  final BaseOptions options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(milliseconds: 10000),
    sendTimeout: const Duration(milliseconds: 10000),
    receiveTimeout: const Duration(milliseconds: 10000),
    headers: {
      'authorization': 'bearer $stoveApiKey',
    },
    contentType: 'application/json; charset=utf-8',
    responseType: ResponseType.json,
  );
  Dio dio = Dio();

  BaseDioApi({Dio? dio}){
    if (dio != null) {
      this.dio = dio;
    } else {
      this.dio = Dio(options);
    }
  }
}
