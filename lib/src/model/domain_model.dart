class DomainModel {
  List<String>? domainItems;

  DomainModel({this.domainItems});

  DomainModel.fromJson(Map<String, dynamic> json) {
    domainItems = json['domain_items'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['domain_items'] = domainItems;
    return data;
  }
}
