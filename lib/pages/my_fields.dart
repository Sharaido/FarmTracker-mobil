import 'package:flutter/material.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/widgets/custom/custom_drawer.dart';
import 'package:flutter_app/widgets/fieldcart.dart';
import 'package:unicorndial/unicorndial.dart';

class MyFields extends StatelessWidget {
  List<Field> fields = [
    new Field(0, "My Field 1", 40, "6105 Bonita Rd #APT K108 Lake Oswego, Oregon(OR), 97035", [
      new Farm(0, "My Farm 1", 40, 5, [
        new Entity(0, "entity1", 1),
        new Entity(1, "entity2", 2),
        new Entity(2, "entity3", 3),
      ]),
    ]),
    new Field(0, "My Field 2", 120, "11789 Alpine Dr SW Port Orchard, Washington(WA), 98367", [
      new Farm(0, "My Farm 2", 50, 5, [
        new Entity(0, "entity1", 1),
        new Entity(1, "entity2", 2),
        new Entity(2, "entity3", 3),
        new Entity(3, "entity4", 4),
      ]),
      new Farm(0, "My Farm 3", 40, 5, [
        new Entity(0, "entity1", 1),
        new Entity(1, "entity2", 2),
        new Entity(2, "entity3", 3),
        new Entity(3, "entity4", 4),
      ]),
      new Farm(0, "My Farm 4", 30, 5, [
        new Entity(0, "entity1", 1),
        new Entity(1, "entity2", 2),
        new Entity(2, "entity3", 3),
        new Entity(3, "entity4", 4),
      ]),
    ]),
    new Field(0, "My Field 3", 130, "135 17th St Wilmette, Illinois(IL), 60091", [
      new Farm(0, "My Farm 5", 100, 5, [
        new Entity(0, "entity1", 5),
        new Entity(1, "entity2", 5),
        new Entity(2, "entity3", 3),
        new Entity(3, "entity4", 4),
      ]),
      new Farm(0, "My Farm 6", 30, 5, [
        new Entity(0, "entity1", 5),
        new Entity(1, "entity2", 5),
        new Entity(2, "entity3", 3),
        new Entity(3, "entity4", 4),
      ]),
    ]),
    new Field(0, "My Field 4", 90, "25546 Alisal Ave Laguna Hills, California(CA), 92653", [
      new Farm(0, "My Farm 7", 30, 5, [
        new Entity(0, "entity1", 1),
        new Entity(1, "entity2", 2),
        new Entity(2, "entity3", 3),
        new Entity(3, "entity4", 4),
      ]),
      new Farm(0, "My Farm 8", 60, 5, [
        new Entity(0, "entity1", 1),
        new Entity(1, "entity2", 2),
        new Entity(2, "entity3", 3),
        new Entity(3, "entity4", 4),
      ]),
    ]),
    new Field(0, "My Field 5", 150, "765 Union Church Rd #9 Brookhaven, Mississippi(MS), 39601", [
      new Farm(0, "My Farm 9", 50, 5, [
        new Entity(0, "entity1", 1),
        new Entity(1, "entity2", 2),
        new Entity(2, "entity3", 3),
        new Entity(3, "entity4", 4),
      ]),
      new Farm(0, "My Farm 10", 50, 5, [
        new Entity(0, "entity1", 1),
        new Entity(1, "entity2", 2),
        new Entity(2, "entity3", 3),
        new Entity(3, "entity4", 1),
      ]),
      new Farm(0, "My Farm 11", 50, 5, [
        new Entity(0, "entity1", 1),
        new Entity(1, "entity2", 1),
        new Entity(2, "entity3", 1),
        new Entity(3, "entity4", 1),
      ]),
    ])
  ];
  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: "search",
      backgroundColor: Colors.green,
      mini: true,
      child: Icon(Icons.search),
      onPressed: () {},
    )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: "add",
      backgroundColor: Colors.green,
      mini: true,
      child: Icon(Icons.add),
      onPressed: () {},
    )));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My fields'.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[200],
        iconTheme: new IconThemeData(color: Colors.green[600]),
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 70, top: 10),
          cacheExtent: 100,
          itemCount: fields.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 3, 12, 5),
              child: FieldCard(field: fields[index]),
            );
          },
        ),
      ),
      drawer: CustomDrawer('MY FIELDS'),
      floatingActionButton: UnicornDialer(
          hasBackground: false,
          parentButtonBackground: Colors.green,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.menu),
          childButtons: childButtons),
    );
  }
}
