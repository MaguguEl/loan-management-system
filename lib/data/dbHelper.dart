// import 'package:loan_management_system/features/member_management/model/member_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;

//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB();
//     return _database!;
//   }

//   Future<Database> _initDB() async {
//     String path = join(await getDatabasesPath(), 'members.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE members (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name TEXT,
//             phone TEXT,
//             email TEXT,
//             ward TEXT,
//             shares TEXT,
//             noteDescription TEXT
//           )
//         ''');
//       },
//     );
//   }

//   Future<int> insertMember(Member member) async {
//     final db = await database;
//     return await db.insert('members', member.toMap());
//   }

//   Future<List<Member>> getMembersList() async {
//     final db = await database;
//     final List<Map<String, dynamic>> memberMaps = await db.query('members');

//     return List.generate(memberMaps.length, (i) {
//       return Member(
//         id: memberMaps[i]['id'],
//         name: memberMaps[i]['name'],
//         phone: memberMaps[i]['phone'],
//         email: memberMaps[i]['email'],
//         ward: memberMaps[i]['ward'],
//         shares: memberMaps[i]['shares'],
//         noteDescription: memberMaps[i]['noteDescription'],
//       );
//     });
//   }

//   Future<int> updateMember(Member member) async {
//     final db = await database;
//     return await db.update(
//       'members',
//       member.toMap(),
//       where: 'id = ?',
//       whereArgs: [member.id],
//     );
//   }

//   Future<int> deleteMember(int id) async {
//     final db = await database;
//     return await db.delete(
//       'members',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }

