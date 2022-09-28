class Invoice_model
{
  String? id;
  String? inv_no;
  String? client_id;
  String? client_name;
  String? client_contact;
  String? client_email;
  String? inv_date;
  String? sub_total;
  String? gst;
  String? total;
  String? total_paid;
  String? total_due;
  String? due_date;
  String? remarks;
  String? is_deleted;
  String? ref_quotation_id;

  Invoice_model(this.id,this.inv_no,this.client_id,this.client_name,this.client_contact,this.client_email,this.inv_date,this.sub_total,
      this.gst,this.total,this.total_paid,this.total_due,this.due_date,this.remarks,this.is_deleted,
      this.ref_quotation_id);
}