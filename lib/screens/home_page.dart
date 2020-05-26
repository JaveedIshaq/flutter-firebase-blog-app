import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/screens/create_blog.dart';
import 'package:flutter_firebase_blog_app/services/post_database.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PostDatabase postDatabase = PostDatabase();
  Stream blogStream;

  @override
  void initState() {
    postDatabase.getData().then((result) {
      setState(() {
        blogStream = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateBlog()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        title: buildAppBarTitle(),
      ),
      body: buildBlogList(),
    );
  }

  Container buildBlogList() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        padding: EdgeInsets.only(bottom: 20),
        child: (blogStream == null)
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: blogStream,
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return buildBlogCard(snapshot, index);
                      });
                }));
  }

  Card buildBlogCard(AsyncSnapshot snapshot, int index) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${snapshot.data.documents[index].data["title"]}",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Image.network(snapshot.data.documents[index].data["imgUrl"]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Author: ${snapshot.data.documents[index].data["authorName"]}",
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${snapshot.data.documents[index].data["desccription"]}",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }

  Widget buildAppBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Flutter "),
        Text(
          "Firebase ",
          style: TextStyle(
            color: Colors.red[300],
          ),
        ),
        Text(
          "Blog ",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        Text(
          "App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
