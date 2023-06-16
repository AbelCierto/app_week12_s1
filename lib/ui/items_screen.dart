import 'package:flutter/material.dart';
import 'package:app_week12_s1/util/dbhelper.dart';
import 'package:app_week12_s1/models/list_items.dart';
import 'package:app_week12_s1/ui/item_list_dialog.dart';
import 'package:app_week12_s1/models/shopping_list.dart';

import 'item_list_dialog.dart';

class ItemScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  const ItemScreen({Key? key, required this.shoppingList}) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState(this.shoppingList);
}

class _ItemScreenState extends State<ItemScreen> {
  final ShoppingList shoppingList;
  _ItemScreenState(this.shoppingList);

  DbHelper ? helper = DbHelper();
  List<ListItem> items = <ListItem>[];
  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(this.shoppingList.id);
    ItemListDialog dialog = ItemListDialog();
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: (items != null) ? items.length : 0,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(items[index].name),
            subtitle: Text('Cantidad: ${items[index].quantity} - Nota: ${items[index].note}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: (){
                  showDialog(context: context, builder: (BuildContext context) => dialog.buildDialog(context, items[index], false));
              },
            ),
            onTap: (){},
          );
        },
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ListItem item = ListItem(0, 0, '', '', shoppingList.id.toString());
            showDialog(context: context, builder: (BuildContext context) => dialog.buildDialog(context, item, true));
          },
          child: const Icon(Icons.add),
          tooltip: 'Add new Item',
        )

    );
  }

  Future showData(int idList) async {
    await helper!.openDb();
    items = await helper!.getItems(idList);
    setState(() {
      items = items;
    });
  }
}
