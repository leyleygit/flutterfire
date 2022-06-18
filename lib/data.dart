class PersonModel {
  final String name, sex;
  final int age;

  PersonModel({required this.name, required this.sex, required this.age});
}

List<PersonModel> persondata = [
  PersonModel(name: 'kerker', sex: 'male', age: 24),
  PersonModel(name: 'livat', sex: 'male', age: 22),
  PersonModel(name: 'noii', sex: 'male', age: 20),
  PersonModel(name: 'vichet', sex: 'male', age: 25),
];
