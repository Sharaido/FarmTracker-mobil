import 'dart:convert';

import 'package:http/http.dart' as http;

import '../main.dart';

enum HealthStatus { HEALTHY, DISEASED, DEAD }

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

  setEntitiesList() async {
    diseased.clear();
    dead.clear();
    all.forEach((element) async {
      var copValues = await getCOPValues(element.id);
      copValues.forEach((cop) {
        if (cop.propertyCategoryID == 3) {
          element.health = HealthStatus.HEALTHY;
          if (cop.value == "Diseased") {
            element.health = HealthStatus.DISEASED;
            diseased.add(element);
          } else if (cop.value == "Dead") {
            element.health = HealthStatus.DEAD;
            dead.add(element);
          }
        }
      });
    });
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
  HealthStatus health;
  String categoryName;
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

  Future<List<EntityDetail>> getEntityDetails() async {
    var jwt = await storage.read(key: "token");
    final response = await http
        .get('$BASE_URL/api/Farms/Properties/Entities/Details/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    return response.statusCode == 404 ? [] : parseDetails(response.body);
  }

  List<EntityDetail> parseDetails(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<EntityDetail>((json) => EntityDetail.fromJson(json))
        .toList();
  }

  void creadeInitialDetails() async {
    var jwt = await storage.read(key: "token");
    await createDetail("water", jwt);
    await createDetail("fertilizer", jwt);
    await createDetail("spray", jwt);
    await createDetail("harvest", jwt);
  }

  Future<bool> createDetail(String type, String jwt) async {
    final http.Response response = await http.post(
      '$BASE_URL/api/Farms/Properties/Entities/Details/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode(<String, dynamic>{
        "EUID": id,
        "Name": type,
        "Description": "desc",
        "Cost": null,
        "RemainderDate": null,
      }),
    );
    return response.statusCode == 201;
  }

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
      createdDate: json['createdDate'],
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

class EntityDetail {
  String duid;
  String euid;
  String name;
  String description;
  double cost;
  String remainderDate;
  bool remainderCompletedFlag;
  String remainderCompletedDate;
  String remainderCompletedByUuid;
  String createdDate;
  String createdByUuid;
  bool deletedFlag;
  DateTime deletedDate;
  String deletedByUuid;

  EntityDetail({
    this.duid,
    this.euid,
    this.name,
    this.description,
    this.cost,
    this.remainderDate,
    this.remainderCompletedFlag,
    this.remainderCompletedDate,
    this.remainderCompletedByUuid,
    this.createdDate,
    this.createdByUuid,
    this.deletedFlag,
    this.deletedDate,
    this.deletedByUuid,
  });

  factory EntityDetail.fromJson(Map<dynamic, dynamic> json) {
    return EntityDetail(
      duid: json['duid'],
      euid: json['euid'],
      name: json['name'],
      description: json['description'],
      cost: json['cost'],
      remainderDate: json['remainderDate'],
      remainderCompletedFlag: json['remainderCompletedFlag'],
      remainderCompletedDate: json['remainderCompletedDate'],
      remainderCompletedByUuid: json['remainderCompletedByUuid'],
      createdDate: json['createdDate'],
      createdByUuid: json['createdByUuid'],
      deletedFlag: json['deletedFlag'],
      deletedDate: json['deletedDate'],
      deletedByUuid: json['deletedByUuid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duid'] = this.duid;
    data['euid'] = this.euid;
    data['name'] = this.name;
    data['description'] = this.description;
    data['cost'] = this.cost;
    data['remainderDate'] = this.remainderDate;
    data['remainderCompletedFlag'] = this.remainderCompletedFlag;
    data['remainderCompletedDate'] = this.remainderCompletedDate;
    data['remainderCompletedByUuid'] = this.remainderCompletedByUuid;
    data['createdDate'] = this.createdDate;
    data['createdByUuid'] = this.createdByUuid;
    data['deletedFlag'] = this.deletedFlag;
    data['deletedDate'] = this.deletedDate;
    data['deletedByUuid'] = this.deletedByUuid;
    return data;
  }
}
