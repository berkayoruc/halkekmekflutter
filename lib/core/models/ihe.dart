class Buffet {
  int _id;
  String _district;
  String _neighborhood;
  String _name;
  String _latitude;
  String _longitude;

  Buffet(this._id, this._district, this._neighborhood, this._name,
      this._latitude, this._longitude);

  factory Buffet.fromJSON(Map<String, dynamic> json) => Buffet(
      int.parse(json['_id'].toString()),
      json['Ilce_Adi'],
      json['Mahalle_Adi'],
      json['Bufe_Adi'],
      json['Enlem'],
      json['Boylam']);

  String get name => _name;
  String get district => _district;
  String get neighborhood => _neighborhood;
  String get latitude => _latitude;
  String get longitude => _longitude;
}
