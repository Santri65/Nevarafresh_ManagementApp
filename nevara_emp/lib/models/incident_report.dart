/// Model representing an incident or operational report in the store.
class IncidentReport {
  final String id;
  final String type;
  final String description;
  final int affectedQuantity;
  final String dateTime;
  final String status;
  final String authorizedBy;

  const IncidentReport({
    required this.id,
    required this.type,
    required this.description,
    required this.affectedQuantity,
    required this.dateTime,
    required this.status,
    this.authorizedBy = 'carlos.mendoza@nevarafresh.com',
  });
}
