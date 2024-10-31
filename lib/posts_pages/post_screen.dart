//Firebase is SQL database
// Firestore is a NoSQL / Rational Database

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/firestore/firestore_list_screen.dart';
import 'package:flutter_with_firebase/login_screen.dart';
import 'package:flutter_with_firebase/posts_pages/add_posts.dart';
import 'package:flutter_with_firebase/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Test');// the name for eg. Test should be same as used in the add post reference
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  void initState(){
    super.initState();
        }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: Text("Post", style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
           showDialogBox(context);
          },
            icon: Icon(Icons.logout_outlined, color: Colors.white),
          ),
          SizedBox(width: 10),
        ],

      ),
      body: Column(
        //Animated list view -the can only be used in the run time and inside the Widget built
        //while Stream builder can be used anywhere in the code.
        //as the database of firebase returns the events in the form of streams and is feasible to get
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
          Expanded(
            child:  FirebaseAnimatedList(query: ref,
                itemBuilder: (context, snapshot, animation, index){
              final title = snapshot.child('Greetings').value.toString();
              if (searchFilter.text.isEmpty)
                {
                  return ListTile(
                      leading: CircleAvatar(child:
                      Text('${index+1}', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                      ),
                        radius:18,
                      ),
                      title: Text(snapshot.child('Greetings').value.toString()),// . value will bring the value
                      subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context)=>[
                          PopupMenuItem(value:1,
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                                onTap: (){
                                  Navigator.pop(context);
                                  showMyDialog(title, snapshot.child('id').value.toString());
                                },
                              ) ),
                          PopupMenuItem(
                              value:1,
                              child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                                onTap: (){
                                  Navigator.pop(context);
                              ref.child(snapshot.child('id').value.toString()).remove(); //we have taken database reference along with id and the use of remove function to delete the data
                                },
                          ))
                        ]),
                  );
                }
              else if(title.toLowerCase().contains(searchFilter.text.toLowerCase())){
                return ListTile(
                    leading:  CircleAvatar(child:
                    Text('${index+1}', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                    ),
                      radius:18,
                    ),
                    title: Text(snapshot.child('Greetings').value.toString()),// . value will bring the value
                    subtitle: Text(snapshot.child('id').value.toString())
                );
              }
              else{
                return Container();
              }

                }),
          )

        ],
      ),

      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPostsScreen()));
      },
      child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }


  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(hintText: 'Enter your update here'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () { //ref is the reference of the database
                Navigator.pop(context);
                ref.child(id).update({
                  'Greetings':editController.text.toString()
                }).then((value){
                  Utils().toastMessage('Post Updated');
                }).onError((error, stackTree){
                  Utils().toastMessage(error.toString());
                });
                // Close the dialog after action
              },
             child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void showDialogBox(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log Out"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Log Out", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),),
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
            ),
            TextButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>FirestoreScreen()));
            }, child: Text('FireStore Screen', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)))
          ],
        );
      },
    );
  }

}





//Stream Builder is the another method or alternative method or process to retrieve or fetch the dat from the database

// Expanded(child: StreamBuilder(
// stream: ref.onValue,
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) //because on Value is returning or doing the database event
//     {
// if(!snapshot.hasData)
// {
// return CircularProgressIndicator();
// }
// else
// {
// Map<dynamic, dynamic> map =snapshot.data!.snapshot.value as dynamic;// as the data is dynamic
// List<dynamic> list=[]; // the data which we fetch is stored in the list
// list.clear(); // any default or unnecessary value get cleared
// list =map.values.toList(); // the value fetched in map format is stored in the list
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context,index){
// return ListTile(
// leading: Text('${index+1}'),
// title: Text(list[index]['Greetings'].toString()),
// subtitle: Text(list[index]['id'].toString()),
// trailing: FaIcon(FontAwesomeIcons.arrowLeft,color: Colors.deepPurple,),
// );
// });
// }
// }
// )
// ),

//
// actions: [
// IconButton(onPressed: (){
// _auth.signOut().then((value){
// Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
// }).onError((error, stackTrace){
// Utils().toastMessage(error.toString());
// });
//
// },
