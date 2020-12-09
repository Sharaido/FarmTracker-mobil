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

class Property {
  final String id;
  final String name;
  final String desc;
  final int categoryID;
  final String farmID;
  final String createdBy;
  final String createdDate;

  Property(
      {this.id,
      this.name,
      this.desc,
      this.categoryID,
      this.farmID,
      this.createdBy,
      this.createdDate});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['puid'],
      name: json['name'],
      desc: json['description'],
      categoryID: json['cuid'],
      farmID: json['fuid'],
      createdBy: json['createdByUuid'],
      createdDate: json['createdDate'],
    );
  }
}

class Entity {
  final String id;
  final int categoryID;
  final String propertyID;
  final String fakeID;
  final String name;
  final String desc;
  final int count;
  final String purchaseDate;
  final double cost;
  final String createdBy;
  final String createdDate;

  Entity(
      {this.id,
      this.categoryID,
      this.propertyID,
      this.fakeID,
      this.name,
      this.desc,
      this.count,
      this.purchaseDate,
      this.cost,
      this.createdBy,
      this.createdDate});

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      id: json['euid'],
      categoryID: json['cuid'],
      propertyID: json['puid'],
      fakeID: json['id'],
      name: json['name'],
      desc: json['description'],
      count: json['count'],
      purchaseDate: json['purchaseDate'],
      cost: json['cost'],
      createdBy: json['createdByUuid'],
      createdDate: json['createdDate'],
    );
  }
}
