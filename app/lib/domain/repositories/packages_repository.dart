import '../models/font_cache.dart';
import '../models/package.dart';
import '../models/svg_icon.dart';

abstract class PackagesRepository {
  Future<List<Package>?> getPackages();
  Future<Package?> createPackage(Package package);
  Future<bool> updatePackage(Package package);
  Future<void> downloadSelectedIconsFont(Package package);
  Future<void> downloadBackup(Package package);
  Future<void> downloadSvgIcon(SvgIcon icon);
  Stream<Package> listenPackageChanges(String packageId);
  Future<FontCache?> getFontCache(Package package);
  String compressSvgPath(String plainText);
  String decodeCompressedSvgPath(String base64String);
}
