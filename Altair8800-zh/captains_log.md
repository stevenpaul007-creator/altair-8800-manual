# ALTAIR 8800 OPERATOR'S MANUAL

Initial conversion from the PDF source was done with `pdftoppm` and
`tesseract-ocr`

```
    $ pdftoppm -png altair-8800.pdf output
    $ for i in *.png
    $ do
    $  tesseract "$i" "output-$i" -l eng
    $ done
    $ cat output-output-*.txt > altair-8800.txt
    $ rm output*.txt
```

After attempting to get sane arrows and lines from Unicode, by
trolling `KCharSelect` I yielded.

Logic gates were added with the [Inkscape Logic Gates
extension](https://github.com/fsmMLK/inkscapeLogicGates) Git
repository.

**WARNING:** Currently using **Inkscape 0.92.5 (2060ec1f9f,
2020-04-08)** but the official [Inkscape
site](https://inkscape.org/~fsmMLK/%E2%98%85logicgates) warns that
this extension will not work in the upcoming 1.0 and offers a link to
the documentation for fixing it.

---

I messed up adding `page.html` to `source/_templates` with the contents:

```
{% extends "layout.html" %}
{% block body %}
    {% if pagename == 'scram2-oct' %}
        {% include 'custom/scram2-oct.html' %}
    {% else %}
        {{ body }}
    {% endif %}
{% endblock %}
```

---

* The `rst2pdf.pdfbuilder` does not appear to be working yet. But
  for future reference, the following additions to `Makefile` and
  `source/conf.py` are being removed.

```
diff --git a/Makefile b/Makefile
index ba501f6..73c7523 100644
--- a/Makefile
+++ b/Makefile
@@ -13,6 +13,11 @@ help:

 .PHONY: help Makefile

+pdf:
+	$(SPHINXBUILD) -b pdf $(ALLSPHINXOPTS) _build/pdf
+	@echo
+	@echo "Build finished. The PDF files are in _build/pdf."
+
 # Catch-all target: route all unknown targets to Sphinx using the new
 # "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
 %: Makefile
```

---

```
diff --git a/source/conf.py b/source/conf.py
index 3bd9212..2c0f83a 100644
--- a/source/conf.py
+++ b/source/conf.py
@@ -44,6 +44,7 @@
     'sphinx.ext.mathjax',
     'sphinx.ext.ifconfig',
     'cloud_sptheme.ext.table_styling',
+    'rst2pdf.pdfbuilder',
 ]

 # Add any paths that contain templates here, relative to this directory.
@@ -203,3 +204,103 @@

 # If true, `todo` and `todoList` produce output, else they produce nothing.
 todo_include_todos = True
+
+# -- Options for PDF output --------------------------------------------------
+
+# Grouping the document tree into PDF files. List of tuples
+# (source start file, target name, title, author, options).
+#
+# If there is more than one author, separate them with \\.
+# For example: r'Guido van Rossum\\Fred L. Drake, Jr., editor'
+#
+# The options element is a dictionary that lets you override
+# this config per-document. For example:
+#
+# ('index', 'MyProject', 'My Project', 'Author Name', {'pdf_compressed': True})
+#
+# would mean that specific document would be compressed
+# regardless of the global 'pdf_compressed' setting.
+
+pdf_documents = [
+    ('index', 'MyProject', 'My Project', 'Author Name'),
+]
+
+# A comma-separated list of custom stylesheets. Example:
+pdf_stylesheets = ['sphinx', 'kerning', 'letter']
+
+# A list of folders to search for stylesheets. Example:
+pdf_style_path = ['.', '_styles']
+
+# Create a compressed PDF
+# Use True/False or 1/0
+# Example: compressed=True
+# pdf_compressed = False
+
+# A colon-separated list of folders to search for fonts. Example:
+# pdf_font_path = ['/usr/share/fonts', '/usr/share/texmf-dist/fonts/']
+
+# Language to be used for hyphenation support
+# pdf_language = "en_US"
+
+# Mode for literal blocks wider than the frame. Can be
+# overflow, shrink or truncate
+# pdf_fit_mode = "shrink"
+
+# Section level that forces a break page.
+# For example: 1 means top-level sections start in a new page
+# 0 means disabled
+# pdf_break_level = 0
+
+# When a section starts in a new page, force it to be 'even', 'odd',
+# or just use 'any'
+# pdf_breakside = 'any'
+
+# Insert footnotes where they are defined instead of
+# at the end.
+# pdf_inline_footnotes = True
+
+# verbosity level. 0 1 or 2
+# pdf_verbosity = 0
+
+# If false, no index is generated.
+# pdf_use_index = True
+
+# If false, no modindex is generated.
+# pdf_use_modindex = True
+
+# If false, no coverpage is generated.
+# pdf_use_coverpage = True
+
+# Name of the cover page template to use
+# pdf_cover_template = 'sphinxcover.tmpl'
+
+# Documents to append as an appendix to all manuals.
+# pdf_appendices = []
+
+# Enable experimental feature to split table cells. Use it
+# if you get "DelayedTable too big" errors
+# pdf_splittables = False
+
+# Set the default DPI for images
+# pdf_default_dpi = 72
+
+# Enable rst2pdf extension modules
+# pdf_extensions = []
+
+# Page template name for "regular" pages
+# pdf_page_template = 'cutePage'
+
+# Show Table Of Contents at the beginning?
+# pdf_use_toc = True
+
+# How many levels deep should the table of contents be?
+pdf_toc_depth = 9999
+
+# Add section number to section references
+pdf_use_numbered_links = False
+
+# Background images fitting mode
+pdf_fit_background_mode = 'scale'
+
+# Repeat table header on tables that cross a page boundary?
+pdf_repeat_table_rows = True
```

---

* The [RS-232 DB-25 SVG
  image](https://upload.wikimedia.org/wikipedia/commons/b/b8/DB25_Diagram.svg)
  was obtained from Wikipedia's
  [RS-232](https://en.wikipedia.org/wiki/RS-232) article.

---

## 2023.02.23

CP/M and disk images...

A handy manual: [Altair 8800 Clone Computer Operator's
Manual](https://altairclone.com/downloads/manuals/Altair%20Clone%20Operator's%20Manual.pdf)
Version 2.4, January 2023.

* Starting CP/M on the Altair:

    + Set address to 0xFF00
	+ Examine
	+ Run

```
63K CP/M
Version 2.2mits (07/28/80)
Copyright 1980 Burcon, Inc.
```

* Send disk images between PC and Altair:

    + Stop + Left Aux on the Altair
	+ Send disk image from PC to Altair
	+ Fill in a "description"
	+ supply filename
	+ Ctrl-A S in minicom to send
	+ Choose XMODEM
	+ Ctrl-A O in minicom to configure
	+ Serial Port Setup
	+ E to change the baud rate
	+ E to select 115200
	+ Enter
	+ Enter
	+ WAIT
	+ Ctrl-A O in minicom to configure
	+ Serial Port Setup
	+ E to change the baud rate
	+ C to select 9600
	+ Enter
	+ Enter
	...
	...

* [CSC 205: Computer
  Organization](https://ict.gctaa.net/sections/csc205/) has a link to
  [Altair 8800 simulator with CP/M](https://schorn.ch/altair.html)

* On Liam's Mac, using the above...

```
Altair 8800 (Z80) simulator V4.0-0 Current        git commit id:     2887

64K CP/M Version 2.2 (SIMH ALTAIR 8800, BIOS V1.27, 2 HD, 02-May-2009)
```

---

## 2023.03.09

Tips for running **CP/M** on the Altiar clone:

* **PCGET** and **PCPUT** are programs that use Xmodem to transfer
  files between the Altair and the attached (Linux) box.

* `ERA filename` "erases" i.e. deletes a file.

* The assembler expects **DOS** line-endings! Don't forget `unix2dos`.

* `ASM filename` (sans extension) will assemble a **.ASM** file and
  produce an Intel **.HEX** file and a **.PRN** list file.

* `LOAD filename` (sans extension) produces an executable **.COM**
  file from the **.HEX** file.

* It appears that **ASM** and **LOAD** actually ignore extensions
  if supplied...

* **IMPORTANT:** CP/M expects "applications" to have their first
  executable instruction at location 100 hex. So don't forget to
  include `ORG 100H` at the top of the **.ASM** files.

* Two users running **minicom** at the same time: Bad. But minicom
  creates a `/var/LCK..ALTAIR` lock file for the first user, in an
  attempt to prevent such badness.

* `LS` appears to be better than `DIR` as it provides individual
  file sizes, plus a summary of disk space used and remaining space.
  (`STAT` shows disk space available too.)

* For transferring disk images:

    1. Start the Altair's Configuration Monitor (**STOP** + left
       **AUX** toggles).
	2. Type `1` for **floppies**
	3. Type `0` for **Disk 0: 63K CP/M 2.2**
	4. Type `3` for **Save floppy to PC**
	5. "Are you sure bla-bla-blah?" `Y`
	6. Change the receiving baud rate to 115200:
	    * `Ctrl-A O` (**cOnfigure**)
		*  **Serial Ports**
		* `E` (**Change baud rate**)
		* `E` (**115200**)
		* `Enter`, `Enter`, **Exit** to return to "normal space"
	7. `Ctrl-A R` for file receive and select **Xmodem**
	8. Provide a simple filename like `cpm.dsk`.

---

* Using Liam's file produced by sending the Altair Clone CP/M disk image...

```
$ altair

Altair 8800 simulator V3.8-1
sim> attach dsk0 cpm.dsk
sim> go 177400


63K CP/M
Version 2.2mits (07/28/80)
Copyright 1980 by Burcon Inc.

A>ls
Bdos Err On A: Bad Sector
Bdos Err On A: Bad Sector
A>dir
Bdos Err On A: Bad Sector
A>^C
A>exit
Bdos Err On A: Bad Sector
Bdos Err On A: Bad Sector
A>
Simulation stopped, PC: 175155 (JZ 175151)
sim> exit
Goodbye
```

---

* Liam Brown provides a link regarding floppies [Re: Loading files to
  floppy](https://altairclone.com/forum/viewtopic.php?f=2&t=37&p=92&hilit=altairz80#p92)
  specifically focusing on the mention of **burcon.zip**.

> **Re: Loading files to floppy**  
> Postby AltairClone » 2013.12.15 13:51:36
>
> There AltairZ80 Simh emulator can run a wide variety of
> configurations, so it gets a bit confusing. To work with images
> compatible with a real Altair floppy and with the Altair Clone,
> here's what I'd recommend:  
>
> 1) Download the emulator executable (altairz80.exe) at
>    http://www.schorn.ch/cpm/zip/altairz80.zip.  
> 2) Download the Burcon CP/M 2.2 software at
>    http://www.schorn.ch/cpm/zip/burcon.zip  
> 3) Optionally, you can also download additional Altair software at
>    http://www.schorn.ch/cpm/zip/altsw.zip  
>
> Unzip each zip file into their own folders. Copy the `altairz80.exe`
> file from the `altairz80` folder into the `burcon` folder you
> created and also into the `altsw` folder you created.
>
> Start inside the burcon folder. Double click `altairz80` to run the
> emulator. At the `sim>` prompt, type "`do cpm`" and press ENTER.
> Burcon CP/M will boot. The CP/M program "`R.COM`" is used to read a
> file from the PC into the CP/M file system. The program "`W.COM`" is
> used to write a file from CP/M to the PC. The files read and written
> must be in the `burcon` folder (i.e., the same folder from which
> `altairz80` was executed).
>
> You can copy any of the disk images from the Altair Clone
> directories into the burcon folder and work with them as well.
> Either name the disk image "`cpm.dsk`" or you can edit the file
> "`cpm`" (you may want to change the name to "`cpm.txt`" so it is
> easier to bring up the text editor) and put in the disk image file
> name where you see "`attach dsk0 cpm.dsk`" line. Note you can also
> add additional disks (up to four total) with additional "`attach`"
> lines using "`dsk1`" "`dsk2`" etc. Note that the simh boot command
> becomes "`do cpm.txt`" if you add the "`.txt`" file extension to the
> command file.
>
> In order to get "`R.COM`" and "`W.COM`" programs onto a new disk,
> first save these programs to the PC from the original **burcon CP/M
> disk** using `W.COM` to write `R.COM` and `W.COM` to the PC. Then
> boot the new disk image onto which you want to load these programs.

> Once CP/M is running and you have the `A>` prompt, type `Ctrl-E` to
> exit to the simh console. At the `sim>` prompt type "`load r.com
> 100`" and press ENTER. This puts the `R.COM` program into 8080
> memory at **0100h**. Then type "`g`" and return to return to
> CP/M. Press ENTER once or twice to be sure you have the `A>`
> prompt. Type "`SAVE 16 R.COM`" to save the read program from memory
> into a file. Now use `R.COM` to load `W.COM` and you're all set.
>
> Note that the CP/M versions in the altsw folder are customized for
> the emulator and may not be ideal versions of CP/M for the Altair
> Clone or for a real Altair floppy.

* Because things scattered to the four winds disappear, I'm
  downloading the zip files. (I may convert them to tarballs...)

---

