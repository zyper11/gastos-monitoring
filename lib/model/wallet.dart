import 'package:gastos_management/database/database_provider.dart';

class Wallet {
  int id;
  String description;
  String dateTime;
  String category;
  double amount;
  bool isIncome;

  Wallet(
      {this.id,
      this.description,
      this.dateTime,
      this.category,
      this.amount,
      this.isIncome});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_DESCRIPTION: description,
      DatabaseProvider.COLUMN_DATE_TIME: dateTime,
      DatabaseProvider.COLUMN_CATEGORY: category,
      DatabaseProvider.COLUMN_AMOUNT: amount,
      DatabaseProvider.COLUMN_INCOME: isIncome ? 1 : 0
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Wallet.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    description = map[DatabaseProvider.COLUMN_DESCRIPTION];
    dateTime = map[DatabaseProvider.COLUMN_DATE_TIME];
    category = map[DatabaseProvider.COLUMN_CATEGORY];
    amount = map[DatabaseProvider.COLUMN_AMOUNT];
    isIncome = map[DatabaseProvider.COLUMN_INCOME] == 1;
  }
}
