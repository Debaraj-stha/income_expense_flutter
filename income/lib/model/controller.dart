import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/dbcontroller.dart';
import 'package:income/model/model.dart';
import 'package:income/utils/smallText.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class myController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  final RxInt _currentTouchBar = 0.obs;
  final RxInt monthlyExpenses = 0.obs;
  int get currentTouchBar => _currentTouchBar.value;
  int get activeTab => _currentIndex.value;
  bool isObsecured = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FocusNode nameNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode emailNode = FocusNode();
  final RxList _todayIncome = [].obs;
  List get todayIncome => _todayIncome.value;
  final RxList _todayExpenses = [].obs;
  List get todayExpenses => _todayExpenses.value;
  final RxDouble _total = 0.0.obs;
  double get total => _total.value;
  final RxDouble _totalExpense = 0.0.obs;
  double get totalExpense => _totalExpense.value;
  var uuid = const Uuid();
  int activetab = 0;
  final incomeKey = GlobalKey<AnimatedListState>();
  final expenseKey = GlobalKey<AnimatedListState>();
  final RxList _oneMonthExpenses = [].obs;
  List get oneMonthExpenses => _oneMonthExpenses.value;
  final RxList _oneMonthIncome = [].obs;
  List get oneMonthIncome => _oneMonthIncome.value;
  final RxList _oneYearIncome = [].obs;
  List get oneYearIncome => _oneYearIncome.value;
  final RxList _oneYearExpense = [].obs;
  List get oneYearExpense => _oneYearExpense.value;
  DbController dbController = DbController();
  final RxList _groupMonthData = [].obs;
  List get groupMonthData => _groupMonthData.value;
  final RxList _groupMonthDataIncome = [].obs;
  List get groupMonthDataIncome => _groupMonthDataIncome.value;
  final RxDouble _oneMOnthExpenseTotal = 0.0.obs;

  double get oneMOnthExpenseTotal => _oneMOnthExpenseTotal.value;
  final RxDouble _oneMOnthIncomeTotal = 0.0.obs;

  double get oneMOnthIncomeTotal => _oneMOnthIncomeTotal.value;
  final RxDouble _oneYearTotalExpense = 0.0.obs;
  double get oneYearTotalExpense => _oneYearTotalExpense.value;
  final RxDouble _oneYearTotalIncome = 0.0.obs;
  double get oneYearTotalIncome => _oneYearTotalIncome.value;
  final RxList _yearlyExpense = [].obs;
  List get yearlyExpense => _yearlyExpense.value;
  final RxList _yearlyIncome = [].obs;
  List get yearlyIncome => _yearlyIncome.value;
  final RxDouble _yerlyTotalIncome = 0.0.obs;
  double get yearlyTotalIncome => _yerlyTotalIncome.value;
  final RxDouble _yerlyTotalExpense = 0.0.obs;
  double get yearlyTotalExpense => _yerlyTotalExpense.value;
  final RxList _specificData = [].obs;
  List get specificData => _specificData.value;
  final RxDouble _specificDataTotal = 0.0.obs;
  double get specificDataTotal => _specificDataTotal.value;
  final RxList _oneMonthIncomeGroupByTitle = [].obs;
  List get oneMonthIncomeGroupByTitle => _oneMonthIncomeGroupByTitle.value;
  final RxList _oneMonthExpenseGroupByTitle = [].obs;
  List get oneMonthExpenseGroupByTitle => _oneMonthExpenseGroupByTitle.value;
  final RxDouble _oneMonthExpenseGroupByTitleTotal = 0.0.obs;
  double get oneMonthExpenseGroupByTitleTotal =>
      _oneMonthExpenseGroupByTitleTotal.value;
  final RxDouble _oneMonthIncomeGroupByTitleTotal = 0.0.obs;
  double get oneMonthIncomeGroupByTitleTotal =>
      _oneMonthIncomeGroupByTitleTotal.value;
  final RxList _yesterDayData = [].obs;
  List get yesterdayData => _yesterDayData.value;

  final RxDouble _yesterdayTotal = 0.0.obs;
  double get yesterdayTotal => _yesterdayTotal.value;
  final RxList _searchData = [].obs;
  List get searchData => _searchData.value;
  final RxDouble _searchTotal = 0.0.obs;
  double get searchTotal => _searchTotal.value;
  @override
  void disposeField() {
    nameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    nameNode.dispose();
    emailNode.dispose();
    passwordNode.dispose();
  }

  void togglePassword() {
    isObsecured = !isObsecured;
    debugPrint("toggling password$isObsecured");
  }

  void handleIntrolPageCount(int index) {
    _currentIndex.value = index;
    debugPrint(_currentIndex.toString());
  }

  void signup() {
    debugPrint("signup");
    var uid = uuid.v1();
    User user = User(
        name: nameController.text,
        password: passwordController.text,
        email: emailController.text,
        id: uid);
    dbController.insertUser(user).then((value) {
      if (value) {
        print("success");
      } else {
        print("failed");
      }
    });
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    emailNode.unfocus();
    passwordNode.unfocus();
    nameNode.unfocus();
  }

  void login() {
    emailController.clear();
    passwordController.clear();
    emailNode.unfocus();
    passwordNode.unfocus();
  }

  void handleActiveTab(int index) {
    _currentIndex.value = index;

    print("object: $activetab");
  }

  Color generateColor() {
    final random = Random();
    int a = random.nextInt(256); // Alpha channel between 0 and 255
    int r = random.nextInt(256); // Red channel between 0 and 255
    int g = random.nextInt(256); // Green channel between 0 and 255
    int b = random.nextInt(256); // Blue channel between 0 and 255
    Color color = Color.fromARGB(a, r, g, b).withGreen(g + 54);
    return color;
  }

  handleBarTouch(FlTouchEvent event, BarTouchResponse barTouchResponse) {
    if (event is FlLongPressEnd) {
      _currentTouchBar.value = -1; // Reset when the touch ends
    } else if (event is FlLongPressStart) {
      // Determine the touched bar group index using the x property
      final touchedIndex =
          barTouchResponse.spot!.touchedRodDataIndex.toInt() ?? -1;
      _currentTouchBar.value = touchedIndex;
    }
    print(_currentTouchBar);
  }

  handlepichartTouch(
      FlTouchEvent event, PieTouchResponse pieTouchResponse, int type) {
    if (!event.isInterestedForInteractions ||
        pieTouchResponse.touchedSection == null) {
      _currentTouchBar.value = -1;
      return;
    }
    if (type == 1) {
      _currentTouchBar.value =
          pieTouchResponse.touchedSection!.touchedSectionIndex;
    } else {
      monthlyExpenses.value =
          pieTouchResponse.touchedSection!.touchedSectionIndex;
    }
    print("_currentTouchBar$_currentTouchBar");
  }

  final List textFieldList = [].obs;

  final List<Map<String, dynamic>> textEditingControllers = [];

  void addTextField(int index, BuildContext context) {
    addController();

    textFieldList.add(buildTextField(index, context));

    print(textEditingControllers.length);
  }

  Widget buildTextField(int index, BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                deleteField(index);
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: constraints().getWidth(context) * 0.6,
              child: TextFormField(
                controller: textEditingControllers[index]['controller'],
                focusNode: textEditingControllers[index]['focusNode'],
                onTapOutside: (event) {
                  if (textEditingControllers[index]['focusNode'].hasFocus) {
                    textEditingControllers[index]['focusNode'].unfocus();
                  }
                },
                onFieldSubmitted: (value) {
                  if (textEditingControllers[index]['focusNode'].hasFocus) {
                    textEditingControllers[index]['focusNode'].unfocus();
                  }
                },
                decoration: const InputDecoration(
                    label: SmallText(
                      text: "Title",
                      size: 15,
                    ),
                    contentPadding: EdgeInsets.all(8)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: constraints().getWidth(context) * 0.20,
              child: TextFormField(
                keyboardType: TextInputType.number,
                onTapOutside: (event) {
                  if (textEditingControllers[index]['amountFocusNode']
                      .hasFocus) {
                    textEditingControllers[index]['amountFocusNode'].unfocus();
                  }
                },
                onFieldSubmitted: (value) {
                  if (textEditingControllers[index]['amountFocusNode']
                      .hasFocus()) {
                    textEditingControllers[index]['amountFocusNode'].unfocus();
                  }
                },
                controller: textEditingControllers[index]['amountController'],
                focusNode: textEditingControllers[index]['amountFocusNode'],
                decoration: const InputDecoration(
                    label: SmallText(
                      text: "Amount",
                      size: 16,
                    ),
                    contentPadding: EdgeInsets.all(8)),
              ),
            ),
          ],
        ),
      );

  void addController() {
    textEditingControllers.add({
      "controller": TextEditingController(),
      "focusNode": FocusNode(),
      "amountController": TextEditingController(),
      "amountFocusNode": FocusNode(),
    });
  }

  void deleteField(int index) {
    // Dispose of the controllers and focus nodes before removing
    textEditingControllers[index]['controller'].dispose();
    textEditingControllers[index]['focusNode'].dispose();
    textEditingControllers[index]['amountController'].dispose();
    textEditingControllers[index]['amountFocusNode'].dispose();

    // Remove the field from the lists
    textFieldList.removeAt(index);
    textEditingControllers.removeAt(index);
    print(textFieldList.length);
    print(index);
  }

  void addData(String type, BuildContext context) async {
    print(type);
    DateTime now = DateTime.now();

    List<Data> data = List.generate(textFieldList.length, (index) {
      return Data(
        date: DateTime(now.year, now.month, now.day),
        title: textEditingControllers[index]['controller'].text,
        amount: textEditingControllers[index]['amountController'].text,
        id: uuid.v1(),
        type: type,
      );
    });
    var response = await dbController.insertData(data);

    if (response != null || response.isNotEmpty) {
      for (int i = 0; i < textEditingControllers.length; i++) {
        textEditingControllers[i]['controller'].clear();
        textEditingControllers[i]['focusNode'].unfocus();
        textEditingControllers[i]['amountController'].clear();
        textEditingControllers[i]['amountFocusNode'].unfocus();
      }
      textEditingControllers.clear();
      textFieldList.clear();
      addTextField(0, context);
      if (response[0].type == 'income') {
        print(response[0].date);
        for (var data in response) {
          _todayIncome.add({
            "title": data.title,
            "amount": data.amount,
            "id": data.id,
            "date": data.date
          });
          if (data.amount != "") {
            _total.value += double.parse(data.amount);
          }
        }
      } else {
        for (var data in response) {
          _todayExpenses.add({
            "title": data.title,
            "amount": data.amount,
            "id": data.id,
            "date": data.date
          });
          if (data.amount != "") {
            _totalExpense.value += double.parse(data.amount);
          }
        }
      }
      print("success");
    } else {
      print("failed");
    }
  }

  Future f = Future(() {});
  void getTodayIncomeExpense(String type) async {
    if (type == 'income') {
      List<Data> datas = await dbController.getData(type, 0);
      for (var data in datas) {
        print(data.title);
        f = f.then((value) {
          return Future.delayed(const Duration(milliseconds: 100), () {
            double parsedAmount = 0.0; // Default value if parsing fails
            try {
              parsedAmount = double.parse(data.amount);
            } catch (e) {
              // Handle the exception,
              print('Error parsing amount for ${data.title}: $e');
            }
            _todayIncome.add({
              "title": data.title,
              "amount": parsedAmount.toString(), // Convert to string
              "id": data.id,
              "date": data.date
            });
            incomeKey.currentState!.insertItem(_todayIncome.length - 1);
            for (var i = 0; i < todayIncome.length; i++) {
              if (todayIncome[i]['amount'] != "") {
                _total.value += double.parse(todayIncome[i]['amount']);
              }
            }
          });
        });
      }
    } else {
      List<Data> datas = await dbController.getData(type, 0);
      for (var data in datas) {
        print(data.title);
        f = f.then((value) {
          return Future.delayed(const Duration(milliseconds: 100), () {
            _todayExpenses.add({
              "title": data.title,
              "amount": data.amount,
              "id": data.id,
              "date": data.date
            });
            expenseKey.currentState!.insertItem(_todayExpenses.length - 1);
            for (var i = 0; i < todayExpenses.length; i++) {
              if (todayExpenses[i]['amount'] != "") {
                _totalExpense.value += double.parse(todayExpenses[i]['amount']);
              }
            }
          });
        });
      }
    }
  }

  void getLongIncomeExpenseData(int dataType, String type,
      {String endDate = "", String groupByTypes = "month"}) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    print("one month");

    switch (dataType) {
      //1 for one month income an expense
      case 1:
        //calculate one month ago date

        DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
        if (type == 'income') {
          print("one month income");
          await dbController
              .getData('income', 1,
                  startDate: oneMonthAgo.toLocal().toString(),
                  endDate: today.toLocal().toString())
              .then((value) {
            for (int index = 0; index < value.length; index++) {
              print("income title${value[index].title}");

              String title = value[index].title;
              double amount = double.parse(
                  value[index].amount); // Convert 'amount' to double
              bool titleExists = false;

              // Check if the title already exists in _oneMonthExpenses
              for (int i = 0; i < _oneMonthIncome.length; i++) {
                if (_oneMonthIncome[i]['title'] == title) {
                  double currentAmount =
                      double.parse(_oneMonthIncome[i]['amount']);
                  currentAmount += amount;
                  _oneMonthIncome[i]['amount'] =
                      currentAmount.toString(); // Update the 'amount' field
                  titleExists = true;
                  break;
                }
              }

              // If the title doesn't exist, add a new entry
              if (!titleExists) {
                _oneMonthIncome.add({
                  "title": title,
                  "amount": amount.toString(), // Convert to String
                  "id": value[index].id,
                  "date": value[index].date
                });
              }
            }

            return value;
          });
        } else {
          print("one month expense");
          await dbController
              .getData('expense', 1,
                  startDate: oneMonthAgo.toLocal().toString(),
                  endDate: today.toLocal().toString())
              .then((value) {
            for (int index = 0; index < value.length; index++) {
              print("expense title${value[index].title}");

              String title = value[index].title;
              double amount = double.parse(
                  value[index].amount); // Convert 'amount' to double
              bool titleExists = false;

              // Check if the title already exists in _oneMonthExpenses
              for (int i = 0; i < _oneMonthExpenses.length; i++) {
                if (_oneMonthExpenses[i]['title'] == title) {
                  double currentAmount =
                      double.parse(_oneMonthExpenses[i]['amount']);
                  currentAmount += amount;
                  _oneMonthExpenses[i]['amount'] =
                      currentAmount.toString(); // Update the 'amount' field
                  titleExists = true;
                  break;
                }
              }

              // If the title doesn't exist, add a new entry
              if (!titleExists) {
                _oneMonthExpenses.add({
                  "title": title,
                  "amount": amount.toString(), // Convert to String
                  "id": value[index].id,
                  "date": value[index].date
                });
              }
            }

            return value;
          });
        }

      //2 for one year income and expense
      case 2:
        //calculate one year ago date
        DateTime oneYearAgo = DateTime(now.year - 1, now.month, now.day);
        if (type == 'income') {
          await dbController
              .getData(type, dataType,
                  startDate: oneYearAgo.toLocal().toString(),
                  endDate: today.toLocal().toString())
              .then((value) {
            for (var data in value) {
              print("income${data.toJson()}");
              print(data.title);
              _oneYearIncome.add({
                "title": data.title,
                "amount": data.amount,
                "id": data.id,
                "date": data.date
              });
              _oneYearTotalIncome.value += double.parse(data.amount);
            }
            return value;
          });
        } else {
          await dbController
              .getData(type, dataType,
                  endDate: today.toLocal().toString(),
                  startDate: oneYearAgo.toLocal().toString())
              .then((value) {
            for (var data in value) {
              print(data.toJson().toString());
              print("yes");
              _oneYearExpense.add({
                "title": data.title,
                "amount": data.amount,
                "id": data.id,
                "date": data.date
              });
              _oneYearTotalExpense.value += double.parse(data.amount);
            }

            print(value.length);
            return value;
          });
        }
      //3 for yearly data
      case 3:
        if (type == 'income') {
          print("income");
          _yerlyTotalIncome.value = 0;
          await dbController.getData(type, dataType).then((value) {
            for (var data in value) {
              _yearlyIncome.add({
                "title": data.title,
                "amount": data.amount,
                "id": data.id,
                "date": data.date
              });

              _yerlyTotalIncome.value += double.parse(data.amount);
            }
            return value;
          });
        } else {
          _yerlyTotalExpense.value = 0;
          await dbController.getData(type, dataType).then((value) {
            for (var data in value) {
              _yearlyExpense.add({
                "title": data.title,
                "amount": data.amount,
                "id": data.id,
                "date": data.date
              });

              _yerlyTotalExpense.value += double.parse(data.amount);
            }
            return value;
          });
        }
      case 4:
        String oneMonthAgo;

        switch (groupByTypes) {
          case 'month':
            oneMonthAgo =
                DateTime(now.year, now.month - 1, now.day).toLocal().toString();
            break;
          case 'year':
            oneMonthAgo =
                DateTime(now.year - 1, now.month, now.day).toLocal().toString();
          case 'yearly':
            oneMonthAgo = "";
          default:
            oneMonthAgo = "";
        }
        print("one month ago$oneMonthAgo");
        if (type == 'income') {
          _oneMonthIncomeGroupByTitleTotal.value = 0.0;
          await dbController
              .getData(type, dataType,
                  startDate: oneMonthAgo, endDate: today.toLocal().toString())
              .then((value) {
            for (int index = 0; index < value.length; index++) {
              print("expense title${value[index].title}");

              String title = value[index].title;
              double amount = double.parse(
                  value[index].amount); // Convert 'amount' to double
              bool titleExists = false;

              // Check if the title already exists in _oneMonthExpenses
              for (int i = 0; i < _oneMonthIncomeGroupByTitle.length; i++) {
                if (_oneMonthIncomeGroupByTitle[i]['title'] == title) {
                  double currentAmount =
                      double.parse(_oneMonthIncomeGroupByTitle[i]['amount']);
                  currentAmount += amount;
                  _oneMonthIncomeGroupByTitle[i]['amount'] =
                      currentAmount.toString(); // Update the 'amount' field
                  titleExists = true;
                  break;
                }
              }

              // If the title doesn't exist, add a new entry
              if (!titleExists) {
                _oneMonthIncomeGroupByTitle.add({
                  "title": title,
                  "amount": amount.toString(), // Convert to String
                  "id": value[index].id,
                  "date": value[index].date
                });
              }
              _oneMonthIncomeGroupByTitleTotal.value +=
                  double.parse(value[index].amount);
            }
          });
        } else {
          _oneMonthExpenseGroupByTitleTotal.value = 0.0;
          await dbController
              .getData(type, dataType,
                  startDate: oneMonthAgo, endDate: today.toLocal().toString())
              .then((value) {
            for (int index = 0; index < value.length; index++) {
              print("expense title${value[index].title}");

              String title = value[index].title;
              double amount = double.parse(
                  value[index].amount); // Convert 'amount' to double
              bool titleExists = false;

              // Check if the title already exists in _oneMonthExpenses
              for (int i = 0; i < _oneMonthExpenseGroupByTitle.length; i++) {
                if (_oneMonthExpenseGroupByTitle[i]['title'] == title) {
                  double currentAmount =
                      double.parse(_oneMonthExpenseGroupByTitle[i]['amount']);
                  currentAmount += amount;
                  _oneMonthExpenseGroupByTitle[i]['amount'] =
                      currentAmount.toString(); // Update the 'amount' field
                  titleExists = true;
                  break;
                }
              }

              // If the title doesn't exist, add a new entry
              if (!titleExists) {
                _oneMonthExpenseGroupByTitle.add({
                  "title": title,
                  "amount": amount.toString(), // Convert to String
                  "id": value[index].id,
                  "date": value[index].date
                });
              }
              _oneMonthExpenseGroupByTitleTotal.value +=
                  double.parse(value[index].amount);
            }
          });
        }
      default:
    }
  }

  void getData() async {
    await dbController.getAllData().then((value) {
      for (var i = 0; i < value.length; i++) {
        print(
            "amount  ${value[i].amount}title ${value[i].title}  id${value[i].id}date ${value[i].date.toLocal()}");
      }
    });
  }

  void getGroupByData(String type) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime startDate = DateTime(today.year, today.month - 1, today.day);
    switch (type) {
      case 'income':
        _groupMonthDataIncome.value = await dbController
            .getDaybyDayData('income', today.toLocal().toString(),
                startDate.toLocal().toString())
            .then((value) {
          print("value groupby");
          print(value);
          double x = 0;
          _oneMOnthIncomeTotal.value = 0;
          for (int i = 0; i < value.length; i++) {
            _oneMOnthIncomeTotal.value += value[i]['amount'];
            x += value[i]['amount'];
          }
          print("sum= $x");
          return value;
        });
      case 'expense':
        _groupMonthData.value = await dbController
            .getDaybyDayData('expense', today.toLocal().toString(),
                startDate.toLocal().toString())
            .then((value) {
          _oneMOnthExpenseTotal.value = 0;
          for (int i = 0; i < value.length; i++) {
            _oneMOnthExpenseTotal.value += value[i]['amount'];
          }

          return value;
        });
    }
  }

  void sortData(int sortType, List data, int sortDataType, String types) {
    List<Map<String, dynamic>> sortedData = List.from(
        data); //creating a new list form the data for the reason of our data is constat and to make mutuable

    switch (sortType) {
      case 1:
        sortedData.sort((a, b) => a['date'].compareTo(b['date']));
        break;
      case 2:
        sortedData.sort((a, b) => b['date'].compareTo(a['date']));
        break;
      case 3:
        sortedData.sort((a, b) => a['amount'].compareTo(b['amount']));
        break;
      case 4:
        sortedData.sort((a, b) => b['amount'].compareTo(a['amount']));
        break;
    }
    updateSortedData(sortedData, sortDataType, types);
    print(sortedData);
  }

  void updateSortedData(
      List<Map<String, dynamic>> sortedData, int sortDataType, String types) {
    //sortdata types is income and expense of month,day,year
    //types is income or expense
    switch (sortDataType) {
      case 1:
        if (types == 'income') {
          print("income");
          print("before sorting$groupMonthData");
          _groupMonthDataIncome.value = sortedData;
          print("afetr sorting$groupMonthData");
        } else {
          _groupMonthData.value = sortedData;
          print("one month expense$groupMonthDataIncome");
        }
        // update();
        break;
      case 2:
        if (types == 'income') {
          _oneYearIncome.value = sortedData;
        } else {
          _oneYearExpense.value = sortedData;
        }
        // update();
        break;
      case 3:
        if (types == 'income') {
          _yearlyIncome.value = sortedData;
        } else {
          _yearlyExpense.value = sortedData;
        }
      // update();
    }
  }

  void getSpecificData(String type, String data, bool isDate,
      {startDate = "", endDate = ""}) async {
    print(startDate);
    print(endDate);
    await dbController
        .getSpecificData(isDate, type, startDate, endDate, data)
        .then((value) {
      print("data oad");
      _specificData.clear();
      for (var data in value) {
        _specificData.add({
          "title": data.title,
          "amount": data.amount,
          "id": data.id,
          "date": data.date
        });
        print(data.toJson().toString());
        _specificDataTotal.value += double.parse(data.amount);
      }
    });
  }

  void downloadFile(String url) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      const baseStorage = "/storage/emulated/0/Download";
      var dir = await getExternalStorageDirectory();
      if (dir != null) {
        print("dir is not empty");
        final taskId = await FlutterDownloader.enqueue(
          url: url,
          headers: {}, // optional: header send with url (auth token etc)
          savedDir: dir.path,
          fileName:
              "${DateFormat('yyyy-MM-dd').format(DateTime.now())}_download",
          showNotification:
              true, // show download progress in status bar (for Android)
          saveInPublicStorage: true,
          openFileFromNotification:
              true, // click on notification to open downloaded file (for Android)
        );
      }
      print("dir is empty");
    }
  }

  ReceivePort receivePort = ReceivePort();

  void initialize() {
    ReceivePort receivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "download");
    receivePort.listen((message) {
      print(message);
    });
    FlutterDownloader.registerCallback(downloadCallBack);
  }

  static void downloadCallBack(id, status, progress) {
    SendPort? sendport = IsolateNameServer.lookupPortByName("download");
    sendport?.send(progress);
    if (status == DownloadTaskStatus.complete) {
      print("download complete");
    }
  }

  Future<Uint8List> getImageUint8List(String assetName) async {
    final ByteData data = await rootBundle.load(assetName);
    return data.buffer.asUint8List();
  }

  void generatePDF(List data, bool isDate, String title, double total,
      String currency) async {
    final imageUint8List =
        await getImageUint8List("asset/logo.png"); //app logo or company logo
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(imageUint8List),
                width: 200, // Adjust the width as needed
                height: 200, // Adjust the height as needed
              ),
            );
          }),
    );
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(children: [
          pw.SizedBox(
            height: 20,
          ),
          pw.Header(
              child: pw.Text(title,
                  style: pw.TextStyle(
                      fontSize: 50, fontWeight: pw.FontWeight.bold))),
          pw.Divider(thickness: 1.8),
          pw.SizedBox(height: 10),
          pw.ListView.builder(
              itemBuilder: ((context, index) {
                return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 7),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text(
                            isDate
                                ? DateFormat('yyyy-MMMM-dd')
                                    .format(data[index]['date'])
                                    .toString()
                                : data[index]['title'],
                            style: const pw.TextStyle(fontSize: 30),
                          ),
                          pw.Spacer(),
                          pw.Text(
                            "$currency " + data[index]['amount'],
                            style: const pw.TextStyle(fontSize: 30),
                          )
                        ]));
              }),
              itemCount: data.length),
          pw.SizedBox(height: 20),
          pw.Divider(thickness: 2),
          pw.Row(children: [
            pw.Text("Total",
                style: pw.TextStyle(
                  fontSize: 35,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.Spacer(),
            pw.Text(
              "$currency $total",
              style: pw.TextStyle(fontSize: 35, fontWeight: pw.FontWeight.bold),
            )
          ])
        ]);
      },
    ));

    final outPut = await getExternalStorageDirectory();

    String path =
        '${'${outPut!.path}/${DateTime.now().toIso8601String()}'}.pdf';
    final file = File(path);
    List<int> bytes = await doc.save();
    file.writeAsBytesSync(bytes);

    print(outPut.path);
  }

  void fetchYesterdayData(String type, int dataType) async {
    DateTime now = DateTime.now();
    DateTime endDate = DateTime(now.year, now.month, now.day - 1);
    String localTypes = "";
    switch (type) {
      case 'income':
        localTypes = 'income';
        break;
      case 'expense':
        localTypes = "expense";
        break;
    }
    print(localTypes);
    _yesterdayTotal.value = 0.0;
    await dbController
        .getYsetrdayData(localTypes, endDate.toLocal().toString())
        .then((value) {
      for (int index = 0; index < value.length; index++) {
        print(value[index]);
        print("expense title${value[index].title}");

        String title = value[index].title;
        double amount =
            double.parse(value[index].amount); // Convert 'amount' to double
        bool titleExists = false;

        // Check if the title already exists in _oneMonthExpenses
        for (int i = 0; i < _yesterDayData.length; i++) {
          if (_yesterDayData[i]['title'] == title) {
            double currentAmount = double.parse(_yesterDayData[i]['amount']);
            currentAmount += amount;
            _yesterDayData[i]['amount'] =
                currentAmount.toString(); // Update the 'amount' field
            titleExists = true;
            break;
          }
        }

        // If the title doesn't exist, add a new entry
        if (!titleExists) {
          _yesterDayData.add({
            "title": title,
            "amount": amount.toString(), // Convert to String
            "id": value[index].id,
            "date": value[index].date
          });
        }
        _yesterdayTotal.value += double.parse(value[index].amount);
      }
    });
  }

  searchSpecificData(String value) async {
    List<String> split = value.split(" ");
    String type = "income";
    int index = 0;
    if (split.contains("expense")) {
      index = split.indexOf('expense');
      type = "expense";
    }
    String title = index >= 1 ? split[index - 1] : split[index + 1];
    _searchTotal.value = 0.0;
    await dbController.searchData(type, title).then((value) {
      for (int index = 0; index < value.length; index++) {
        print(value[index]);
        print("expense title${value[index].title}");

        String title = value[index].title;
        double amount =
            double.parse(value[index].amount); // Convert 'amount' to double
        bool titleExists = false;

        // Check if the title already exists in _oneMonthExpenses
        for (int i = 0; i < _searchData.length; i++) {
          if (_searchData[i]['title'] == title) {
            double currentAmount = double.parse(_searchData[i]['amount']);
            currentAmount += amount;
            _searchData[i]['amount'] =
                currentAmount.toString(); // Update the 'amount' field
            titleExists = true;
            break;
          }
        }

        // If the title doesn't exist, add a new entry
        if (!titleExists) {
          _searchData.add({
            "title": title,
            "amount": amount.toString(), // Convert to String
            "id": value[index].id,
            "date": value[index].date
          });
        }
        _searchTotal.value += double.parse(value[index].amount);
      }
    });
  }

  signinWithGoogle() async {
    try {
      GoogleSignInAccount? gSignIN = await GoogleSignIn().signIn();
      User user = User(
          name: gSignIN!.displayName!, email: gSignIN.email, id: gSignIN.id);
      await dbController.insertUser(user).then((value) {
        if (value) {
          print("user data is not saved");
        } else {
          print("ueer data is saved");
        }
      });
      print(gSignIN);
    } catch (e) {
      print(e);
    }
  }

  final RxList _user = [].obs;
  List get user => _user.value;
  Future<List<User>> getUserInfo() async {
    try {
      final value = await dbController.getUser();
      print("User Info: $value");
      if (value.isNotEmpty) {
        print("User Name: ${value[0].name}");
      }
      return value;
    } catch (e) {
      print("Error fetching user info: $e");
      return [];
    }
  }

  void sendNotification(String to) async {
    String key =
        "AAAAh9Ixkxk:APA91bGxgePRoGY5Q-vK4K_WRd6gdfHMQZ1NmYNK_agJFVf-s9WIy79ul4i8rOnCC7byROcI3iUwv-6EfKBmb1OmoW6SZ0YJQVEUrszLR_9BzrqsIn3qinJEYn7uF4exqTde8eUinmC9";
    var data = {
      "to": to,
      "priority": "high",
      "notification": {
        "title": "testing notification",
        "body": "testing notification body"
      },
      "type": "msg",
      "data": {"message": "message "}
    };
    final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': 'key=$key'
        });
    print("response${response.statusCode}");
  }
}
