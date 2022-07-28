import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final whiteTheme = ThemeData(
    backgroundColor: AppColors.appColor5,
    primaryColor: AppColors.appColor1,
    focusColor: AppColors.black,
  );

  static final darkTheme = ThemeData(
    backgroundColor: AppColors.black,
    primaryColor: AppColors.appColor1,
  );
}
