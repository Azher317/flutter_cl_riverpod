import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/constants/sizes.dart';
import 'package:app/core/widgets/image/cached_image.dart';
import 'package:app/core/widgets/image/image_svg.dart';
import 'package:flutter/material.dart';

class AccountAvatar extends StatelessWidget {
  const AccountAvatar({
    super.key,
    required this.imageUrl,
    this.size = 56,
    this.verifiedSize = 20,
    this.isEditiable = false,
    this.onTap,
  });

  final String? imageUrl;
  final double size, verifiedSize;
  final bool isEditiable;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderSize.extraLargeRadius,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Badge(
            label:
                // isVerified ? SvgPicture.asset(Assets.assetsSvgCheckmarkBadge) :
                null,
            smallSize: verifiedSize,
            largeSize: verifiedSize,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            alignment: Alignment.topRight,
            child: _framed(
              context,
              child: imageUrl == null
                  ? _cameraPlaceholder(context)
                  : CachedImage(
                      imageUrl,
                      width: size,
                      height: size,
                      radius: size / 2,
                    ),
            ),
          ),
          if (isEditiable)
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: context.colorScheme.primary,
                  width: 1,
                ),
                shape: BoxShape.circle,
              ),
              padding: Insets.extraSmallAll,
              child: ImageSvg(
                img: 'CameraPlus',
                color: context.colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _framed(BuildContext context, {required Widget child}) => Container(
    height: size,
    width: size,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: context.colorScheme.outline, width: 0.25),
    ),
    child: child,
  );

  Widget _cameraPlaceholder(BuildContext context) => ColoredBox(
    color: context.colorScheme.surfaceContainerHighest,
    child: Padding(
      padding: Insets.extraSmallAll,
      child: ImageSvg(img: 'CameraPlus', fit: BoxFit.contain),
    ),
  );
}
