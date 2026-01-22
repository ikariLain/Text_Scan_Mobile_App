// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Text Scanner',
//       theme: ThemeData(
//         useMaterial3: true,
//       ),
//       home: const TextScannerPage(),
//     );
//   }
// }

// class TextScannerPage extends StatefulWidget {
//   const TextScannerPage({super.key});

//   @override
//   State<TextScannerPage> createState() => _TextScannerPageState();
// }

// class _TextScannerPageState extends State<TextScannerPage> {
//   final ImagePicker _picker = ImagePicker();

//   File? _imageFile;
//   String _recognizedText = '';
//   bool _isLoading = false;

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? picked = await _picker.pickImage(source: source);

//       if (picked == null) return;

//       setState(() {
//         _imageFile = File(picked.path);
//         _recognizedText = '';
//       });

//       await _scanTextFromImage(picked.path);
//     } catch (e) {
//       _showError("Kunde inte välja bild: $e");
//     }
//   }

//   Future<void> _scanTextFromImage(String path) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final inputImage = InputImage.fromFilePath(path);

//       final textRecognizer = TextRecognizer(
//         script: TextRecognitionScript.latin,
//       );

//       final RecognizedText recognizedText =
//           await textRecognizer.processImage(inputImage);

//       await textRecognizer.close();

//       setState(() {
//         _recognizedText = recognizedText.text.isEmpty
//             ? "Ingen text hittades i bilden."
//             : recognizedText.text;
//       });
//     } catch (e) {
//       _showError("OCR misslyckades: $e");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Text Scanner (ML Kit)"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Image preview
//             Container(
//               width: double.infinity,
//               height: 220,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.grey.shade400),
//               ),
//               child: _imageFile == null
//                   ? const Center(
//                       child: Text(
//                         "Ingen bild vald",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     )
//                   : ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: Image.file(
//                         _imageFile!,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//             ),

//             const SizedBox(height: 16),

//             // Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text("Kamera"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
//                     icon: const Icon(Icons.photo),
//                     label: const Text("Galleri"),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             if (_isLoading) ...[
//               const CircularProgressIndicator(),
//               const SizedBox(height: 10),
//               const Text("Scannar text..."),
//             ] else ...[
//               // Recognized text output
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.grey.shade300),
//                     color: Colors.grey.shade100,
//                   ),
//                   child: SingleChildScrollView(
//                     child: SelectableText(
//                       _recognizedText.isEmpty
//                           ? "Tryck på Kamera/Galleri för att scanna text."
//                           : _recognizedText,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
