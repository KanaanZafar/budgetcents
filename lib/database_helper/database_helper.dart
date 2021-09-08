import 'dart:io';
import 'package:budgetcents/models/bill.dart';
import 'package:budgetcents/models/budgets.dart';
import 'package:budgetcents/models/income.dart';
import 'package:budgetcents/models/sub_bill.dart';
import 'package:budgetcents/res/constants.dart';

//import 'package:budgetcents/res/static_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    return await _initDb();
  }

  _initDb() async {
    Directory directory = await getApplicationSupportDirectory();
    String path = join(directory.path, Constant.dbName);
    return await openDatabase(path,
        version: Constant.dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE ${Constant.budgets}'
        '(${Constant.budgetId} INTEGER PRIMARY KEY,'
//        '${Constant.currentUserUid} TEXT,'
        '${Constant.income} DOUBLE)');
//        '${Constant.budgeted} DOUBLE)');
    await db.execute('CREATE TABLE ${Constant.incomes}'
        '(${Constant.incomeId} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${Constant.budgetId} INTEGER,'
        '${Constant.incomeSourceName} TEXT,'
        '${Constant.incomeDate} INTEGER,'
        '${Constant.incomeAmount} DOUBLE)');
    await db.execute('CREATE TABLE ${Constant.bills}'
        '(${Constant.billId} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${Constant.budgetId} INTEGER,'
        '${Constant.billName} TEXT,'
        '${Constant.billAmount} DOUBLE)');

    await db.execute('CREATE TABLE ${Constant.subBills}'
        '(${Constant.subBillId} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${Constant.budgetId} INTEGER,'
        '${Constant.billName} TEXT,'
        '${Constant.subBillName} TEXT,'
        '${Constant.subBillAmount} DOUBLE)');
  }

  Future<int> insertBudget(Budget budget) async {
    Database db = await database;
    int result = await db.insert(Constant.budgets, budget.toMap());
    return result;
  }

  Future<int> updateBudget(Budget budget) async {
    Database db = await database;
    int result = await db.update(Constant.budgets, budget.toMap(),
        where: '${Constant.budgetId}=?', whereArgs: [budget.budgetId]);
    return result;
  }

  Future<int> insertIncome(Income income) async {
    Database db = await database;
    int result = await db.insert(Constant.incomes, income.toMap());
    return result;
  }

  Future<int> insertBill(Bill bill) async {
    Database db = await database;
    int result = await db.insert(Constant.bills, bill.toMap());
    return result;
  }

  Future<int> updateIncome(Income income, Budget budget) async {
    Database db = await database;
    int result = await db.update(Constant.incomes, income.toMap(),
        where: '${Constant.budgetId}=? AND ${Constant.incomeSourceName}=?',
        whereArgs: [budget.budgetId, income.incomeSourceName]);
    return result;
  }

  Future<int> updateBill(Bill bill, Budget budget) async {
    Database db = await database;
    int result = await db.update(Constant.bills, bill.toMap(),
        where: '${Constant.budgetId}=? AND ${Constant.billName}=?',
        whereArgs: [budget.budgetId, bill.billName]);
    return result;
  }

  Future<int> deleteBill(Bill bill) async {
    Database db = await database;
    int result = await db.delete(Constant.bills,
        where: '${Constant.budgetId}=? AND ${Constant.billName}=?',
        whereArgs: [bill.budgetId, bill.billName]);
    return result;
  }

  Future<int> deleteIncome(Income income) async {
    Database db = await database;
    int result = await db.delete(Constant.incomes,
        where: '${Constant.budgetId}=? AND ${Constant.incomeSourceName}=?',
        whereArgs: [income.budgetId, income.incomeSourceName]);
    return result;
  }

  Future<int> deleteSubBillsOfaBill(Bill bill) async {
    Database db = await database;
    int result = await db.delete(Constant.subBills,
        where: '${Constant.budgetId}=? AND ${Constant.billName}=?',
        whereArgs: [bill.budgetId, bill.billName]);
    return result;
  }

  Future<int> updateSubBill(SubBill subBill) async {
    Database db = await database;
    int result = await db.update(Constant.subBills, subBill.toMap(),
        where:
            '${Constant.budgetId}=? AND ${Constant.billName}=? AND ${Constant.subBillName}=?',
        whereArgs: [subBill.budgetId, subBill.billName, subBill.subBillName]);
    return result;
  }

  Future<int> deleteBudget(Budget budget) async {
    Database db = await database;
    int result = await db.delete(Constant.budgets,
        where: '${Constant.budgetId}=?', whereArgs: [budget.budgetId]);
    return result;
  }

  Future<int> deleteAllBillsOfBudget(Budget budget) async {
    Database db = await database;
    int result = await db.delete(Constant.bills,
        where: '${Constant.budgetId}=?', whereArgs: [budget.budgetId]);
//    print('+++++++ ${result}');

    return result;
  }

  Future<int> deleteAllIncomes(Budget budget) async {
    Database db = await database;
    int rslt = await db.delete(Constant.incomes,
        where: '${Constant.budgetId}=?', whereArgs: [budget.budgetId]);
    return rslt;
  }

  Future<int> insertSubBill(SubBill subBill) async {
    Database db = await database;
    return await db.insert(Constant.subBills, subBill.toMap());
  }

  Future<int> deletesubBills(Budget budget) async {
    Database db = await database;
    int result = await db.delete(Constant.subBills,
        where: '${Constant.budgetId}=?', whereArgs: [budget.budgetId]);
//    print('deleteBills:${result}');
    return result;
  }


  Future<List<Budget>> allBudgets() async {
    Database db = await database;
    List<Budget> budgetsList = List<Budget>();
    List<Map<String, dynamic>> mapList = await db.query(
      Constant.budgets,
//        where: '${Constant.currentUserUid}=?',
//        whereArgs: [StaticInfo.currentUser.uid]
    );
    // where: '${Constant.gameId}=?', whereArgs: [game.gameId]

    for (int i = 0; i < mapList.length; i++) {
      budgetsList.add(Budget.fromMap(mapList[i]));
    }
    return budgetsList;
  }

  Future<List<Bill>> relatedBills(Budget budget) async {
    Database db = await database;
    List<Bill> billsList = List<Bill>();
    List<Map<String, dynamic>> mapList = await db.query(Constant.bills,
        where: '${Constant.budgetId}=?', whereArgs: [budget.budgetId]);
    for (int i = 0; i < mapList.length; i++) {
      billsList.add(Bill.fromMap(mapList[i]));
    }
    return billsList;
  }
