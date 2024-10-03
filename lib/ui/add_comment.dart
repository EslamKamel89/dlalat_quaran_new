import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/widgets/custom_buttons.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCommentView extends StatefulWidget {
  const AddCommentView({super.key});
  static var id = '/AddComment';

  @override
  State<AddCommentView> createState() => _AddCommentViewState();
}

class _AddCommentViewState extends State<AddCommentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QuranBar('addComment'.tr),
      backgroundColor: lightGray2,
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'الاسم',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 18,
                  fontFamily: 'Almarai',
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                // minLines: 5,
                // maxLines: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: '',
                  isDense: true, // Added this
                  contentPadding: const EdgeInsets.all(8), // Added this
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'البريد الألكتروني',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 18,
                  fontFamily: 'Almarai',
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                // minLines: 5,
                // maxLines: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: '',
                  isDense: true, // Added this
                  contentPadding: const EdgeInsets.all(8), // Added this
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'phoneNumber'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 18,
                  fontFamily: 'Almarai',
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                // minLines: 5,
                // maxLines: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: '',
                  isDense: true, // Added this
                  contentPadding: const EdgeInsets.all(8), // Added this
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'comment'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 18,
                  fontFamily: 'Almarai',
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                minLines: 5,
                maxLines: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  // labelText: 'Even Densed TextFiled',
                  isDense: true, // Added this
                  contentPadding: const EdgeInsets.all(8), // Added this
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: PrimaryButton(
                  onPressed: () {
                    Get.back();
                    Get.showSnackbar(
                      GetSnackBar(
                        overlayColor: Colors.white,
                        titleText: const Text(
                          'شكرا',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Almarai',
                          ),
                        ),
                        messageText: const Text(
                          'تم أضافة تعليقكم بنجاح',
                          style: TextStyle(
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
                  },
                  borderRadius: 5,
                  child: Text(
                    'save'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
