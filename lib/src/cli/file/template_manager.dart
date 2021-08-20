import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:pub_cache/pub_cache.dart';
import 'package:pub_semver/pub_semver.dart';

import '../version.dart';
import 'file_manager.dart';

class TemplateManager extends FileManager {
  String filename;
  PubCache pc;

  late File source;
  late String hostedPubCachePath;

  TemplateManager(Directory projectDir, this.filename)
      : pc = PubCache(),
        super(projectDir, path.normalize('lib/$filename')) {
    hostedPubCachePath =
        path.normalize('${pc.location.absolute.path}/hosted/pub.dartlang.org');
    setSourceFromPubCache();
  }

  Future<bool> copyTemplate() async {
    try {
      while (existsSync == false) {
        sleep(Duration(milliseconds: 500));
      }
      if (!source.existsSync()) {
        setSourceFromPubCache();
      }
      var sourceLines = await source.readAsLines();
      await write(sourceLines);
    } catch (error) {
      print(error.toString());
      return false;
    }
    return true;
  }

  void setSourceFromPubCache() {
    Version? version = pc.getLatestVersion('at_app')?.version;

    if (version == null) {
      throw NoPackageException('at_app');
    }

    // try to build from the exact version if possible
    // otherwise use the latest available
    if (version != Version.parse(packageVersion)) {
      buildSourceUrlForVersion(packageVersion);
      if (source.existsSync()) return;
    }
    buildSourceUrlForVersion(version.toString());
  }

  void buildSourceUrlForVersion(String version) {
    source = FileManager.fileFromPath(path.normalize(
        '$hostedPubCachePath/at_app-${version}/lib/templates/$filename'));
  }
}

class NoPackageException implements Exception {
  final String message;

  NoPackageException(String packageName)
      : message = 'No version of $packageName found in the pub cache.';
}
