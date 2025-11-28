import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_candi_abel/models/candi.dart';

class DetailScreen extends StatefulWidget {
  final Candi candi;

  const DetailScreen({super.key, required this.candi});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  bool isSignedIn = false;

  Future<void> _toggleFavorite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!isSignedIn) {
      Navigator.pushReplacementNamed(context, '/signin');
      return;
    }

    final newStatus = !isFavorite;
    prefs.setBool('favorite_${widget.candi.name}', newStatus);

    setState(() {
      isFavorite = newStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSignedIn = prefs.getBool('isSignedIn') ?? false;
      isFavorite = prefs.getBool('favorite_${widget.candi.name}') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.candi.imageAsset,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100]?.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.candi.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: _toggleFavorite,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(children: [
                    const Icon(Icons.place, color: Colors.red),
                    SizedBox(width: 8),
                    const SizedBox(
                      width: 70,
                      child: Text('Lokasi', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(': ${widget.candi.location}')
                  ]),

                  Row(children: [
                    const Icon(Icons.calendar_month, color: Colors.blue),
                    SizedBox(width: 8),
                    const SizedBox(
                      width: 70,
                      child: Text('Dibangun', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(': ${widget.candi.built}')
                  ]),

                  Row(children: [
                    const Icon(Icons.house, color: Colors.green),
                    SizedBox(width: 8),
                    const SizedBox(
                      width: 70,
                      child: Text('Tipe', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(': ${widget.candi.type}')
                  ]),

                  const SizedBox(height: 16),
                  Divider(color: Colors.deepPurple.shade100),
                  const SizedBox(height: 16),

                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(widget.candi.description),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.deepPurple.shade100),
                  const Text(
                    'Galeri',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.candi.imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: widget.candi.imageUrls[index],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.deepPurple[50],
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 4),
                  const Text(
                    'Tap untuk memperbesar',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
