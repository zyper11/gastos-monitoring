import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:gastos_management/add.dart';
import 'package:gastos_management/event/delete_wallet.dart';
import 'package:gastos_management/event/set_wallet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'bloc/wallet_bloc.dart';
import 'database/database_provider.dart';
import 'event/clear_wallet.dart';
import 'model/wallet.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double balance = 0;
  double income = 0;
  double expenses = 0;
  String moneyFormatter(double amount) {
    var formatter = new NumberFormat("#,###.00", "en_US");
    return formatter.format(amount);
  }

  Container _buildContainer(String title, double amount) {
    String formattedAmount = moneyFormatter(amount);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.yellow,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '₱ $formattedAmount',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.purple[50],
            ),
          )
        ],
      ),
    );
  }

  Container _buildHorizontalDivider() {
    return Container(
      height: 35.0,
      width: 1.0,
      color: Colors.purple[300],
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }

  SizedBox _buildInvisibleBox(double h, double w) {
    return SizedBox(
      height: h,
      width: w,
    );
  }

  showInfoAlert(BuildContext context, int index, Wallet wallet) {
    // set up the buttons
    print(index);

    Widget editButton = FlatButton(
      child: Text(
        "Back",
        style: TextStyle(color: Colors.purple[900]),
      ),
      onPressed: () => {Navigator.pop(context)},
    );

    Widget deleteButton = FlatButton(
      child: Text("Delete", style: TextStyle(color: Colors.purple[900])),
      onPressed: () => DatabaseProvider.db.delete(wallet.id).then((_) {
        BlocProvider.of<WalletBloc>(context).add(
          DeleteWallet(index),
        );
        Navigator.pop(context);
        setState(() {
          if (wallet.isIncome) {
            income = income - wallet.amount;
            balance = balance - wallet.amount;
          } else {
            expenses = expenses - wallet.amount;
            balance = balance + wallet.amount;
          }
        });
      }),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Info",
        style: TextStyle(color: Colors.purple[900]),
      ),
      content: Container(
        width: 500,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Transaction type: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  wallet.isIncome ? 'Income' : 'Expense',
                  style: TextStyle(
                    color: wallet.isIncome ? Colors.green : Colors.red,
                  ),
                )
              ],
            ),
            _buildInvisibleBox(10, 0),
            Row(
              children: <Widget>[
                Text(
                  'Category: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(wallet.category)
              ],
            ),
            _buildInvisibleBox(10, 0),
            Row(
              children: <Widget>[
                Text(
                  'Description: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(wallet.description)
              ],
            ),
            _buildInvisibleBox(10, 0),
            Row(
              children: <Widget>[
                Text(
                  'Date: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(wallet.dateTime)
              ],
            ),
            _buildInvisibleBox(10, 0),
            Row(
              children: <Widget>[
                Text(
                  'Amount: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text('₱ ${moneyFormatter(wallet.amount)}')
              ],
            )
          ],
        ),
      ),
      actions: [
        editButton,
        deleteButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showResetAlert(BuildContext context) {
    // set up the buttons
    Widget noButton = FlatButton(
      child: Text(
        "No",
        style: TextStyle(color: Colors.purple[900]),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget yesButton = FlatButton(
      child: Text("Yes", style: TextStyle(color: Colors.purple[900])),
      onPressed: () => DatabaseProvider.db.clear().then((_) {
        BlocProvider.of<WalletBloc>(context).add(
          ClearWallet(),
        );
        Navigator.pop(context);
        setState(() {
          balance = 0;
          income = 0;
          expenses = 0;
        });
      }),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Message",
        style: TextStyle(
          color: Colors.purple[900],
        ),
      ),
      content: Text("It will reset your data. Would you like to proceed?"),
      actions: [
        noButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAddAlert(BuildContext context) {
    // set up the buttons
    Widget incomeButton = SizedBox(
      height: 50,
      child: FlatButton.icon(
        onPressed: () async {
          Navigator.pop(context);
          final rs = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(
                addType: AddType.Income,
              ),
            ),
          );
          setState(() {
            if (rs != null) {
              income = income + double.parse(rs);
              balance = balance + double.parse(rs);
            }
          });
        },
        icon: Icon(Icons.attach_money),
        label: Text('Income'),
      ),
    );

    Widget expenseButton = SizedBox(
      height: 50,
      child: FlatButton.icon(
        onPressed: () async {
          Navigator.pop(context);
          final rs = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(
                addType: AddType.Expense,
              ),
            ),
          );
          setState(() {
            if (rs != null) {
              expenses = expenses + double.parse(rs);
              balance = balance - double.parse(rs);
            }
          });
        },
        icon: Icon(Icons.money_off),
        label: Text('Expense'),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Add",
        style: TextStyle(
          color: Colors.purple[900],
        ),
      ),
      content: Container(
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            incomeButton,
            expenseButton,
          ],
        ),
      ),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getTransactions().then(
      (walletList) {
        BlocProvider.of<WalletBloc>(context).add(SetWallet(walletList));
      },
    );
    DatabaseProvider.db.totalIncome().then((value) {
      setState(() {
        if (value > 0) {
          income = value;
          balance = balance + value;
        }
      });
    });
    DatabaseProvider.db.totalExpense().then((value) {
      setState(() {
        if (value > 0) {
          expenses = value;
          balance = balance - expenses;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F6),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.purple[900],
              ),
            ),
          ),
          ListView(
            padding: EdgeInsets.all(8.0),
            children: <Widget>[
              _buildInvisibleBox(40, 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "YOUR WALLET",
                        style: GoogleFonts.montserrat(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () => {showAddAlert(context)},
                    ),
                  ],
                ),
              ),
              _buildInvisibleBox(15, 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildContainer('Balance', balance),
                  _buildHorizontalDivider(),
                  _buildContainer('Income', income),
                  _buildHorizontalDivider(),
                  _buildContainer('Expenses', expenses),
                ],
              ),
              _buildInvisibleBox(30, 0),
              Container(
                alignment: Alignment.center,
                child: FlatButton.icon(
                  color: Colors.yellow,
                  textColor: Colors.purple[900],
                  onPressed: () => {showResetAlert(context)},
                  icon: Icon(Icons.refresh),
                  label: Text('Reset'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              _buildInvisibleBox(30, 0),
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 15),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'List of your transactions:',
                  style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 350),
            height: 500,
            child: BlocConsumer<WalletBloc, List<Wallet>>(
              builder: (context, walletList) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        Wallet wallet = walletList[index];
                        return Card(
                          child: ListTile(
                            onTap: () =>
                                {showInfoAlert(context, index, wallet)},
                            leading: CircleAvatar(
                              backgroundColor:
                                  wallet.isIncome ? Colors.green : Colors.red,
                              child: Icon(
                                wallet.isIncome
                                    ? Icons.attach_money
                                    : Icons.money_off,
                                size: 20,
                              ),
                              foregroundColor: Colors.white,
                            ),
                            title: Text(
                              wallet.category,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              wallet.dateTime,
                              style: GoogleFonts.montserrat(fontSize: 11),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${wallet.isIncome ? '+' : '-'} ₱ ${moneyFormatter(wallet.amount)}',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: wallet.isIncome
                                          ? Colors.green
                                          : Colors.red),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: walletList.length),
                );
              },
              listener: (BuildContext context, walletList) {},
            ),
          ),
        ],
      ),
    );
  }
}

// padding: EdgeInsets.symmetric(horizontal: 8.0),
// shrinkWrap: false,
