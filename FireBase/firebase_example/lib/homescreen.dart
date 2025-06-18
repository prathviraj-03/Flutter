import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class  Homescreen extends StatefulWidget{
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  TextEditingController controller = TextEditingController();

  final CollectionReference users = FirebaseFirestore.instance.collection("users");
  String documentId = "demo-user";
  String namee = "";


  void createData(){
    users.doc(documentId).set({"name": controller.text.toString()});
    controller.clear();

  }
  void updateData(){
    users.doc(documentId).update({"name":controller.text});

  }
  Future<void> readData() async {
    DocumentSnapshot doc =await users.doc(documentId).get();
    if(doc.exists){
      setState(() {
        namee = doc.get("name");
      });
    } else {
      setState(() {
        namee = "No data found";
      });
    }
  }
  void deleteData(){
    users.doc(documentId).delete();
  }
  @override
  Widget build(BuildContext context) {
    
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: (){FirebaseAuth.instance.signOut()
          Navigator.instance.}, icon: icon)],
          title: const Text('Home Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(namee),
              TextField(controller: controller,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ElevatedButton(onPressed: createData, child: Text("CREATE")),
              ElevatedButton(onPressed: updateData, child: Text("UPADTE")),
              ElevatedButton(onPressed: readData, child: Text("READ")),
              ElevatedButton(onPressed: deleteData, child: Text("DELETE"))],)
            ],
          ),
        ),
      ),
    );
  }
}