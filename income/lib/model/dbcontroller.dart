import 'package:income/model/model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class DbController {
  static Database? database;
  Future<Database?> get db async {
    if (database != null) {
      return database;
    } else {
      database = await initDatabase();
      return database;
    }
  }

  Future<Database?> initDatabase() async {
    io.Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.toString(), "mydbs.db");

    var db = await openDatabase(path, version: 1, onCreate: (db, version) {
      String userTable =
          'create table user(name text, email text, password text,id text)';
      String dataTable =
          'create table data(title text,amount integer,id text,date Text,type text)';
      db.execute(userTable);
      db.execute(dataTable);
    });
    return db;
  }

  Future<List<Data>> insertData(List<Data> data) async {
    var dbclient = await db;
    if (dbclient != null)
      for (var item in data) {
        await dbclient.insert('data', item.toJson());
        print("yse");
      }
    return data;
  }

  Future<int> deleteData(String id) async {
    var dbclient = await db;
    var res = await dbclient!.delete('data', where: "id=?", whereArgs: [id]);
    return res;
  }

  Future<bool> insertUser(User user) async {
    var dbclient = await db;
    var res = await dbclient!.insert('user', user.toJson());
    print("res$res");
    return res == 1 ? true : false;
  }

  Future<List<User>> getUser() async {
    var dbclient = await db;
    if (dbclient == null) {
      return [];
    }
    List<Map<String, Object?>> result = await dbclient.query(
      'user',
      limit: 1,
    );

    return result.map((e) => User.fromJson(e)).toList();
  }

  Future<int> deleteUser(String email) async {
    var dbclient = await db;
    var res =
        await dbclient!.delete('user', where: "email=?", whereArgs: [email]);

    return res;
  }

  Future<List<Data>> getData(String type, int dataType,
      {String startDate = "", String endDate = ""}) async {
    //dataType is today  or one month or one year or yearly data
    var dbclient = await db;

    if (dbclient == null) {
      return [];
    }
    switch (dataType) {
      //case 0 for today data
      case 0:
        DateTime now = DateTime.now();
        String today =
            DateTime(now.year, now.month, now.day).toLocal().toString();
        List<Map<String, Object?>> result = await dbclient.query(
          'data',
          where: "type =? AND date=?",
          whereArgs: [type, today],
        );

        return result.map((e) => Data.fromJson(e)).toList();
      //case 1 for one month data
      case 1:
        List<Map<String, Object?>> result = await dbclient.query(
          'data',
          where: "type =? AND date BETWEEN ? AND ?",
          whereArgs: [type, startDate, endDate],
        );

        return result.map((e) => Data.fromJson(e)).toList();
      // case 2 for one year data
      case 2:
        List<Map<String, Object?>> result = await dbclient.rawQuery('''
    SELECT strftime('%Y-%m', date) AS month,
           SUM(amount) AS amount,
           title,id,date
    FROM data
    WHERE type = ? AND date BETWEEN ? AND ?
    GROUP BY month
  ''', [type, startDate, endDate]);

        // print(result);
        return result.map((e) => Data.fromJson(e)).toList();
      case 3:
        print("case 3");
        List<Map<String, Object?>> result = await dbclient.rawQuery(
            '''SELECT strftime('%Y',date) AS year,title,id,date,Sum(amount) AS amount FROM data WHERE type=? GROUP BY year''',
            [type]);

        return result.map((e) => Data.fromJson(e)).toList();
      case 4:
        //for geting the data of specific title  on a day
        print("start$startDate");
        print("enddate$endDate");

        List<Map<String, Object?>> result = endDate != ""
            ? await dbclient.rawQuery('''
    SELECT 
           SUM(amount) AS amount,
           title,id,date
    FROM data
    WHERE type = ? AND date BETWEEN ? AND ?
    GROUP BY title
  ''', [type, startDate, endDate])
            : await dbclient.rawQuery('''
    SELECT 
           SUM(amount) AS amount,
           title,id,date
    FROM data
    WHERE type = ? AND date BETWEEN ? AND ?
    GROUP BY title
  ''', [type, startDate, endDate]);
        print("one month data end");

        // print(result);
        return result.map((e) => Data.fromJson(e)).toList();
      default:
        return [];
    }
  }

  Future<List<Data>> getAllData() async {
    var dbclient = await db;
    if (dbclient == null) {
      return [];
    }

    List<Map<String, Object?>> result = await dbclient.query(
      'data',
    );
    return result.map((e) => Data.fromJson(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getDaybyDayData(
    String type,
    String endDate,
    String startDate,
  ) async {
    var dbclient = await db;
    if (dbclient == null) {
      return [];
    }

    List<Map<String, dynamic>> result = await dbclient.rawQuery('''
    SELECT date, SUM(amount) AS amount,title,id
    FROM data
    WHERE type = ? AND date BETWEEN ? AND ?
    GROUP BY date
  ''', [type, startDate, endDate]);

    return result;
  }

  Future<List<Data>> getSpecificData(bool isDate, String type, String startDate,
      String endDate, String data) async {
    var dbclient = await db;
    if (dbclient == null) {
      return [];
    }
    if (isDate) {
      List<Map<String, Object?>> result = await dbclient.rawQuery(
          '''SELECT * FROM data WHERE type=? AND date BETWEEN ? AND ?''',
          [type, startDate, endDate]);
      return result.map((e) => Data.fromJson(e)).toList();
    } else {
      List<Map<String, Object?>> result = await dbclient.rawQuery(
          '''SELECT * FROM data WHERE type=? AND AND title=? AND date BETWEEN ? AND ?''',
          [type, data, startDate, endDate]);
      return result.map((e) => Data.fromJson(e)).toList();
    }
  }

  Future<List<Data>> getYsetrdayData(String type, String date) async {
    var dbclient = await db;
    if (dbclient == null) return [];
    List<Map<String, Object?>> result = await dbclient.query(
      'data',
      where: "type =? AND date =?",
      whereArgs: [type, date],
    );
    print(result.length);
    return result.map((e) => Data.fromJson(e)).toList();
  }

  Future<List<Data>> searchData(String type, String filter) async {
    var dbclient = await db;
    if (dbclient == null) return [];
    List<Map<String, Object?>> result = await dbclient.query(
      'data',
      where: "type =? AND date =? OR  title=?",
      whereArgs: [type, filter, filter],
    );
    print(result.length);
    return result.map((e) => Data.fromJson(e)).toList();
  }
}
