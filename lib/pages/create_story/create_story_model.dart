import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_media_display.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'create_story_widget.dart' show CreateStoryWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateStoryModel extends FlutterFlowModel<CreateStoryWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadDataQ5l = false;
  FFUploadedFile uploadedLocalFile_uploadDataQ5l =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataQ5l = '';

  // State field(s) for storyDescription widget.
  FocusNode? storyDescriptionFocusNode;
  TextEditingController? storyDescriptionTextController;
  String? Function(BuildContext, String?)?
      storyDescriptionTextControllerValidator;
  bool isDataUploading_uploadDataNzi = false;
  FFUploadedFile uploadedLocalFile_uploadDataNzi =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataNzi = '';

  bool isDataUploading_uploadDataS5t = false;
  FFUploadedFile uploadedLocalFile_uploadDataS5t =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataS5t = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    storyDescriptionFocusNode?.dispose();
    storyDescriptionTextController?.dispose();
  }
}
