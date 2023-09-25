import 'dart:typed_data';

import '../models/package.dart';
import '../models/session.dart';

abstract class PackagesRepository {
  Future<List<Package>?> getPackages(Session session);
  Future<Package?> getPackage(
    String packageId, {
    String? apiKey,
  });
  Future<Uint8List?> downloadSelectedIconsFont(
    Package package, {
    String? apiKey,
  });
}
