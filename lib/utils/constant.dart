import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;
// final storageClient = SupabaseClient(supabaseUrl, supabaseKey, )

extension ShowSnackBar on BuildContext {
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.redAccent),
      ),
      backgroundColor: Colors.grey,
    ));
  }
}

Widget dataNotFound() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('assets/empty-folder.png'),
          width: 180,
          height: 180,
        ),
        Container(
            margin: EdgeInsets.only(top: 15),
            child: Text(
              'Belum Ada Data',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ))
      ],
    ),
  );
}

// Future<void> _takePicture() async{
//   try{
//     final XFile? pickedPhoto = await pi
//   }
// }