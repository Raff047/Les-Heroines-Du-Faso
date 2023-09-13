// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/providers/firebase_providers.dart';

final commonFirebaseStorageMethodsProvider = Provider((ref) =>
    CommonFirebaseStorageMethods(firebaseStorage: ref.read(storageProvider)));

class CommonFirebaseStorageMethods {
  final FirebaseStorage firebaseStorage;
  CommonFirebaseStorageMethods({
    required this.firebaseStorage,
  });

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
