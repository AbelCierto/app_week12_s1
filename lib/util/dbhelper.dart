import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_week12_s1/models/list_items.dart';
import 'package:app_week12_s1/models/shopping_list.dart';

class DbHelper{
  final int version = 1;
  Database? db;
  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper(){
    return _dbHelper;
  }

  Future<Database> openDb() async{
    if(db == null){
      db = await openDatabase(
        join(await getDatabasesPath(), 'shopping_v1.db'),
        onCreate: (database, version){
          database.execute(
            'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)',
          );
          database.execute(
            'CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER,'
                'name TEXT, quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES lists(id))',
          );
        },
        version: version,
      );
    }
    return db!;
  }

  //Vamos a probar la BD
  Future testDB() async{
    db = await openDb();
    await db!.execute('INSERT INTO lists VALUES(0, "Memorias", 1)');
    await db!.execute('INSERT INTO items VALUES(0, 0, "Memoria DDR4", "8 Unidades", "Marca Kingston")');
    List lists = await db!.rawQuery('SELECT * FROM lists');
    List items = await db!.rawQuery('SELECT * FROM items');
    print(lists[0]);
    print(items[0]);
  }

  Future<int> insertList(ShoppingList list) async{
    int id = await this.db!.insert('lists', list.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<int> insertItem(ListItem item) async{
    int id = await this.db!.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<ShoppingList>> getList() async {
    final List<Map<String, dynamic>> maps = await db!.query('lists');
    return List.generate(maps.length, (i) {
      return ShoppingList(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['priority'],
      );
    });
  }

  Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps = await db!.query('items',
        where: 'idList = ?',
        whereArgs: [idList]);
    return List.generate(maps.length, (i) {
      return ListItem(
        maps[i]['id'],
        maps[i]['idList'],
        maps[i]['name'],
        maps[i]['quantity'],
        maps[i]['note'],
      );
    });
  }
}