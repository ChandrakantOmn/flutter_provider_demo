
import 'package:drift/drift.dart';
import 'package:untitled1/drift/tables/tod_items.dart';

import '../tables/todo_category.dart';

@DriftView(name: 'customViewName')
abstract class TodoItemWithCategoryNameView extends View {
  TodoItems get todoItems;
  TodoCategories get todoCategories;

  Expression<String> get title =>
      todoItems.title +
          const Constant('(') +
          todoCategories.name +
          const Constant(')');

  @override
  Query as() => select([todoItems.id, title]).from(todoItems).join([
    innerJoin(
        todoCategories, todoCategories.id.equalsExp(todoItems.categoryId))
  ]);
}