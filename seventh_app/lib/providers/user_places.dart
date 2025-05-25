import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seventh_app/models/place.dart';
// OSに依存しないパス
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
// flutter用SQLite
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    // DB作成時に実行
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
      );
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super([]);

  Future<void> loadPlaces() async {
    // SQLite
    final db = await _getDatabase();
    // DBからデータ取得
    final data = await db.query('user_places');
    final placesList =
        data
            .map(
              (row) => Place.withId(
                id: row['id'] as String,
                title: row['title'] as String,
                image: File(row['image'] as String),
                location: PlaceLocation(
                  latitude: row['lat'] as double,
                  longitude: row['lng'] as double,
                  address: row['address'] as String,
                ),
              ),
            )
            .toList();
    state = placesList;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    // アプリケーションはアプリケーションごとに専用のフォルダにインストールされる
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    // localにimageを保存
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final newPlace = Place(title: title, image: image, location: location);

    final db = await _getDatabase();
    // DBにデータを挿入
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': copiedImage.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [...state, newPlace];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
