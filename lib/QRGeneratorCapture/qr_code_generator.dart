import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

// NOTE: Carfull using deprecated things
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html; // For downloading files

class QrCodeGeneratorRepository {
  Widget generateItemQRCode(String id, String name) {
    String data = "{\"id\":\"$id\", \"name\":\"$name\"}";
    return Center(
      child: QrImageView(
        data: data,
        size: 250,
        gapless: false,
        errorStateBuilder: (cxt, err) {
          return AlertDialog(
            content: Text(
              'Uh oh! Something went wrong...',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

    // Function to capture the widget as an image
  Future<bool> captureAndSave({required GlobalKey repaintBoundaryKey,required String qrCodeName}) async {
    try {
      RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(
          pixelRatio: 3.0); // Use higher pixel ratio for better quality

      // Convert to byte data (PNG format)
      image.toByteData(format: ImageByteFormat.png).then((byteData) {
        final bytes = byteData!.buffer.asUint8List();

        // Create a downloadable link to the image
        final buffer = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(buffer);
        // ignore: unused_local_variable
        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = '$qrCodeName.png'
          ..click();
        html.Url.revokeObjectUrl(url);
      });
      return true;
    } catch (e) {
      // ignore: avoid_print
      print("Error capturing image: $e");
      return false;
    }
  }
}
