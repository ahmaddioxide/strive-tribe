import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lobay/common_widgets/widget_constants.dart';
import 'package:lobay/generated/assets.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';
import 'dart:io';

class AppImageWidget extends StatelessWidget {
  final String imagePathOrURL;
  final double height;
  final double width;
  final BoxFit boxFit;
  final FilterQuality filterQuality;
  final Color? colorSVG;
  final bool networkImage;
  final Color? colorProgressLoaderIndicator;
  final String? networkErrorPlaceHolderImagePath;

  const AppImageWidget(
      {super.key,
      this.networkErrorPlaceHolderImagePath,
      this.colorProgressLoaderIndicator,
      this.networkImage = false,
      this.colorSVG,
      this.boxFit = BoxFit.fill,
      required this.imagePathOrURL,
      this.height = 20,
      this.width = 20,
      this.filterQuality = FilterQuality.high});

  @override
  Widget build(BuildContext context) {
    if (networkImage) {
      return imagePathOrURL.contains('?')
          ? getNetworkImageView(
              boxFit: boxFit,
              context: context,
              colorProgressLoaderIndicator: colorProgressLoaderIndicator,
              imageWidth: width,
              imageHeight: height,
              imageURL: imagePathOrURL.split('?')[0])
          : getNetworkImageView(
              boxFit: boxFit,
              context: context,
              colorProgressLoaderIndicator: colorProgressLoaderIndicator,
              imageWidth: width,
              imageHeight: height,
              imageURL: imagePathOrURL);
    } else {
      if (imagePathOrURL.isNotEmpty) {
        // Check if the path is a filesystem path
        if (imagePathOrURL.startsWith('/')) {
          return Image.file(
            File(imagePathOrURL),
            height: height,
            width: width,
            filterQuality: filterQuality,
            fit: boxFit,
            color: colorSVG,
          );
        }
        // Handle local assets
        else if (imagePathOrURL.endsWith('.png') ||
            imagePathOrURL.endsWith('.jpg') ||
            imagePathOrURL.endsWith('.jpeg')) {
          return Image.asset(
            imagePathOrURL,
            height: height,
            width: width,
            filterQuality: filterQuality,
            fit: boxFit,
            color: colorSVG,
          );
        } else if (imagePathOrURL.endsWith('.svg')) {
          return SvgPicture.asset(
            imagePathOrURL,
            height: height,
            width: width,
            fit: boxFit,
            colorFilter: ColorFilter.mode(
                colorSVG ?? AppColors.primaryLight, BlendMode.srcIn),
          );
        } else {
          return WidgetConstant.emptySizeBox();
        }
      } else {
        return WidgetConstant.emptySizeBox();
      }
    }
  }

  Widget getNetworkImageView(
      {required BuildContext context,
      Color? colorProgressLoaderIndicator,
      BoxFit? boxFit,
      String? imageURL,
      double? imageHeight,
      double? imageWidth,
      FilterQuality filterQuality = FilterQuality.high}) {
    return (imageURL != null && imageURL.isNotEmpty)
        ? boxFit != null
            ? Image.network(
                imageURL,
                height: imageHeight ?? 30,
                width: imageWidth ?? 30,
                filterQuality: filterQuality,
                fit: boxFit,
                loadingBuilder: (BuildContext? context, Widget? child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child!;
                  return SizedBox(
                    height: imageHeight,
                    width: imageWidth,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: colorProgressLoaderIndicator ??
                          AppColors.primaryLight,
                    )),
                  );
                },
                errorBuilder: (BuildContext? context, Object? exception,
                    StackTrace? stackTrace) {
                  return Center(
                    child: networkErrorPlaceHolderImagePath != null &&
                            networkErrorPlaceHolderImagePath!.isNotEmpty
                        ? AppImageWidget(
                            imagePathOrURL: networkErrorPlaceHolderImagePath ??
                                Assets.imagesPlaceholder,
                            height: imageHeight!,
                            width: imageWidth!,
                            filterQuality: filterQuality,
                          )
                        : AppImageWidget(
                            imagePathOrURL: Assets.imagesPlaceholder,
                            height: imageHeight!,
                            width: imageWidth!,
                            filterQuality: filterQuality,
                          ),
                  );
                },
              )
            : Image.network(
                imageURL,
                height: imageHeight ?? 30,
                width: imageWidth ?? 30,
                filterQuality: filterQuality,
                loadingBuilder: (BuildContext? context, Widget? child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child!;
                  return SizedBox(
                    height: imageHeight,
                    width: imageWidth,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colorProgressLoaderIndicator ??
                            AppColors.primaryLight,
                      ),
                    ),
                  );
                },
                errorBuilder: (BuildContext? context, Object? exception,
                    StackTrace? stackTrace) {
                  return Center(
                    child: AppImageWidget(
                      height: imageHeight!,
                      width: imageWidth!,
                      filterQuality: filterQuality,
                      imagePathOrURL: Assets.imagesPlaceholder,
                    ),
                  );
                },
              )
        : AppImageWidget(
            height: imageHeight ?? 20,
            width: imageWidth ?? 20,
            filterQuality: filterQuality,
            imagePathOrURL: Assets.imagesPlaceholder,
          );
  }
}
