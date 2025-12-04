// lib/activity_detail_page.dart (REVISI FINAL)

import 'package:flutter/material.dart';
import 'model/activity_model.dart';

class ActivityDetailPage extends StatelessWidget {
  final Activity activity;
  // 🗑️ Properti onDelete dihapus, karena HomePage akan menerima hasil pop

  const ActivityDetailPage({
    super.key,
    required this.activity,
    // required this.onDelete, // Dihapus
  });

  // 🗑️ Fungsi konfirmasi hapus (REVISI LOGIKA POP)
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Yakin ingin menghapus aktivitas '${activity.name}'?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Tutup dialog (mengirim null)
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // 1. Tutup AlertDialog
              
              // 2. Pop halaman detail dan kirim sinyal TRUE ke HomePage
              // Ini akan memicu logika penghapusan di HomePage
              Navigator.pop(context, true); 
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Widget pembantu perlu diubah menjadi fungsi statis atau dipindahkan, 
  // karena StatelessWidget tidak dapat menggunakan context secara langsung di dalam fungsi helper.
  Widget _buildDetailRow(BuildContext context, String title, String value, IconData icon,
      [Color color = Colors.black87]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600, color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Aktivitas"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Nama Aktivitas (Judul Besar)
            Text(
              activity.name,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 20),

            // Card Detail Informasi
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                        context, 'Kategori', activity.category, Icons.category),
                    const Divider(),
                    _buildDetailRow(
                        context, 
                        'Durasi',
                        '${activity.duration.toStringAsFixed(1)} Jam',
                        Icons.access_time),
                    const Divider(),
                    _buildDetailRow(
                        context, 
                        'Status',
                        activity.isCompleted ? 'Selesai' : 'Belum Selesai',
                        activity.isCompleted ? Icons.check_circle : Icons.warning,
                        activity.isCompleted ? Colors.green : Colors.orange),
                    const Divider(),
                    _buildDetailRow(context, 'Catatan',
                        activity.notes.isEmpty ? 'Tidak ada catatan' : activity.notes, Icons.notes),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Tombol "Kembali"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Kembali"),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15)),
              ),
            ),
            const SizedBox(height: 10),

            // Tombol "Hapus Aktivitas"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete),
                label: const Text("Hapus Aktivitas"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}