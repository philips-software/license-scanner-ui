/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */

class Detection {
  Detection({
    this.license,
    this.file,
    this.startLine,
    this.endLine,
    this.confirmations,
    this.ignored,
  });

  final String license;
  final String file;
  final int startLine;
  final int endLine;
  final int confirmations;
  bool ignored;

  factory Detection.fromMap(Map<String, dynamic> map) {
    return Detection(
      license: map['license'],
      file: map['file'] ?? '?',
      startLine: map['start_line'] ?? 0,
      endLine: map['end_line'] ?? 0,
      confirmations: map['confirmations'] ?? 0,
      ignored: map['ignored'] ?? false,
    );
  }
}
