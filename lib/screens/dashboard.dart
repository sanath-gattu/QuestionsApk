import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phnauthnew/screens/loginpage.dart';
import 'package:phnauthnew/services/authservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';
import 'package:paginate_firestore/paginate_firestore.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  String question;
  int x;

  List<String> list= [];

  TextEditingController textEditingController = TextEditingController();
  DocumentReference documentSnapshot = FirebaseFirestore.instance.collection("Questions").doc();


  @override
  void initState() {

     setState(() {
        x=Random().nextInt(5000);
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Questions "),
        actions: [

          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: ()
              {
                AuthService().signOut();
              },
            )
          )
        ]

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add
        ),
        onPressed: () async{
          _showDialog();
        },
      ),


      body:StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Questions').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data.docs.map((document) {
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.1,
                        width: MediaQuery.of(context).size.width/2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(width:1.0),
                          boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey[300] , spreadRadius: 2.0)]
                        ),

                          child: Column(
                            children: [

                              SizedBox(height: 3,),
                              Align(

                                  child: Text("Question Asked by :  " + document['ID'] +"  " , style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500),),
                                  alignment: Alignment.topRight,

                              ),
                              SizedBox(height: MediaQuery.of(context).size.height*0.020),
                              Center(
                                child: Text(document["Question"]),
                              ),


                            ],
                          ),

                      ),
                      
                      SizedBox(height: 5),
                      
                      document["ID"]== FirebaseAuth.instance.currentUser.phoneNumber? Container(

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                           onPressed: () async {
                            await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                            return AlertDialog(
                            contentPadding: const EdgeInsets.all(16.0),
                            content: Row(
                            children: <Widget>[
                            Expanded(
                            child: TextField(
                            controller: textEditingController,
                            autofocus: true,
                            maxLines: 5,
                            decoration: InputDecoration(
                            labelText: 'Edit Question',),

                            onChanged: (val){
                            this.question=val;
                            },
                            ),
                            )
                            ],
                            ),
                            actions: <Widget>[
                            TextButton(
                            child: const Text('CANCEL'),
                            onPressed: () {
                            Navigator.pop(context);
                            }),
                            TextButton(
                            child: const Text('SUBMIT'),
                            onPressed: () async{



                            FirebaseFirestore.instance.collection("Questions").doc(document.id).update(
                              {"Question" : question}
                            ).then((value) => textEditingController.clear());


                            Navigator.pop(context);


                            })
                            ],
                            );
                            },
                            );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 20
                            ),
                            child: Text(" Edit ")
                            ),
                            SizedBox(width: 10,),
                            ElevatedButton(


                              child: Text("Delete"),
                              style: ElevatedButton.styleFrom(
                                elevation: 20,

                                ),
                              onPressed: ()
                              {
                                  FirebaseFirestore.instance.collection("Questions").doc(document.id).delete();
                              },
                            ),
                          ],
                        ),
                      ) : Container()
                    ],
                  ),
                );
              }).toList(),
            );
          }),


    );

  }





  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  autofocus: true,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Ask Question',),

                  onChanged: (val){
                    this.question=val;
                  },
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                child: const Text('SUBMIT'),
                onPressed: () async{



                FirebaseFirestore.instance.collection("Questions").add({

                  "Question":question,
                  "ID":FirebaseAuth.instance.currentUser.phoneNumber,
                }).then((value) => textEditingController.clear());


                  Navigator.pop(context);


                })
          ],
        );
      },
    );
  }



  }


