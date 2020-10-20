import 'package:etiqa_todo/constant.dart';
import 'package:etiqa_todo/controllers/state.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = Get.put<StateController>(StateController());
    return Scaffold(
      //NOTE: AppBar in homescreen.
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('To-Do-List', style: TextStyle(color: Colors.black)),
      ),
      /*NOTE:
        Using GetX Reactive Programming is as easy as using setState.
        if no todo item has been created, screen will display text "You have no To-Do" and display listview if there is todo item.
      */
      body: Obx(() => _.todoItems.length > 0
          ? ListView.builder(
              controller: _.scrollController,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              itemCount: _.todoItems.length,
              itemBuilder: (context, index) => Todo(index: index), // Todo Widget
            )
          : Container(
              child: Center(
                  child: Text('You have no To-Do',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                          fontWeight: FontWeight.w500))))),
      floatingActionButton: FloatingButton(), // Floating Action Button Widget
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // FAB position in center float.
    );
  }
}

class Todo extends StatelessWidget {
  const Todo({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<StateController>();
    return Align(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.grey[400], spreadRadius: 0, blurRadius: 5)
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                Container(
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 17.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _.title.text = _.todoItems[index]['title'];
                                _.startdate.text =
                                    _.todoItems[index]['startDate'];
                                _.enddate.text = _.todoItems[index]['endDate'];
                                Get.toNamed('/addNew?type=edit&index=$index');
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.edit, color: Colors.grey),
                                  )),
                            ),
                            SizedBox(width: 10.0),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _.remove(index),
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.delete,
                                        color: Colors.red[600]),
                                  )),
                            )
                          ],
                        ),
                        Container(
                            child: Text(_.todoItems[index]['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22))),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Start Date', style: subTextStyle),
                                SizedBox(height: 4.0),
                                Text(_.todoItems[index]['startDate'],
                                    style: contentTextStyle),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('End Date', style: subTextStyle),
                                SizedBox(height: 4.0),
                                Text(_.todoItems[index]['endDate'],
                                    style: contentTextStyle),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Time Left', style: subTextStyle),
                                SizedBox(height: 4.0),
                                Text(
                                    '${_.todoItems[index]['hours']} hrs ${_.todoItems[index]['minutes']} min',
                                    style: contentTextStyle),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: Get.width * 0.9,
                  height: 40,
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Text('Status', style: subTextStyle),
                        SizedBox(width: 7.0),
                        Text(_.todoItems[index]['status'],
                            style: contentTextStyle),
                        Spacer(),
                        Text('Tick if completed',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Checkbox(
                            value: _.todoItems[index]['checked'],
                            onChanged:
                                _.todoItems[index]['status'] == 'Incomplete'
                                    ? null
                                    : (val) => _.checked(val, index))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<StateController>();
    return Obx(() => Visibility(
          visible: _.listenforpxup.value,
          child: Container(
              width: 65,
              height: 65,
              child: FittedBox(
                  child: FloatingActionButton(
                      child: Icon(Icons.add),
                      backgroundColor: primary,
                      onPressed: () => Get.toNamed('/addNew?type=add')))),
        ));
  }
}
