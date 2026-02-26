import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:uuid/uuid.dart';

class CloudinaryService {
  final Cloudinary cloudinary = Cloudinary.unsignedConfig(
    cloudName: "dtxtvspsw",
  );

  Future<String?> saveToCloudinary(File file) async {
    try {
      final fileName = "store_image_${const Uuid().v4()}";

      final response = await cloudinary.unsignedUpload(
        file: file.path,
        uploadPreset: "stores",
        resourceType: CloudinaryResourceType.image,
        folder: "stores",
        fileName: fileName,
        progressCallback: (count, total) {
        },
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
