class Category {
  final int id;
  final String name;
  final int subCategoryOf;

  Category({this.id, this.name, this.subCategoryOf});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['cuid'],
      name: json['name'],
      subCategoryOf: json['subCategoryOfCuid'],
    );
  }
}
