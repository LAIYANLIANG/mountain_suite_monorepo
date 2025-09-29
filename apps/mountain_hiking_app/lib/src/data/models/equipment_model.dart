
// Updated by Gemini on 2025-08-31. Replaced with reference file to fix issues.
class ChecklistItem {
  final String id;
  final String name;
  final String? note;
  final bool isSnowEssential;
  bool isChecked;
  int quantity;
  double weight; // in grams

  ChecklistItem({
    required this.id,
    required this.name,
    this.note,
    this.isSnowEssential = false,
    this.isChecked = false,
    this.quantity = 1,
    this.weight = 0.0,
  });

  ChecklistItem copyWith({
    bool? isChecked,
    int? quantity,
    double? weight,
  }) {
    return ChecklistItem(
      id: id,
      name: name,
      note: note,
      isSnowEssential: isSnowEssential,
      isChecked: isChecked ?? this.isChecked,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
    );
  }
}

class ChecklistSubCategory {
  final String name;
  final List<ChecklistItem> items;

  ChecklistSubCategory({required this.name, required this.items});
}

class ChecklistMainCategory {
  final String name;
  final Map<String, ChecklistSubCategory> subCategories;

  ChecklistMainCategory({required this.name, required this.subCategories});
}
