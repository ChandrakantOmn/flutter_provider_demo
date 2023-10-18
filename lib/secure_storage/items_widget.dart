import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'secure_storage_provider.dart';
import 'edit_item_widget.dart';

class ItemsWidget extends StatefulWidget {
  const ItemsWidget({Key? key}) : super(key: key);

  @override
  ItemsWidgetState createState() => ItemsWidgetState();
}

class ItemsWidgetState extends State<ItemsWidget> {
  final _accountNameController =
      TextEditingController(text: 'flutter_secure_storage_service');
  late SecureStorageProvider secureStorageProvider;

  @override
  void initState() {
    super.initState();
    secureStorageProvider =
        Provider.of<SecureStorageProvider>(context, listen: false);
    _accountNameController.addListener(() {
      secureStorageProvider.readAll();
    });

    secureStorageProvider.readAll();
  }

  String? _getAccountName() =>
      _accountNameController.text.isEmpty ? null : _accountNameController.text;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              key: const Key('add_random'),
              onPressed: () {
                secureStorageProvider.addNewItem();
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<UserActions>(
              key: const Key('popup_menu'),
              onSelected: (action) {
                switch (action) {
                  case UserActions.deleteAll:
                    secureStorageProvider.deleteAll();
                    break;
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<UserActions>>[
                const PopupMenuItem(
                  key: Key('delete_all'),
                  value: UserActions.deleteAll,
                  child: Text('Delete all'),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            if (!kIsWeb && Platform.isIOS)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _accountNameController,
                  decoration:
                      const InputDecoration(labelText: 'kSecAttrService'),
                ),
              ),
            Expanded(
              child: Consumer<SecureStorageProvider>(
                  builder: (context, secureStorageProvider, child) {
                return ListView.builder(
                  itemCount: secureStorageProvider.items.length,
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    trailing: PopupMenuButton<ItemActions>(
                      key: Key('popup_row_$index'),
                      onSelected: (action) => _performAction(
                          action, secureStorageProvider.items[index], context),
                      itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<ItemActions>>[
                        PopupMenuItem(
                          value: ItemActions.delete,
                          child: Text(
                            'Delete',
                            key: Key('delete_row_$index'),
                          ),
                        ),
                        PopupMenuItem(
                          value: ItemActions.edit,
                          child: Text(
                            'Edit',
                            key: Key('edit_row_$index'),
                          ),
                        ),
                        PopupMenuItem(
                          value: ItemActions.containsKey,
                          child: Text(
                            'Contains Key',
                            key: Key('contains_row_$index'),
                          ),
                        ),
                        PopupMenuItem(
                          value: ItemActions.read,
                          child: Text(
                            'Read',
                            key: Key(
                                'read_row_$index'), // Changed the key to 'read_row_$index'
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      secureStorageProvider.items[index].value,
                      key: Key('title_row_$index'),
                    ),
                    subtitle: Text(
                      secureStorageProvider.items[index].key,
                      key: Key('subtitle_row_$index'),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );

  Future<void> _performAction(
    ItemActions action,
    SecItem item,
    BuildContext context,
  ) async {
    switch (action) {
      case ItemActions.delete:
        secureStorageProvider.deleteItem(item.key);
        secureStorageProvider.readAll();
        break;
      case ItemActions.edit:
        if (!context.mounted) return;
        final result = await showDialog<String>(
          context: context,
          builder: (context) => EditItemWidget(item.value),
        );
        if (result != null) {
          secureStorageProvider.updateItem(item.key, result);
          secureStorageProvider.readAll();
        }
        break;
      case ItemActions.containsKey:
        if (!context.mounted) return;
        final key = await _displayTextInputDialog(context, item.key);
        final result = await secureStorageProvider.isItemPresent(key);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contains Key: $result, key checked: $key'),
            backgroundColor: result ? Colors.green : Colors.red,
          ),
        );
        break;
      case ItemActions.read:
        if (!context.mounted) return;
        final key = await _displayTextInputDialog(context, item.key);
        final result = await secureStorageProvider.getItem(key);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('value: $result'),
          ),
        );
        break;
    }
  }

  Future<String> _displayTextInputDialog(
    BuildContext context,
    String key,
  ) async {
    final controller = TextEditingController();
    controller.text = key;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Check if key exists'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
          content: TextField(
            controller: controller,
          ),
        );
      },
    );
    return controller.text;
  }
}
