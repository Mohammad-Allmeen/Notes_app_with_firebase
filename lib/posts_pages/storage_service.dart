//
//
// import 'dart:io';
//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart';
//
// class StorageService with ChangeNotifier{
// //instance of the firebase
//   final firebaseStorage = FirebaseStorage.instance;
//
// // images are stored in firebase as download URLs
//   //eg- https://firbasestorage.googleapi.com/v0/b/-mastrclass.../uploaded_images/[image_name.png]
//
// List<String> _imageUrls=[];
//
// //loading status
//
// bool _isLoading = false;
//
// //uploading status
//
// bool _isUploading = false;
//
// // Getters
//
// List<String> get imageUrls => _imageUrls;
// bool get isLoading => _isLoading;
// bool get isUploading => _isUploading;
//
// //read Images
//
// Future <void> fetchImages() async {
//   //start loading
//   _isLoading = true;
//
//   //get the list under the directory: uploaded_images
//   final ListResult result = await firebaseStorage.ref('uploaded_images/')
//       .listAll();
//
//   //get the downloaded URLs for each image
//   final urls = await Future.wait(
//       result.items.map((ref) => ref.getDownloadURL()));
//
//   //update Urls
//
//   _imageUrls = urls;
//
//   //loading finished...
//
//   _isLoading = false;
//
//   //update UI
//   notifyListeners();
// }
//   //delete the image
//
//   //in order to delete the images we only need to know the path of image stored in the firebase
//   Future<void> deleteImages(String imageUrls) async{
//   try{
//     //remove from the local list
//     _imageUrls.remove(imageUrls);
//
//     //get path name and delete from firebase
//
//     final String path = extractPathFromUrl(imageUrls);
//     await firebaseStorage.ref(path).delete();
//   }
//   catch (e){
//     print('Error deleting image: $e');
//   }
//   }
// String extractPathFromUrl(String url){
//   Uri uri = Uri.parse(url);
//
//   //extracting the part of url we need
//   String encodePath = uri.pathSegments.last;
//
//   //url decoding the path
//   return Uri.decodeComponent(encodePath);
// }
//
// //upload the image
//
// Future<void> uploadImage()async{
//   _isLoading =true;
//   //updating the UI
//   notifyListeners();
//
//   //pick the image from the gallery
//
//   final ImagePicker picker = ImagePicker();
//   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//
//   if(image==null) return; //if user cancelled the picker
//
//   //get the file image path
//   File file = File(image.path);
//
//   try{
//     //define the path in the storage
//     String filePath = 'uploaded_images/${(DateTime.now())}.png';
//
//     //upload the file to firebase storage
//     await firebaseStorage.ref(filePath).putFile(file);
//
//     //after uploading fetch the uploaded url
//     String downloadUrl = await firebaseStorage.ref(filePath).getDownloadURL();
//
//     //update the image url list and UI
//     _imageUrls.add(downloadUrl);
//     notifyListeners();
//   }
//   catch(e){
//     print('Error uploading $e');
//   }
//   finally{
//     _isLoading = false;
//     notifyListeners();
//   }
// }
// }