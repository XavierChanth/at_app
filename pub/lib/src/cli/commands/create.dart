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
        TemplateManager(projectDir, 'main.dart');

    CommandStatus? flutterCreateResult = await super.run();
    if (flutterCreateResult != null) return flutterCreateResult;
    return CommandStatus.success;
  }

  void validateOutputDirectoryArg() {
    if (argResults?.rest.isEmpty ?? false) {
      throw UsageException(
          'No option specified for the output directory.', usage);
    }

    if (argResults!.rest.length > 1) {
      String message = 'Multiple output directories specified.';
      for (final String arg in argResults!.rest) {
        if (arg.startsWith('-')) {
          message += '\nTry moving $arg to be immediately following $name';
          break;
        }
      }
      throw FormatException(message);
    }
  }

  Directory get projectDir {
    if (argResults?.rest == null) {
      throw UsageException(
          'No option specified for the output directory.', usage);
    }
    return Directory(argResults!.rest.first);
  }
}
