import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/utils/upload_picker.dart';

/// Shows a picked file inside an upload box: the image itself, or a PDF
/// icon with the file name.
class UploadPreview extends StatelessWidget {
  const UploadPreview({super.key, required this.upload});

  final UploadPicked upload;

  static const double _pdfIconSize = 32;
  static const double _iconToName = 6;
  static const EdgeInsets _namePadding = EdgeInsets.symmetric(horizontal: 16);

  @override
  Widget build(BuildContext context) {
    if (!upload.isPdf) {
      return Image.file(File(upload.file.path), fit: BoxFit.cover);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.picture_as_pdf_outlined,
          size: _pdfIconSize,
          color: AppColors.primary,
        ),
        const SizedBox(height: _iconToName),
        Padding(
          padding: _namePadding,
          child: Text(
            upload.file.name,
            style: AppTextStyles.uploadLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
