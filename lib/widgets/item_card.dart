import 'package:flutter/material.dart';
import 'package:wisata_candi_abel/models/candi.dart';
import 'package:wisata_candi_abel/screens/detail_screen.dart';

class ItemCard extends StatelessWidget {
  final Candi candi;

  const ItemCard({super.key, required this.candi});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(candi: candi),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.deepPurple[50],
        margin: const EdgeInsets.all(8),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Gambar
            SizedBox(
              height: 150,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  candi.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            // ✅ Nama Candi
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 8, right: 8),
              child: Text(
                candi.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // ✅ Lokasi atau Jenis
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 10, right: 8),
              child: Text(
                candi.location, // bisa diganti jadi candi.type kalau mau
                style: const TextStyle(fontSize: 13, color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
