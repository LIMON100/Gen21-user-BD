import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../common/sqf_lite_key.dart';
import '../models/add_to_cart_model.dart';

class DatabaseHelper extends GetxService {
//   Database db;
//
//   SqfLiteClient()  {
//     db = await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//           await db.execute('''
// create table $tableTodo (
//   $columnId integer primary key autoincrement,
//   $columnTitle text not null,
//   $columnDone integer not null)
// ''');
//         });
//   }
// }
  static final _databaseName = "gen21User.db";

// final String tableAddToCart = 'cart';

  static final _databaseVersion = 1;

  // static final table = "cart";
  // static final columnId = 'id';
  // static final columnTitle = 'title';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // static final String columnId = 'id';
  // static final String columnType = 'type';
  // static final String columnServiceId = 'service_id';
  // static final String columnName = 'name';
  // static final String columnImageUrl = 'image_url';
  // static final String columnPrice = 'price';
  // static final String columnMinimumUnit = 'minimum_unit';
  // static final String columnAddedUnit = 'added_unit';
  // $SqfLiteKey.columnId INTEGER PRIMARY KEY AUTOINCREMENT,
  Future _onCreate(Database db, int version) async {
    print("sjndfjsan _onCreate called in helper");

    await db.execute('''
  CREATE TABLE ${SqfLiteKey.tableAddToCart} (
  
    ${SqfLiteKey.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${SqfLiteKey.columnType} String,
     ${SqfLiteKey.columnServiceName} String,
      ${SqfLiteKey.columnServiceId} String,
        ${SqfLiteKey.columnName} String,
          ${SqfLiteKey.columnImageUrl} String,
            ${SqfLiteKey.columnPrice} String,
              ${SqfLiteKey.columnMinimumUnit} String,
                ${SqfLiteKey.columnAddedUnit} String
  )
  ''');
  }

  Future<int> insert(AddToCart addToCart) async {
    Database db = await instance.database;
    var res = await db.insert(SqfLiteKey.tableAddToCart, addToCart.toMap());
    print("fasfdsa $res");
    return res;
  }

  Future<int> find(String serviceId, String serviceType) async {
    Database db = await instance.database;
    var res = await db.query(SqfLiteKey.tableAddToCart,
        where:
            '${SqfLiteKey.columnServiceId} = ? and ${SqfLiteKey.columnType} = ?',
        whereArgs: [serviceId, serviceType]);
    print("djfjsanfd  query data: ${res.toString()}");
    List<AddToCart> list =
        res.isNotEmpty ? res.map((c) => AddToCart.fromMap(c)).toList() : [];
    print("djfjsanfd  query data length: ${list.length}");

    if (list.length > 0) {
      return int.parse(list[0].added_unit);
    } else {
      return 0;
    }
    print("djfjsanfd  model data: ${list.toString()}");
    // List<AddToCart>
    // return data;
  }

  Future<int> update(String serviceId, String currentAddedUnit) async {
    Database db = await instance.database;
    // return await db.update(SqfLiteKey.tableAddToCart, where: '$columnId = ?', whereArgs: [id], );

    return await db.rawUpdate(
        'UPDATE ${SqfLiteKey.tableAddToCart} SET ${SqfLiteKey.columnAddedUnit} = ? WHERE ${SqfLiteKey.columnServiceId} = ?',
        ['$currentAddedUnit', '${serviceId}']);

    // print('updated: $count');
    // print("djfjsanfd ${data.length.toString()}");
    // return data.length;
  }

  Future<List<AddToCart>> getAllAddToCartData() async {
    Database db = await instance.database;
    var res = await db.query(SqfLiteKey.tableAddToCart,
        orderBy: "${SqfLiteKey.columnId} DESC");
    List<AddToCart> list =
        res.isNotEmpty ? res.map((c) => AddToCart.fromMap(c)).toList() : [];
    return list;
  }

  //
  // Future<int> delete(int id) async {
  //   Database db = await instance.database;
  //   return await db.delete(SqfLiteKey.tableAddToCart, where: '$columnId = ?', whereArgs: [id]);
  // }

  Future<void> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM ${SqfLiteKey.tableAddToCart}");
  }
}
