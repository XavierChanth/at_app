/// An exception thrown when the at_app dependencies fail to load
class PubException implements Exception {
  final String message;

  PubException(this.message);
}

/// An exception thrown when the android configuration fails to update
class AndroidBuildException implements Exception {
  final String message;

  AndroidBuildException(this.message);
}

/// An exception thrown when the environment variables fail to set
class EnvException implements Exception {
  final String message;

  EnvException(this.message);
}

/// An exception thrown when a template file fails to be copied
class TemplateFileException implements Exception {
  final String message;

  TemplateFileException(this.message);
}
