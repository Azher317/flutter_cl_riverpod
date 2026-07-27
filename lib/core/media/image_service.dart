import 'package:app/core/observability/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<CroppedFile?> cropImage(BuildContext context) async {
  try {
    final theme = Theme.of(context);
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result == null) return null;
    return await ImageCropper().cropImage(
      sourcePath: result.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: theme.colorScheme.primary,
          cropGridColor: theme.colorScheme.outline,
          backgroundColor: theme.colorScheme.surface,
          activeControlsWidgetColor: theme.colorScheme.primary,
          toolbarWidgetColor: theme.colorScheme.onPrimary,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          hideBottomControls: false,

          // Additional fixes for proper spacing
          cropFrameColor: theme.colorScheme.primary,
          cropGridRowCount: 3,
          cropGridColumnCount: 3,
          cropFrameStrokeWidth: 2,
          cropGridStrokeWidth: 1,
        ),
        IOSUiSettings(title: 'Crop'),
      ],
    );
  } catch (e, st) {
    AppLogger.error(e.toString(), e, st);
    return null;
  }
}
