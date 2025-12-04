// lib/add_activity_page.dart

import 'package:flutter/material.dart';
import 'model/activity_model.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  // GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();
  
  // 📝 Variabel untuk menampung data input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  String? _activityCategory; // Dropdown memerlukan String?
  double _duration = 1.0; // Nilai awal Slider (1-8 jam)
  bool _isCompleted = false;

  final List<String> _categories = [
    'Belajar',
    'Ibadah',
    'Olahraga',
    'Hiburan',
    'Lainnya'
  ];

  // 💾 Fungsi untuk menyimpan data dan kembali ke HomePage
  void _saveActivity() {
    // 📌 Validasi Nama Aktivitas (Wajib diisi)
    if (_nameController.text.isEmpty) {
      // Tampilkan AlertDialog dengan pesan kesalahan.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Peringatan"),
          content: const Text("Nama Aktivitas wajib diisi!"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: const Text("OK"))
          ],
        ),
      );
      return;
    }

    // Buat objek Activity baru
    final newActivity = Activity(
      name: _nameController.text,
      // Jika kategori null, set ke 'Lainnya' sebagai default
      category: _activityCategory ?? 'Lainnya', 
      duration: _duration,
      isCompleted: _isCompleted,
      notes: _notesController.text,
    );

    // 📤 Kirim data kembali ke halaman utama
    Navigator.pop(context, newActivity);
  }
  
  // Pastikan controller dibersihkan saat widget dibuang
  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Aktivitas Baru"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 1. TextField: Nama Aktivitas (Wajib diisi)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Aktivitas',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // 2. DropdownButtonFormField: Kategori
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Kategori Aktivitas',
                  border: OutlineInputBorder(),
                ),
                value: _activityCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _activityCategory = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              // 3. Slider: Durasi (Jam)
              Text('Durasi: ${_duration.toStringAsFixed(1)} Jam (Maks. 8 Jam)',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _duration,
                min: 1.0,
                max: 8.0,
                divisions: 14, // Untuk mendapatkan interval 0.5 (1.0, 1.5, 2.0, ...)
                label: _duration.toStringAsFixed(1),
                onChanged: (double value) {
                  setState(() {
                    _duration = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              // 4. SwitchListTile: Status Aktivitas
              SwitchListTile(
                title: const Text('Status Aktivitas:'),
                subtitle: Text(_isCompleted ? 'Sudah Selesai' : 'Belum Selesai'),
                value: _isCompleted,
                onChanged: (bool value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
                activeColor: Colors.green,
                tileColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              ),
              const SizedBox(height: 20),

              // 5. TextField Multiline: Catatan Tambahan (Optional)
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Tambahan (Optional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // 6. ElevatedButton: Tombol Simpan
              Center(
                child: ElevatedButton(
                  onPressed: _saveActivity,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Simpan Aktivitas', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}