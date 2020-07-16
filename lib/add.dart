import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_management/bloc/wallet_bloc.dart';
import 'package:gastos_management/event/add_wallet.dart';
import 'package:intl/intl.dart';

import 'database/database_provider.dart';
import 'model/wallet.dart';

enum AddType { Expense, Income }

class Category {
  int id;
  String name;

  Category(this.id, this.name);

  static List<Category> getInCategories() {
    return <Category>[
      Category(1, 'Gift'),
      Category(2, 'Provision'),
      Category(3, 'Reward'),
      Category(4, 'Salary'),
      Category(5, 'Others'),
    ];
  }

  static List<Category> getExCategories() {
    return <Category>[
      Category(1, 'Bill'),
      Category(2, 'Fare'),
      Category(3, 'Food'),
      Category(4, 'Rent'),
      Category(5, 'Shopping'),
      Category(6, 'Others'),
    ];
  }
}

class AddPage extends StatefulWidget {
  final Wallet wallet;
  final int foodIndex;
  final AddType addType;

  const AddPage({Key key, this.addType, this.wallet, this.foodIndex})
      : super(key: key);

  @override
  _AddPageState createState() => _AddPageState(addType);
}

class _AddPageState extends State<AddPage> {
  String _description;
  String _amount;
  bool _isIncome = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buildDescription() {
    return TextFormField(
      maxLength: 15,
      initialValue: _description,
      decoration: InputDecoration(
        labelText: 'Description',
        icon: Icon(
          Icons.description,
          color: Colors.purple[900],
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Description is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _description = value;
      },
    );
  }

  Widget buildAmount() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Amount',
        icon: Icon(
          Icons.attach_money,
          color: Colors.purple[900],
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Amount is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _amount = value;
      },
    );
  }

  final AddType _addType;

  _AddPageState(this._addType);

  List<Category> _inCategories = Category.getInCategories();
  List<Category> _exCategories = Category.getExCategories();
  List<DropdownMenuItem<Category>> _dropdownMenuItems;
  Category _selectedCategory;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(
        _addType == AddType.Income ? _inCategories : _exCategories);
    _selectedCategory = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Category>> buildDropdownMenuItems(List categories) {
    List<DropdownMenuItem<Category>> items = List();
    for (Category category in categories) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Text(category.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Category selectedCompany) {
    setState(() {
      _selectedCategory = selectedCompany;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add ${_addType == AddType.Expense ? 'Expense' : 'Income'}',
        ),
        backgroundColor: Colors.purple[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              buildDescription(),
              buildAmount(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedCategory,
                  items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  color: Colors.purple[900],
                  textColor: Colors.white,
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    _formKey.currentState.save();

                    Wallet wallet = Wallet(
                        description: _description,
                        dateTime: new DateFormat.yMMMMd('en_US')
                            .add_jm()
                            .format(new DateTime.now()),
                        category: _selectedCategory.name,
                        amount: double.parse(_amount),
                        isIncome:
                            _addType == AddType.Income ? _isIncome : false);

                    DatabaseProvider.db.insert(wallet).then(
                          (storedTransaction) =>
                              BlocProvider.of<WalletBloc>(context).add(
                            AddWallet(storedTransaction),
                          ),
                        );
                    Navigator.pop(context, _amount);
                    print('submitted');
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
