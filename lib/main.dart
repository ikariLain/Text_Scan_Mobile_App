import 'package:flutter/material.dart';
import 'package:ocr_scan_text/ocr_scan_text.dart';
import 'package:text_scan_mobile_app/scan_module/scan_all_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR Prototype',
      debugShowCheckedModeBanner: false,
      home: const OcrCameraPage(),
    );
  }
}

class OcrCameraPage extends StatefulWidget {
  const OcrCameraPage({super.key});

  @override
  State<OcrCameraPage> createState() => _OcrCameraPageState();
}

class _OcrCameraPageState extends State<OcrCameraPage> {
  final ScanAllModule module = ScanAllModule();

  String detectedText = "";
  bool showCamera = false;

  @override
  void dispose() {
    module.stop();
    super.dispose();
  }

  void _startCameraScan() {
    setState(() {
      detectedText = "";
      showCamera = true;
    });

    module.start();
  }

  void _stopCameraScan() {
    module.stop();
    setState(() {
      showCamera = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OCR Camera Prototype"),
        actions: [
          if (showCamera)
            IconButton(
              onPressed: _stopCameraScan,
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: showCamera ? _buildCameraView() : _buildHomeView(),
    );
  }

  Widget _buildHomeView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Tryck på knappen för att öppna kameran och läsa text.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _startCameraScan,
            icon: const Icon(Icons.camera_alt),
            label: const Text("Öppna kamera och scanna text"),
          ),
          const SizedBox(height: 24),
          const Text(
            "Resultat (String):",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              detectedText.isEmpty ? "Ingen text ännu..." : detectedText,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Column(
      children: [
        Expanded(
          child: LiveScanWidget(
            scanModules: [module],
            ocrTextResult: (ocrTextResult) {
              // ocrTextResult = resultat från OCR
              // Det kan vara block/lines/elements beroende på lib:en
              // Vi tar ALL text som en enda String för användaren.

              final resultAsString = ocrTextResult.toString();

              if (resultAsString.trim().isEmpty) return;

              setState(() {
                detectedText = resultAsString;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black87,
          ),
          child: Text(
            detectedText.isEmpty ? "Scannar..." : detectedText,
            style: const TextStyle(color: Colors.white),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
