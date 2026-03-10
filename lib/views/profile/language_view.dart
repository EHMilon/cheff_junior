import 'package:chef_junior/core/themes/app_colors.dart';
import 'package:chef_junior/shared/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  String selectedLanguage = 'en_US';

  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en_US'},
    {'name': 'Not Finalized Yet', 'code': 'other'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(title: 'select_language'.tr),
            SizedBox(height: 24.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: languages.length,
                
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedLanguage = lang['code']!;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedLanguage == lang['code']
                                    ? AppColors.primary
                                    : AppColors.grey200,
                                width: 2,
                              ),
                            ),
                            child: selectedLanguage == lang['code']
                                ? Center(
                                    child: Container(
                                      width: 10.w,
                                      height: 10.h,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            lang['name']!,
                            style: GoogleFonts.baloo2(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textBody,
                              // color: const Color(0xFF242424),
            height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement language change logic
                    if (selectedLanguage == 'en_US') {
                      Get.updateLocale(const Locale('en_US'));
                    }
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  child: Text(
                    'change_language'.tr,
                    style: GoogleFonts.baloo2(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
