import '../database.dart';

class CompletionAttemptsTable extends SupabaseTable<CompletionAttemptsRow> {
  @override
  String get tableName => 'completion_attempts';

  @override
  CompletionAttemptsRow createRow(Map<String, dynamic> data) =>
      CompletionAttemptsRow(data);
}

class CompletionAttemptsRow extends SupabaseDataRow {
  CompletionAttemptsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CompletionAttemptsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get siteId => getField<String>('site_id')!;
  set siteId(String value) => setField<String>('site_id', value);

  String get ticketId => getField<String>('ticket_id')!;
  set ticketId(String value) => setField<String>('ticket_id', value);

  String get technicianId => getField<String>('technician_id')!;
  set technicianId(String value) => setField<String>('technician_id', value);

  int get attemptNumber => getField<int>('attempt_number')!;
  set attemptNumber(int value) => setField<int>('attempt_number', value);

  dynamic get checklistResults => getField<dynamic>('checklist_results')!;
  set checklistResults(dynamic value) =>
      setField<dynamic>('checklist_results', value);

  String get note => getField<String>('note')!;
  set note(String value) => setField<String>('note', value);

  String? get proofPhotoPath => getField<String>('proof_photo_path');
  set proofPhotoPath(String? value) =>
      setField<String>('proof_photo_path', value);

  String get proofPhotoUrl => getField<String>('proof_photo_url')!;
  set proofPhotoUrl(String value) => setField<String>('proof_photo_url', value);

  DateTime? get startedAt => getField<DateTime>('started_at');
  set startedAt(DateTime? value) => setField<DateTime>('started_at', value);

  DateTime get completedAt => getField<DateTime>('completed_at')!;
  set completedAt(DateTime value) => setField<DateTime>('completed_at', value);

  int? get workDurationMinutes => getField<int>('work_duration_minutes');
  set workDurationMinutes(int? value) =>
      setField<int>('work_duration_minutes', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
