
class TContact {
  int? _id;
  String? _number;
  String? _name;

  TContact(this._number, this._name);
  TContact.withId(this._id, this._number, this._name);

  // getters
  int get id => _id!;
  String get number => _number!;
  String get name => _name!;

  @override
  String toString() {
    return 'Contact: (id: $_id, name: $_name, number: $_number)';
  }

  // setters
  set number(String newNumber) => _number = newNumber;
  set name(String newName) => _name = newName;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (_id != null) {
      map['id'] = _id;
    }
    map['number'] = _number;
    map['name'] = _name;

    return map;
  }

  // Extract TContact from a Map object
  TContact.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _number = map['number'];
    _name = map['name'];
  }
}
