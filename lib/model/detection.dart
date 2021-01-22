/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
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
}