/*
  Future<List<Bill>> allBills() async {
    Database db = await database;
    List<Bill> bills = List<Bill>();
    List<Map<String, dynamic>> mapList = await db.query(
      Constant.bills,
    );
    for (int i = 0; i < mapList.length; i++) {
      bills.add(Bill.fromMap(mapList[i]));
    }
    return bills;
  }*/

  Future<List<Income>> relatedIncomes(Budget budget) async {
    Database db = await database;
    List<Income> incomesList = List<Income>();
    List<Map<String, dynamic>> mapList = await db.query(Constant.incomes,
        where: '${Constant.budgetId}=?', whereArgs: [budget.budgetId]);
    for (int i = 0; i < mapList.length; i++) {
      incomesList.add(Income.fromMap(mapList[i]));
    }
    return incomesList;
  }

  Future<List<SubBill>> subBills(Budget budget, Bill bill) async {
    Database db = await database;
    List<SubBill> subBillsList = List<SubBill>();
    List<Map<String, dynamic>> mapsList = await db.query(Constant.subBills,
        where: '${Constant.budgetId}=? AND ${Constant.billName}=?',
        whereArgs: [budget.budgetId, bill.billName]);
    for (int i = 0; i < mapsList.length; i++) {
      subBillsList.add(SubBill.fromMap(mapsList[i]));
    }
    return subBillsList;
  }

  /*Future<List<SubBill>> allsubs() async {
    Database db = await database;
    List<SubBill> subBillsList = List<SubBill>();
    List<Map<String, dynamic>> mapsList = await db.query(
      Constant.subBills,
//        where: '${Constant.budgetId}=? AND ${Constant.billName}=?',
//        whereArgs: [budget.budgetId, bill.billName]
    );
    for (int i = 0; i < mapsList.length; i++) {
      subBillsList.add(SubBill.fromMap(mapsList[i]));
    }
    return subBillsList;
  } */
}
