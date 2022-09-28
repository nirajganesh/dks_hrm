class Payment_model
{
  String? pay_id;
  String? receipt_no;
  String? client_id;
  String? client_name;
  String? amount;
  String? invoice_id;
  String? payment_date;
  String? remarks;
  String? is_deleted;
  String? name;
  String? person;
  String? address;
  String? contact_no;
  String? email;
  String? gst_no;
  String? balance;

  Payment_model(this.pay_id,this.receipt_no,this.client_id,this.client_name,this.amount,this.invoice_id,this.payment_date,this.remarks,this.is_deleted,
    this.name,this.person,this.address,this.contact_no,this.email,this.gst_no,this.balance);
}