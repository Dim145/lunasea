import 'package:lunasea/database/table.dart';

enum TracearrDatabase<T> with LunaTableMixin<T> {
  NAVIGATION_INDEX<int>(0),
  REFRESH_RATE<int>(15),
  CONTENT_LOAD_LENGTH<int>(50);

  @override
  LunaTable get table => LunaTable.tracearr;

  @override
  final T fallback;

  const TracearrDatabase(this.fallback);
}
