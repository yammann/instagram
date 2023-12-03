
import 'package:firebase_storage/firebase_storage.dart';

getProfilImg({required imgName,required imgPaht,required foldername})async{
  final storgref = FirebaseStorage.instance.ref("$foldername/$imgName");
      UploadTask uplodTask = storgref.putData(imgPaht);
      TaskSnapshot snap = await uplodTask;
      String url = await snap.ref.getDownloadURL();

      return url;
}