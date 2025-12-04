// lib/home_page.dart (REVISI FINAL)

import 'package:flutter/material.dart';
import 'model/activity_model.dart';
import 'add_activity_page.dart';
import 'activity_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 💾 Daftar Aktivitas yang disimpan di State
  List<Activity> activities = [
    // Contoh data awal
    Activity(
        name: "Belajar Flutter",
        category: "Belajar",
        duration: 2.5,
        isCompleted: false),
    Activity(
        name: "Sholat Maghrib",
        category: "Ibadah",
        duration: 0.5,
        isCompleted: true),
  ];

  // ➕ Fungsi Navigasi untuk Menambah Aktivitas
  void _navigateToAddActivity() async {
    final newActivity = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddActivityPage()),
    );

    if (newActivity != null && newActivity is Activity) {
      setState(() {
        activities.add(newActivity); // Perbarui UI secara dinamis (setState())
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aktivitas baru berhasil ditambahkan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Activity Tracker"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: activities.isEmpty
          ? const Center(
              child: Text("Belum ada aktivitas. Silakan tambahkan!"))
          : ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    // Nama aktivitas
                    title: Text(activity.name,
                        style: TextStyle(
                            decoration: activity.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none)),
                    // Durasi dan Status
                    subtitle: Text(
                        '${activity.duration.toStringAsFixed(1)} Jam | Status: ${activity.isCompleted ? "Selesai" : "Belum"}'),
                    // Icon Status
                    trailing: Icon(
                      activity.isCompleted
                          ? Icons.check_circle
                          : Icons.watch_later,
                      color: activity.isCompleted ? Colors.green : Colors.orange,
                    ),
                    // Navigasi ke Halaman Detail
                    onTap: () async {
                      // Mengirim data Activity ke halaman Detail dan menunggu status hapus
                      final bool? isDeleted = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          // Halaman Detail TIDAK PERLU lagi parameter onDelete
                          builder: (context) => ActivityDetailPage(
                            activity: activity,
                            // Anda mungkin perlu index jika ingin mengedit di masa depan, tapi untuk hapus cukup di HomePage
                          ), 
                        ),
                      );

                      // Jika isDeleted adalah true (dikonfirmasi dari ActivityDetailPage)
                      if (isDeleted == true) {
                        setState(() {
                          activities.removeAt(index); // Hapus dari daftar
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Aktivitas berhasil dihapus.')),
                        );
                      }
                    },
                  ),
                );
              },
            ),
      // Tombol Mengambang "Tambah Aktivitas Baru"
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddActivity,
        tooltip: 'Tambah Aktivitas Baru',
        child: const Icon(Icons.add),
      ),
    );
  }
}