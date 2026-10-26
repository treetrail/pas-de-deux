import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/catalog.dart';

class CatalogRepository {
  Future<Catalog> load() async => Catalog.fromJson(
    jsonDecode(await rootBundle.loadString('assets/questions.json'))
        as Map<String, dynamic>,
  );
}
