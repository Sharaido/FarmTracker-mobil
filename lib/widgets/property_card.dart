import 'package:flutter/material.dart';
import 'package:flutter_app/models/field.dart';
import 'package:flutter_app/pages/field_details.dart';
import 'package:flutter_app/pages/test-pages/farm_properties.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final Function stateChanged;
  const PropertyCard({Key key, this.property, this.stateChanged})
      : super(key: key);

  Color get borderColor {
    return property.categoryID == 1 ? Colors.green[200] : Colors.blue[200];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(routeRightToLeft(FieldDetails(
            property: property,
          )))
              .then((value) {
            Provider.of<PropertyProvider>(context, listen: false)
                .updateFuture(property.farmID);
            stateChanged();
          });
        },
        child: Card(
          color: Colors.grey[100],
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 5, color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${property.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                if (property.desc != "")
                  Text(
                    '${property.desc}',
                    style: TextStyle(color: Colors.black),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
