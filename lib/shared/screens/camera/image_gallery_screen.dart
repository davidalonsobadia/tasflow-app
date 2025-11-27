import 'dart:typed_data';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/core/utils/image_utils.dart';
import 'package:taskflow_app/features/images/domain/entities/image_entity.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_cubit.dart';
import 'package:taskflow_app/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:taskflow_app/shared/widgets/thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

class ImageGalleryScreen extends StatefulWidget {
  final List<ImageEntity> photos;
  final int initialIndex;

  const ImageGalleryScreen({
    super.key,
    required this.photos,
    this.initialIndex = 0,
  });

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  late int _selectedPhotoIndex;
  late List<ImageEntity> photos;

  @override
  void initState() {
    super.initState();
    _selectedPhotoIndex = widget.initialIndex;
    photos = widget.photos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveConstants.getRelativeWidth(context, 8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close, color: whiteColor),
                  ),
                  IconButton(
                    onPressed:
                        () => _showDeleteConfirmationDialog(
                          context,
                          photos[_selectedPhotoIndex].taskId,
                          photos[_selectedPhotoIndex].systemId,
                        ),
                    icon: Icon(Icons.delete, color: whiteColor),
                  ),
                ],
              ),
              // Expanded section with centered image
              Expanded(
                child: Center(
                  child: _buildImage(photos[_selectedPhotoIndex].imageData),
                ),
              ),
              // Bottom widgets
              SizedBox(
                width: double.infinity,
                child: Text(
                  translate(
                    'imageCounter',
                    args: {
                      'current': _selectedPhotoIndex + 1,
                      'total': photos.length,
                    },
                  ),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: lightGreyColor),
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 10),
              ),
              SizedBox(
                height: ResponsiveConstants.getRelativeHeight(context, 100),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPhotoIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    _selectedPhotoIndex == index
                                        ? whiteColor
                                        : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: ResponsiveConstants.getRelativeBorderRadius(context, 18),
                            ),
                            child: Thumbnail(imageEntity: photos[index]),
                          ),
                        ),
                        SizedBox(
                          width: ResponsiveConstants.getRelativeWidth(
                            context,
                            8,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    String taskId,
    String imageSystemId,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: translate('deleteImage'),
          message: translate('areYouSureYouWantToDeleteThisImage'),
          confirmText: translate('delete'),
        );
      },
    );

    if (confirm == true) {
      // Delete the image from the server
      context.read<ImageCubit>().deleteImage(taskId, imageSystemId);

      // Remove the image from the local list
      setState(() {
        // Remove the deleted image
        photos.removeWhere((photo) => photo.systemId == imageSystemId);

        // If there are no more photos, go back to the previous screen
        if (photos.isEmpty) {
          context.pop();
          return;
        }

        // Adjust the selected index if needed
        if (_selectedPhotoIndex >= photos.length) {
          _selectedPhotoIndex = photos.length - 1;
        }
      });
    }
  }

  Widget _buildImage(Uint8List imageData) {
    return ImageUtils.buildImageFromBinary(imageData);
  }
}
