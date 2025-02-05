import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_nik_extractor/ocr_nik_extractor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'OCR NIK KTP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _imageFile;
  String _extractedNik = "Belum ada NIK yang diekstrak";
  final OcrNikExtractor _ocrNikExtractor = OcrNikExtractor();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndExtractNik() async {
    final XFile? imageFile = await _picker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });

      try {
        final nik = await _ocrNikExtractor.extractNik(imageFile: File(imageFile.path));
        setState(() {
          _extractedNik = nik;
        });
      } catch (e) {
        setState(() {
          _extractedNik = "Gagal mengekstrak NIK: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageFile != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    _imageFile!,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const Text(
              '*Note: Pastikan NIK KTP terlihat jelas!',
              style: TextStyle(
                color: Colors.red
              ),
            ),
            const Text(
              'NIK yang diekstrak:',
            ),
            Text(
              _extractedNik,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndExtractNik,
        tooltip: 'Ambil Gambar dan Ekstrak NIK',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}