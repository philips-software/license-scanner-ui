/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */

class FileFragment {
  FileFragment(
      {this.filename, this.offset, this.startLine, this.endLine, this.lines});

  final String filename;
  final int offset;
  final int startLine;
  final int endLine;
  final List<String> lines;
}
