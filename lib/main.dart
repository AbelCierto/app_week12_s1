import 'package:app_week12_s1/ui/shopping_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app_week12_s1/util/dbhelper.dart';
import 'package:app_week12_s1/models/shopping_list.dart';
import 'package:app_week12_s1/ui/items_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //DbHelper helper = DbHelper();
    //helper.testDB();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Week 12 S1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: ShowList(),
      ),
    );
  }
}

class ShowList extends StatefulWidget {
  const ShowList({Key? key}) : super(key: key);

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList = <ShoppingList>[];
  ShoppingListDialog ? dialog;
  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shopping List'),
      ),
      body: ListView.builder(
          itemCount: (shoppingList != null) ? shoppingList.length : 0,
          itemBuilder: (context,int index) {
            return ListTile(
              title: Text(shoppingList[index].name),
              leading: CircleAvatar(
                child: Text(shoppingList[index].priority.toString()),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  showDialog(context: context, builder: (BuildContext context) => dialog!.buildDialog(
                      context, shoppingList[index], false));
                },
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ItemScreen(shoppingList: shoppingList[index])));
              },
            );
          }

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ShoppingList list = ShoppingList(0, '', 0);
          showDialog(context: context, builder: (BuildContext context) => dialog!.buildDialog(
              context, list, true));
        },
        child: const Icon(Icons.plus_one),
        backgroundColor: Colors.green,
      )
    );
  }

  Future showData() async {
    await helper.openDb();
    shoppingList = await helper.getList();
    setState(() {
      shoppingList = shoppingList;
      print("Items: ${shoppingList.length}");
    });
  }
}

