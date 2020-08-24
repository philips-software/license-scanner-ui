class ScanResult {
  final String namespace;
  final String name;
  final String version;

  String license = '';
  String error;

  ScanResult(this.namespace, this.name, this.version);

  factory ScanResult.fromMap(Map<String, dynamic> map) {
    var result =
        ScanResult(map['namespace'] ?? '', map['name'], map['version']);
    result.license = map['license'] ?? '';
    return result;
  }
}
