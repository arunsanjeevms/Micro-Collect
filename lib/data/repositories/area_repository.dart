import '../../core/models/area.dart';

class AreaDraft {
  const AreaDraft({required this.code, required this.name, this.active = true});

  final String code;
  final String name;
  final bool active;
}

class AreaPatch {
  const AreaPatch({this.code, this.name, this.active});

  final String? code;
  final String? name;
  final bool? active;
}

abstract interface class AreaRepository {
  Future<List<Area>> fetchAll();

  Future<Area> create(AreaDraft draft);

  Future<Area> update(String id, AreaPatch patch);

  Future<void> delete(String id);
}
