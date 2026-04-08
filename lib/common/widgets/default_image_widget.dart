import 'package:elmotamizon/common/resources/assets_manager.dart';
import 'package:elmotamizon/common/widgets/shimmer_container_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class DefaultImageWidget extends StatefulWidget {
  final String image;
  final double? width;
  final double? height;
  final double? shimmerHeight;
  final void Function()? onTap;
  final double? radius;
  const DefaultImageWidget({super.key, required this.image, this.width, this.height, this.shimmerHeight, this.onTap, this.radius});

  @override
  State<DefaultImageWidget> createState() => _DefaultImageWidgetState();
}

class _DefaultImageWidgetState extends State<DefaultImageWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.radius == null ? BorderRadius.zero : BorderRadius.circular(widget.radius!),
      child: InkWell(
        onTap: widget.onTap,
        child: CachedNetworkImage(
          imageUrl: widget.image,
          width: widget.width??double.infinity,
          height: widget.height,
          fit: BoxFit.cover,
          placeholder: (context, url) => ShimmerContainerWidget(height: widget.shimmerHeight?? MediaQuery.sizeOf(context).height*.2),
          errorWidget: (context, url, error) => Lottie.asset(JsonAssets.error),
        ),
      ),
    );
  }
}
