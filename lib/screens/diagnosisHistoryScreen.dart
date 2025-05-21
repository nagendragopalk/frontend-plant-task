import 'package:flutter/material.dart';
import 'package:plant_task/helper/generalWidgets/customTextLabel.dart';
import 'package:plant_task/helper/generalWidgets/widgets.dart';
import 'package:plant_task/helper/provider/cropDiagnosisProvider.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';
import 'package:plant_task/helper/utils/constant.dart';
import 'package:plant_task/helper/utils/routeGenerator.dart';
import 'package:plant_task/helper/utils/sessionManager.dart';
import 'package:provider/provider.dart';
import 'package:plant_task/model/DiagnosisHistoryList.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DiagnosisHistoryscreen extends StatefulWidget {
  const DiagnosisHistoryscreen({super.key});

  @override
  State<DiagnosisHistoryscreen> createState() => _DiagnosisHistoryscreenState();
}

class _DiagnosisHistoryscreenState extends State<DiagnosisHistoryscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      if (Constant.session.getBoolData(SessionManager.isUserLogin)) {
        await context.read<CropDiagnosisProvider>().getDiagnosisHistoryListApiProvider(
          context: context,
          params: {},
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorsRes.grey.withOpacity(0.04),
      appBar: getAppBar(
        context: context,
        title: Padding(
          padding: const EdgeInsetsDirectional.only(start: 15),
          child: Row(
            children: [
             
              CustomTextLabel(
                text: "Diagnosis History",
                style: TextStyle(
                  color: ColorsRes.mainTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        showBackButton: false,
      ),
      body: Consumer<CropDiagnosisProvider>(
        builder: (context, cropDiagnosisProvider, child) {
          final historyList = cropDiagnosisProvider.diagnosisHistoryList?.results ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (historyList.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        "No diagnosis history found.",
                        style: TextStyle(
                          color: ColorsRes.mainTextColor.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: historyList.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final DiagnosisHistoryData item = historyList[index];
                      return Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: item.diseaseimage ?? '',
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 54,
                                height: 54,
                                color: Colors.grey[200],
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 54,
                                height: 54,
                                color: Colors.grey[200],
                                child: Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                          ),
                          title: Text(
                            item.crop?.name ?? 'Crop Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorsRes.mainTextColor,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            item.pestRecommendation?.name ?? 'Pest Name',
                            style: TextStyle(
                              color: ColorsRes.mainTextColor.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsRes.appColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            ),
                            onPressed: () {
                              Map<String, String> params = {};
                               params["pestDiseaseId"] =
                                item.id.toString();
                              cropDiagnosisProvider
                                .getDiagnosisDataProvider(
                              params: params,
                              context: context,
                            )
                                .then((value) {
                              Navigator.pushNamed(
                                  context, recommendationscreen);
                            });
                            },
                            child: Text(
                              "View",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}