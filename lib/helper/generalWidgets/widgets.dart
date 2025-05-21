import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plant_task/helper/generalWidgets/customTextLabel.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';
import 'package:plant_task/helper/styles/designConfig.dart';
import 'package:plant_task/helper/utils/constant.dart';
import 'package:plant_task/helper/utils/sessionManager.dart';

Widget gradientBtnWidget(BuildContext context, double borderRadius,
    {required Function? callback,
    String title = "",
    Widget? otherWidgets,
    double? height,
    double? width,
    Color? color1,
    Color? color2}) {
  return GestureDetector(
    onTap: () {
      callback!();
    },
    child: Container(
      height: height ?? 45,
      width: width,
      alignment: Alignment.center,
      decoration: DesignConfig.boxGradient(
        borderRadius,
        color1: color1,
        color2: color2,
      ),
      child: otherWidgets ??= CustomTextLabel(
        text: title,
        softWrap: true,
        style: Theme.of(context).textTheme.titleMedium!.merge(TextStyle(
            color: ColorsRes.mainIconColor,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500)),
      ),
    ),
  );
}

Widget defaultImg({
  double? height,
  double? width,
  required String image,
  Color? iconColor,
  BoxFit? boxFit,
  EdgeInsetsDirectional? padding,
  bool? requiredRTL = true,
}) {
  return Padding(
    padding: padding ?? const EdgeInsets.all(0),
    child: iconColor != null
        ? SvgPicture.asset(
            Constant.getAssetsPath(1, image),
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            fit: boxFit ?? BoxFit.contain,
            matchTextDirection: requiredRTL ?? true,
          )
        : SvgPicture.asset(
            Constant.getAssetsPath(1, image),
            width: width,
            height: height,
            fit: boxFit ?? BoxFit.contain,
            matchTextDirection: requiredRTL ?? true,
          ),
  );
}

// // 

Widget setNetworkImg({
  double? height,
  double? width,
  String image = "placeholder",
  Color? iconColor,
  BoxFit? boxFit,
}) {
  if (image.trim().isNotEmpty && !image.contains("http")) {
    image = "${Constant.baseUrl}storage/$image";
  }
  return image.trim().isEmpty
      ? defaultImg(
          image: "placeholder",
          height: height,
          width: width,
          boxFit: boxFit,
        )
      : CachedNetworkImage(
          imageUrl: image,
          height: height,
          width: width,
          fit: boxFit,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: boxFit,
                onError: (exception, stackTrace) => defaultImg(
                  image: "placeholder",
                  height: height,
                  width: height,
                  boxFit: boxFit,
                  padding: EdgeInsetsDirectional.all(20),
                ),
              ),
            ),
          ),
          placeholder: (context, url) => defaultImg(
            image: "placeholder",
            height: height,
            width: height,
            boxFit: boxFit,
            padding: EdgeInsetsDirectional.all(20),
          ),
          errorWidget: (context, url, error) => defaultImg(
            image: "placeholder",
            height: height,
            width: height,
            boxFit: boxFit,
            padding: EdgeInsetsDirectional.all(20),
          ),
        );
}

Widget getSizedBox({double? height, double? width, Widget? child}) {
  return SizedBox(
    height: height ?? 0,
    width: width ?? 0,
    child: child,
  );
}



getLoadingIndicator() {
  return Center(
      child: CircularProgressIndicator(
    backgroundColor: Colors.transparent,
    color: ColorsRes.appColor,
    strokeWidth: 2,
  ));
}


class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}



AppBar getAppBar(
    {required BuildContext context,
    bool? centerTitle,
    required Widget title,
    List<Widget>? actions,
    Color? backgroundColor,
    bool? showBackButton,
    GestureTapCallback? onTap}) {
  return AppBar(
    leading: showBackButton ?? true
        ? GestureDetector(
            onTap: onTap ??
                () {
                  Navigator.pop(context);
                },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(18),
                child: SizedBox(
                  child: defaultImg(
                    boxFit: BoxFit.contain,
                    image: "ic_arrow_back",
                    iconColor: ColorsRes.mainTextColor,
                  ),
                  height: 10,
                  width: 10,
                ),
              ),
            ),
          )
        : null,
    automaticallyImplyLeading: true,
    elevation: 0,
    titleSpacing: 0,
    title: title,
    centerTitle: centerTitle ?? false,
    surfaceTintColor: Colors.transparent,
    backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
    actions: actions ?? [],
  );
}

class ScrollGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}



