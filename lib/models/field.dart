class Field {
  final int id;
  final String name;
  final int size;
  final String location;
  final List<Farm> farms;

  Field(this.id, this.name, this.size, this.location, this.farms);

  int getTotalEntity() {
    int sum = 0;
    for (var farm in farms) {}
    return sum;
  }
}

class Farm {
  final String id;
  final String name;
  final String desc;
  final String createdBy;
  final String createdDate;

  Farm({this.id, this.name, this.desc, this.createdBy, this.createdDate});

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['fuid'],
      name: json['name'],
      desc: json['description'],
      createdBy: json['createdByUuid'],
      createdDate: json['createdDate'],
    );
  }
}

class Entity {
  final int id;
  final String name;
  final int count;

  Entity(this.id, this.name, this.count);
}
