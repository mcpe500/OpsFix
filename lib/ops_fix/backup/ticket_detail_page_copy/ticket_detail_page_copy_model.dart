import '/components/info_row2_widget.dart';
import '/components/timeline_item2_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'ticket_detail_page_copy_widget.dart' show TicketDetailPageCopyWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TicketDetailPageCopyModel
    extends FlutterFlowModel<TicketDetailPageCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for InfoRow.
  late InfoRow2Model infoRowModel1;
  // Model for InfoRow.
  late InfoRow2Model infoRowModel2;
  // Model for InfoRow.
  late InfoRow2Model infoRowModel3;
  // Model for InfoRow.
  late InfoRow2Model infoRowModel4;
  // Model for InfoRow.
  late InfoRow2Model infoRowModel5;
  // Model for InfoRow.
  late InfoRow2Model infoRowModel6;
  // Model for InfoRow.
  late InfoRow2Model infoRowModel7;
  // Model for InfoRow.
  late InfoRow2Model infoRowModel8;
  // Model for TimelineItem.
  late TimelineItem2Model timelineItemModel1;
  // Model for TimelineItem.
  late TimelineItem2Model timelineItemModel2;

  @override
  void initState(BuildContext context) {
    infoRowModel1 = createModel(context, () => InfoRow2Model());
    infoRowModel2 = createModel(context, () => InfoRow2Model());
    infoRowModel3 = createModel(context, () => InfoRow2Model());
    infoRowModel4 = createModel(context, () => InfoRow2Model());
    infoRowModel5 = createModel(context, () => InfoRow2Model());
    infoRowModel6 = createModel(context, () => InfoRow2Model());
    infoRowModel7 = createModel(context, () => InfoRow2Model());
    infoRowModel8 = createModel(context, () => InfoRow2Model());
    timelineItemModel1 = createModel(context, () => TimelineItem2Model());
    timelineItemModel2 = createModel(context, () => TimelineItem2Model());
  }

  @override
  void dispose() {
    infoRowModel1.dispose();
    infoRowModel2.dispose();
    infoRowModel3.dispose();
    infoRowModel4.dispose();
    infoRowModel5.dispose();
    infoRowModel6.dispose();
    infoRowModel7.dispose();
    infoRowModel8.dispose();
    timelineItemModel1.dispose();
    timelineItemModel2.dispose();
  }
}
