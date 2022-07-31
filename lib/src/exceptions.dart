class MissingFlavoredPackagesInPubspecException implements Exception {
  const MissingFlavoredPackagesInPubspecException([this.message]);

  final String? message;

  @override
  String toString() {
    return message ?? super.toString();
  }
}
