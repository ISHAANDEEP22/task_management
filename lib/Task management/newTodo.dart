import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:task_management/Task management/newUI.dart';
import 'package:task_management/Auth/login.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

bool show = true;

class _Home_ScreenState extends State<Home_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management Tool'),
        centerTitle: true,
      ),
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Add_creen(),
            ));
          },
          backgroundColor: Colors.blue, // Button background color
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white, // Icon color
          ),
        ),
      ),
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                show = true;
              });
            }
            if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                show = false;
              });
            }
            return true;
          },
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 80,
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.red, // Set text color to red
                      ),
                    ),
                    onPressed: () => doUserLogout(context),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Make text bold
                      ),
                    ),
                  ),
                ),
              ),

              // Stream_note(false),
              Expanded(
                  child: FutureBuilder<List<ParseObject>>(
                      future: getTodo(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: Container(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator()),
                            );
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("Error..."),
                              );
                            }
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text("No Data..."),
                              );
                            } else {
                              return ListView.builder(
                                  padding: EdgeInsets.only(top: 10.0),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    //*************************************
                                    //Get Parse Object Values
                                    final varTodo = snapshot.data![index];
                                    final varTitle =
                                        varTodo.get<String>('title')!;
                                    final varDone = varTodo.get<bool>('done')!;
                                    //*************************************

                                    return ListTile(
                                      title: Text(varTitle),
                                      leading: CircleAvatar(
                                        child: Icon(varDone
                                            ? Icons.check
                                            : Icons.error),
                                        backgroundColor: varDone
                                            ? Colors.green
                                            : Colors.blue,
                                        foregroundColor: Colors.white,
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                              value: varDone,
                                              onChanged: (value) async {
                                                await updateTodo(
                                                    varTodo.objectId!, value!);
                                                setState(() {
                                                  //Refresh UI
                                                });
                                              }),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () async {
                                              await deleteTodo(
                                                  varTodo.objectId!);
                                              setState(() {
                                                final snackBar = SnackBar(
                                                  content:
                                                      Text("Todo deleted!"),
                                                  duration:
                                                      Duration(seconds: 2),
                                                );
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(snackBar);
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            }
                        }
                      })),
              Center(
                child: Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Stream_note(true),
            ],
          ),
        ),
      ),
    );
  }
}

doUserLogout(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => LoginPage()), // Navigate to RegisterPage
  );
}

Future<void> saveTodo(String title) async {
  final todo = ParseObject('Todo')
    ..set('title', title)
    ..set('done', false);
  await todo.save();
}

Future<List<ParseObject>> getTodo() async {
  QueryBuilder<ParseObject> queryTodo =
      QueryBuilder<ParseObject>(ParseObject('Todo'));
  final ParseResponse apiResponse = await queryTodo.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

Future<void> updateTodo(String id, bool done) async {
  var todo = ParseObject('Todo')
    ..objectId = id
    ..set('done', done);
  await todo.save();
}

Future<void> deleteTodo(String id) async {
  var todo = ParseObject('Todo')..objectId = id;
  await todo.delete();
}
