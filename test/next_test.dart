import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pptx/flutter_pptx.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test(
    'check sample presentation',
    () async {
      final pres = Powerpoint();

      const count = 50;
      for (var i = 0; i <= count; i++) {
        final slide = pres.addTitle('Slide $i');
        slide.speakerNotes = 'This is a note!';
      }

      pres.showSlideNumber = true;

      final bytes = await pres.save();
      if (bytes != null) {
        // Save to directory
        final dir = Directory('./build/pptx');
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        } else {
          await dir.delete(recursive: true);
          await dir.create(recursive: true);
        }
        for (final entry in pres.context.archive.files.entries) {
          final name = entry.key;
          final value = entry.value;
          if (value is List<int>) {
            await saveFile('${dir.path}/$name', bytes: value);
          } else if (value is String) {
            await saveFile('${dir.path}/$name', string: value);
          }
        }

        await saveFile('./samples/pptx/sample.pptx', bytes: bytes);
      }

      expect(bytes != null && bytes.isNotEmpty, true);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

Future<void> saveFile(
  String name, {
  List<int>? bytes,
  String? string,
}) async {
  final file = File(name);
  if (!await file.exists()) {
    await file.create(recursive: true);
  }
  if (bytes != null) await file.writeAsBytes(bytes);
  if (string != null) await file.writeAsString(string);
}
