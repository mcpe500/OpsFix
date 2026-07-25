import '../database.dart';

class TicketVerificationsTable extends SupabaseTable<TicketVerificationsRow> {
  @override
  String get tableName => 'ticket_verifications';

  @override
  TicketVerificationsRow createRow(Map<String, dynamic> data) =>
      TicketVerificationsRow(data);
}

class TicketVerificationsRow extends SupabaseDataRow {
  TicketVerificationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TicketVerificationsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get siteId => getField<String>('site_id')!;
  set siteId(String value) => setField<String>('site_id', value);

  String get ticketId => getField<String>('ticket_id')!;
  set ticketId(String value) => setField<String>('ticket_id', value);

  String get completionAttemptId => getField<String>('completion_attempt_id')!;
  set completionAttemptId(String value) =>
      setField<String>('completion_attempt_id', value);

  String get decision => getField<String>('decision')!;
  set decision(String value) => setField<String>('decision', value);

  String get actorId => getField<String>('actor_id')!;
  set actorId(String value) => setField<String>('actor_id', value);

  String get actorRoleSnapshot => getField<String>('actor_role_snapshot')!;
  set actorRoleSnapshot(String value) =>
      setField<String>('actor_role_snapshot', value);

  int? get rating => getField<int>('rating');
  set rating(int? value) => setField<int>('rating', value);

  String? get comment => getField<String>('comment');
  set comment(String? value) => setField<String>('comment', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  String? get proofPhotoPath => getField<String>('proof_photo_path');
  set proofPhotoPath(String? value) =>
      setField<String>('proof_photo_path', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
