import '../database.dart';

class TicketCountersTable extends SupabaseTable<TicketCountersRow> {
  @override
  String get tableName => 'ticket_counters';

  @override
  TicketCountersRow createRow(Map<String, dynamic> data) =>
      TicketCountersRow(data);
}

class TicketCountersRow extends SupabaseDataRow {
  TicketCountersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TicketCountersTable();

  String get siteId => getField<String>('site_id')!;
  set siteId(String value) => setField<String>('site_id', value);

  int get nextTicketNumber => getField<int>('next_ticket_number')!;
  set nextTicketNumber(int value) => setField<int>('next_ticket_number', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
