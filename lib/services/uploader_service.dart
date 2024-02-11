import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';

class UploaderService {
  static Future<bool> upload(File file) async {
    final dio = Dio();
    final data = FormData();
    data.fields.add(const MapEntry('token', 'abc123'));
    data.files.add(
      MapEntry(
        "dok_foto",
        await MultipartFile.fromFile(
          file.path,
          filename: basename(file.path),
        ),
      ),
    );
    try {
      final result = await dio.post(
        'http://103.47.60.30/app/contoso/api/demo/layanan/kirim_data',
        data: data,
      );
      if (result.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print(e.response);
    }
    return false;
  }
}
