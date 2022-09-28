class Proposal_model
{
  late String id;
  late String name;
  late String client_id;
  String? file_src;
  String? short_descr;
  String? descr;
  late String status;
  late String follow_up_date;

  Proposal_model(this.id,this.name,this.client_id,this.file_src,this.short_descr,this.descr,this.status,this.follow_up_date);
}