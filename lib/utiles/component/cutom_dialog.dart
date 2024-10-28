import 'package:flutter/material.dart';

import '../constants/app_colors/app_colors.dart';
import 'custom_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final TextStyle? textSecondaryStyle;
  final TextStyle? textPrimaryStyle;
  final String? message;
  final bool isSvg;
  final String? image;
  final double? widthImage;
  final double? heightImage;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback primaryButtonAction;
  final VoidCallback secondaryButtonAction;

  const CustomDialog({
    Key? key,
    required this.title,
    this.message,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.primaryButtonAction,
    required this.secondaryButtonAction,
    this.image,
    this.widthImage,
    this.heightImage, this.titleStyle, this.textSecondaryStyle, this.textPrimaryStyle, required this.isSvg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          if (image != null)
            isSvg==true?Image.asset(   image!, // Use the image parameter instead of a hardcoded value
              height: heightImage,
              width: widthImage,):
            Image.asset(
              image!, // Use the image parameter instead of a hardcoded value
              height: heightImage,
              width: widthImage,
            ),
          Text(
            title,
            style:titleStyle?? TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          if (message != null)
            Text(
              message!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGreyColor,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 20),
          CustomButton(
            label: primaryButtonText,
            onPressed: primaryButtonAction,
            size: const Size(double.infinity, 40),
            style: textPrimaryStyle??Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.whiteColor,
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(
            label: secondaryButtonText,
            onPressed: secondaryButtonAction,
            size: const Size(double.infinity, 40),
            color: Colors.white,
            style:textSecondaryStyle?? Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
