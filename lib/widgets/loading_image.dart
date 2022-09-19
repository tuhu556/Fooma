import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/color.dart';

class LoadingImage extends StatelessWidget {
  const LoadingImage({
    Key? key,
    required this.urlImg,
  }) : super(key: key);

  final String urlImg;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: urlImg,
      placeholder: (context, url) => Padding(
        padding: const EdgeInsets.all(50.0),
        child: CircularProgressIndicator(
            color: FoodHubColors.colorFC6011, strokeWidth: 5),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
