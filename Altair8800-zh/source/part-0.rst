.. include:: <isonum.txt>
.. include:: /_static/isonum.txt
.. |wink| unicode:: U+1F609 .. WINKING FACE

########################################
第 0 部分：前言：版本说明、致谢等
########################################

这项倾注热爱的工作由 Kevin Cole（"The Ubuntourist"）于 2020 年 9 月发起，旨在为 `计算机系统课程`_ 提供补充。

本文档的读者可以使用 Ian Davies 开发的出色 `MITS Altair 8800 simulator`_ 来测试自己的代码，或者只需 $621（US）即可拥有一台实体 `Altair 8800 Clone`_，配有拨动开关、闪烁的红色 LED 等等。

初学者可能会觉得 YouTube 上 `Patrick Jackson 的视频`_ 相当有参考价值。

除了将 `扫描印刷品`_ 转换为可搜索的 HTML 之外，本版本还包含对原文档中排印错误的更正，以及一些补充材料，尤其涉及 `半加器`_ 电路、`在 Linux 系统下汇编并加载代码的说明`_，以及 `快进到 2020 年`_ —— 后者同时包含用 **GNU Assembler（gas）** 和 **Netwide Assembler（nasm）** 编写的 **"Hello World"**。

若要深入了解 Intel 8080 CPU，请参阅 `Intel 8080 编程手册`_，唉，它多半不会由我转换为 HTML 了。它有*一点* |wink| 太远了。

----

从 PDF 扫描印刷品到 HTML（以及最终更好的 PDF）的转换，是借助以下工具完成的：**pdftoppm**（`poppler-utils`_ 工具之一）、`Tesseract-OCR`_、`Inkscape`_、基于 `Cloud`_ 主题的 `Sphinx`_，当然还有 `One True Editor`_（"顶礼膜拜！"）|wink|。

印刷品本身来自一座金矿：`Classic Computing`_ 网站上的 `Dave Dunfield's`_ 页面 `Daves Old Computers`_。认真的学生和爱好者不妨戴上安全帽，去那里挖上一番。（金丝雀可选。|wink|）

源代码和渲染出的 HTML 托管在 **Codeberg.org**，因为我**真的**很喜欢他们的 `使命宣言`_。

如果你发现了问题，可以提交 `issue`_。

由于 Micro Instrumentation and Telemetry Systems（MITS）公司已经不复存在，我们曾尝试联系版权持有人，但可惜搜寻无果。

无论如何，原作的版权归 `MITS, Inc`_ 所有：Copyright |cpyrgt| 1975。

.. _计算机系统课程: https://ict.gctaa.net/sections/csc215/
.. _poppler-utils: https://en.wikipedia.org/wiki/Poppler_(software)#poppler-utils
.. _Tesseract-OCR: https://en.wikipedia.org/wiki/Tesseract_(software)
.. _Sphinx: https://en.wikipedia.org/wiki/Sphinx_(documentation_generator)
.. _Cloud: https://cloud-sptheme.readthedocs.io/en/latest/cloud_theme.html
.. _Inkscape: https://en.wikipedia.org/wiki/Inkscape
.. _One True Editor: https://en.wikipedia.org/wiki/Editor_war#Humor
.. _半加器: https://en.wikipedia.org/wiki/Adder_(electronics)#Half_adder
.. _MITS, Inc: https://en.wikipedia.org/wiki/Micro_Instrumentation_and_Telemetry_Systems
.. _MITS Altair 8800 simulator: https://www.s2js.com/altair/
.. _Altair 8800 Clone: https://altairclone.com/
.. _扫描印刷品: http://dunfield.classiccmp.org/altair/d/88opman.pdf
.. _Classic Computing: https://classiccmp.org/
.. _Daves Old Computers: http://dunfield.classiccmp.org/
.. _Dave Dunfield's: https://dunfield.themindfactory.com/
.. _Intel 8080 编程手册: https://altairclone.com/downloads/manuals/8080%20Programmers%20Manual.pdf
.. _在 Linux 系统下汇编并加载代码的说明: linux.html
.. _快进到 2020 年: addendum.html
.. _issue: https://codeberg.org/ubuntourist/Altair8800/issues
.. _使命宣言: https://blog.codeberg.org/codebergorg-launched.html
.. _Patrick Jackson 的视频: https://www.youtube.com/playlist?list=PLgpana-oqo-KSE-Hlc3uLJ9xISCByBpO1
