import 'dart:io';
import 'package:flutter/material.dart';

class UniversalImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  const UniversalImage(
    this.path, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('assets/') || path.startsWith('assets\\')) {
      return Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _errorWidget(),
      );
    } 
    else {
      return Image.file(
        File(path),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _errorWidget(),
      );
    }
  }

  Widget _errorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}