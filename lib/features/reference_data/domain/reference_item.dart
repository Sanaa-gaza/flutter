/// A governorate, an area or a service: the lists the forms choose from.
class ReferenceItem {
  const ReferenceItem({required this.id, required this.name});

  final int id;
  final String name;

  @override
  bool operator ==(Object other) =>
      other is ReferenceItem && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}
