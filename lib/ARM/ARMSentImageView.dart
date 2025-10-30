import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

class Armsentimageview extends StatefulWidget {
  final String poc;
  final String SerialNum;

  const Armsentimageview({
    super.key,
    required this.poc,
    required this.SerialNum,
  });

  @override
  State<Armsentimageview> createState() => _ArmsentimageviewState();
}

class _ArmsentimageviewState extends State<Armsentimageview> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<String> imageUrls = [];
  bool _loading = true;

  /// 🔒 Custom Cache Manager (cache for 24 hours)
  static final cacheManager = CacheManager(
    Config(
      'coSentImagesCache',
      stalePeriod: const Duration(hours: 24),
      maxNrOfCacheObjects: 200,
    ),
  );

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  /// 🔹 Fetch image URLs once per 24 hours from Firebase Realtime Database
  Future<void> _fetchImages() async {
    setState(() => _loading = true);
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
      setState(() {
        imageUrls = [];
        _loading = false;
      });
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
            /// 🟦 Header
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
                  // FloatingActionButton(
                  //   heroTag: "uploadButton",
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => CoSenteImageAttach(
                  //           poc: widget.poc,
                  //           SerialNum: widget.SerialNum,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   backgroundColor: Colors.blue,
                  //   child: const Icon(
                  //     Iconsax.cloud_plus5,
                  //     color: Colors.white,
                  //     size: 32,
                  //   ),
                  // ),
                ],
              ),
            ),

            /// 🖼️ Image Grid
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
                  : RefreshIndicator(
                      onRefresh: _fetchImages,
                      color: const Color(0xFF0A7AFE),
                      child: Padding(
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
                            final url = imageUrls[index];
                            return GestureDetector(
                              onTap: () => _openFullImage(url),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: CachedNetworkImage(
                                  cacheManager: cacheManager,
                                  imageUrl: url,
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(
                                    milliseconds: 200,
                                  ),
                                  fadeOutDuration: const Duration(
                                    milliseconds: 200,
                                  ),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
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
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔍 Full Image View with zoom/pan
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
          child: CachedNetworkImage(
            cacheManager: _ArmsentimageviewState.cacheManager,
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            errorWidget: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.white, size: 100),
          ),
        ),
      ),
    );
  }
}
