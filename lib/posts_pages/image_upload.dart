// import 'package:flutter/material.dart';
// import 'package:flutter_with_firebase/posts_pages/storage_service.dart';
// import 'package:provider/provider.dart';
//
// class ImageUpload extends StatefulWidget {
//   const ImageUpload({super.key});
//
//   @override
//   State<ImageUpload> createState() => _ImageUploadState();
// }
//
// class _ImageUploadState extends State<ImageUpload> {
//   @override
//   void initState(){
//   super.initState();
//   fetchImages();
// }
// // fetch images
// Future<void> fetchImages() async{
//     await Provider.of<StorageService>(context, listen: false).fetchImages();
// }
// @override
//   Widget build(BuildContext context) {
//     //Consumer of Storage service
//
//     return Consumer<StorageService>(builder: (context, storageService, child){
//       //list of image Urls
//       final List<String> imageUrls = storageService.imageUrls;
//       //home page UI
//       return Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => storageService.uploadImage(),
//         child: const Icon(Icons.add),
//         ),
//       body: ListView.builder(
//           itemCount: imageUrls.length,
//           itemBuilder: (context, index){
//         //get each individual image
//         final String imageUrl = imageUrls[index];
//         //image post UI
//             return Image.network(imageUrl);
//       }),
//       );
//     }
//
//     );
//   }
// // }
