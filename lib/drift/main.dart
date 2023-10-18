import 'package:drift/drift.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:drift/native.dart';

import 'database.dart';


Future<void> main() async {
  // Create an in-memory instance of the database with todo items.
  final db = Database(NativeDatabase.memory());

  db.allItems.listen((event) {
    print('Todo-item in database: $event');
  });

  // Add category
  final categoryId = await db
      .into(db.todoCategories)
      .insert(TodoCategoriesCompanion.insert(name: 'Category'));

  // Add another entry
  await db.into(db.todoItems).insert(TodoItemsCompanion.insert(
      title: 'Another entry added later', categoryId: categoryId));

  final query = db.select(db.todoItems).join([
    innerJoin(db.todoCategories,
        db.todoCategories.id.equalsExp(db.todoItems.categoryId))
  ]);

  for (final row in await query.get()) {
    print('has row');
    print(row.read(db.todoItems.categoryId));
    print(row.read(db.todoCategories.name));
  }

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Container(),
        floatingActionButton: FloatingActionButton(onPressed: () {  },),
      ),
    );
  }
}
