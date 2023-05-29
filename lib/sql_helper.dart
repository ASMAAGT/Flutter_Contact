import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:project_db/Contact.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{
  static Future<void> createTables(sql.Database database)async{
    await database.execute("""CREATE TABLE data(id integer Primary Key AUTOINCREMENT,"
        "nom TEXT NOT NULL,"
        "tel TEXT,"
        "createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ")""");

  }

  //constructeur pour executer data base
  //getdatabase pth dosse par defaut eli 7ot fih phone les donnees
   static Future<sql.Database> db() async{
    return sql.openDatabase("database_name.db",
        version: 1,
        onCreate: (sql.Database database, int version) async{
      await createTables(database);
    }
    );
   }

  static Future<int> createData(String? nom, String? tel) async {
    final db = await SQLHelper.db();
    final data = {'nom': nom, 'tel': tel};
    final id = await db.insert(
        'data', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }
//key de type string,dynamic ay no3
  static Future<List<Map <String, dynamic>>> GetAllData() async {
    final db = await SQLHelper.db();
    return db.query('data', orderBy: 'id');
  }
  static Future<List<Map <String, dynamic>>> GetSingleData(int id) async {
    final db = await SQLHelper.db();
    return db.query('data', where: "id=?", whereArgs: [id], limit: 1);
  }

  static Future<void> deleteData(int id) async{
    final db = await SQLHelper.db();
    try{
      await db.delete('data', where: "id = ?", whereArgs: [id]);
    }
    catch(e){}
  }

  static Future<int> updateData(int id, String nom, String? tel) async {
    final db = await SQLHelper.db();
    final data ={
      'nom': nom,
      'tel' : tel,
      'createAt': DateTime.now().toString()
    };
    final result= await db.update('data', data, where: "id = ?", whereArgs: [id]);
    return result;
  }


}

