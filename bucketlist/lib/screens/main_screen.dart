import 'package:bucketlist/screens/add_screen.dart';
import 'package:bucketlist/screens/view_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketListData = [];
  bool isLoaded = false;
  bool isError = false;

  Future<void> getData() async {
    setState(() {
      isLoaded = true;
    });
    try {
      Response response = await Dio().get(
        "https://flutterapitest811-default-rtdb.firebaseio.com/bucketlist.json",
      );
      if (response.data is List) {
        bucketListData = response.data;
      } else {
        bucketListData = [];
      }
      isLoaded = false;
      isError = false;

      setState(() {});
    } catch (e) {
      setState(() {
        isLoaded = false;
        isError = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  Widget errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning),
          Text("Cannot connect to server..."),
          ElevatedButton(onPressed: getData, child: Text("Try again")),
        ],
      ),
    );
  }

  Widget bucketList() {
    List<dynamic> filteredList = bucketListData
        .where((element) => !(element?["completed"] ?? true))
        .toList();

    return (filteredList.length < 1)
        ? Center(
            child: Text(
              "No Data...",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        : ListView.builder(
            itemCount: bucketListData.length,
            itemBuilder: (BuildContext context, int index) {
              return ((bucketListData[index] is Map) &&
                      (!(bucketListData[index]?['completed'] ?? false)))
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Viewitem(
                                  title: bucketListData[index]['item'] ?? "",
                                  image: bucketListData[index]['image'] ?? "",
                                  index: index,
                                );
                              },
                            ),
                          ).then((value) {
                            if (value == "refresh") {
                              getData();
                            }
                          });
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            bucketListData[index]?['image'] ?? "",
                          ),
                        ),
                        title: Text(bucketListData[index]?['item'] ?? ""),
                        trailing: Text(
                          bucketListData[index]?['cost'].toString() ?? "",
                        ),
                      ),
                    )
                  : SizedBox();
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Bucket List"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: getData,
              child: Icon(Icons.refresh, size: 30),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: isLoaded
            ? Center(child: CircularProgressIndicator())
            : isError
            ? errorWidget()
            : bucketList(),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Addbucketlist(newIndex: bucketListData.length);
              },
            ),
          ).then((value) {
            if (value == "refresh") {
              getData();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
