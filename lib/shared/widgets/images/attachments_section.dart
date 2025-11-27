import 'package:dotted_border/dotted_border.dart';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/themes/colors_config.dart';
import 'package:taskflow_app/features/images/domain/entities/image_entity.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_cubit.dart';
import 'package:taskflow_app/features/images/presentation/cubit/image_state.dart';
import 'package:taskflow_app/shared/widgets/card_container.dart';
import 'package:taskflow_app/shared/widgets/card_list_header.dart';
import 'package:taskflow_app/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:taskflow_app/shared/widgets/loading_indicators/loading_indicator_in_card_item.dart';
import 'package:taskflow_app/shared/widgets/products/empty_item_placeholder.dart';
import 'package:taskflow_app/shared/widgets/thumbnail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

class AttachmentsSection extends StatefulWidget {
  const AttachmentsSection({super.key, required this.taskId});

  final String taskId;

  @override
  State<AttachmentsSection> createState() => _AttachmentsSectionState();
}

class _AttachmentsSectionState extends State<AttachmentsSection> {
  late List<ImageEntity> _photos;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ImageCubit>().getImages(widget.taskId);
    });
  }

  void moveRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100, // Move by 100 pixels
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void moveLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100, // Move by 100 pixels
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Method to add a new photo
  Future<void> _addNewPhoto(BuildContext context) async {
    final result = await context.push('/camera');

    if (result != null && result is Map<String, dynamic>) {
      // send Photo to server
      context.read<ImageCubit>().addImage(widget.taskId, result['path']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<ImageCubit, ImageState>(
            builder: (context, state) {
              if ((state is ImageLoaded && _allImagesLoaded(state.images)) ||
                  state is ImageFailure) {
                return CardListHeader(
                  title: translate('photos'),
                  icon: CupertinoIcons.camera_fill,
                  onAdd: () => _addNewPhoto(context),
                );
              }
              return CardListHeader(
                title: translate('photos'),
                icon: CupertinoIcons.camera_fill,
              );
            },
          ),
          SizedBox(height: ResponsiveConstants.getRelativeHeight(context, 20)),
          BlocBuilder<ImageCubit, ImageState>(
            builder: (context, state) {
              if (state is ImageLoading) {
                return LoadingIndicatorInCardItem();
              } else if (state is ImageFailure) {
                return Center(child: Text(state.error.message));
              } else if (state is ImageLoaded) {
                _photos = state.images;

                if (_photos.isEmpty) {
                  return EmptyItemPlaceholder(
                    iconItem: CupertinoIcons.camera_fill,
                    noItemsAdded: translate('noPhotosAddedYet'),
                    addItem: translate('addPhoto'),
                    onAdd: () => _addNewPhoto(context),
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: ResponsiveConstants.getRelativeHeight(
                          context,
                          100,
                        ),
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              _photos.length + 1, // +1 for the "add new" button
                          itemBuilder: (context, index) {
                            if (index < _photos.length) {
                              return Row(
                                children: [
                                  Thumbnail(
                                    imageEntity: _photos[index],
                                    onClose:
                                        _photos[index].isUploading
                                            ? null
                                            : () =>
                                                _showDeleteConfirmationDialog(
                                                  context,
                                                  _photos[index].systemId,
                                                ),
                                    onTap:
                                        _photos[index].isUploading
                                            ? null
                                            : () {
                                              context.push(
                                                '/image-gallery',
                                                extra: {
                                                  'photos': _photos,
                                                  'initialIndex': index,
                                                },
                                              );
                                            },
                                  ),
                                  SizedBox(
                                    width: ResponsiveConstants.getRelativeWidth(
                                      context,
                                      8,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              if (_allImagesLoaded(_photos)) {
                                return Row(
                                  children: [
                                    NewThumbnail(
                                      onTap: () => _addNewPhoto(context),
                                    ),
                                    SizedBox(
                                      width:
                                          ResponsiveConstants.getRelativeWidth(
                                            context,
                                            8,
                                          ),
                                    ),
                                  ],
                                );
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_left, size: 40),
                            onPressed: moveLeft,
                          ),
                          SizedBox(
                            width: ResponsiveConstants.getRelativeWidth(
                              context,
                              100,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_right, size: 40),
                            onPressed: moveRight,
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }

              // Initial state or other states
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
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
      context.read<ImageCubit>().deleteImage(widget.taskId, imageSystemId);
    }
  }
}

bool _allImagesLoaded(List<ImageEntity> images) {
  return images.every((image) => !image.isUploading);
}

class NewThumbnail extends StatelessWidget {
  final VoidCallback onTap;

  const NewThumbnail({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: ResponsiveConstants.getRelativeWidth(context, 90),
        height: ResponsiveConstants.getRelativeHeight(context, 90),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(
            ResponsiveConstants.getRelativeWidth(context, 16),
          ),
          dashPattern: [5, 4],
          color: lightGreyColor,
          child: Center(child: Icon(Icons.add)),
        ),
      ),
    );
  }
}

class EmptyThumbnail extends StatelessWidget {
  const EmptyThumbnail({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveConstants.getRelativeWidth(context, 75),
      height: ResponsiveConstants.getRelativeHeight(context, 75),
      decoration: BoxDecoration(
        color: onPrimaryColor,
        borderRadius:
            ResponsiveConstants.getRelativeBorderRadius(context, 12),
      ),
    );
  }
}
