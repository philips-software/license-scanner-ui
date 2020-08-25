class ScanResult {
  final String uuid;
  final String namespace;
  final String name;
  final String version;

  String license = '';
  String error;
  bool isContested = false;
  bool isConfirmed = false;

  ScanResult(this.uuid, this.namespace, this.name, this.version);

  factory ScanResult.fromMap(Map<String, dynamic> map) {
    var result = ScanResult(
      map['uuid'],
      map['namespace'] ?? '',
      map['name'],
      map['version'],
    );
    result.license = map['license'];
    result.error = map['error'];
    result.isConfirmed = map['isConfirmed'] ?? false;
    result.isContested = map['isContested'] ?? false;

    return result;
  }
}
