import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageOverlay extends StatelessWidget {
  final File image;
  final VoidCallback onConfirmed;

  const ImageOverlay(
    this.image, {
    Key? key,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PhotoView(
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                loadingBuilder: (context, event) => const Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                ),
                imageProvider: FileImage(image),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.blue.withOpacity(.1),
                child: const Text(
                  'Upload sekarang?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            _actionItem(
              label: 'Tidak',
              color: Colors.red[300]!,
              onTap: () => Navigator.of(context).pop(),
            ),
            _actionItem(
              label: 'Ya',
              color: Colors.blue,
              onTap: onConfirmed,
            ),
          ],
        )
      ],
    );
  }

  _actionItem({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: color,
          padding: const EdgeInsets.all(10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
