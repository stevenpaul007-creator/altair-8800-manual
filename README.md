# Altair 8800 Operator's Manual (Bilingual Project)

This directory holds the **Altair 8800 Operator's Manual** in its original English
(`Altair8800/`) and a Simplified-Chinese translation (`Altair8800-zh/`).
Sources are written in reStructuredText (ReST) and built to HTML with
[Sphinx](https://www.sphinx-doc.org/) using the `cloud_sptheme` theme.

---

## 1. Directory layout

```
altair-8800-manual/
├── Altair8800/        # Original English manual
│   ├── source/        # ReST sources (index + part-0..4 + appendix + linux + ...)
│   ├── build/html/    # Built HTML output
│   ├── Makefile       # Sphinx Makefile (make html)
│   └── requirements.txt
├── Altair8800-zh/     # Simplified-Chinese translation
│   ├── source/        # Chinese ReST sources
│   ├── build/html/    # Chinese HTML output
│   └── tools/         # Helper scripts (e.g. CJK table checker)
└── .venv/             # Python virtualenv (sphinx + cloud_sptheme, patched)
```

> Note: `.venv` lives outside the repos (PEP 668 forbids installing into the system
> Python) and is shared by both sub-projects.

---

## 2. Building

You need Python 3 and the shared virtualenv `.venv` (which has `sphinx` and
`cloud-sptheme` installed). `cloud_sptheme` is patched for Jinja2 3.1: its
`ext/index_styling.py` imports `Markup` from `markupsafe`.

```bash
# Enter either sub-project (English or Chinese)
cd Altair8800          # or: cd Altair8800-zh

# Build HTML using the shared virtualenv's sphinx-build
PATH=../.venv/bin:$PATH make html

# Equivalent:
# ../.venv/bin/sphinx-build -M html source build
```

Open `build/html/index.html` to read the result.
(The Chinese build emits a few non-blocking cosmetic warnings, mostly from
cross-row inline literals in Part 4; the exit code is 0.)

---

## 3. Manual contents

| File | Contents |
|------|----------|
| `index` | Master table of contents |
| `part-0` | Project notes: from scanned printout to searchable text |
| `part-1` | Number systems, logic, and programming basics |
| `part-2` | Front panel, memory, and CPU architecture |
| `part-3` | Loading programs and an introduction to the instructions (incl. front-panel switches/LEDs) |
| `part-4` | Instruction-set reference (78 instructions) |
| `appendix` | Appendix |
| `linux` | Using SIMH and related tools under Linux |
| `addendum` / `resources` / `service` / `price-list` | Supplements, resources, service, price list |

---

## 4. Source project

The original English manual and its sources are maintained by Kevin Cole
("The Ubuntourist") on Codeberg:

- Source repository: https://codeberg.org/ubuntourist/Altair8800
- Issue tracker: https://codeberg.org/ubuntourist/Altair8800/issues

---

## 5. License

See `Altair8800/LICENSE.md`.
