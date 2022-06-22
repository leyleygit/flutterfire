// class PersonModel {
//   final String name, sex;
//   final int age;

//   PersonModel({required this.name, required this.sex, required this.age});
// }

// List<PersonModel> persondata = [
//   PersonModel(name: 'kerker', sex: 'male', age: 24),
//   PersonModel(name: 'livat', sex: 'male', age: 22),
//   PersonModel(name: 'noii', sex: 'male', age: 20),
//   PersonModel(name: 'vichet', sex: 'male', age: 25),
// ];
class PersonModel {
  String? id;
  final String name;
  final num age;
  final String sex;
  PersonModel(
      {this.id, required this.name, required this.age, required this.sex});
}

List<PersonModel> personInBattambang = [
  PersonModel(id: "0001", name: 'vichect', age: 25, sex: 'male'),
  PersonModel(id: "0002", name: 'mengley', age: 24, sex: 'male'),
];
