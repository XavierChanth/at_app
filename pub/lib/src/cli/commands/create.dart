import 'package:at_app/src/cli/exceptions.dart';
import 'package:logger/logger.dart';

import '../command_status.dart';
import '../file/index.dart';
import '../flutter.dart';
import 'create_base.dart';

class CreateCommand extends CreateBase {
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
        boolArg('overwrite') ?? false || !mainFileManager.existsSync;

    CommandStatus flutterCreateResult = await super.run();
    if (flutterCreateResult != CommandStatus.success) {
      return flutterCreateResult;
    }

    await Future.wait([
      updateEnvFile(),
      addDependencies(),
      androidConfig(),
    ]);

    // Should be completed after addDependencies
    // so that we can expect at_app to be in the pub cache
    try {
      if (shouldWriteMainFile) await mainFileManager.copyTemplate();
    } catch (e) {
      throw TemplateFileException(e.toString());
    }

    return CommandStatus.success;
  }

  /// Updates the environment variables from the command arguments
  Future<void> updateEnvFile() async {
    try {
      var values = parseEnvArgs();
      // generatedFileCount++;
      await EnvManager(outputDirectory).update(values);
    } catch (e) {
      throw EnvException(e.toString());
    }
  }

  /// Parses the environment variables from the command arguments
  Map<String, String> parseEnvArgs() {
    assert(argResults != null);
    Map<String, String> result = {};
    if (argResults!.wasParsed('namespace')) {
      result['NAMESPACE'] = stringArg('namespace')!;
    }
    if (argResults!.wasParsed('root-domain')) {
      result['ROOT_DOMAIN'] = getRootDomain(stringArg('root-domain')!);
    }
    if (argResults!.wasParsed('api-key')) {
      result['API_KEY'] = stringArg('api-key')!;
    }
    return result;
  }

  /// Get the full rootDomain for the specified [flag]
  String getRootDomain(String flag) {
    switch (flag) {
      case 've':
        return 'vip.ve.atsign.zone';
      case 'prod':
      default:
        return 'root.atsign.org';
    }
  }

  /// Dependencies for the @platform app
  Future<void> addDependencies() async {
    assert(argResults != null);
    final List<String> packages = [
      'at_client_mobile',
      'at_onboarding_flutter',
      'at_app'
    ];
    try {
      List<Future> futures = packages.map((package) async {
        return await Flutter.pubAdd(package, directory: outputDirectory);
      }).toList();
      if (boolArg('pub')!) {
        await Flutter.pubGet(directory: outputDirectory);
      }
      await Future.wait(futures);
    } catch (e) {
      throw PubException(e.toString());
    }
  }

  /// Required Android build configuration
  Future<void> androidConfig() async {
    try {
      await Future.wait([
        GradlePropertiesManager(outputDirectory).update(),
        AppBuildGradleManager(outputDirectory).update()
      ]);
    } catch (e) {
      throw AndroidBuildException(e.toString());
    }
  }
}
