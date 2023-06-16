import 'package:app_week12_s1/models/shopping_list.dart';
import 'package:flutter/material.dart';

import '../util/dbhelper.dart';

class ShoppingListDialog{
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew){
    DbHelper helper = DbHelper();
    if(!isNew){
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }
    return AlertDialog(
      title: Text((isNew)? 'New Shopping List': 'Edit Shopping List'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Type name'
              ),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Type Priority (1-3)'
              ),
            ),
            ElevatedButton(
              onPressed: (){
                list.name = txtName.text;
                list.priority = int.parse(txtPriority.text);
                helper.insertList(list);
                Navigator.pop(context);
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }

}