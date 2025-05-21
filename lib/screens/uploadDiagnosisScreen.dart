import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_task/camera_page.dart';
import 'package:plant_task/helper/generalWidgets/categoryItemContainer.dart';
import 'package:plant_task/helper/generalWidgets/customTextLabel.dart';
import 'package:plant_task/helper/generalWidgets/widgets.dart';
import 'package:plant_task/helper/image_helpers.dart';
import 'package:plant_task/helper/provider/cropDiagnosisProvider.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';
import 'package:plant_task/helper/utils/constant.dart';
import 'package:plant_task/helper/utils/sessionManager.dart';
import 'package:plant_task/model/CropCategoryList.dart' show CropCategoryItem, CropCategoryList;
import 'package:provider/provider.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart'
    as ip;

class UploadDiagnosisScreen extends StatefulWidget {
  const UploadDiagnosisScreen({super.key});

  @override
  State<UploadDiagnosisScreen> createState() => _UploadDiagnosisScreen();
}

class _UploadDiagnosisScreen extends State<UploadDiagnosisScreen> {
  int? _selectedCropId;
  File? _selectedImage;

  Future<void> _takePhoto(BuildContext context) async {
    try {
      final cameraData = await availableCameras();
      if (context.mounted) {
        if (cameraData.isNotEmpty) {
          var imageFile = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CameraPage(cameras: cameraData),
            ),
          );
          if (imageFile != null) {
            var image = File(imageFile.path.toString());
            setState(() {
              _selectedImage = image;
            });
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera not available: $e'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _takePhoto(context),
            ),
          ),
        );
      }
    }
  }

  Future<void> _uploadPhoto(BuildContext context) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ip.ImageSource.gallery);
      if (pickedFile != null && pickedFile.path.isNotEmpty) {
        var image = File(pickedFile.path.toString());
        var croppedImage = await ImageHelper.cropImage(image, context);
        if (croppedImage == null) {
          return;
        }
        setState(() {
          _selectedImage = File(croppedImage.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => _uploadPhoto(context),
          ),
        ),
      );
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (_selectedCropId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a crop.")),
      );
      return;
    }
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select or capture an image.")),
      );
      return;
    }
    // Call provider
    await context.read<CropDiagnosisProvider>().getPestDiseaseUploadProvider(
      context: context,
      params: {
        "crop_id": _selectedCropId ?? '',
        "diseaseimage": XFile(_selectedImage!.path),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      if (Constant.session.getBoolData(SessionManager.isUserLogin)) {
        await context.read<CropDiagnosisProvider>().getCropListApiProvider(
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
              Icon(Icons.cloud_upload_rounded, color: ColorsRes.appColor, size: 28),
              const SizedBox(width: 10),
              CustomTextLabel(
                text: "Upload Diagnosis",
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
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCropList(cropDiagnosisProvider.cropList),
                const SizedBox(height: 18),
                _buildImageCard(context),
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_rounded, size: 24, color: Colors.white),
            label: const Text(
              "Submit",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsRes.appColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 3,
            ),
            onPressed: () => _submit(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCropList(CropCategoryList cropList) {
    return Card(
      color: ColorsRes.appColorWhite,
      shadowColor: ColorsRes.appColor.withOpacity(0.2),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.agriculture_rounded, color: ColorsRes.appColor, size: 24),
                const SizedBox(width: 10),
                CustomTextLabel(
                  text: "Select your Crop",
                  style: TextStyle(
                    fontSize: 17,
                    color: ColorsRes.appColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (cropList.results?.isNotEmpty ?? false)
              GridView.builder(
                itemCount: cropList.results!.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final category = cropList.results![index];
                  final isSelected = _selectedCropId == category.id;
                  return Material(
                    color: Colors.transparent,
                    elevation: isSelected ? 4 : 2,
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        CategoryItemContainer(
                          category: category,
                          selected: isSelected,
                          voidCallBack: () {
                            setState(() {
                              if (_selectedCropId == category.id) {
                                _selectedCropId = null;
                              } else {
                                _selectedCropId = category.id;
                              }
                            });
                          },
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: ColorsRes.appColor,
                              child: const Icon(Icons.check, color: Colors.white, size: 16),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: const Center(child: Text("No crops available")),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(BuildContext context) {
    return Card(
      color: ColorsRes.appColorWhite,
      shadowColor: ColorsRes.appColor.withOpacity(0.2),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.image_rounded, color: ColorsRes.appColor, size: 24),
                const SizedBox(width: 10),
                CustomTextLabel(
                  text: "Select or Capture Image",
                  style: TextStyle(
                    fontSize: 17,
                    color: ColorsRes.appColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorsRes.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorsRes.grey.withOpacity(0.3)),
                ),
                child: const Center(
                  child: Text(
                    "No image selected",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                  label: const Text("Take Photo", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsRes.appColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _takePhoto(context),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
                  label: const Text("Upload Photo", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsRes.appColor.withOpacity(0.85),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _uploadPhoto(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
