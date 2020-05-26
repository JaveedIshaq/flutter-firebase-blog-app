import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/services/post_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  PostDatabase postDatabase = PostDatabase();
  String authorName, title, description;
  File selectedImage;
  bool isLoading = false;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  uploadBlog() async {
    if (selectedImage != null) {
      /// upload Image to Firebase Storage
      setState(() {
        isLoading = true;
      });

      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImage")
          .child("${randomAlphaNumeric(9)}.jpog");

      StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);

      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();

      print("This is URL of Image: $downloadUrl");

      Map<String, String> blogPostMap = {
        "imgUrl": downloadUrl,
        "authorName": authorName,
        "title": title,
        "desccription": description
      };

      postDatabase.addData(blogPostMap).then((value) => Navigator.pop(context));

      setState(() {
        isLoading = false;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: buildAppBarTitle(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: () {
              uploadBlog();
            },
          )
        ],
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 20),
                  (selectedImage != null)
                      ? buildShhowPhotoWidget(size)
                      : buildAddPhotoWidget(size),
                  TextFormField(
                    onChanged: (value) {
                      authorName = value;
                    },
                    decoration: InputDecoration(hintText: "Author Name"),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(hintText: "Title"),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      description = value;
                    },
                    decoration: InputDecoration(hintText: "Description"),
                  ),
                ],
              )),
    );
  }

  Widget buildAddPhotoWidget(Size size) {
    return GestureDetector(
      onTap: () {
        getImage();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 120,
        width: size.width,
        child: Center(
          child: Icon(
            Icons.camera_alt,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget buildShhowPhotoWidget(Size size) {
    return GestureDetector(
      onTap: () {
        getImage();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 120,
        width: size.width,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.file(selectedImage, fit: BoxFit.cover)),
      ),
    );
  }

  Widget buildAppBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Add "),
        Text(
          "New ",
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
          "Post",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
