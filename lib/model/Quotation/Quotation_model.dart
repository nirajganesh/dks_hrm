class Quotation_model
{
  late String id;
  late String quote_no;
  late String client_id;
  late String client_name;
  late String client_email;
  late String quote_date;
  late String valid_till;
  late String sub_total;
  late String gst;
  late String discount;
  late String total;
  late String status;
  String? remarks;
  late String is_deleted;
  late String ref_invoice_id;


  Quotation_model(this.id,this.quote_no,this.client_id,this.client_name,this.client_email,this.quote_date,this.valid_till,this.sub_total,this.gst,this.discount,this.total,this.status,this.remarks,this.is_deleted,this.ref_invoice_id);
}