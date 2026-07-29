// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/ops_fix_language_setting.dart';

Map<String, dynamic> _opsFixPageFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

Map<String, dynamic> _opsFixReporterFade() => <String, dynamic>{
      '__transition_info__': const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 160),
      ),
    };

class OpsFixReportEvidencePanel extends StatefulWidget {
  const OpsFixReportEvidencePanel({
    super.key,
    this.width,
    this.height,
    required this.locationId,
    required this.unitId,
    required this.issueCategoryId,
    required this.issueTypeId,
    required this.description,
  });

  final double? width;
  final double? height;
  final String locationId;
  final String unitId;
  final String? issueCategoryId;
  final String? issueTypeId;
  final String? description;

  @override
  State<OpsFixReportEvidencePanel> createState() =>
      _OpsFixReportEvidencePanelState();
}

class _OpsFixReportEvidencePanelState extends State<OpsFixReportEvidencePanel> {
  PlatformFile? _evidence;
  bool _busy = false;
  bool _duplicateConfirmed = false;
  String? _message;

  String _extension(PlatformFile file) {
    final explicit = (file.extension ?? '').toLowerCase();
    if (explicit.isNotEmpty) return explicit;
    final pieces = file.name.toLowerCase().split('.');
    return pieces.length > 1 ? pieces.last : '';
  }

  String _contentType(String extension) => switch (extension) {
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'webp' => 'image/webp',
        _ => 'application/octet-stream',
      };

  Future<void> _chooseEvidence() async {
    if (SupaFlow.client.auth.currentUser == null) {
      setState(() => _message = OpsFixI18n.t('Please sign in again.'));
      return;
    }
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp'],
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final extension = _extension(file);
    if (!const {'jpg', 'jpeg', 'png', 'webp'}.contains(extension) ||
        file.bytes == null) {
      setState(
          () => _message = OpsFixI18n.t('Use a JPEG, PNG, or WebP image.'));
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      setState(() => _message =
          OpsFixI18n.t('The evidence photo must be 5 MB or smaller.'));
      return;
    }
    setState(() {
      _evidence = file;
      _duplicateConfirmed = false;
      _message = 'Evidence selected: ${file.name}';
    });
  }

  Future<Map<String, String>> _upload(
    PlatformFile file,
    String userId,
  ) async {
    final extension = _extension(file);
    final path =
        'users/$userId/${DateTime.now().microsecondsSinceEpoch}.$extension';
    await SupaFlow.client.storage.from('ticket-photos').uploadBinary(
          path,
          file.bytes!,
          fileOptions: FileOptions(
            contentType: _contentType(extension),
            upsert: false,
          ),
        );
    return {
      'path': path,
      'url': SupaFlow.client.storage.from('ticket-photos').getPublicUrl(path),
    };
  }

  Future<void> _createTicket() async {
    final user = SupaFlow.client.auth.currentUser;
    final locationId = widget.locationId.trim();
    final unitId = widget.unitId.trim();
    final issueCategoryId = (widget.issueCategoryId ?? '').trim();
    final issueTypeId = (widget.issueTypeId ?? '').trim();
    final description = (widget.description ?? '').trim();
    final evidence = _evidence;
    if (user == null) {
      setState(() => _message = OpsFixI18n.t('Please sign in again.'));
      return;
    }
    if (locationId.isEmpty) {
      setState(() => _message = OpsFixI18n.t('Select a valid location first.'));
      return;
    }
    if (issueCategoryId.isEmpty || issueTypeId.isEmpty) {
      setState(() => _message = OpsFixI18n.t('Choose an issue type first.'));
      return;
    }
    if (description.length < 5 || evidence == null) {
      setState(() =>
          _message = OpsFixI18n.t('Add a description and evidence photo.'));
      return;
    }

    if (!_duplicateConfirmed) {
      var duplicateQuery = SupaFlow.client
          .from('tickets')
          .select('ticket_code')
          .eq('reporter_id', user.id)
          .eq('location_id', locationId)
          .eq('issue_type_id', issueTypeId)
          .inFilter('status', const [
        'reported',
        'assigned',
        'in_progress',
        'pending_verification',
        'reopened',
      ]);
      if (unitId.isNotEmpty) {
        duplicateQuery = duplicateQuery.eq('unit_id', unitId);
      }
      final duplicates = await duplicateQuery.limit(1);
      if (duplicates.isNotEmpty) {
        setState(() {
          _duplicateConfirmed = true;
          _message =
              'Similar active ticket ${duplicates.first['ticket_code']} exists. Tap submit again to continue.';
        });
        return;
      }
    }

    setState(() {
      _busy = true;
      _message = 'Uploading evidence…';
    });
    try {
      final upload = await _upload(evidence, user.id);
      final created = await SupaFlow.client
          .from('tickets')
          .insert({
            'location_id': locationId,
            'unit_id': unitId.isEmpty ? null : unitId,
            'issue_category_id': issueCategoryId,
            'issue_type_id': issueTypeId,
            'description': description,
            'before_photo_path': upload['path'],
            'before_photo_url': upload['url'],
          })
          .select('ticket_code')
          .single();
      if (!mounted) return;
      setState(() {
        _busy = false;
        _message = 'Ticket ${created['ticket_code']} created successfully.';
      });
      context.goNamed('myTicketsPage', extra: _opsFixReporterFade());
    } catch (error) {
      debugPrint('OpsFix ticket creation failed: ${error.runtimeType}');
      if (!mounted) return;
      setState(() {
        _busy = false;
        _message = OpsFixI18n.t(
            'Could not create the ticket. Check the form and try again.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: _busy ? null : _chooseEvidence,
            icon: const Icon(Icons.add_a_photo_outlined),
            label: Text(
              _evidence == null
                  ? OpsFixI18n.t('Choose evidence photo')
                  : OpsFixI18n.t('Change evidence photo'),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _busy ? null : _createTicket,
            icon: _busy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_outlined),
            label: Text(_busy
                ? 'Submitting…'
                : OpsFixI18n.t('Submit report with evidence')),
          ),
          if (_message != null) ...[
            const SizedBox(height: 8),
            Text(_message!, style: TextStyle(color: colors.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }
}
