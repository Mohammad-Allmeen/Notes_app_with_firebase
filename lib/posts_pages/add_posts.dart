
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/rounded_button.dart';
import 'package:flutter_with_firebase/utils.dart';

class AddPostsScreen extends StatefulWidget {
  const AddPostsScreen({super.key});

  @override
  State<AddPostsScreen> createState() => _AddPostsScreenState();
}

class _AddPostsScreenState extends State<AddPostsScreen> {
  final postController = TextEditingController();
  bool loading = false;
  //final post2Controller = TextEditingController();
  final _keyform = GlobalKey<FormState>();
  final databaseRef = FirebaseDatabase.instance.ref('Test');// basically we creating a Test table or node(in firebase, table is called Node) with the reference databaseRef and also creating an instance
  //Test is a table which works as a reference

  void addFunction(){
    setState(() {
      loading =true;
    }); // in Test table, 1 is the 1st child of that table, we have a created Firebase instance and then databaseRef of table post whose child is 1 and it contains data in the set

    String id = DateTime.now().millisecondsSinceEpoch.toString(); //milliseconds is used so that the id value changes fast and all data will get different id's
    databaseRef.child(id).set({ //DateTime is id of the data that a user adds because at every seconds the data can be added hence this function will provide unique id to each and every data
      'Greetings': postController.text.toString(), //key: value pair
      'id': id,
    }).then((value){
      Utils().toastMessage('Post Added');
      setState(() {
        loading=false;
      });
      Navigator.pop(context);
    }).onError((error, stackTree){
      Utils().toastMessage(error.toString());
      setState(() {
        loading=false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post',style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _keyform,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: postController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'What is in your mind?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                      width: 2
                    )
                  )
                ),
                validator: (value){
                  if(value!.isNotEmpty){
                    return null;
                  }
                  return 'Please,Enter the Details';
                }
              ),
              SizedBox(
                height: 20,
              ),
              RoundButton(
                title: 'Add',
                loading: loading,
                onTap: (){
                 if(_keyform.currentState!.validate())
                   {
                     addFunction();
                   }
                },
              )
            ],
          ),
        ),
      ),

    );
  }



}
