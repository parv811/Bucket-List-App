import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Viewitem extends StatefulWidget {
  String title;
  String image;
  int index;
  Viewitem({
    super.key,
    required this.title,
    required this.image,
    required this.index,
  });

  @override
  State<Viewitem> createState() => _AddbucketlistState();
}

class _AddbucketlistState extends State<Viewitem> {
  Future<void> deleteData() async {
    Navigator.pop(context);
    try {
      await Dio().delete(
        "https://flutterapitest811-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json",
      );

      Navigator.pop(context, "refresh");
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Unable to delete! Please try again."),
          );
        },
      );
    }
  }

  Future<void> markAsComplete() async {
    try {
      Map<String, dynamic> data = {"completed": true};

      await Dio().patch(
        "https://flutterapitest811-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json",
        data: data,
      );

      Navigator.pop(context, "refresh");
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Unable to mark as complete! Please try again."),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Confirm to delete"),
                      actions: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        InkWell(onTap: deleteData, child: Text("Confirm")),
                      ],
                    );
                  },
                );
              }

              if (value == 2) {
                markAsComplete();
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(value: 1, child: Text("Delete")),
                PopupMenuItem(value: 2, child: Text("Mark as complete")),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
