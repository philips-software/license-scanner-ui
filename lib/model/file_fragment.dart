/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
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
