#!/usr/bin/env python3
"""Validate grid table alignment in reStructuredText files (CJK-aware).

Checks (errors, exit != 0):
  B. every interior line starts with '|' at the first border column and
     ends with '|' at the last border column (trailing spaces allowed);
  C. nothing but whitespace after the last border column.

Notes (informational only):
  A. border lines of one table whose '+' columns differ from the table's
     first border line (docutils tolerates this, e.g. extra header
     separators, so it is not an error).

CJK (full-width) characters occupy two display columns, so padding must
account for East Asian width.  Pipes that are cell *content* (e.g. the
"|---|" isonum substitution) are ignored by design.

Usage:
    python3 check_tables.py file.rst [file.rst ...]
"""

import re
import sys
import unicodedata


def char_width(ch):
    if unicodedata.combining(ch):
        return 0
    return 2 if unicodedata.east_asian_width(ch) in ("W", "F") else 1


def border_columns(line):
    cols = []
    width = 0
    for ch in line:
        if ch == "+":
            cols.append(width)
        width += char_width(ch)
    return cols


def pipe_columns(stripped, indent):
    cols = []
    width = indent
    for ch in stripped:
        if ch == "|":
            cols.append(width)
        width += char_width(ch)
    return cols


def is_border(line):
    s = line.rstrip()
    # a border starts with '+' and may end with '+' or '|' (partial borders
    # of spanned rows may end with '|')
    return bool(re.match(r"^\s*\+[-=+ ]*[+|]\s*$", s)) and ("-" in s or "=" in s)


def check_file(path):
    problems = []
    notes = []
    with open(path, encoding="utf-8") as fh:
        lines = fh.readlines()

    i = 0
    n = len(lines)
    while i < n:
        if is_border(lines[i]):
            ref_cols = border_columns(lines[i].rstrip("\n"))
            ref_line = i + 1
            first, last = ref_cols[0], ref_cols[-1]
            i += 1
            while i < n:
                cur = lines[i].rstrip("\n")
                if is_border(cur):
                    cols = border_columns(cur)
                    if cols != ref_cols:
                        notes.append(
                            f"{path}:{i + 1}: NOTE border columns {cols} differ "
                            f"from table starting line {ref_line} {ref_cols}"
                        )
                    i += 1
                    continue
                if not cur.strip():
                    break
                stripped = cur.lstrip()
                indent = len(cur) - len(stripped)
                if not stripped.startswith("|"):
                    problems.append(
                        f"{path}:{i + 1}: interior line does not start with "
                        f"'|' (table starting line {ref_line})"
                    )
                    i += 1
                    continue
                pipes = pipe_columns(stripped, indent)
                if pipes[0] != first:
                    problems.append(
                        f"{path}:{i + 1}: first '|' at column {pipes[0]} != "
                        f"left border {first}"
                    )
                if pipes[-1] != last:
                    problems.append(
                        f"{path}:{i + 1}: last '|' at column {pipes[-1]} != "
                        f"right border {last}"
                    )
                tail = cur[pipes[-1] + 1:] if pipes[-1] < len(cur) else ""
                if tail.strip():
                    problems.append(
                        f"{path}:{i + 1}: non-space content after last '|': "
                        f"{tail.strip()[:40]!r}"
                    )
                i += 1
        else:
            i += 1
    return problems, notes


def main(argv):
    total = 0
    for path in argv[1:]:
        problems, notes = check_file(path)
        for p in problems:
            print(p)
        for nt in notes:
            print(nt)
        total += len(problems)
    print(f"{total} problem(s) found." if total else "All grid tables aligned.")
    return 1 if total else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
