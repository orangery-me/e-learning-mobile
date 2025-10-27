/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Mulish-Bold.ttf
  String get mulishBold => 'assets/fonts/Mulish-Bold.ttf';

  /// File path: assets/fonts/Mulish-Medium.ttf
  String get mulishMedium => 'assets/fonts/Mulish-Medium.ttf';

  /// File path: assets/fonts/Mulish-Regular.ttf
  String get mulishRegular => 'assets/fonts/Mulish-Regular.ttf';

  /// File path: assets/fonts/Mulish-SemiBold.ttf
  String get mulishSemiBold => 'assets/fonts/Mulish-SemiBold.ttf';

  /// List of all assets
  List<String> get values => [
    mulishBold,
    mulishMedium,
    mulishRegular,
    mulishSemiBold,
  ];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/events.png
  AssetGenImage get events => const AssetGenImage('assets/icons/events.png');

  /// Directory path: assets/icons/launcher
  $AssetsIconsLauncherGen get launcher => const $AssetsIconsLauncherGen();

  /// File path: assets/icons/post-it.png
  AssetGenImage get postIt => const AssetGenImage('assets/icons/post-it.png');

  /// File path: assets/icons/star.png
  AssetGenImage get star => const AssetGenImage('assets/icons/star.png');

  /// File path: assets/icons/terminal.png
  AssetGenImage get terminal =>
      const AssetGenImage('assets/icons/terminal.png');

  /// List of all assets
  List<AssetGenImage> get values => [events, postIt, star, terminal];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/banners
  $AssetsImagesBannersGen get banners => const $AssetsImagesBannersGen();

  /// Directory path: assets/images/lottie
  $AssetsImagesLottieGen get lottie => const $AssetsImagesLottieGen();
}

class $AssetsLocalesGen {
  const $AssetsLocalesGen();

  /// File path: assets/locales/en.json
  String get en => 'assets/locales/en.json';

  /// File path: assets/locales/vi.json
  String get vi => 'assets/locales/vi.json';

  /// List of all assets
  List<String> get values => [en, vi];
}

class $AssetsIconsLauncherGen {
  const $AssetsIconsLauncherGen();

  /// File path: assets/icons/launcher/app_icon.png
  AssetGenImage get appIcon =>
      const AssetGenImage('assets/icons/launcher/app_icon.png');

  /// List of all assets
  List<AssetGenImage> get values => [appIcon];
}

class $AssetsImagesBannersGen {
  const $AssetsImagesBannersGen();

  /// File path: assets/images/banners/avatar.png
  AssetGenImage get avatar =>
      const AssetGenImage('assets/images/banners/avatar.png');

  /// File path: assets/images/banners/coursevo-banner.jpg
  AssetGenImage get coursevoBanner =>
      const AssetGenImage('assets/images/banners/coursevo-banner.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [avatar, coursevoBanner];
}

class $AssetsImagesLottieGen {
  const $AssetsImagesLottieGen();

  /// File path: assets/images/lottie/error.json
  String get error => 'assets/images/lottie/error.json';

  /// File path: assets/images/lottie/search_not_found.json
  String get searchNotFound => 'assets/images/lottie/search_not_found.json';

  /// List of all assets
  List<String> get values => [error, searchNotFound];
}

class Assets {
  const Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLocalesGen locales = $AssetsLocalesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
