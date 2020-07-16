import 'package:gastos_management/model/wallet.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String TABLE_WALLET = "wallet";
  static const String COLUMN_ID = "id";
  static const String COLUMN_DESCRIPTION = "description";
  static const String COLUMN_DATE_TIME = "dateTime";
  static const String COLUMN_CATEGORY = "category";
  static const String COLUMN_AMOUNT = "amount";
  static const String COLUMN_INCOME = "isIncome";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'walletDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating food table");

        await database.execute(
          "CREATE TABLE $TABLE_WALLET ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_DESCRIPTION TEXT,"
          "$COLUMN_DATE_TIME TEXT,"
          "$COLUMN_CATEGORY TEXT,"
          "$COLUMN_AMOUNT DOUBLE,"
          "$COLUMN_INCOME INTEGER"
          ")",
        );
      },
    );
  }

  Future<List<Wallet>> getTransactions() async {
    final db = await database;

    var wallet = await db.query(
      TABLE_WALLET,
      columns: [
        COLUMN_ID,
        COLUMN_DESCRIPTION,
        COLUMN_DATE_TIME,
        COLUMN_CATEGORY,
        COLUMN_AMOUNT,
        COLUMN_INCOME
      ],
    );

    List<Wallet> walletList = List<Wallet>();

    wallet.forEach((currentFood) {
      Wallet food = Wallet.fromMap(currentFood);

      walletList.add(food);
    });

    return walletList;
  }

  Future<Wallet> insert(Wallet wallet) async {
    final db = await database;
    wallet.id = await db.insert(TABLE_WALLET, wallet.toMap());
    return wallet;
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      TABLE_WALLET,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future clear() async {
    final db = await database;
    return await db.delete(TABLE_WALLET);
  }

  Future<int> update(Wallet food) async {
    final db = await database;

    return await db.update(
      TABLE_WALLET,
      food.toMap(),
      where: "id = ?",
      whereArgs: [food.id],
    );
  }

  Future<int> queryRowCount() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $TABLE_WALLET'));
  }

  Future totalIncome() async {
    final db = await database;
    var result = await db.rawQuery(
        'SELECT SUM($COLUMN_AMOUNT) FROM $TABLE_WALLET WHERE $COLUMN_INCOME = 1');
    return result[0]["SUM(amount)"];
  }

  Future totalExpense() async {
    final db = await database;
    var result = await db.rawQuery(
        'SELECT SUM($COLUMN_AMOUNT) FROM $TABLE_WALLET WHERE $COLUMN_INCOME = 0');
    return result[0]["SUM(amount)"];
  }
}
