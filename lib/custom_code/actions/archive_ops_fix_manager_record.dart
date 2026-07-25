// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';

Future<String> archiveOpsFixManagerRecord(
  BuildContext context,
  String recordKind,
  String? recordId,
  int? recordIndex,
  String? siteId,
) async {
  try {
    final isLocation = recordKind == 'location';
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(isLocation ? 'Arsipkan lokasi' : 'Arsipkan aset'),
            content: Text(
              isLocation
                  ? 'Lokasi dan unit aktifnya akan diarsipkan. Riwayat tetap tersimpan.'
                  : 'Aset akan dinonaktifkan. Tiket dan catatan lama tetap tersimpan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Arsipkan'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return 'cancelled';

    var resolvedId = (recordId ?? '').trim();
    if (resolvedId.isEmpty && recordKind == 'location') {
      final rows = await SupaFlow.client
          .from('locations')
          .select('id')
          .eq('site_id', siteId ?? '')
          .eq('is_active', true)
          .order('code')
          .range(recordIndex ?? 0, recordIndex ?? 0);
      if (rows.isEmpty) return 'access_denied';
      resolvedId = rows.first['id'] as String? ?? '';
    }
    final functionName = recordKind == 'location'
        ? 'archive_opsfix_location'
        : 'archive_opsfix_unit';
    final parameterName =
        recordKind == 'location' ? 'p_location_id' : 'p_unit_id';
    final response = await SupaFlow.client.rpc(
      functionName,
      params: {parameterName: resolvedId},
    );
    final result = Map<String, dynamic>.from(response as Map);
    return result['code'] as String? ?? 'network_error';
  } catch (_) {
    return 'network_error';
  }
}
