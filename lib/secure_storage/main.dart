import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/secure_storage/secure_storage_provider.dart';

import 'items_widget.dart';

void main() {
  runApp(
    MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => SecureStorageProvider(),
        child: const ItemsWidget(),
      ),
    ),
  );
}
