import 'package:flutter/material.dart';
import '../models/list_items.dart';
import '../util/dbhelper.dart';

class ItemListDialog{
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem item, bool isNew){
    DbHelper helper = DbHelper();
    if(!isNew){
      txtName.text = item.name;
      txtQuantity.text = item.quantity;
      txtNote.text = item.note;
    }
    else{
      txtName.text = '';
      txtQuantity.text = '';
      txtNote.text = '';
    }
    return AlertDialog(
      title: Text((isNew)? 'New Item List': 'Edit Item List'),
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
              controller: txtQuantity,
              decoration: InputDecoration(
                  hintText: 'Type quantity'
              ),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(
                  hintText: 'Type note'
              ),
            ),
            ElevatedButton(
              onPressed: (){
                item.name = txtName.text;
                item.quantity = txtQuantity.text;
                item.note = txtNote.text;
                helper.insertItem(item);
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