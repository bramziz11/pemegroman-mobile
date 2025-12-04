class Activity {
  String name;
  String category; // Pilihan: Belajar, Ibadah, Olahraga, Hiburan, Lainnya
  double duration; // Dalam jam (1.0 - 8.0)
  bool isCompleted;
  String notes; // Catatan tambahan

  Activity({
    required this.name,
    required this.category,
    required this.duration,
    required this.isCompleted,
    this.notes = "",
  });

  // Metode opsional: untuk debugging
  @override
  String toString() {
    return 'Activity(name: $name, category: $category, duration: $duration, isCompleted: $isCompleted, notes: $notes)';
  }
}