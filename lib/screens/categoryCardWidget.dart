import 'package:flutter/material.dart';
import 'package:plant_task/helper/generalWidgets/customTextLabel.dart';
import 'package:plant_task/helper/generalWidgets/widgets.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';

class CategoryCardWidget extends StatelessWidget {
  final String? cardTitle, btnWidgetText1, btnWidgetText2;
  final Function? callback1, callback2;

  const CategoryCardWidget({
    super.key,
    required this.cardTitle,
    this.btnWidgetText1,
    this.btnWidgetText2,
    required this.callback1,
    required this.callback2,
  });

 

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildCardTitle(context),
            const SizedBox(height: 10),
            _buildActionButtons(context),
            const SizedBox(height: 10),
            
          ],
        ),
      ),
    );
  }

  Widget _buildCardTitle(BuildContext context) {
    return CustomTextLabel(
      text: cardTitle,
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 20,
        color: ColorsRes.appColor,
        fontWeight: FontWeight.bold,
        
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionColumn(
          context,
          text: btnWidgetText1,
          icon: Icons.camera_alt_outlined,
          callback: callback1,
        ),
        _buildActionColumn(
          context,
          text: btnWidgetText2,
          icon: Icons.add_photo_alternate_outlined,
          callback: callback2,
        ),
      ],
    );
  }

  Widget _buildActionColumn(BuildContext context,
      {String? text, IconData? icon, Function? callback}) {
    return Column(
      children: [
        // CustomTextLabel(
        //   jsonKey: text,
        //   softWrap: true,
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        //   style: TextStyle(
        //     fontSize: 18,
        //     color: ColorsRes.subTitleMainTextColor,
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
        Icon(icon,  size: 100),
        gradientBtnWidget(
          context,
          10,
          callback: callback,
          otherWidgets: Padding(
            padding: const EdgeInsets.all(10),
            child: CustomTextLabel(
              text: text,
              softWrap: true,
              style: Theme.of(context).textTheme.titleMedium!.merge(
                    const TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            ),
          ),
        ),
      ],
    );
  }

 
}
