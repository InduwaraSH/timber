import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timber_app/CO/CO_SEnte_image_attach.dart';

class CoSentImageview extends StatefulWidget {
  final String poc;
  final String SerialNum;

  const CoSentImageview({
    super.key,
    required this.poc,
    required this.SerialNum,
  });

  @override
  State<CoSentImageview> createState() => _CoSentImageviewState();
}

class _CoSentImageviewState extends State<CoSentImageview> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<String> imageUrls = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final ref = dbRef.child("CoSent_Images/${widget.SerialNum}");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final urls = data.values.map((item) {
        return (item as Map)['url'] as String;
      }).toList();

      setState(() {
        imageUrls = urls;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  void _openFullImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FullImageView(imageUrl: imageUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🟦 Top "Gallery" header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontFamily: "sfproRoundSemiB",
                      letterSpacing: -1,
                    ),
                  ),
                  Row(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CoSenteImageAttach(
                                poc: widget.poc,
                                SerialNum: widget.SerialNum,
                              ),
                            ),
                          );
                        },
                        backgroundColor: Colors.blue,
                        child: const Icon(
                          Iconsax.cloud_plus5,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// 🖼️ Image grid or loading/error
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0A7AFE),
                        strokeWidth: 3,
                      ),
                    )
                  : imageUrls.isEmpty
                  ? const Center(
                      child: Text(
                        'No images uploaded yet.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: GridView.builder(
                        itemCount: imageUrls.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _openFullImage(imageUrls[index]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF0A7AFE),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper for top-right icons
  Widget _iconButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class FullImageView extends StatelessWidget {
  final String imageUrl;

  const FullImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.8,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.white, size: 100),
          ),
        ),
      ),
    );
  }
}
