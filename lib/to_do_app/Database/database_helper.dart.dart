import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // 📌 نستخدم Singleton (كائن واحد بس من الكلاس) علشان ما نفتـحش الداتابيز كل مرة
  static final DatabaseHelper instance = DatabaseHelper._init();

  // 📌 الداتابيز نفسها (Private علشان ما تتعدلش من بره)
  static Database? _database;

  // 📌 Constructor خاص (private) علشان نمنع عمل كائنات جديدة
  DatabaseHelper._init();

  // 📌 Getter بيرجع لنا نسخة واحدة من الداتابيز (يفتحها لو مش مفتوحة)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db'); // 📁 اسم ملف الداتابيز
    return _database!;
  }

  // 📌 تهيئة الداتابيز (لو مش موجودة بيعملها)
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // 📂 بنجيب مسار ملفات الداتابيز
    final path = join(dbPath, filePath);     // 📂 بنكون المسار النهائي للفايل

    // 📌 فتح أو إنشاء الداتابيز
    return await openDatabase(
        path,
        version: 4,         // 🔄 رقم النسخة (لو اتغير بيعمل onUpgrade)
        onCreate: _createDB // 🆕 يتنادى أول مرة ينشئ الداتابيز
    );
  }

  // 📌 إنشاء الجداول أول مرة (Table tasks)
  Future _createDB(Database db, int version) async {
    await db.execute('''
       CREATE TABLE tasks (
         id INTEGER PRIMARY KEY AUTOINCREMENT, 
         taskName TEXT NOT NULL,                
         taskTime TEXT NOT NULL,               
         taskDate TEXT NOT NULL,              
         priority INTEGER NOT NULL           
       )
    ''');
  }

  // 📌 إضافة مهمة جديدة
  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await instance.database;
    return await db.insert('tasks', task);
  }

  // 📌 إغلاق الداتابيز (لو حبيت في الآخر)
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // 📌 جلب كل المهام مرتبة حسب التاريخ والوقت
  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await instance.database;
    return await db.query(
      'tasks',
      orderBy: 'taskDate ASC, taskTime ASC', // ⬅️ الأول التاريخ بعدين الوقت
    );
  }

  // 📌 حذف مهمة معينة بالـ ID
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // 📌 تعديل بيانات مهمة معينة
  Future<int> updateTask(int id, Map<String, dynamic> values) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 📌 تعديل الأولوية بس للمهمة (لوحدها)
  Future<void> updateTaskPriority(int id, int priority) async {
    final db = await database;
    await db.update(
      'tasks',
      {'priority': priority},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
