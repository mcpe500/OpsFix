import '../database.dart';

class TicketDetailVTable extends SupabaseTable<TicketDetailVRow> {
  @override
  String get tableName => 'ticket_detail_v';

  @override
  TicketDetailVRow createRow(Map<String, dynamic> data) =>
      TicketDetailVRow(data);
}

class TicketDetailVRow extends SupabaseDataRow {
  TicketDetailVRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TicketDetailVTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get siteId => getField<String>('site_id');
  set siteId(String? value) => setField<String>('site_id', value);

  String? get ticketCode => getField<String>('ticket_code');
  set ticketCode(String? value) => setField<String>('ticket_code', value);

  int? get ticketNumber => getField<int>('ticket_number');
  set ticketNumber(int? value) => setField<int>('ticket_number', value);

  String? get locationId => getField<String>('location_id');
  set locationId(String? value) => setField<String>('location_id', value);

  String? get unitId => getField<String>('unit_id');
  set unitId(String? value) => setField<String>('unit_id', value);

  String? get targetType => getField<String>('target_type');
  set targetType(String? value) => setField<String>('target_type', value);

  String? get componentKey => getField<String>('component_key');
  set componentKey(String? value) => setField<String>('component_key', value);

  String? get locationCodeSnapshot =>
      getField<String>('location_code_snapshot');
  set locationCodeSnapshot(String? value) =>
      setField<String>('location_code_snapshot', value);

  String? get locationNameSnapshot =>
      getField<String>('location_name_snapshot');
  set locationNameSnapshot(String? value) =>
      setField<String>('location_name_snapshot', value);

  String? get unitCodeSnapshot => getField<String>('unit_code_snapshot');
  set unitCodeSnapshot(String? value) =>
      setField<String>('unit_code_snapshot', value);

  String? get unitNameSnapshot => getField<String>('unit_name_snapshot');
  set unitNameSnapshot(String? value) =>
      setField<String>('unit_name_snapshot', value);

  String? get unitPositionSnapshot =>
      getField<String>('unit_position_snapshot');
  set unitPositionSnapshot(String? value) =>
      setField<String>('unit_position_snapshot', value);

  String? get targetLabelSnapshot => getField<String>('target_label_snapshot');
  set targetLabelSnapshot(String? value) =>
      setField<String>('target_label_snapshot', value);

  String? get issueCategorySnapshot =>
      getField<String>('issue_category_snapshot');
  set issueCategorySnapshot(String? value) =>
      setField<String>('issue_category_snapshot', value);

  String? get issueTypeSnapshot => getField<String>('issue_type_snapshot');
  set issueTypeSnapshot(String? value) =>
      setField<String>('issue_type_snapshot', value);

  String? get reporterId => getField<String>('reporter_id');
  set reporterId(String? value) => setField<String>('reporter_id', value);

  String? get reporterNameSnapshot =>
      getField<String>('reporter_name_snapshot');
  set reporterNameSnapshot(String? value) =>
      setField<String>('reporter_name_snapshot', value);

  String? get assignedTechnicianId =>
      getField<String>('assigned_technician_id');
  set assignedTechnicianId(String? value) =>
      setField<String>('assigned_technician_id', value);

  String? get technicianNameSnapshot =>
      getField<String>('technician_name_snapshot');
  set technicianNameSnapshot(String? value) =>
      setField<String>('technician_name_snapshot', value);

  String? get issueCategoryId => getField<String>('issue_category_id');
  set issueCategoryId(String? value) =>
      setField<String>('issue_category_id', value);

  String? get issueTypeId => getField<String>('issue_type_id');
  set issueTypeId(String? value) => setField<String>('issue_type_id', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get priority => getField<String>('priority');
  set priority(String? value) => setField<String>('priority', value);

  int? get priorityRank => getField<int>('priority_rank');
  set priorityRank(int? value) => setField<int>('priority_rank', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get assignmentState => getField<String>('assignment_state');
  set assignmentState(String? value) =>
      setField<String>('assignment_state', value);

  bool? get isOpen => getField<bool>('is_open');
  set isOpen(bool? value) => setField<bool>('is_open', value);

  bool? get isArchived => getField<bool>('is_archived');
  set isArchived(bool? value) => setField<bool>('is_archived', value);

  int? get affectedCount => getField<int>('affected_count');
  set affectedCount(int? value) => setField<int>('affected_count', value);

  DateTime? get occurredAt => getField<DateTime>('occurred_at');
  set occurredAt(DateTime? value) => setField<DateTime>('occurred_at', value);

  String? get contact => getField<String>('contact');
  set contact(String? value) => setField<String>('contact', value);

  String? get accessHint => getField<String>('access_hint');
  set accessHint(String? value) => setField<String>('access_hint', value);

  DateTime? get responseDueAt => getField<DateTime>('response_due_at');
  set responseDueAt(DateTime? value) =>
      setField<DateTime>('response_due_at', value);

  DateTime? get resolutionDueAt => getField<DateTime>('resolution_due_at');
  set resolutionDueAt(DateTime? value) =>
      setField<DateTime>('resolution_due_at', value);

  DateTime? get scheduledAt => getField<DateTime>('scheduled_at');
  set scheduledAt(DateTime? value) => setField<DateTime>('scheduled_at', value);

  DateTime? get assignedAt => getField<DateTime>('assigned_at');
  set assignedAt(DateTime? value) => setField<DateTime>('assigned_at', value);

  DateTime? get respondedAt => getField<DateTime>('responded_at');
  set respondedAt(DateTime? value) => setField<DateTime>('responded_at', value);

  DateTime? get startedAt => getField<DateTime>('started_at');
  set startedAt(DateTime? value) => setField<DateTime>('started_at', value);

  DateTime? get workCompletedAt => getField<DateTime>('work_completed_at');
  set workCompletedAt(DateTime? value) =>
      setField<DateTime>('work_completed_at', value);

  DateTime? get completedAt => getField<DateTime>('completed_at');
  set completedAt(DateTime? value) => setField<DateTime>('completed_at', value);

  DateTime? get escalatedAt => getField<DateTime>('escalated_at');
  set escalatedAt(DateTime? value) => setField<DateTime>('escalated_at', value);

  DateTime? get reopenedAt => getField<DateTime>('reopened_at');
  set reopenedAt(DateTime? value) => setField<DateTime>('reopened_at', value);

  String? get beforePhotoPath => getField<String>('before_photo_path');
  set beforePhotoPath(String? value) =>
      setField<String>('before_photo_path', value);

  String? get beforePhotoUrl => getField<String>('before_photo_url');
  set beforePhotoUrl(String? value) =>
      setField<String>('before_photo_url', value);

  String? get afterPhotoPath => getField<String>('after_photo_path');
  set afterPhotoPath(String? value) =>
      setField<String>('after_photo_path', value);

  String? get afterPhotoUrl => getField<String>('after_photo_url');
  set afterPhotoUrl(String? value) =>
      setField<String>('after_photo_url', value);

  String? get technicianNote => getField<String>('technician_note');
  set technicianNote(String? value) =>
      setField<String>('technician_note', value);

  int? get version => getField<int>('version');
  set version(int? value) => setField<int>('version', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
