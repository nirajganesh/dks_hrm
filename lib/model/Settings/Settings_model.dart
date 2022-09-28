class Settings_model
{
  String id;
  String sitelogo;
  String? sitetitle;
  String? description;
  String? copyright;
  String? contact;
  String? currency;
  String? symbol;
  String? system_email;
  String? address;
  String? bank_name;
  String? account_name;
  String? account_number;
  String? ifsc;
  String? upi_id;


  Settings_model(
      this.id,
      this.sitelogo,
      this.sitetitle,
      this.description,
      this.copyright,
      this.contact,
      this.currency,
      this.symbol,
      this.system_email,
      this.address,
      this.bank_name,
      this.account_name,
      this.account_number,
      this.ifsc,
      this.upi_id
      );
}