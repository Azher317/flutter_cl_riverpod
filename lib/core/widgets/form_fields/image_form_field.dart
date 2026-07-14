import 'dart:io';

import 'package:app/core/extensions/common_extensions.dart';
import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/media/image_service.dart';
import 'package:app/core/constants/sizes.dart';
import 'package:app/core/widgets/flex_padded.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageFormField extends StatelessWidget {
  const ImageFormField({
    super.key,
    required this.height,
    this.width,
    required this.imgheight,
    this.imgwidth,
    this.text,
    this.hintText,
    this.icon,
    required this.image,
    required this.onChanged,
  });

  ImageFormField.notifier(
    ValueNotifier<CroppedFile?> notifier, {
    super.key,
    required this.height,
    this.width,
    required this.imgheight,
    this.imgwidth,
    this.text,
    this.hintText,
    this.icon,
  }) : image = notifier.value,
       onChanged = notifier.update;

  final CroppedFile? image;
  final ValueChanged<CroppedFile> onChanged;
  final double height;
  final double? width;
  final double imgheight;
  final double? imgwidth;
  final String? text;
  final String? hintText;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedSwitcher(
      duration: Time.small,
      child: image == null
          ? FormField(
              initialValue: image,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null) return context.l10n.validatorRequired;
                return null;
              },
              builder: (field) {
                return InkWell(
                  onTap: () {
                    cropImage(context).then((value) {
                      if (value != null) onChanged(value);
                    });
                  },
                  child: ColumnPadded(
                    gap: 4,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: width ?? height,
                        height: height,
                        padding: EdgeInsets.symmetric(horizontal: 11),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outline),
                          borderRadius: BorderSize.smallRadius,
                        ),
                        child: Row(
                          mainAxisAlignment: hintText != null
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                          children: [
                            if (hintText != null) ...[
                              Text(
                                hintText!,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                            Icon(
                              Icons.add_a_photo,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                      if (text != null) ...[
                        Text(text!, style: theme.textTheme.titleLarge),
                      ],
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            field.errorText!,
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            )
          : InkWell(
              onTap: () {
                cropImage(context).then((value) {
                  if (value != null) onChanged(value);
                });
              },
              child: Column(
                children: [
                  Container(
                    width: (imgwidth ?? imgheight) * 3,
                    height: imgheight * 3,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outline),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderSize.smallRadius,
                      child: Image.file(File(image!.path), fit: BoxFit.cover),
                    ),
                  ),
                  if (text != null) ...[
                    Text(text!, style: theme.textTheme.titleLarge),
                  ],
                ],
              ),
            ),
    );
  }
}
