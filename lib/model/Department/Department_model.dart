class Department_model
{
  late String id;
  late String dep_name;

  Department_model(this.id,this.dep_name);

  Department_model.fromJson(Map<String,dynamic> json)
  {
    id=json['id'];
    dep_name=json['dep_name'];
  }
}