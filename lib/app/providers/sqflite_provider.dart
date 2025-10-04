import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../common/sqf_lite_key.dart';
import '../models/add_to_cart_model.dart';
import 'database_helper.dart';

class SqfLiteProvider {
  Database db;
  static final _databaseName = "gen21User.db";
  static final _databaseVersion = 1;

  SqfLiteProvider() {
     openDB();
  }


  Future openDB() async {
    try {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, _databaseName);

      // open the database
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          print(db);
          this.db = db;
          createTables();
        },
      );
      return true;
    } catch (e) {
      print("ERROR IN OPEN DATABASE $e");
      return Future.error(e);
    }
  }

  // Future openDB() async {
  //   // try {
  //   //   print("sdnfjknaf openDB called in provider");
  //   //   String path = join(await getDatabasesPath(), _databaseName);
  //   //
  //   //   // Get a location using getDatabasesPath
  //   //   // var databasesPath = await getDatabasesPath();
  //   //   // String path = join(databasesPath, 'gen21User.db');
  //   //   //
  //   //   // // open the database
  //   //   db = await openDatabase(
  //   //     path,
  //   //     version: 1,
  //   //     onCreate: (Database db, int version) async {
  //   //       print(db);
  //   //       this.db = db;
  //   //       _onCreate;
  //   //     },
  //   //   );
  //   //
  //   //   // String path = join(await getDatabasesPath(), _databaseName);
  //   //   // return await openDatabase(path,
  //   //   //     version: _databaseVersion, onCreate: _onCreate);
  //   //
  //   //   // return await openDatabase(path,
  //   //   //     version: _databaseVersion, onCreate: _onCreate);
  //   // } catch (e) {
  //   //   print("sdnfjknaf ERROR IN OPEN DATABASE $e");
  //   //   return Future.error(e);
  //   // }
  //
  //   try {
  //     // Get a location using getDatabasesPath
  //     var databasesPath = await getDatabasesPath();
  //     String path = join(databasesPath, 'gen21User.db');
  //
  //     // open the database
  //     db = await openDatabase(
  //       path,
  //       version: 1,
  //       onCreate: (Database db, int version) async {
  //         print(db);
  //         this.db = db;
  //         _createTables();
  //       },
  //     );
  //     return true;
  //   } catch (e) {
  //     print("ERROR IN OPEN DATABASE $e");
  //     return Future.error(e);
  //   }
  //
  //
  // }

  Future createTables() async {
    try {
      // var qry = "CREATE TABLE IF NOT EXISTS shopping ( "
      //     "id INTEGER PRIMARY KEY,"
      //     "name TEXT,"
      //     "image Text,"
      //     "price REAL,"
      //     "fav INTEGER,"
      //     "rating REAL,"
      //     "datetime DATETIME)";
      // await db?.execute(qry);
      // qry = "CREATE TABLE IF NOT EXISTS cart_list ( "
      //     "id INTEGER PRIMARY KEY,"
      //     "shop_id INTEGER,"
      //     "name TEXT,"
      //     "image Text,"
      //     "price REAL,"
      //     "fav INTEGER,"
      //     "rating REAL,"
      //     "datetime DATETIME)";
      //
      // await db?.execute(qry);

      // ${SqfLiteKey.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
      // ${SqfLiteKey.columnType} String,
      //   ${SqfLiteKey.columnServiceId} String,
      //     ${SqfLiteKey.columnName} String,
      //       ${SqfLiteKey.columnImageUrl} String,
      //         ${SqfLiteKey.columnPrice} String,
      //           ${SqfLiteKey.columnMinimumUnit} String,
      //             ${SqfLiteKey.columnAddedUnit} String

      await db.execute('''
  CREATE TABLE ${SqfLiteKey.tableAddToCart} (
      ${SqfLiteKey.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${SqfLiteKey.columnType} String,
      ${SqfLiteKey.columnServiceId} String,
       ${SqfLiteKey.columnServiceName} String,
        ${SqfLiteKey.columnName} String,
          ${SqfLiteKey.columnImageUrl} String,
            ${SqfLiteKey.columnPrice} String,
            ${SqfLiteKey.columnDiscountPrice} String,
              ${SqfLiteKey.columnMinimumUnit} String,
                ${SqfLiteKey.columnAddedUnit} String
  )
  ''');
    } catch (e) {
      print("ERROR IN CREATE TABLE");
      print(e);
    }
  }

  // Future _onCreate(Database db, int version) async {
  //   print("sjndfjsan ${db.toString()}");
  //   await this.db.execute('''
  // CREATE TABLE ${SqfLiteKey.tableAddToCart} (
  //
  //   ${SqfLiteKey.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
  //   ${SqfLiteKey.columnType} String,
  //     ${SqfLiteKey.columnServiceId} String,
  //      ${SqfLiteKey.columnServiceName} String,
  //       ${SqfLiteKey.columnName} String,
  //         ${SqfLiteKey.columnImageUrl} String,
  //           ${SqfLiteKey.columnPrice} String,
  //             ${SqfLiteKey.columnMinimumUnit} String,
  //               ${SqfLiteKey.columnAddedUnit} String
  // )
  // ''');
  // }

  Future<List<AddToCart>> getCartList() async {
    try {
      var data = await db?.rawQuery('SELECT * FROM cart', []);

      List<AddToCart> list =
      data.isNotEmpty ? data.map((c) => AddToCart.fromMap(c)).toList() : [];

      return list ?? [];
    } catch (e) {
      return Future.error(e);
    }
  }

  // Future addToCart(ShopItemModel data) async {
  //   await this.db?.transaction((txn) async {
  //     var qry =
  //         'INSERT INTO cart_list(shop_id, name, price, image,rating,fav) VALUES(${data.id}, "${data.name}",${data.price}, "${data.image}",${data.rating},${data.fav ? 1 : 0})';
  //     int id1 = await txn.rawInsert(qry);
  //     return id1;
  //   });
  // }

  // Future removeFromCart(int shopId) async {
  //   var qry = "DELETE FROM cart_list where shop_id = ${shopId}";
  //   return await this.db?.rawDelete(qry);
  // }

  Future<int> insertToCart(AddToCart addToCart) async {
    var res = await db.insert(SqfLiteKey.tableAddToCart, addToCart.toMap());
    print("fasfdsa $res");
    return res;
  }

  Future<int> removeFromCart(String serviceId, String type) async {
    print("sjndfjsan removeFromCart called in sqflite provider");

    // return await db.update(SqfLiteKey.tableAddToCart, where: '$columnId = ?', whereArgs: [id], );

    return await db.delete(SqfLiteKey.tableAddToCart,
        where:
            '${SqfLiteKey.columnServiceId} = ? and ${SqfLiteKey.columnType} = ?',
        whereArgs: ['$serviceId', '${type}']);

    // return await db.rawDelete(
    //
    //     'delete ${SqfLiteKey.tableAddToCart} WHERE ${SqfLiteKey.columnServiceId} = ? and ${SqfLiteKey.columnType} = ?',
    //     ['$serviceId',  '${type}']);

    // print('sjndfjsan: $count');
    // print("djfjsanfd ${data.length.toString()}");
    // return data.length;
  }

  Future<int> findAddedCartUnit(String id, String type) async {
    // Database db = await instance.database;
    var res = await db.query(SqfLiteKey.tableAddToCart,
        where:
            '${SqfLiteKey.columnServiceId} = ? and ${SqfLiteKey.columnType} = ?',
        whereArgs: [id, type]);
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

  // Future<int> decrement(String id, String type, int){
  //
  // }

  Future<int> updateCart(String id, String type, int minimumUnit) async {
    // Database db = await instance.database;
    // return await db.update(SqfLiteKey.tableAddToCart, where: '$columnId = ?', whereArgs: [id], );

    return await db.rawUpdate(
        'UPDATE ${SqfLiteKey.tableAddToCart} SET ${SqfLiteKey.columnAddedUnit} = ? WHERE ${SqfLiteKey.columnServiceId} = ? and ${SqfLiteKey.columnType} = ?',
        ['$minimumUnit', '$id', '$type']);

    // print('updated: $count');
    // print("djfjsanfd ${data.length.toString()}");
    // return data.length;
  }

  Future deleteAllCart() async{
   var data = await db.rawQuery('delete FROM "${SqfLiteKey.tableAddToCart}"');
   print("sjkfnak ${data.toString()}");
  }
}
