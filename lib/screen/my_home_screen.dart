import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      var fileContent = await file.readAsLines();
      int count = 0;
      for (int i = 0; i < fileContent.length; i++) {
        List res = fileContent[i].split(',');
        print(res.length);
        res.forEach((e) {
          print("Res $e");
        });
        if (res.length == 2) {
          print('add 1');
          addContact(res[0], res[1]);
        } else {
          print('add 2');
          addContact(res[0], res[0]);
        }
        count++;
      }
      showMessage('Контакти імпортовані к-сть:$count', true);
    } else {
      showMessage('Виникла помилка, файл не обрано');
    }
  }

  addContact(
    String name,
    String phone,
  ) async {
    Contact contact =
        Contact(phones: [Item(label: "mobile", value: phone)], givenName: name);
    await ContactsService.addContact(contact);
  }

  delContacts() async {
    int count = 0;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      var fileContent = await file.readAsLines();
      List<Contact> contacts = await ContactsService.getContacts();

      for (int i = 0; i < fileContent.length; i++) {
        List res = fileContent[i].split(',');

        if (res.length == 2) {
          for (var contact in contacts) {
            if (contact.givenName == res[0] || contact.givenName == res[1]) {
              await ContactsService.deleteContact(contact);
            }
          }
          count++;
        } else {
          for (var contact in contacts) {
            if (contact.givenName == res[0]) {
              await ContactsService.deleteContact(contact);
            }
          }
          count++;
        }
      }
      showMessage('Контакти видалені к-сть: $count', true);
    } else {
      showMessage('Виникла помилка, файл не обрано');
    }
  }

  showMessage(String text, [bool isTrue = false]) {
    final snackBar = SnackBar(
      backgroundColor: isTrue ? Colors.green : Colors.red,
      content: Text(
        text,
        style: TextStyle(fontSize: isTrue ? 18.0 : 16.0),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'VARIANT 1 with Name',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const Text(
            'Alex, 380971234567\nBen, 380971234567',
            style: TextStyle(fontSize: 18.0),
          ),
          const SizedBox(
            height: 30.0,
            width: double.infinity,
            child: Divider(
              height: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'VARIANT 2 without Name',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const Text(
            '380971234567,\n380971234567,',
            style: TextStyle(fontSize: 18.0),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: openFile,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 18.0),
              child: Text(
                'Open *.txt file',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          const SizedBox(height: 18.0),
          ElevatedButton(
            onPressed: delContacts,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 18.0),
              child: Text(
                'Delete *.txt file',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
