import '../database.dart';

class TicketEventsTable extends SupabaseTable<TicketEventsRow> {
  @override
  String get tableName => 'ticket_events';

  @override
  TicketEventsRow createRow(Map<String, dynamic> data) => TicketEventsRow(data);
}

class TicketEventsRow extends SupabaseDataRow {
  TicketEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TicketEventsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get siteId => getField<String>('site_id')!;
  set siteId(String value) => setField<String>('site_id', value);

  String get ticketId => getField<String>('ticket_id')!;
  set ticketId(String value) => setField<String>('ticket_id', value);

  String get eventType => getField<String>('event_type')!;
  set eventType(String value) => setField<String>('event_type', value);

  String? get fromStatus => getField<String>('from_status');
  set fromStatus(String? value) => setField<String>('from_status', value);

  String? get toStatus => getField<String>('to_status');
  set toStatus(String? value) => setField<String>('to_status', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  String? get actorId => getField<String>('actor_id');
  set actorId(String? value) => setField<String>('actor_id', value);

  String? get actorNameSnapshot => getField<String>('actor_name_snapshot');
  set actorNameSnapshot(String? value) =>
      setField<String>('actor_name_snapshot', value);

  String? get actorRoleSnapshot => getField<String>('actor_role_snapshot');
  set actorRoleSnapshot(String? value) =>
      setField<String>('actor_role_snapshot', value);

  dynamic get metadata => getField<dynamic>('metadata')!;
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
