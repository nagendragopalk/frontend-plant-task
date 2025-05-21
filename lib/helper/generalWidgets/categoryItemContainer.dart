import 'package:flutter/material.dart';
import 'package:plant_task/helper/generalWidgets/customTextLabel.dart';
import 'package:plant_task/helper/generalWidgets/widgets.dart';
import 'package:plant_task/model/CropCategoryList.dart';

class CategoryItemContainer extends StatelessWidget {
  final CropCategoryItem category;
  final VoidCallback voidCallBack;
  final bool selected;

  const CategoryItemContainer({
    Key? key,
    required this.category,
    required this.voidCallBack,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? Theme.of(context).colorScheme.primary : Colors.transparent;
    final bgColor = selected ? Theme.of(context).colorScheme.primary.withOpacity(0.08) : Theme.of(context).cardColor;
    final textColor = selected ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodyMedium?.color;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: voidCallBack,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 5, end: 5, top: 5),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: setNetworkImg(
                      boxFit: BoxFit.cover,
                      image: category.cropimage ?? "",
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 4, end: 4),
                  child: CustomTextLabel(
                    text: category.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}