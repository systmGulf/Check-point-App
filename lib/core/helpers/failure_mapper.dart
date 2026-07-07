/// Maps common failure messages to localization keys.
///
/// Cubits should emit these keys instead of raw error strings.
/// The UI translates them with `.tr()`.
class FailureMapper {
  FailureMapper._();

  static String toLocalizedKey(String rawMessage) {
    final lower = rawMessage.toLowerCase();

    if (lower.contains('timeout') || lower.contains('timed out')) {
      return 'error.network_timeout';
    }
    if (lower.contains('no internet') ||
        lower.contains('socket') ||
        lower.contains('connection refused')) {
      return 'error.no_internet';
    }
    if (lower.contains('unauthorized') || lower.contains('401')) {
      return 'error.unauthorized';
    }
    if (lower.contains('500') || lower.contains('internal server')) {
      return 'error.server_error';
    }
    if (lower.contains('404') || lower.contains('not found')) {
      return 'error.not_found';
    }

    // Fallback: return the original message as-is.
    // This keeps backward-compatibility with server-provided messages.
    return rawMessage;
  }
}
