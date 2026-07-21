import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'edit_dog_profile_widget.dart' show EditDogProfileWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditDogProfileModel extends FlutterFlowModel<EditDogProfileWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadDataGj1 = false;
  FFUploadedFile uploadedLocalFile_uploadDataGj1 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataGj1 = '';

  // State field(s) for dogName widget.
  FocusNode? dogNameFocusNode;
  TextEditingController? dogNameTextController;
  String? Function(BuildContext, String?)? dogNameTextControllerValidator;
  // State field(s) for dogBreed widget.
  FocusNode? dogBreedFocusNode;
  TextEditingController? dogBreedTextController;
  String? Function(BuildContext, String?)? dogBreedTextControllerValidator;
  // State field(s) for dogAge widget.
  FocusNode? dogAgeFocusNode;
  TextEditingController? dogAgeTextController;
  String? Function(BuildContext, String?)? dogAgeTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    dogNameFocusNode?.dispose();
    dogNameTextController?.dispose();

    dogBreedFocusNode?.dispose();
    dogBreedTextController?.dispose();

    dogAgeFocusNode?.dispose();
    dogAgeTextController?.dispose();
  }
}
