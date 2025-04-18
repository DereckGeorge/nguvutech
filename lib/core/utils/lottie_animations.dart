import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Class responsible for loading and playing Lottie animations
class LottieAnimations {
  // Animation paths
  static const String _basePath = 'assets/lottie/';
  static const String loading = '${_basePath}loading.json';
  static const String success = '${_basePath}success.json';
  static const String empty = '${_basePath}empty.json';
  static const String avatar = '${_basePath}avatar.json';

  /// Returns a loading animation widget
  static Widget getLoadingAnimation({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
  }) {
    return Lottie.asset(
      loading,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
    );
  }

  /// Returns a success animation widget
  static Widget getSuccessAnimation({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    bool repeat = false,
    VoidCallback? onFinished,
  }) {
    return Lottie.asset(
      success,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
      onLoaded:
          onFinished != null
              ? (composition) {
                Future.delayed(composition.duration, onFinished);
              }
              : null,
    );
  }

  /// Returns an empty state animation widget
  static Widget getEmptyAnimation({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
  }) {
    return Lottie.asset(
      empty,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
    );
  }

  /// Returns an avatar animation widget
  static Widget getAvatarAnimation({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
  }) {
    return Lottie.asset(
      avatar,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
    );
  }
}
