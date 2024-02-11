import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:photo_uploader/services/uploader_service.dart';
import 'package:photo_uploader/ui/widgets/image_overlay.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  File? selfiePhoto;

  bool isInitialized = false;
  bool isProcessing = false;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  void _initCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(
      cameras[1],
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );
    try {
      controller.initialize().then((_) {
        if (!mounted) return;
        setState(() => isInitialized = true);
      });
    } on CameraException catch (e) {
      debugPrint('camera error $e');
    }
  }

  _performUpload() async {
    final isFileUploaded = await UploaderService.upload(selfiePhoto!);
    if (isFileUploaded) {
      _notifyUser('Berhasil upload foto :)');
      _saveToGallery();
    } else {
      _notifyUser('Gagal upload foto :(', true);
    }
  }

  _saveToGallery() async {
    await GallerySaver.saveImage(selfiePhoto!.path).then((_) {
      _notifyUser('Foto berhasil disimpan ke galeri :)');
    }, onError: (e) {
      _notifyUser('Gagal menyimpan foto', true);
    });
  }

  _takeSelfie() async {
    if (!controller.value.isTakingPicture) {
      setState(() {
        isProcessing = true;
      });
      final img = await controller.takePicture();
      setState(() {
        selfiePhoto = File(img.path);
        isProcessing = false;
      });
      if (context.mounted) {
        _showPreview(context);
      }
    }
  }

  _showPreview(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black12,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          shadowColor: Colors.transparent,
          child: ImageOverlay(
            File(selfiePhoto!.path),
            onConfirmed: () {
              Navigator.of(context).pop();
              _performUpload();
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (!isInitialized) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(),
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              SizedBox(
                width: width,
                height: width * controller.value.aspectRatio,
                child: CameraPreview(controller),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: _takeSelfie,
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(70),
                    border: Border.all(
                      color: Colors.grey[700]!,
                      width: 2,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _notifyUser(String message, [bool isError = false]) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: (!isError ? Colors.green[400] : Colors.red[400]),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
