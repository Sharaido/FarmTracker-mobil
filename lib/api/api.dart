import 'dart:convert';

import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/models/user.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class API {
  static String jwt;
  static const String BASE_URL = "http://10.0.2.2:8181";

  // Farm Controller

  static Future<List<Farm>> getAllFarms() async {
    final response = await http.get('$BASE_URL/api/Farms/', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    if (response.statusCode == 404) return [];
    return _parseFarms(response.body);
  }

  static List<Farm> _parseFarms(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Farm>((json) => Farm.fromJson(json)).toList();
  }

  static Future<List<Entity>> getAllEntities(String id) async {
    final response =
        await http.get('$BASE_URL/api/Farms/Properties/Entities/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    if (response.statusCode == 404) return [];
    return _parseEntities(response.body);
  }

  static List<Entity> _parseEntities(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Entity>((json) => Entity.fromJson(json)).toList();
  }

  static Future<List<COPValue>> getCOPValues(String id) async {
    final response = await http
        .get('$BASE_URL/api/Farms/Properties/Entities/COPValues/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    return _parseCOPValues(response.body);
  }

  static List<COPValue> _parseCOPValues(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<COPValue>((json) => COPValue.fromJson(json)).toList();
  }

  static Future<List<EntityDetail>> getEntityDetails(String id) async {
    final response = await http
        .get('$BASE_URL/api/Farms/Properties/Entities/Details/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    return response.statusCode == 404 ? [] : _parseDetails(response.body);
  }

  static List<EntityDetail> _parseDetails(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<EntityDetail>((json) => EntityDetail.fromJson(json))
        .toList();
  }

  static Future<List<Property>> getProperties(String id) async {
    final response =
        await http.get('$BASE_URL/api/Farms/Properties/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });

    return _parseProperties(response.body);
  }

  static List<Property> _parseProperties(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Property>((json) => Property.fromJson(json)).toList();
  }

  static Future<Category> getCategory(int id) async {
    var jwt = await storage.read(key: "token");
    final response =
        await http.get('$BASE_URL/api/Farms/Categories/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    return _parseCategory(response.body);
  }

  static Category _parseCategory(String responseBody) {
    final parsed = Map<String, dynamic>.from(jsonDecode(responseBody));
    return Category.fromJson(parsed);
  }

  static Future<List<Category>> getSubCategories(int id) async {
    final response =
        await http.get('$BASE_URL/api/Farms/SubCategories/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    return _parseCategories(response.body);
  }

  static List<Category> _parseCategories(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Category>((json) => Category.fromJson(json)).toList();
  }

  static Entity _parseEntity(String responseBody) {
    var parsed = Map<String, dynamic>.from(jsonDecode(responseBody));
    return Entity.fromJson(parsed);
  }

  static Future<bool> createFarm(String name, String desc) async {
    final http.Response response = await http.post(
      '$BASE_URL/api/Farms/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode(<String, String>{
        'Name': name,
        'Description': desc,
      }),
    );
    return response.statusCode == 201;
  }

  static Future<bool> createProperty(
      String name, String desc, int category, String farmID) async {
    final http.Response response = await http.post(
      '$BASE_URL/api/Farms/Properties',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode(<String, dynamic>{
        'Name': name,
        'Description': desc,
        'CUID': category,
        'FUID': farmID,
      }),
    );
    return response.statusCode == 201;
  }

  static Future<bool> createDetail(String id, String type) async {
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

  static Future<Entity> createEntity(int categoryID, String propertyID,
      String id, String name, String desc, int count) async {
    final http.Response response = await http.post(
      '$BASE_URL/api/Farms/Properties/Entities/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode(<String, dynamic>{
        "CUID": categoryID,
        "PUID": propertyID,
        "ID": id,
        "Name": name,
        "Description": desc,
        "Count": count,
        "PurchasedDate": null,
        "Cost": 0
      }),
    );

    if (response.statusCode == 201) {
      var entity = _parseEntity(response.body);
      entity.creadeInitialDetails();
      return entity;
    }
    return null;
  }

  static Future<bool> addCOPValue(
      String entityID, int copID, String value) async {
    final http.Response response = await http.post(
      '$BASE_URL/api/Farms/Properties/Entities/COPValues/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode(<String, dynamic>{
        'EUID': entityID,
        'PUID': copID,
        'Value': value,
      }),
    );
    return response.statusCode == 201;
  }

  static Future<bool> deleteFarm(id) async {
    final http.Response response = await http.delete(
      '$BASE_URL/api/Farms/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
    );
    print(response.body);
    return response.statusCode == 200;
  }

  static Future<bool> deleteProperty(id) async {
    final http.Response response = await http.delete(
      '$BASE_URL/api/Farms/Properties/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
    );
    print(response.body);
    return response.statusCode == 200;
  }

  // User controller

  static Future<bool> isUsernameTaken(String username) async {
    final http.Response response =
        await http.get("$BASE_URL/api/Members/IsUsedUsername/$username");
    return response.body == 'true';
  }

  static Future<bool> isEmailTaken(String email) async {
    final http.Response response =
        await http.get("$BASE_URL/api/Members/IsUsedEmail/$email");
    return response.body == 'true';
  }

  static Future<String> getCodeForRegister() async {
    final http.Response response =
        await http.get("$BASE_URL/api/Members/GetNewUCodeForSignUp");
    return json.decode(response.body)['guc'];
  }

  static Future<bool> tryRegister(User user, String guc) async {
    final http.Response response = await http.post(
      '$BASE_URL/api/Members/SignUp',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Username': user.username,
        'Password': user.password,
        'Email': user.email,
        'Name': user.name,
        'Surname': user.surname,
        'Guc': guc,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<String> tryLogin(String username, String password) async {
    final http.Response response = await http.post(
      '$BASE_URL/api/Members/SignIn',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'SignInKey': username,
        'Password': password,
      }),
    );

    var body = json.decode(response.body);

    if (body['result']) {
      var jwt = body['token'];
      var expires = body['expiration'];
      await storage.write(key: "token", value: jwt);
      await storage.write(key: "expire", value: expires);
      return '{"result": true, "expiration":"$expires", "token":"$jwt"}';
    }

    return '{"result":false}';
  }
}
