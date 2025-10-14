import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class CoSenteImageAttach extends StatefulWidget {
  final String poc;
  final String SerialNum;

  const CoSenteImageAttach({
    super.key,
    required this.poc,
    required this.SerialNum,
  });

  @override
  State<CoSenteImageAttach> createState() => _CoSenteImageAttachState();
}

class _CoSenteImageAttachState extends State<CoSenteImageAttach> {
  final List<File> _images = [];
  final picker = ImagePicker();
  bool _uploading = false;
  double _progress = 0.0;

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 5) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Maximum 5 images allowed')));
      return;
    }

    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() => _images.add(File(pickedFile.path)));
    }
  }

  Future<void> _uploadImages() async {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image')),
      );
      return;
    }

    setState(() {
      _uploading = true;
      _progress = 0.0;
    });

    final storage = FirebaseStorage.instance;
    final database = FirebaseDatabase.instance.ref(
      "CoSent_Images/${widget.SerialNum}",
    );
    final totalImages = _images.length;
    int uploadedCount = 0;

    try {
      for (var img in _images) {
        final id = const Uuid().v4();
        final ref = storage.ref().child(
          'CoSent_Images/${widget.SerialNum}/$id.jpg',
        );
        final uploadTask = ref.putFile(img);

        uploadTask.snapshotEvents.listen((snapshot) {
          final taskProgress = snapshot.bytesTransferred / snapshot.totalBytes;
          setState(() {
            _progress = (uploadedCount + taskProgress) / totalImages;
          });
        });

        await uploadTask.whenComplete(() => null);
        final url = await ref.getDownloadURL();
        await database.child(id).set({'url': url, 'poc': widget.poc});
        uploadedCount++;
      }
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All images uploaded successfully!')),
      );

      setState(() {
        _images.clear();
        _progress = 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _uploading = false);
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Iconsax.camera5, color: Colors.black),
              title: const Text(
                'Take Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "sfproRoundSemiB",
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.gallery5, color: Colors.black),
              title: const Text(
                'Choose from Gallery',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "sfproRoundSemiB",
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage(int index) => setState(() => _images.removeAt(index));

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF8F9FB);
    const accentColor = Color(0xFF0A7AFE);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 25, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Upload",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "sfproRoundSemiB",
                    ),
                  ),

                  FloatingActionButton(
                    onPressed: () {
                      _uploading ? null : _uploadImages();
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(
                      Iconsax.cloud_add5,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ✅ Image Grid
              Expanded(
                child: _images.isEmpty
                    ? const Center(
                        child: Text(
                          "No images selected",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "sfproRoundSemiB",
                          ),
                        ),
                      )
                    : GridView.builder(
                        itemCount: _images.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemBuilder: (context, index) => Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                image: DecorationImage(
                                  image: FileImage(_images[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black54,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              if (_uploading) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  color: accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 8),
                Text(
                  "${(_progress * 100).toStringAsFixed(0)}% Uploaded",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // Floating Buttons
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Sleek Black Floating Add Button ---

          // --- Blue Rounded Upload Button ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: _showImagePickerDialog,
              icon: const Icon(Iconsax.camera, size: 30),
              label: const Text(
                "Add Images",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: "sfproRoundSemiB",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
