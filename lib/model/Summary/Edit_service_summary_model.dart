class Edit_service_summary_model
{
  String? id;
  String? client_id;
  String? item_id;
  String? descr;
  String? qty;
  String? price;
  String? is_billed;
  String? date;
  String? item_name;
  bool? isSelected;

  Edit_service_summary_model({
    required this.id,
    required this.client_id,
    required this.item_id,
    required this.descr,
    required this.qty,
    required this.price,
    required this.is_billed,
    required this.date,
    required this.item_name,
    required this.isSelected
  });
}