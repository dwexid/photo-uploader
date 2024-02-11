import 'package:flutter/material.dart';
import 'package:photo_uploader/ui/camera_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  _goToCameraPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CameraPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambil Foto'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _goToCameraPage,
              child: const Text('Ambil Foto'),
            ),
          ),
        ],
      ),
    );
  }
}
