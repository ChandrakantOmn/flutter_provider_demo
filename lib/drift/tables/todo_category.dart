

import 'package:drift/drift.dart';

@DataClassName('TodoCategory')
class TodoCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
