import 'package:etiqa_todo/controllers/state.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constant.dart';

class AddNewTodo extends StatefulWidget {
  const AddNewTodo({Key key}) : super(key: key);

  @override
  _AddNewTodoState createState() => _AddNewTodoState();
}

class _AddNewTodoState extends State<AddNewTodo> {
  final _ = Get.find<StateController>();
  int index = 0;
  String type = '';

  @override
  void initState() {
    super.initState();
    type = Get.parameters['type'];
    if (Get.parameters['index'] != null) {
      index = int.parse(Get.parameters['index']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 19),
              onPressed: () => Get.back()),
          title:
              Text('Add new To-Do-List', style: TextStyle(color: Colors.black)),
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => removeFocus(context),
            child: Container(
              height: Get.height -
                  (MediaQuery.of(context).padding.top + kToolbarHeight),
              child: Column(
                children: [
                  Form(),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (!Get.isSnackbarOpen) {
                        if (_.title.text.isEmpty ||
                            _.startdate.text.isEmpty ||
                            _.enddate.text.isEmpty) {
                          Get.snackbar('Error', 'Please fill all field below',
                              backgroundColor: Colors.red[600]);
                        } else {
                          if (type == 'add') {
                            return add();
                          } else {
                            return edit();
                          }
                        }
                      }
                    },
                    child: Button(type: type),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  removeFocus(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  add() {
    Duration diff = _.ed.difference(DateTime.now());
    var todo = {
      'title': _.title.text.trim(),
      'startDate': _.startdate.text.trim(),
      'endDate': _.enddate.text.trim(),
      'sd': _.sd.toString(),
      'ed': _.ed.toString(),
      'hours': diff.inHours,
      'minutes': diff.inMinutes.remainder(60),
      'status': '-',
      'checked': false
    };
    if (diff.inMinutes.remainder(60) < 0) {
      todo['hours'] = '--';
      todo['minutes'] = '--';
      todo['status'] = 'Incomplete';
    }
    _.todoItems.add(todo);
    _.saveToStorage();
    Get.back();
    Get.snackbar('Success', 'To-Do item has been added to list',
        backgroundColor: Colors.green[400], colorText: Colors.white);
    return;
  }

  edit() {
    Duration diff = _.ed.difference(DateTime.now());
    var item = _.todoItems[index];
    item['title'] = _.title.text.trim();
    item['startDate'] = _.startdate.text.trim();
    item['endDate'] = _.enddate.text.trim();
    item['sd'] = _.sd.toString();
    item['ed'] = _.ed.toString();
    item['hours'] = diff.inHours;
    item['minutes'] = diff.inMinutes.remainder(60);
    _.todoItems[index] = item;
    _.saveToStorage();
    Get.back();
    Get.snackbar('Success', 'To-Do item has been updated',
        backgroundColor: Colors.green[400], colorText: Colors.white);
    return;
  }

  @override
  void dispose() {
    super.dispose();
    _.title.text = '';
    _.startdate.text = '';
    _.enddate.text = '';
  }
}

class Button extends StatelessWidget {
  const Button({
    Key key,
    @required this.type,
  }) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: Get.height * 0.072,
      child: Center(
        child: Text(type == 'add' ? 'Create Now' : 'Update',
            style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 20)),
      ),
    );
  }
}

class Form extends StatelessWidget {
  const Form({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<StateController>();
    return Expanded(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('To-Do-Title',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 15.0),
          TextField(
            controller: _.title,
            maxLines: 5,
            cursorColor: Colors.grey[600],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[700], width: 1.2)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[700], width: 1.2)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[700], width: 1.2)),
              hintText: 'Please key in your To-Do title here',
            ),
          ),
          SizedBox(height: 25.0),
          Text('Start Date',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 15.0),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: Colors.grey[700],
                    width: 1.2,
                    style: BorderStyle.solid)),
            child: Padding(
              padding: const EdgeInsets.only(left: 13.0, right: 3.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    readOnly: true,
                    controller: _.startdate,
                    maxLines: 1,
                    cursorColor: Colors.grey[600],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Select a date',
                    ),
                  )),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 40,
                      height: 45,
                      child: Center(
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                    onTap: () async {
                      _.sd = await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime.now(),
                          lastDate: new DateTime(new DateTime.now().year + 1),
                          builder: (context, child) => Theme(
                              data: ThemeData(primarySwatch: Colors.amber),
                              child: child));
                      if (_.sd != null) {
                        _.startdate.text =
                            DateFormat('d MMM y').format(_.sd).toString();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 25.0),
          Text('End Date',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 15.0),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: Colors.grey[700],
                    width: 1.2,
                    style: BorderStyle.solid)),
            child: Padding(
              padding: const EdgeInsets.only(left: 13.0, right: 3.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    readOnly: true,
                    controller: _.enddate,
                    maxLines: 1,
                    cursorColor: Colors.grey[600],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Select a date',
                    ),
                  )),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 40,
                      height: 45,
                      child: Center(
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                    onTap: () async {
                      _.ed = await showDatePicker(
                          context: context,
                          initialDate:
                              new DateTime.now().add(Duration(days: 1)),
                          firstDate: new DateTime.now().add(Duration(days: 1)),
                          lastDate: new DateTime(new DateTime.now().year + 1),
                          builder: (context, child) => Theme(
                              data: ThemeData(primarySwatch: Colors.amber),
                              child: child));
                      if (_.ed != null) {
                        _.enddate.text =
                            DateFormat('d MMM y').format(_.ed).toString();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
