import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExcelExportService {
  /// Generates an Excel file with the given [sheetName], [headers], and [data].
  Uint8List? generateExcel({
    required String sheetName,
    required List<String> headers,
    required List<List<dynamic>> data,
  }) {
    try {
      var excel = Excel.createExcel();
      var sheet = excel[sheetName];

      // Add headers
      sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());

      // Add data rows
      for (var row in data) {
        sheet.appendRow(row.map((val) {
          if (val == null) return null;
          if (val is int) return IntCellValue(val);
          if (val is double) return DoubleCellValue(val);
          if (val is bool) return BoolCellValue(val);
          return TextCellValue(val.toString());
        }).toList());
      }

      List<int>? bytesList = excel.save();
      if (bytesList == null) {
        throw Exception('Failed to generate Excel file.');
      }
      return Uint8List.fromList(bytesList);
    } catch (_) {
      return null;
    }
  }

  /// Shares the generated Excel file using the Share Plus package.
  Future<void> shareExcel({
    required Uint8List fileBytes,
    required String fileName,
    String? message,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final safeFileName = fileName.trim().isEmpty ? 'export.xlsx' : fileName;
      final file = File('${tempDir.path}/$safeFileName');
      await file.writeAsBytes(fileBytes, flush: true);

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(
              file.path,
              mimeType:
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            )
          ],
          text: message,
        ),
      );
    } catch (_) {
      throw Exception('Failed to share Excel file.');
    }
  }
}
