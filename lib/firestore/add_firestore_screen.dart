
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/rounded_button.dart';
import 'package:flutter_with_firebase/utils.dart';
import 'package:firebase_core/firebase_core.dart';
class AddFirestoreScreen extends StatefulWidget {
  const AddFirestoreScreen({super.key});

  @override
  State<AddFirestoreScreen> createState() => _AddFirestoreScreenState();
}

class _AddFirestoreScreenState extends State<AddFirestoreScreen> {
  final addController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users'); //creating the firestore collections because unlike in real time database the data is
  // store in the form of tree but in cloud firestore the data is store in collection and inside the documents are present.
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Fire Store Data', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
                maxLines: 4,
                controller: addController,
                decoration: InputDecoration(
                    hintText: 'What is on your Mind?',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            width: 2,
                            color: Colors.deepPurple
                        )
                    )
                )
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: "Add",
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                // inside the collections creating the documents and there we will set the data like in database
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  //documents needs ID and we do not provide it will automatically create by default
                  'title': addController.text.toString(),
                  'id': id
                }).then((value) {
                  Utils().toastMessage('Post Added');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTree) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
