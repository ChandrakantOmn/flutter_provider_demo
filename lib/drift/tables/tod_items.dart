
import 'package:drift/drift.dart';
import 'package:untitled1/drift/tables/todo_category.dart';

@TableIndex(name: 'item_title', columns: {#title})
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text().nullable()();
  IntColumn get categoryId => integer().references(TodoCategories, #id)();

  TextColumn get generatedText => text().nullable().generatedAs(
      title + const Constant(' (') + content + const Constant(')'))();
}