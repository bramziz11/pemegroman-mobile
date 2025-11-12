import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// ===============================================
/// App Root
/// ===============================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State & Interaksi • Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Menggunakan skema warna yang lebih menarik, misalnya ungu
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light, // Terapkan tema terang
        ),
        useMaterial3: true,
        // Kustomisasi AppBar
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 2, // Tambahkan sedikit bayangan
        ),
      ),
      home: const HomePage(),
    );
  }
}

/// ===============================================
/// MODEL sederhana untuk data form
/// ===============================================
class FeedbackItem {
  final String name;
  final String gender; // "L" / "P"
  final double rating; // 1..5
  final bool isAgree; // setuju syarat
  final List<String> hobbies; // ["Coding","Olahraga",...]
  final String comment;

  FeedbackItem({
    required this.name,
    required this.gender,
    required this.rating,
    required this.isAgree,
    required this.hobbies,
    required this.comment,
  });
}

/// ===============================================
/// HOME: menampilkan daftar feedback + tombol ke Counter demo + tambah feedback
/// ===============================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<FeedbackItem> _items = [];

  // Menggunakan fungsi yang lebih spesifik untuk ikon gender
  IconData _getGenderIcon(String gender) {
    return gender == 'L' ? Icons.male : Icons.female;
  }

  // Menggunakan fungsi untuk mendapatkan warna rating
  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 3.5) return Colors.lightGreen;
    if (rating >= 2.5) return Colors.amber;
    return Colors.red;
  }

  Future<void> _openForm() async {
    final result = await Navigator.push<FeedbackItem>(
      context,
      MaterialPageRoute(builder: (_) => const FeedbackFormPage()),
    );

    if (result != null) {
      setState(() => _items.add(result));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feedback dari ${result.name} berhasil ditambahkan! 🎉'),
          backgroundColor: Theme.of(context).colorScheme.primary, // Warna SnackBar
        ),
      );
    }
  }

  void _openCounterDemo() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CounterPage()));
  }

  void _openDetail(FeedbackItem item) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(item: item)));
  }

  @override
  Widget build(BuildContext context) {
    // Memberikan warna latar belakang kontras ringan pada Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text("📝 Demo: State & Interaksi Pengguna"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Banner aksi cepat
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), // Padding atas dan bawah lebih besar
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add_comment_rounded),
                    label: const Text("Tambah Feedback"),
                    onPressed: _openForm,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text("Counter Demo"),
                  onPressed: _openCounterDemo,
                ),
              ],
            ),
          ),
          const Divider(height: 16),
          // Daftar feedback
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 80, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        const Text(
                          "Belum ada data feedback.\nMari kita buat yang pertama!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, i) {
                      final it = _items[i];
                      return Card(
                        // Menggunakan margin yang sedikit lebih kecil
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        elevation: 1, // Bayangan ringan
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                            foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                            child: Icon(_getGenderIcon(it.gender)),
                          ),
                          title: Text(
                            it.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender: ${it.gender == 'L' ? 'Laki-laki' : 'Perempuan'}",
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, size: 16, color: _getRatingColor(it.rating)),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Rating: ${it.rating.toStringAsFixed(1)}",
                                    style: TextStyle(color: _getRatingColor(it.rating), fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              if (it.hobbies.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "Hobi: ${it.hobbies.join(', ')}",
                                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                  ),
                                ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          onTap: () => _openDetail(it),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // FAB diubah menjadi floatingActionButton biasa
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        tooltip: 'Tambah Feedback Baru',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ... (CounterPage tetap sama, hanya untuk demo setState)
/// ===============================================
/// COUNTER DEMO: setState() + FAB (+ / - / reset)
/// ===============================================
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _inc() => setState(() => _counter++);
  void _dec() => setState(() => _counter--);
  void _reset() => setState(() => _counter = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🔢 Counter • setState() Demo")),
      body: Center(
        child: Text(
          "$_counter",
          style: TextStyle(
            fontSize: 80, // Ukuran lebih besar
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Penjelasan: setiap tombol memanggil setState() untuk mengubah nilai _counter "
          "dan memicu rebuild UI.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            onPressed: _dec,
            heroTag: 'dec',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 12),
          FloatingActionButton.extended(
            onPressed: _reset,
            heroTag: 'reset',
            label: const Text("Reset"),
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: _inc,
            heroTag: 'inc',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
// ... (CounterPage end)

/// ===============================================
/// FORM PAGE: TextField, Radio, Checkbox, Switch, Slider + validasi
/// Mengembalikan FeedbackItem melalui Navigator.pop(context, data)
/// ===============================================
class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _commentCtrl = TextEditingHelper();

  String _gender = "L";
  double _rating = 3;
  bool _agree = false;

  // checkbox hobbies
  final Map<String, bool> _hobbyMap = {
    "Coding": false,
    "Membaca": false,
    "Olahraga": false,
    "Musik": false, // Tambahkan satu hobi lagi
  };

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final hobbies = _hobbyMap.entries.where((e) => e.value).map((e) => e.key).toList();

    if (!_agree) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("⚠️ Perlu Persetujuan"),
          content: const Text("Centang \"Setuju syarat & ketentuan\" untuk melanjutkan pengisian form."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
      return;
    }

    final item = FeedbackItem(
      name: _nameCtrl.text.trim(),
      gender: _gender,
      rating: _rating,
      isAgree: _agree,
      hobbies: hobbies,
      comment: _commentCtrl.text.trim(),
    );

    Navigator.pop(context, item);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📝 Form Feedback Pengguna")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Nama
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap", // Label yang lebih deskriptif
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))), // Rounded border
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? "Nama wajib diisi" : null,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24), // Spasi lebih besar

            // Gender - Radio
            const SectionHeader(title: "Jenis Kelamin"),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    value: "L",
                    groupValue: _gender,
                    title: const Text("Laki-laki 👦"),
                    onChanged: (v) => setState(() => _gender = v ?? "L"),
                    dense: true,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    value: "P",
                    groupValue: _gender,
                    title: const Text("Perempuan 👧"),
                    onChanged: (v) => setState(() => _gender = v ?? "P"),
                    dense: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hobi - Checkbox
            const SectionHeader(title: "Hobi"),
            Wrap(
              spacing: 8.0, // jarak antar chip
              children: _hobbyMap.keys.map((h) {
                return ChoiceChip(
                  label: Text(h),
                  selected: _hobbyMap[h] ?? false,
                  onSelected: (val) => setState(() => _hobbyMap[h] = val),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Rating - Slider
            const SectionHeader(title: "Rating (1–5)"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Puas terhadap pelayanan: ",
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              min: 1,
              max: 5,
              divisions: 8,
              value: _rating,
              label: _rating.toStringAsFixed(1),
              onChanged: (v) => setState(() => _rating = v),
            ),
            const SizedBox(height: 16),

            // Comment
            TextFormField(
              controller: _commentCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Komentar/Saran",
                hintText: "Tuliskan komentar Anda di sini...",
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                prefixIcon: Icon(Icons.chat_bubble_outline),
                alignLabelWithHint: true,
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? "Komentar wajib diisi" : null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16),

            // Agreement - Switch
            SwitchListTile(
              value: _agree,
              title: const Text("Setuju syarat & ketentuan"),
              subtitle: const Text("Data Anda akan digunakan untuk pengembangan produk."),
              onChanged: (v) => setState(() => _agree = v),
              activeColor: Theme.of(context).colorScheme.primary,
              tileColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 24),

            // Tombol Submit
            FilledButton.icon(
              icon: const Icon(Icons.send_rounded),
              onPressed: _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Tombol lebih tinggi
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              label: const Text(
                "Simpan Feedback",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget bantu untuk judul bagian
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

/// ===============================================
/// DETAIL PAGE: tampilkan isi FeedbackItem
/// ===============================================
class DetailPage extends StatelessWidget {
  final FeedbackItem item;
  const DetailPage({super.key, required this.item});

  // Fungsi utilitas untuk item detail
  Widget _buildDetailTile(BuildContext context, IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0.5,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: Theme.of(context).textTheme.bodySmall),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("🔎 Detail Feedback")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan nama dan status persetujuan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.colorScheme.primary,
                      child: Text(
                        item.name.isNotEmpty ? item.name[0].toUpperCase() : "?",
                        style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: theme.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Chip(
                            label: Text(item.isAgree ? "Syarat Disetujui ✅" : "Syarat Tidak Disetujui ❌"),
                            backgroundColor: item.isAgree ? Colors.green.shade100 : Colors.red.shade100,
                            labelStyle: TextStyle(color: item.isAgree ? Colors.green.shade800 : Colors.red.shade800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text("DATA FORM", style: theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.primary)),
              const Divider(),

              _buildDetailTile(
                context,
                Icons.transgender,
                "Jenis Kelamin",
                item.gender == "L" ? "Laki-laki" : "Perempuan",
              ),
              _buildDetailTile(
                context,
                Icons.star_rate_rounded,
                "Rating",
                "${item.rating.toStringAsFixed(1)} / 5.0",
              ),

              const SizedBox(height: 16),
              Text("KEGEMARAN", style: theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.primary)),
              const Divider(),

              _buildDetailTile(
                context,
                Icons.sports_soccer_outlined,
                "Hobi",
                item.hobbies.isEmpty ? "Tidak Ada" : item.hobbies.join(", "),
              ),

              const SizedBox(height: 16),
              Text("KOMENTAR", style: theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.primary)),
              const Divider(),

              Card(
                elevation: 0.5,
                child: ListTile(
                  leading: const Icon(Icons.format_quote_rounded),
                  title: Text(item.comment.isEmpty ? "(Tidak ada komentar)" : item.comment, style: theme.textTheme.bodyLarge),
                  subtitle: Text("Komentar", style: theme.textTheme.bodySmall),
                  isThreeLine: true,
                ),
              ),

              const SizedBox(height: 32),
              Center(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  label: const Text("Kembali ke Daftar"),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Helper sementara untuk menghilangkan warning di `_commentCtrl`
class TextEditingHelper extends TextEditingController {
  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}