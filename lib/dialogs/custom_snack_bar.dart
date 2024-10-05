import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showCustomSnackBar({required String title, required String body}) {
  Get.showSnackbar(
    GetSnackBar(
      overlayColor: Colors.white,
      titleText: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Almarai',
        ),
      ),
      messageText: Text(
        body,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Almarai',
        ),
      ),
      icon: const Icon(Icons.check, color: Colors.white),
      duration: const Duration(seconds: 3),
      backgroundColor: primaryColor.withOpacity(0.8),
    ),
  );
}
