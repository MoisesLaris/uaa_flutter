import 'package:flutter/material.dart';
import 'package:form_validation/enums/enum_apis.dart';
import 'package:form_validation/src/providers/publicacion_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';

class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  final PostProvider postProvider;  
  MyAppZefyrImageDelegate(this.postProvider);

  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    if (file == null) return null;
    // Use my storage service to upload selected file. The uploadImage method
    // returns unique ID of newly uploaded image on my server.

    final String imageId = await postProvider.uploadImage(file);
    return ApisEnum.url + ApisEnum.getPostImage + imageId;
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    // final file = File.fromUri(Uri.parse(key)); //Esto es para traer una imagen del dispositivo
    /// Create standard [FileImage] provider. If [key] was an HTTP link
    /// we could use [NetworkImage] instead.
    final image = NetworkImage(key); // Esto es para traer una imagen de un URL
    return Image(image: image);
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;
}