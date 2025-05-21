import 'package:flutter/material.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';

class CustomTextLabel extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const CustomTextLabel({
    Key? key,
    this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
            text ?? "",
            style: style ?? TextStyle(color: ColorsRes.mainTextColor),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            softWrap: softWrap ?? true,
          );
  }
}
