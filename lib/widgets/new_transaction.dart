import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expenseapp/widgets/adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  Function addNewTransaction;
  NewTransaction(this.addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleInput = TextEditingController();
  final _amountInput = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountInput.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleInput.text;
    final enteredAmount = double.parse(_amountInput.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addNewTransaction(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    }); //class property context
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              //lift up keyboard by whatever the keyboard is height is
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleInput,
                  onSubmitted: (_) => _submitData(), //dump data here
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: _amountInput,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                ),
                Container(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        //take as much free space as it can get
                        child: Text(
                          _selectedDate == null
                              ? 'No Date Chosen'
                              : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                        ),
                      ),
                      AdaptiveButton('Choose Date', _presentDatePicker),
                    ],
                  ),
                ),
                RaisedButton(
                  child: Text('Add Transaction'),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color,
                  onPressed: _submitData,
                )
              ],
            ),
          )),
    );
  }
}
