
import 'package:drift/drift.dart';
import 'package:untitled1/drift/tables/tod_items.dart';

import '../tables/todo_category.dart';

abstract class TodoCategoryItemCount extends View {
  TodoItems get todoItems;
  TodoCategories get todoCategories;

  Expression<int> get itemCount => todoItems.id.count();

  @override
  Query as() => select([
    todoCategories.name,
    itemCount,
  ]).from(todoCategories).join([
    innerJoin(todoItems, todoItems.categoryId.equalsExp(todoCategories.id))
  ]);
}