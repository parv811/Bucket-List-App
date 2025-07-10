import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Addbucketlist extends StatefulWidget {
  int newIndex;
  Addbucketlist({super.key, required this.newIndex});

  @override
  State<Addbucketlist> createState() => _AddbucketlistState();
}

class _AddbucketlistState extends State<Addbucketlist> {
  TextEditingController itemText = TextEditingController();
  TextEditingController costText = TextEditingController();
  TextEditingController imageText = TextEditingController();

  Future<void> addData() async {
    try {
      Map<String, dynamic> data = {
        "completed": false,
        "cost": costText.text,
        "image": imageText.text,
        "item": itemText.text,
      };

      await Dio().patch(
        "https://flutterapitest811-default-rtdb.firebaseio.com/bucketlist/${widget.newIndex}.json",
        data: data,
      );

      Navigator.pop(context, "refresh");
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var addForm = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: Text("Add Bucket List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: addForm,
          child: Column(
            children: [
              TextFormField(
                controller: itemText,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "Item must have more than 2 characters";
                  }
                  if (value == null || value.isEmpty) {
                    return "Item cannot be empty";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(label: Text("Item")),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: costText,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cost cannot be empty";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(label: Text("Estimated Cost")),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: imageText,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "URL must have more than 2 characters";
                  }
                  if (value == null || value.isEmpty) {
                    return "URL cannot be empty";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(label: Text("Image URL")),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (addForm.currentState!.validate()) {
                          addData();
                        }
                      },
                      child: Text("Add Item"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
