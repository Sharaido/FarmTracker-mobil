class Field {
  final int id;
  final String name;
  final int size;
  final String location;
  final List<Farm> farms;

  Field(this.id, this.name, this.size, this.location, this.farms);

  int getTotalEntity() {
    int sum = 0;
    for (var farm in farms) {
      sum += farm.entityCount;
    }
    return sum;
  }
}

class Farm {
  final int id;
  final String name;
  final int size;
  final int entityCount;
  final List<Entity> entities;

  Farm(this.id, this.name, this.size, this.entityCount, this.entities);
}

class Entity {
  final int id;
  final String name;
  final int count;

  Entity(this.id, this.name, this.count);
}
