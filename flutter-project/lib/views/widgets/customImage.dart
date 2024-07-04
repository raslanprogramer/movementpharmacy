import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../theme/AppColor.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
      {super.key, required this.image,
        this.width = 100,
        this.height = 100,
        this.bgColor,
        this.borderWidth = 0,
        this.borderColor,
        this.trBackground = false,
        this.fit = BoxFit.cover,
        this.isNetwork = true,
        this.radius = 50,
        this.borderRadius,

        this.isShadow = true});
  final String image;
  final double width;
  final double height;
  final double borderWidth;
  final bool isShadow;
  final Color? borderColor;
  final Color? bgColor;
  final bool trBackground;
  final bool isNetwork;
  final double radius;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        boxShadow: [
          if (isShadow)
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(1, 0), // changes position of shadow
            ),
        ],
      ),
      child: isNetwork
          ? _buildNetworkImage()
          :ClipRRect(
        borderRadius: borderRadius??BorderRadius.circular(15.0),
            child: Image.asset(
              width:width,
              height:height,
                    image,fit: fit,
                  ),
          )
      //
      // Image(
      //             image: AssetImage(image),
      //             fit: fit,
      //           ),
    );
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: image,
      placeholder: (context, url) => BlankImageWidget(radius: radius,),
      errorWidget: (context, url, error) => BlankImageWidget(radius: radius,),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
          image: DecorationImage(image: imageProvider, fit: fit),
        ),
      ),
    );
  }
}

class BlankImageWidget extends StatelessWidget {
  const BlankImageWidget({Key? key, required this.radius}) : super(key: key);
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            // const Color.fromARGB(255, 66, 73, 98).withOpacity(0.8),
            // const Color(0xFF697686),
            Color(0xF5F5F5FF),
            Color(0xE0E0E0FF),

          ],
          stops: [0.3, 1.0],
        ),
      ),
      margin: EdgeInsets.zero,
    );
  }
}

