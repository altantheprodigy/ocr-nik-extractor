<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A package to make it easier for users to extract nik data from identity card of the Indonesian people 

## Features

To generate data NIK from image of identity card of the Indonesian people

## Getting started

import 'package:ocr_nik_extractor/ocr_nik_extractor.dart';

## Usage

Define the function

final OcrNikExtractor ocrNikExtractor = OcrNikExtractor();

Call the function to get the data

final String nik = await ocrNikExtractor.extractNik(imageFile: imageFile);

## Additional information


