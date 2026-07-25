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

class OpsFixCompletionPanel extends StatefulWidget {
  const OpsFixCompletionPanel({
    super.key,
    this.width,
    this.height,
    required this.ticketId,
  });

  final double? width;
  final double? height;
  final String ticketId;

  @override
  State<OpsFixCompletionPanel> createState() => _OpsFixCompletionPanelState();
}

class _OpsFixCompletionPanelState extends State<OpsFixCompletionPanel> {
  final _noteController = TextEditingController();
  PlatformFile? _proof;
  bool _busy = false;
  String? _message;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _extension(PlatformFile file) =>
      (file.extension ?? file.name.split('.').last).toLowerCase();

  String _contentType(String extension) => switch (extension) {
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'webp' => 'image/webp',
        _ => 'application/octet-stream',
      };

  Future<void> _chooseProof() async {
    if (SupaFlow.client.auth.currentUser == null) {
      setState(() => _message = 'Please sign in again.');
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
      setState(() => _message = 'Use a JPEG, PNG, or WebP image.');
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      setState(() => _message = 'The proof photo must be 5 MB or smaller.');
      return;
    }
    setState(() {
      _proof = file;
      _message = 'Proof selected: ${file.name}';
    });
  }

  Future<String> _upload(PlatformFile file, String userId) async {
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
    return SupaFlow.client.storage.from('ticket-photos').getPublicUrl(path);
  }

  Future<void> _submit() async {
    final user = SupaFlow.client.auth.currentUser;
    final note = _noteController.text.trim();
    final proof = _proof;
    if (user == null || widget.ticketId.isEmpty) {
      setState(() => _message = 'Invalid session or ticket.');
      return;
    }
    if (note.length < 3 || proof == null) {
      setState(() => _message = 'Add a repair note and proof photo first.');
      return;
    }
    setState(() {
      _busy = true;
      _message = 'Uploading proof…';
    });
    try {
      final proofUrl = await _upload(proof, user.id);
      final response = await SupaFlow.client.functions.invoke(
        'submit-completion',
        body: {
          'ticket_id': widget.ticketId,
          'note': note,
          'proof_url': proofUrl,
          'checklist': <dynamic>[],
        },
      );
      if (response.status >= 400) {
        throw Exception('Completion request failed.');
      }
      final ticket = await SupaFlow.client
          .from('tickets')
          .select('status')
          .eq('id', widget.ticketId)
          .maybeSingle();
      if (ticket?['status']?.toString() != 'pending_verification') {
        throw Exception('Ticket status was not updated.');
      }
      if (!mounted) return;
      setState(() {
        _busy = false;
        _message = 'Hasil perbaikan berhasil dikirim.';
      });
      context.goNamed('technicianTasksPage');
    } catch (error) {
      debugPrint('OpsFix completion failed: ${error.runtimeType}');
      if (!mounted) return;
      setState(() {
        _busy = false;
        _message = 'Could not submit completion. Check the proof and retry.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Complete repair',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _noteController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Repair note',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _busy ? null : _chooseProof,
                icon: const Icon(Icons.add_a_photo_outlined),
                label: Text(
                  _proof == null ? 'Choose proof photo' : 'Change proof photo',
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _busy ? null : _submit,
                icon: _busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.verified_outlined),
                label: Text(_busy ? 'Submitting…' : 'Send for verification'),
              ),
              if (_message != null) ...[
                const SizedBox(height: 8),
                Text(
                  _message!,
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
