import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
/* Widgets: Includes a variety of Material Design widgets like Scaffold, AppBar, FloatingActionButton, TextField, and more.
The line import 'package:flutter/material.dart'; is used in Flutter applications to import the Material Design library,
which provides a rich set of pre-built widgets and tools to create beautiful and responsive user interfaces.*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_with_firebase/firestore/add_firestore_screen.dart';
import 'package:flutter_with_firebase/firestore/upload_image.dart';
import 'package:flutter_with_firebase/login_screen.dart';
import 'package:flutter_with_firebase/posts_pages/add_posts.dart';
import 'package:flutter_with_firebase/utils.dart';
class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  @override
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('users').snapshots();// this snapshot says stream requires query snapshots
  CollectionReference ref = FirebaseFirestore.instance.collection('users'); // this is reference for collection ref is taken to update the value or delete the value

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: const Text("Fire Store list", style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            showDialogBox(context);
          },
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
          SizedBox(width: 10),
        ],

      ),
      body: Column(
        //Animated list view -the can only be used in the run time and inside the Widget built
        //while Stream builder can be used anywhere in the code
        // as the database of firebase returns the events in the form of streams and is feasible to get
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                          width: 4,
                          color: Colors.deepPurple
                      )
                  )
              ),
              onChanged: (String value){
                setState(() {// because whenever the value in form field will change we need to rebuild the widget
                });
              },
            ),
          ),

         // The ListView dynamically updates as the data stream changes, thanks to the StreamBuilder.

          StreamBuilder<QuerySnapshot>(//This widget listens to a stream of QuerySnapshot data. A QuerySnapshot contains a collection of documents retrieved from Firestore.
              stream: firestore,//This is the data source for the StreamBuilder. It’s expected to be a stream that provides QuerySnapshot updates.
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();// if the connection is still waiting for data, it shows a loading spinner.
                }

                if(snapshot.hasError)
                  return const Text('Some Error Occured');

                final filteredDocs = snapshot.data!.docs.where((doc) {
                final title = doc['title'].toString().toLowerCase();
                return searchFilter.text.isEmpty || title.contains(searchFilter.text.toLowerCase());
    }).toList();

               return Expanded(
                child: ListView.builder(
                   itemCount: filteredDocs.length,
                 itemBuilder: (context, index) {
                   return ListTile(
                     leading: CircleAvatar(
                        child:  Text('${index + 1}', style: TextStyle(fontSize: 15)),
                  radius: 19,
    ),
                       title: Text(filteredDocs[index]['title'].toString()),
                       subtitle: Text(filteredDocs[index]['id'].toString()),
                       trailing:
                             SizedBox(
                               width: 50,
                               child: Row(
                                 children: [
                                   InkWell(
                                     child: Icon(Icons.edit,
                                     ),
                                     onTap:(){
                                       showMyDialog(filteredDocs[index]['title'].toString(), filteredDocs[index]['id'].toString());
                                     },
                                   ),
                                   InkWell(
                                     child: Icon(Icons.delete, color: Colors.red,),
                                     onTap: (){
                                       ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                     },
                                   )
                                 ],
                               ),
                             ),
                   );
    },
    ),
    );
    },
    ),
          SizedBox(
            height: 20,
            width: 30,
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadImageScreen()));
            }, child: Text('Post Picture') ),
          )
    ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddFirestoreScreen()));
      },
        child: const Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }



  Future <void> showMyDialog(String title, String id) async{
    editController.text =title;
   return showDialog<void>(
       context: context,
       builder: (BuildContext context){
         return AlertDialog(
           title: Text('Update'),
           content: Container(
             child: TextField(
               maxLines: 4,
               controller: editController,
               decoration: InputDecoration(
                 hintText: 'Enter your new Updated text',
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(20),
                   borderSide: BorderSide(
                     color: Colors.deepPurple,
                     width: 2
                   )
                 )
               ),
             ),
           ),
           actions: [
             TextButton(onPressed: (){
               Navigator.of(context).pop();
             }, child: const Text('Cancel')),
             TextButton(onPressed: (){
               ref.doc(id).update({
             'title' : editController.text.toString().trim()
         }).then((value) {
           Utils().toastMessage('Post Updated');
           Navigator.of(context).pop();
         }).onError((error,stackTree){
              Utils().toastMessage(error.toString());
         });
             }, child: Text('Update'))
           ],
         );
       });

  }

  void showDialogBox(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text("Log Out"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            // TextButton(
            //   child: Text("Log Out", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),),
            //   onPressed: () {
            //     firestore.signOut().then((value) {
            //       Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(builder: (context) => LoginScreen()),
            //       );
            //     }).onError((error, stackTrace) {
            //       Utils().toastMessage(error.toString());
            //     });
            //   },
            // ),
          ],
        );
      },
    );
  }

}


