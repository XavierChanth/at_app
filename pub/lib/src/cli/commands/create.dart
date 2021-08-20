import 'dart:io';

import 'package:logger/logger.dart';
import 'package:args/src/usage_exception.dart';

import '../command_status.dart';
import '../file/index.dart';
import 'flutter_create.dart';

class CreateCommand extends FlutterCreate {
  final String description = 'Create a new @platform Flutter project.';
  final Logger _logger;
  CreateCommand({Logger? logger})
      : _logger = logger ?? Logger(),
        super(logger: logger) {
    argParser.addOption(
      'namespace',
      abbr: 'n',
      help: 'The @protocol app namespace to use for the application.',
      defaultsTo: '',
      valueHelp: 'namespace',
    );
    argParser.addOption(
      'root-domain',
      abbr: 'r',
      help: 'The @protocol root domain to use for the application.',
      allowed: ['prod', 've'],
      defaultsTo: 'prod',
      valueHelp: 'prod | ve',
    );
    argParser.addOption(
      'api-key',
      abbr: 'k',
      help: 'The api key for at_onboarding_flutter.',
      defaultsTo: '',
      valueHelp: 'api-key',
    );
  }

  @override
  Future<CommandStatus> run() async {
    validateOutputDirectoryArg();
    final TemplateManager mainFileManager =
        TemplateManager(outputDirectory, 'main.dart');

    bool shouldWriteMainFile =
        argResults!['overwrite'] ?? false || !mainFileManager.existsSync;

    CommandStatus flutterCreateResult = await super.run();
    if (flutterCreateResult != CommandStatus.success) {
      return flutterCreateResult;
    }

    var results = await Future.wait([
      _updateEnvFile(),
      _addDependencies(),
      if (shouldWriteMainFile) mainFileManager.copyTemplate(),
      _androidConfig(),
    ]);

    results.forEach((result) {
      if (!result) {
        throwToolExit(
          'There was an issue generating your @platform $projectType',
          exitCode: 3,
        );
      }
    });

    return CommandStatus.success;
  }

  Future<bool> _updateEnvFile() async {
    var values = _parseEnvArgs();
    // generatedFileCount++;
    return EnvManager(outputDirectory).update(values);
  }

  Map<String, String> _parseEnvArgs() {
    if (argResults == null) throw NullThrownError();
    Map<String, String> result = {};
    if (argResults!.wasParsed('namespace')) {
      result['NAMESPACE'] = argResults!['namespace'];
    }
    if (argResults!.wasParsed('root-domain')) {
      result['ROOT_DOMAIN'] = _getRootDomain(argResults!['root-domain']);
    }
    if (argResults!.wasParsed('api-key')) {
      result['API_KEY'] = argResults!['api-key'];
    }
    return result;
  }

  String _getRootDomain(String flag) {
    switch (flag) {
      case 've':
        return 'vip.ve.atsign.zone';
      case 'prod':
      default:
        return 'root.atsign.org';
    }
  }

  // * dependencies for skeleton_app

  Future<bool> _addDependencies() async {
    if (argResults == null) throw NullThrownError();
    final List<String> packages = [
      'at_client_mobile',
      'at_onboarding_flutter',
      'at_app'
    ];
    final bool local = argResults!['local'] as bool;
    List<Future> futures = packages.map((package) async {
      return await pub.add(package, local: local, directory: outputDirectory);
    }).toList();
    if (argResults!['pub']) {
      await pub.get(directory: outputDirectory);
    }
    return (await Future.wait(futures)).every((res) => res);
  }

  // * update the flutter android config

  Future<bool> _androidConfig() async {
    List<Future> futures = [
      GradlePropertiesManager(outputDirectory).update(),
      AppBuildGradleManager(outputDirectory).update()
    ];
    return (await Future.wait(futures)).every((res) => res);
  }
}
