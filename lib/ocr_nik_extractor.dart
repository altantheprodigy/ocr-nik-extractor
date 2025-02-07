  import 'dart:io';
  import 'dart:typed_data';
  import 'dart:ui';
  import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

  class OcrNikExtractor {
    Future<Map<String, String>> extractData({File? imageFile, Uint8List? imageBytes, int? width, int? height}) async {
      try {
        final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

        InputImage inputImage;
        if (imageFile != null) {
          inputImage = InputImage.fromFile(imageFile);
        } else if (imageBytes != null && width != null && height != null) {
          inputImage = InputImage.fromBytes(
            bytes: imageBytes,
            metadata: InputImageMetadata(
              size: Size(width.toDouble(), height.toDouble()),
              rotation: InputImageRotation.rotation0deg,
              format: InputImageFormat.nv21,
              bytesPerRow: width,
            ),
          );
        } else {
          throw Exception('Either imageFile or imageBytes must be provided');
        }

        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

        String nik = _extractNikFromText(recognizedText.text);
        String nama = _extractNamaFromText(recognizedText.text);
        print("OCR MENTAH = ${recognizedText.text}");
        print("OCR NAMA = $nama");

        textRecognizer.close();

        return {
          'nik': nik.isNotEmpty ? nik : "NIK tidak terdeteksi",
          'nama': nama.isNotEmpty ? nama : "Nama tidak terdeteksi"
        };


      } catch (e) {
        throw Exception('Terjadi kesalahan: $e');
      }
    }

    String _extractNikFromText(String text) {
      final RegExp nikRegExp = RegExp(r'\b\d{16}\b');
      final Match? match = nikRegExp.firstMatch(text);
      return match?.group(0) ?? '';
    }

    String _extractNamaFromText(String text) {
      final RegExp namaRegExp = RegExp(
          r'Nama\s*[:\-]?\s*([\s\S]*?)\n([A-Z\s]{3,})\n[A-Z]+,\s*\d{2}-\d{2}-\d{4}',
          multiLine: true
      );

      final Match? match = namaRegExp.firstMatch(text);
      return match?.group(2)?.trim() ?? '';
    }
  }
