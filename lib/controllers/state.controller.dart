import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StateController extends GetxController {
  var scrollController = ScrollController();
  TextEditingController title = TextEditingController();
  TextEditingController startdate = TextEditingController();
  TextEditingController enddate = TextEditingController();

  DateTime sd;
  DateTime ed;

  Timer timer;

  final listenforpxup = true.obs;
  final checkedValue = false.obs;

  var todoItems = [].obs;

  @override
  void onInit() {
    super.onInit();
    initList();
    cal();
    scrollController.addListener(() {
      //NOTE: Hide & Show FAB on scroll
      if (listenforpxup.value) {
        if (scrollController.position.pixels.round() > 140) {
          listenforpxup.value = false;
        }
      } else {
        if (scrollController.position.pixels.round() <= 140) {
          listenforpxup.value = true;
        }
      }
    });
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => cal());
  }

  void initList() {
    final box = GetStorage();
    if (box.read('todo') != null) {
      List list = box.read('todo');
      for (var item in list) {
        todoItems.add(item);
      }
    }
    return;
  }

  void cal() {
    for (var i = 0; i < todoItems.length; i++) {
      var item = todoItems[i];
      DateTime ed = DateTime.parse(item['ed']);
      Duration diff = ed.difference(DateTime.now());
      if (diff.inMinutes.remainder(60) < 0) {
        item['hours'] = '--';
        item['minutes'] = '--';
        item['status'] = 'Incomplete';
      } else {
        item['hours'] = diff.inHours;
        item['minutes'] = diff.inMinutes.remainder(60);
      }
      todoItems[i] = item;
    }
  }

  void saveToStorage() {
    final box = GetStorage();
    box.write('todo', todoItems);
    return;
  }

  checked(bool val, int index) async {
    if (val) {
      await Get.defaultDialog(
          title: 'Tick to-do',
          middleText: 'Completed this to-do?',
          textConfirm: 'Confirm',
          confirmTextColor: Colors.white,
          onConfirm: () {
            var item = todoItems[index];
            item['checked'] = val;
            if (val) {
              item['status'] = 'Completed';
            } else {
              item['status'] = '-';
            }
            todoItems[index] = item;
            saveToStorage();
            Get.back();
          },
          textCancel: 'Cancel');
    } else {
      await Get.defaultDialog(
          title: 'Untick to-do',
          middleText: 'Untick this to-do?',
          textConfirm: 'Confirm',
          confirmTextColor: Colors.white,
          onConfirm: () {
            var item = todoItems[index];
            item['checked'] = val;
            if (val) {
              item['status'] = 'Completed';
            } else {
              item['status'] = '-';
            }
            todoItems[index] = item;
            saveToStorage();
            Get.back();
          },
          textCancel: 'Cancel');
    }
    return;
  }

  void remove(int index) async {
    await Get.defaultDialog(
        title: 'Remove to-do',
        middleText: 'remove this to-do?',
        textConfirm: 'Confirm',
        confirmTextColor: Colors.white,
        onConfirm: () => {todoItems.removeAt(index), Get.back()},
        textCancel: 'Cancel');
    saveToStorage();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
