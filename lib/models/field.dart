import 'dart:convert';

import '../main.dart';
import 'package:http/http.dart' as http;

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

  List<Entity> all = [];
  List<Entity> diseased = [];
  List<Entity> dead = [];

  Future<List<Entity>> getAllEntities() async {
    var jwt = await storage.read(key: "token");
    final response =
        await http.get('$BASE_URL/api/Farms/Properties/Entities/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    if (response.statusCode == 404) return [];
    return parseEntities(response.body);
  }

  List<Entity> parseEntities(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Entity>((json) => Entity.fromJson(json)).toList();
  }

  Future<List<COPValue>> getCOPValues(String id) async {
    var jwt = await storage.read(key: "token");
    final response = await http
        .get('$BASE_URL/api/Farms/Properties/Entities/COPValues/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    return parseCOPValues(response.body);
  }

  List<COPValue> parseCOPValues(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<COPValue>((json) => COPValue.fromJson(json)).toList();
  }

  Future<bool> setEntitiesList() async {
    diseased.clear();
    dead.clear();
    all.forEach((element) {
      getCOPValues(element.id).then((value) {
        value.forEach((cop) {
          if (cop.propertyCategoryID == 3) {
            if (cop.value == "Diseased") {
              diseased.add(element);
            } else if (cop.value == "Dead") {
              dead.add(element);
            }
          }
        });
      });
    });
    return true;
  }

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
    );
  }
}

class COPValue {
  final String entityID;
  final int propertyCategoryID;
  final String value;

  COPValue({this.entityID, this.propertyCategoryID, this.value});

  factory COPValue.fromJson(Map<String, dynamic> json) {
    return COPValue(
      entityID: json['euid'],
      propertyCategoryID: json['puid'],
      value: json['value'],
    );
  }
}
