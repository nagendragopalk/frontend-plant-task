import 'package:flutter/material.dart';
import 'package:plant_task/helper/generalWidgets/customTextLabel.dart';
import 'package:plant_task/helper/generalWidgets/widgets.dart';
import 'package:plant_task/helper/provider/cropDiagnosisProvider.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Recommendationscreen extends StatefulWidget {
  const Recommendationscreen({super.key});

  @override
  State<Recommendationscreen> createState() => _RecommendationscreenState();
}

class _RecommendationscreenState extends State<Recommendationscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Padding(
          padding: const EdgeInsetsDirectional.only(start: 15),
          child: Row(
            children: [
             
              CustomTextLabel(
                text: "Diagnosis Details",
                style: TextStyle(
                  color: ColorsRes.mainTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        showBackButton: false,

      ),
      body: Consumer<CropDiagnosisProvider>(
        builder: (context, cropDiagnosisProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Disease Image Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: cropDiagnosisProvider.pestData.diseaseimage ?? '',
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 220,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 220,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
               
                // Pest Recommendation Card
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  color: ColorsRes.appColorWhite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with pest name and avatar
                      Container(
                        decoration: BoxDecoration(
                          color: ColorsRes.appColorWhite,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: ColorsRes.appColor.withOpacity(0.2),
                              backgroundImage: cropDiagnosisProvider.pestData.crop?.cropimage != null
                                  ? NetworkImage(cropDiagnosisProvider.pestData.crop!.cropimage!)
                                  : null,
                              child: cropDiagnosisProvider.pestData.crop?.cropimage == null
                                  ? Icon(Icons.bug_report, color: ColorsRes.appColor, size: 28)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                cropDiagnosisProvider.pestData.pestRecommendation?.name ?? 'Pest Name',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsRes.appColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Crop Name
                            Row(
                              children: [
                                Icon(Icons.grass, color: ColorsRes.appColor, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  cropDiagnosisProvider.pestData.pestRecommendation?.crop?.name ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: ColorsRes.mainTextColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Severity
                            Text(
                              "Severity",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsRes.mainTextColor.withOpacity(0.85),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: ColorsRes.appColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                cropDiagnosisProvider.pestData.pestRecommendation?.severity ?? 'No severity info.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: ColorsRes.mainTextColor.withOpacity(0.85),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Suggested Treatment
                            Text(
                              "Suggested Treatment",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsRes.mainTextColor.withOpacity(0.85),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: ColorsRes.appColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                cropDiagnosisProvider.pestData.pestRecommendation?.suggestedTreatment ?? 'No treatment info.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: ColorsRes.mainTextColor.withOpacity(0.85),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}