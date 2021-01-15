import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/models/field.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../main.dart';

class CategoryProvider extends ChangeNotifier {
  Future<List<Category>> firstFuture;
  Future<List<Category>> secondFuture = Future.value([]);
  Future<List<Category>> thirdFuture = Future.value([]);
  List<Future> futureList;

  CategoryProvider(Future first) {
    this.firstFuture = first;
    this.secondFuture = Future.value([]);
    this.thirdFuture = Future.value([]);
    futureList = [firstFuture, secondFuture, thirdFuture];
  }

  void setFuture(Future newFuture, int order) {
    futureList[order] = newFuture;
    if (order == 1) {
      thirdFuture = Future.value([]);
    }
    notifyListeners();
  }
}

// ignore: camel_case_types

// ignore: camel_case_types
class newEntity extends StatefulWidget {
  const newEntity({Key key, this.property}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
  final Property property;
}

class _MyHomePageState extends State<newEntity> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _countController = TextEditingController();
  TextEditingController _idController = TextEditingController();

  Category c1;
  Category c2;
  Category c3;

  List<DropdownMenuItem<int>> firstCategories;
  List<DropdownMenuItem<int>> secondCategories;
  List<DropdownMenuItem<int>> thirdCategories;
  List<List<DropdownMenuItem<int>>> categoryList;
  List<Category> selectedCategoryList = [];
  List<int> selectedCategoryIndex;
  List<bool> dropdownVisibilities = [true, false, false];
  bool checkBoxValue = false;
  bool checkBoxValueNew = false;
  bool hasError = false;
  bool succesful = false;

  bool get _addDisabled {
    return entityCategory == null;
  }

  String get _health {
    return checkBoxValue ? "Diseased" : "Healty";
  }

  Category get entityCategory {
    if (selectedCategoryIndex[2] != 0) return selectedCategoryList[2];
    if (selectedCategoryIndex[1] != 0) return selectedCategoryList[1];
    if (selectedCategoryIndex[0] != 0) return selectedCategoryList[0];
    return null;
  }

  @override
  void initState() {
    super.initState();
    firstCategories = [new DropdownMenuItem(child: Text("-"), value: 0)];
    secondCategories = [new DropdownMenuItem(child: Text("-"), value: 0)];
    thirdCategories = [new DropdownMenuItem(child: Text("-"), value: 0)];
    categoryList = [firstCategories, secondCategories, thirdCategories];
    selectedCategoryList = [c1, c2, c3];
    selectedCategoryIndex = [0, 0, 0];
  }

  Widget dropDown(int order, context) {
    var provider = Provider.of<CategoryProvider>(context, listen: false);
    return FutureBuilder<List<Category>>(
      future: provider.futureList[order],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return new Container();
        } else if (snapshot.hasData) {
          categoryList[order].clear();
          var dropDownItemsMap = new Map();
          categoryList[order]
              .add(new DropdownMenuItem(child: Text('-'), value: 0));
          snapshot.data.forEach((category) {
            int index = snapshot.data.indexOf(category);
            dropDownItemsMap[index + 1] = category;
            categoryList[order].add(new DropdownMenuItem(
                child: Text(category.name), value: index + 1));
          });
          return DropdownButton(
            items: categoryList[order],
            value: selectedCategoryIndex[order],
            onChanged: (int selectedIndex) {
              setState(() {
                selectedCategoryIndex[order] = selectedIndex;
                selectedCategoryList[order] = dropDownItemsMap[
                    selectedIndex]; //categoryList[order][selectedIndex].value
                switch (order) {
                  case 0:
                    dropdownVisibilities[1] = selectedIndex != 0;
                    dropdownVisibilities[2] = false;
                    selectedCategoryIndex[1] = 0;
                    selectedCategoryIndex[2] = 0;
                    break;
                  case 1:
                    dropdownVisibilities[2] = selectedIndex != 0;
                    selectedCategoryIndex[2] = 0;
                    break;
                  default:
                }
                if (order != 2 && selectedIndex != 0) {
                  provider.setFuture(
                      API.getSubCategories(selectedCategoryList[order].id),
                      order + 1);
                }
              });
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  List<DropdownMenuItem<Category>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<Category>> items = List();
    for (Category listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Widget checkWidget() {
    return Checkbox(
        value: checkBoxValue,
        onChanged: (bool value) {
          setState(() {
            checkBoxValue = value;
          });
        });
  }

  Widget checkWidgetNew() {
    return Checkbox(
        value: checkBoxValueNew,
        onChanged: (bool value) {
          setState(() {
            checkBoxValueNew = value;
          });
        });
  }

  _onAddButtonClicked() async {
    if (!_formKey.currentState.validate()) return;
    API
        .createEntity(entityCategory.id, widget.property.id, _idController.text,
            'name', 'desc', int.parse(_countController.text))
        .then((value) {
      setState(() {
        if (value == null) {
          hasError = true;
          return;
        }
        API.addCOPValue(value.id, 3, _health).then((value) => onAddSuccesful());
      });
    });
  }

  onAddSuccesful() {
    setState(() {
      _idController.clear();
      _countController.clear();
      selectedCategoryIndex[0] = 0;
      dropdownVisibilities[1] = false;
      dropdownVisibilities[2] = false;
      checkBoxValue = false;
      hasError = false;
      succesful = true;
    });
  }

  _getAddButton() {
    return FlatButton(
      disabledColor: Colors.green[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.green,
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Text(
        'EKLE',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: _addDisabled ? null : _onAddButtonClicked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CategoryProvider(API.getSubCategories(1)),
        builder: (ctx, wid) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (hasError)
                        Text(
                          'Bir hata oluştu, lütfen tekrar deneyin.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
                      if (succesful)
                        Text(
                          'Ekleme başarıyla tamamlandı.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                          ),
                        ),
                      new Text(
                        'ÜRÜN EKLE',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(1.0)),
                      ),
                      if (dropdownVisibilities[0]) dropDown(0, ctx),
                      if (dropdownVisibilities[1]) dropDown(1, ctx),
                      if (dropdownVisibilities[2]) dropDown(2, ctx),
                      Container(
                          padding: const EdgeInsets.fromLTRB(160, 0, 160, 0),
                          child: new Column(
                            children: <Widget>[
                              new TextFormField(
                                controller: _countController,
                                validator: (String value) {
                                  if (value.isEmpty) return "Boş kalamaz";
                                  return null;
                                },
                                decoration:
                                    new InputDecoration(labelText: "Adet"),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                              ),
                            ],
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(140, 0, 140, 0),
                          child: new Column(
                            children: <Widget>[
                              new TextFormField(
                                controller: _idController,
                                decoration: new InputDecoration(
                                    labelText: "Numara (Sayı-Sayı)"),
                                keyboardType: TextInputType.number,
                                inputFormatters: <
                                    TextInputFormatter>[], // Only numbers can be entered
                              ),
                            ],
                          )),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            checkWidget(),
                            Text("Hasta"),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            checkWidgetNew(),
                            Text("Yeni"),
                          ]),
                      _getAddButton(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
