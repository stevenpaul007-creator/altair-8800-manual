.. include:: <isonum.txt>
.. include:: <isogrk3.txt>
.. include:: /_static/isonum.txt
.. |_|   unicode:: U+000A0 .. NO-BREAK SPACE
.. role:: raw-html(raw)
   :format: html

############################################
附录 B：在 Linux 上配置 Altair 8800
############################################

**作者：Kevin Cole (ubuntourist@hacdc.org) 2020.10.18**

这些操作说明将让用户能够在自己的 Linux 计算机上：

* 使用有意义的助记符（缩写）为机器指令编写 Altair 程序，
  而不必向开关中拨入二进制数字；
* 将这些程序从 **源代码文件**（有意义的助记符）汇编成可执行的
  **目标代码文件**，后者由本应被拨入的二进制数字组成；
* 生成 **列表文件**，这是一份同时显示源代码与相应二进制
  机器代码的报告，并包含错误列表以及与源代码汇编相关的
  其他有用信息；
* 在运行于其计算机上的 Altair 软件 **模拟器** 中测试代码；
* 在其 Linux 计算机与 Altair 之间建立通信；
* 向 Altair 发送可执行的目标代码文件；
* 以及，从其 Linux 计算机向 Altair 发送数据并接收返回的数据。

初学者应从运行 `Raspberry Pi
Desktop`_ 操作系统的计算机开始。

软件包
========

首先，从安装 `Macroassembler AS`_ 开始。转到 `下载
页面``_ 并下载 **C 源代码** 的 ``最新测试版`_。
点击列表中第一行末尾的 **as bz2** 链接。

要构建并安装，你的系统还需要 ``LaTeX``，它是
``texlive`` 软件包的一部分。

.. note::

   1. 以下步骤假定你运行在 Linux 系统上，且该系统具备构建
      该应用程序及其文档所需的全部程序。如果你运行的是
      **Raspberry Pi Desktop** 操作系统，则一切正常，
      可以放心继续。

   2. 下面的 ``make docs`` 步骤会抱怨 10 或 11 次，
      提示缺少 ``german.sty`` 文件。除非你需要德文文档，
      否则可以安全地忽略该错误。每次抱怨时只需按 ``ENTER``。

   3. ``make install``（截至 2021.09.13）引入了一个错误，
      称无法创建目录 ``‘/usr/local/include/asl/.’``，
      因为它已经存在，但该错误可以安全地忽略。
      （我已提交了一份修复，可能在你读到此处时已被接受。）

   4. 如果你 **没有** 运行 Raspberry Pi Desktop 系统，
      请参阅 ``INSTALL`` 文档，了解关于其他系统和定制的
      更多烦琐、陈旧的细节。

   5. 下面最后一步会移除损坏的德文文档。

按如下方式输入::

   $ sudo apt update
   $ sudo apt install texlive texlive-latex-extra
   $ cd ~/Downloads
   $ wget http://john.ccac.rwth-aachen.de:8000/ftp/as/source/c_version/asl-current.tar.bz2
   $ tar xjvf asl-current.tar.bz2
   $ cd asl-current
   $ cp -v Makefile.def-samples/Makefile.def-unknown-linux Makefile.def
   $ make
   $ make test
   $ make docs
   $ sudo make install
   $ sudo rm /usr/local/doc/asl/as_DE.*

接下来，获取：

* 一款老式通信程序（``minicom``）、
* 一个用于 ``minicom`` 的文件传输协议附加组件（``gkermit``）、
* 一款 Altair 软件模拟器（``simh``），以及
* 大家都喜爱的页面浏览器（``most``）。见下文：它会派上用场。

你很可能可以跳过 ``gkermit``，但它“完善”了 ``minicom``，
   后者默认希望手边有一份 Kermit 版本，即使 Altair 并不会用到它。
用以下命令将它们全部安装::

   $ sudo apt update
   $ sudo apt install minicom gkermit simh most


编写、汇编源代码
==============================

然后，使用你最喜欢的编辑器——即使它不是 ``emacs`` ——
创建一个汇编器源文件，例如 ``program.asm``。要
了解该源文件的语法，请研究：

* `Intel 8080 Programming Manual`_（PDF）
* Macroassembler AS 文档，提供以下形式：
    * PDF（`/usr/local/doc/asl/as_EN.pdf`_)
    * HTML （`/usr/local/doc/asl/as_EN.html`_) 和
    * 纯文本（`/usr/local/doc/asl/as_EN.doc`_)
* `Intel 8080 Microcomputer Systems Users Manual`_，连同其他一些好东西，可从 `Bitsavers archive`_ 获取

例如，下面这段源代码是本书 `Part 3, Section B`_ 中通过
前面板拨入的那个加法程序的汇编语言版本。

.. code-block:: text

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;
   ; 名称：    add.asm
   ; 作者：  Kevin Cole ("The Ubuntourist") <kevin.cole@novawebdevelopment.org>
   ; 最后修改： 2020.10.06 (kjc)
   ;
   ; 描述：
   ;
   ;     这是一段汇编源代码，其生成的机器
   ;     操作码与 Altair 8800 操作手册中第一个
   ;     示例（两个数字相加）所展示的相同。
   ;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; 代码段：

           ORG    0o       ; 将程序计数器设置为地址 0
   START:  LDA    VAL1     ; 将 VAL1 (200) 处的值 (5) 载入累加器
           MOV    B,A      ; 将累加器中的值传送到寄存器 B
           LDA    VAL2     ; 将 VAL2 (201) 处的值 (8) 载入累加器
           ADD    B        ; 将寄存器 B 中的值加到累加器中
           STA    SUM      ; 将累加器存入 SUM (202)
           JMP    START    ; 跳转到代码开头（无限循环）

   ; 数据段：

           ORG    200o     ; 将程序计数器设置为地址 200
   VAL1:   DB     5o       ; 地址 200 处的数据字节 = 5
   VAL2:   DB     10o      ; 地址 201 处的数据字节 = 8（八进制 10）
   SUM:    DB     0o       ; 地址 202 处的数据字节 = 0

           END             ; 结束

使用以下命令进行汇编::

   $ asl -a -cpu 8080 -L -listradix 8 program.asm

这会生成一个列表报告（``program.lst``）和一个目标文件
（``program.p``）。将生成的列表文件与手册中提供的八进制机器
操作码进行比对。

不过，如果你已经安装了 ``most``——你肯定想要的——用
以下命令来汇编源文件会
**非常**有启发::

   $ asl -a -cpu 8080 -L -listradix 16 program.asm

这会生成与第一条命令相同的二进制文件（``program.p``），但
改变了列表文件的格式，以十六进制而非八进制来显示
机器操作码，并且配合以下命令::

   $ most program.p

你可以研究生成的实际二进制"可执行文件"，并通过在可执行文件中
查找嵌入的机器操作码（十六进制）来"调试"它
（与 ``program.lst`` 进行比对）。

无论用哪种方式汇编，你都会希望通过执行以下命令来生成
``program.bin`` 和 ``program.hex`` 文件::

   $ p2hex program.p
   $ p2bin program.p

（用 ``most`` 查看 ``.bin`` 和 ``.hex`` 文件，并
将其与你在 ``.p`` 和十六进制列表文件中
看到的内容进行比对。）

在软件模拟器中运行你的程序
==========================================

``simh`` Debian 软件包可模拟至少 30 种不同的
体系结构——其中包括除 Altair 之外我还曾有幸
把玩过的另外七种。

每个模拟器都由单独的程序启动。Altair
模拟器被很合理地命名为 ``altair``。要使用它：

1. 启动模拟器（``altair``）。
2. 如同实际机器的前面板那样，复位（``reset all``）。
3. 将你的二进制文件载入模拟器的“存储器”（``load
   program.bin``）。
4. 启动程序运行（``run``）。
5. 如果程序没有自行结束并停止，你需要
   通过按下 ``Ctrl-E``（将显示为
   ``^E``）来停止模拟。
6. 用 ``e`` 后跟地址来检查存储单元，或
   查阅并尝试 ``help`` 命令所展示的其他模拟器命令。
7. 完成后，输入 ``exit``。

以上面的加法程序为例，输入以下内容::

   $ altair

   Altair 8800 simulator V3.8-1
   sim> reset all
   sim> load program.bin
   131 Bytes loaded.
   sim> run
   ^E

   Simulation stopped, PC: 000004 (LDA 201)
   sim> e 202
   202:    015
   sim> e PC,A,BC,DE,HL,C,Z,AC,P,S,SR,WRU
   PC:     000004
   ...
   sim> exit
   Goodbye
   $

上面第二条 ``examine``（``e``）命令列出了寄存器以及
其他有用的位置。

.. container:: center

   .. table:: simh 寄存器与状态标志
      :widths: 1 3
      :header-alignment: center center
      :column-alignment: left left
      :column-dividers: single single single

      +----------+----------------------+
      |  助记符  |         含义         |
      +==========+======================+
      | PC       | 程序计数器           |
      +----------+----------------------+
      | A        | 累加器               |
      +----------+----------------------+
      | BC       | 寄存器对 BC          |
      +----------+----------------------+
      | DE       | 寄存器对 DE          |
      +----------+----------------------+
      | HL       | 寄存器对 HL          |
      +----------+----------------------+
      | C        | 进位标志             |
      +----------+----------------------+
      | Z        | 零标志               |
      +----------+----------------------+
      | AC       | 辅助进位标志         |
      +----------+----------------------+
      | P        | 奇偶标志             |
      +----------+----------------------+
      | S        | 符号标志             |
      +----------+----------------------+
      | SR       | 前面板开关           |
      +----------+----------------------+
      | BREAK    | 断点地址             |
      +----------+----------------------+
      | WRU      | 中断字符             |
      +----------+----------------------+

模拟器还有许多其他命令，但上面的内容足以完成
基本工作。``Ctrl-E`` 会停止当前正在模拟器中运行的程序，并
报告当前的程序计数器（PC）以及停止时所执行的指令。

如果你运行的是上面所示的程序，**list file** 会告诉我们，
标有 **SUM** 的数据字节（DB）位于存储地址 202
（八进制）。用模拟器的 ``e`` 命令检查该地址，
会发现其中包含数据值 015（八进制）。

.. note::

   你应该记住，上面的程序（来自 `Part 3, Section B`_ 的
   **add two numbers** 程序）是一个 **无限循环**，并且正在
   非常快速地将代码一遍又一遍地重复执行。

   |_|

   当你通过按下 ``Ctrl-E`` 来停止模拟时，无法
   得知当时正在执行哪条指令。这意味着程序计数器 **PC**
   及其所指向的指令在每次运行模拟时都会变化——除非
   你自己是一台超级计算机，并且拥有极快的反应速度。

   |_|

   在我上面的示例中，你可以看到程序计数器位于
   **000004**，并且在模拟停止时正在执行指令 ``LDA 201``，
   但对你来说结果很可能不同。

   |_|

   上面那条 ``131 Bytes loaded.`` 是以十进制表示的。按八进制
   计算，那就是 203 字节。你会注意到程序起始于存储地址 000
   （八进制），而加法运算的结果（即程序所使用的最后一个
   存储字节）位于存储地址 202（八进制）。换句话说，程序
   包含在存储器的前 203（八进制）个字节中——不过，在
   存储器中字节 015（八进制）（即实际指令代码的最后一个字节）
   与字节 200（八进制）（即待相加的第一个值的存放处）之间的
   那些字节并未使用，因此这些字节是未初始化的，
   并将包含不可预测的随机值。

``help`` 命令所提供的更有用的模拟器命令汇总：

.. container:: center

   .. table:: 常用的 simh 命令
      :widths: 2 3
      :header-alignment: center center
      :column-alignment: left left
      :column-dividers: single single single

      +------------------------+--------------------------------------------+
      | r{eset} {ALL|<device>} | 复位模拟器                                 |
      +------------------------+--------------------------------------------+
      | e{xamine} <list>       | 检查存储器或寄存器                         |
      +------------------------+--------------------------------------------+
      | ie{xamine} <list>      | 交互式检查存储器或寄存器                   |
      +------------------------+--------------------------------------------+
      | d{eposit} <list> <val> | 在存储器或寄存器中存入                     |
      +------------------------+--------------------------------------------+
      | id{eposit} <list>      | 交互式在存储器或寄存器中存入               |
      +------------------------+--------------------------------------------+
      | ev{aluate} <expr>      | 计算符号表达式                             |
      +------------------------+--------------------------------------------+
      | ru{n} {new PC}         | 复位并启动模拟                             |
      +------------------------+--------------------------------------------+
      | go {new PC}            | 启动模拟                                   |
      +------------------------+--------------------------------------------+
      | s{tep} {n}             | 模拟 n 条指令                              |
      +------------------------+--------------------------------------------+

.. note::

   ``simh`` Debian 软件包已经严重过时，如果你的
   程序变得足够复杂——例如，试图将整个 CP/M 操作系统
   载入模拟器——它会出错。更新的版本可以从 `Altair clone site`_ 和 `GitHub repository`_ 获取。

----
连接 Altair 克隆机
===========================

拆箱、插上电源并通电后，状态如下：

* inte
* prot
* **MEMR**
* inp
* **M1**
* out
* hlta
* stack
* **WO**
* int
* **WAIT**
* hlda

其中，大写、粗体表示处于“点亮”状态的发光二极管，小写表示处于“熄灭”状态的发光二极管。

将串口线缆一端插入 Altair 背面的 **TOP** 端口，另一端插入 Linux 机器的任意 USB 端口。然后执行 ``lsusb`` 命令。列表中应出现一个新的 USB 设备：：

   Bus 003 Device 002: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port

此外，插上线缆后，你应在 ``/dev`` 目录下看到两个新条目：一个 ``/dev/ttyUSB0`` 设备和一个 ``/dev/serial/`` 目录。我们要找的就是那个 ``/dev/ttyUSB0``。

配置 MINICOM
===================

首先，确认**你的**系统将这根线缆识别为 ``/dev/ttyUSB0``。（这在不同电脑上可能不同，尤其是取决于你当时插了哪些设备。）我所知道的唯一的做法是：在插上线缆之前和之后各执行一次如下命令：：

   $ ls /dev/tty*

并对比两次结果的差异。应当会多出一个 ``/dev/ttyUSB0`` 或 ``/dev/ttyUSB1``——也可能是另一个编号，这取决于所插入的其他被识别为终端的 USB 设备的数量。[我也见过有些系统使用 ``/dev/ttyACM0``（或 ``1``、``2`` 等）来识别能够像终端一样通信的 USB 设备。]

.. note::

   如果你打算频繁地将 Altair 8800 克隆机连接到同一台电脑，或许值得配置一条 ``udev`` 规则。在 ``/etc/udev/rules.d/`` 中创建一个名为 `99-local.rules`_ 的文件，内容如下：：

      $ sudo cat > /etc/udev/rules.d/99-local.rules <<EOF
      # Written by Kevin Cole <ubuntourist@hacdc.org> 2020.10.19 (kjc)
      # Custom udev rules
      #

      # Create a symlink ALTAIR for Prolific Technology USB-Serial Controller
      # (idVendor=067b, idProduct=2303, driver=pl2303)
      #
      # Determined via:
      #
      #     $ udevadm info -a -n /dev/ttyUSB0 | grep -i "driver"
      #
      SUBSYSTEMS=="usb",      \
          DRIVERS=="pl2303",  \
          SYMLINK+="ALTAIR"
      EOF
      $ sudo udevadm control --reload-rules && sudo udevadm trigger

   该 ``serial`` 属性可通过如下方式确定：：

      $ udevadm info -a -n /dev/ttyUSB0 | grep "[\{]serial[\}]"

   并可用 ``ATTRS{serial}=="..."`` 替换 ``DRIVERS--\"pl2303\"``，但由于每次将设备插入新的 USB 插槽时 serial 属性都会变化，使用驱动器标识（我希望）更具实用性。

``minicom`` 在以一种合理的方式写入其配置文件这件事上，有着一种反常的幽默感。因此，为了让它把配置文件放到你想要的位置，人们不得不做一些愚蠢的折腾。你可以跟它较劲，或者直接编辑我的配置来满足你的需要。（参见下文的 **~/.minirc.altair** 一节。要与它较劲，按如下操作：：）

   $ sudo usermod -aG dialout kjcole
   $ cp /usr/share/doc/minicom/examples/minirc.dfl ~/.minirc.altair
   $ sudo minicom --setup altair
   Filenames and paths
      A - Download directory: ~/Downloads
      B - Upload directory: ~/Code/Altair
      C - Script directory:
      D - Script program: runscript
      E - Kermit program: gkermit
      F - Logging options:
          A - File name (empty=disable) : minicom.log
          B - Log connects and hangups  : Yes
          C - Log file transfers        : Yes
   File transfer protocols:
      G kermit   /usr/bin/gkermit -i -s
      H kermit   /usr/bin/gkermit -i -r
   Serial port setup
      A - Serial Device         : /dev/ttyUSB0
      B - Lockfile Location     : /var/lock
      C - Callin Program        :
      D - Callout Program       :
      E - BPS/Parity/Bits       : 115200 8N1
      F - Hardware Flow Control : Yes
      G - Software Flow Control : No
   Save setup as altair
   Exit from Minicom
   $ cp /etc/minicom/minirc.altair ~/.minirc.altair
   $ sudo rm /etc/minicom/minirc.altair

.. note::

   如果你已成功创建了 ``udev`` 规则，那么应当将上述串行设备改用 ``/dev/ALTAIR``，因为这样在多次重启之间会更加可靠。

此时，应当可以直接编辑 ``~/.minirc.altair``，尽管关于该文件格式并没有任何文档说明。

----

~/.MINIRC.ALTAIR
=================

编辑你的 ``updir`` 和 ``downdir`` 以适合自己的情况。（你可能不想试图把它放进 **我** 的主目录里。）

.. code-block:: text

   # Minicom Altair 8800 Clone configuration
   # Last edited by Kevin Cole <ubuntourist@hacdc.org> 2020.10.18

   pu pprog7           /usr/bin/gkermit -i -s
   pu pprog8           /usr/bin/gkermit -i -r
   pu port             /dev/ALTAIR
   pu baudrate         9600
   pu kermit           gkermit
   pu updir            /home/kjcole/Code/Altair/
   pu downdir          /home/kjcole/Downloads/

运行实测：在 Altair 克隆机上运行你的程序
======================================================

一旦将上述内容放入你的主目录，现在就可以准备把代码装入 Altair 了：：

   $ minicom altair
   Welcome to minicom 2.7.1

   OPTIONS: I18n
   Compiled on Dec 23 2019, 02:06:26.
   Port /dev/ALTAIR, 08:32:24

   Press CTRL-A Z for help on special keys

现在，在 Altair 前面板上，抬起并保持 ``STOP`` 开关，在保持的同时，抬起并松开左侧的 ``AUX`` 开关，最后松开 ``STOP``。你应当会在 ``minicom`` 窗口中看到：：

   === Configuration Monitor 1.94 ===

   1) Floppies
   2) PROMs
   3) Serial Ports
   4) Load .BIN
   5) Load .HEX
   6) Admin
   x) Exit to Altair

   Choice:

我发现载入 ``.hex`` 文件要稍微容易一些。载入 ``.bin`` 文件需要额外的步骤，告诉 Altair 从哪个地址开始载入文件。（``.hex`` 文件已将这一信息内嵌其中。）

.. code-block:: text

   Choice: 5

   Send .hex file now...
   Ctrl-A S

``Ctrl-A`` 后接 ``S`` 会弹出 ``Send file`` 对话框。

* 选择 ``ascii`` 作为文件传输协议

* ``G``（``[Goto]``）后接从你的主目录到 ``.hex`` 文件的完整目录路径，以导航到该文件。例如，如果 ``program.hex`` 位于 ``/home/kjcole/Code/Altair/Assembler``，则使用 ``Code/Altair/Assembler``（如果你已将 **upload** 目录配置为指向你存放所有 Altair 文件的目录，这一步就不需要了。）

* 键入 ``S``（对应 ``[Show]``）以缩小文件名匹配范围，或滚动到相应文件并按 ``SPACE``，该文件应被高亮；然后按 ``O`` 或 ``ENTER``（对应 ``[Okay]``，该选项应当已被高亮）。

你应当会看到类似以下内容：：

        +------------[ascii upload - Press CTRL-C to quit]------------+
        |ASCII upload of "program.hex"                                |
        |                                                             |
        |0.2 Kbytes transferred at 194 CPS... Done.                   |
        |                                                             |
        | READY: press any key to continue...                         |
        |                                                             |
        |                                                             |
        +-------------------------------------------------------------+

* 按 ``ENTER``（或者如提示所说，任意键），然后按 ``x`` 以 **Exit to Altair**（退出到 Altair），如下所示：：

   ...
   0219h bytes loaded at 0000h


   === Configuration Monitor 1.94 ===

   1) Floppies
   2) PROMs
   3) Serial Ports
   4) Load .BIN
   5) Load .HEX
   6) Admin
   x) Exit to Altair

   Choice: x

   Control Returned to Altair

最后，假设你在 000 处载入了程序，按下 Altair 克隆机上的 ``RUN`` 开关，你就应该“起跑”了。

要退出 ``minicom`` 并返回 ``Bash`` shell，键入 ``Ctrl-A`` 后接 ``Q``。

----

MAKEFILE
========
MAKEFILE
========

一个 `Makefile`_ 可自动生成两份列表报告、目标文件、BIN 文件和 HEX 文件，甚至还能一次性汇编多个源文件。下面的 `Makefile`_ 接受以下命令：

.. container:: center

   +------------------+--------------------------------------------------+
   | ``make``         | 汇编当前目录下全部 ``asm`` 文件                  |
   +------------------+--------------------------------------------------+
   | ``make program`` | 汇编 ``program.asm``                             |
   +------------------+--------------------------------------------------+
   | ``make clean``   | 删除所有 ``asm`` 生成的全部文件                  |
   +------------------+--------------------------------------------------+

**IMPORTANT**：``make`` 喜欢 **TAB** 而不是 **SPACE**。把下面代码中连续八个空格全部改成制表符！

.. code-block:: text

   #!/usr/bin/make -f
   # Written by Kevin Cole <ubuntourist@hacdc.org> 2020.10.17 (kjc)
   #
   # This takes Altair-8800 assembler source files and produces:
   #
   #    - an object file                                 (.p)
   #    - an Intel HEX file                              (.hex)
   #    - a  binary executable                           (.bin)
   #    - a  list report file with octal       op codes  (.oct.lst)
   #    - a  list report file with hexadecimal op codes  (.oct.lst)
   #    - an include(?) file -- thus far, empty          (.inc)
   #
   # To use:
   #
   #        make         # to generate for all .asm files
   # or     make root    # (where "root" is the root of a specific "root.asm")
   # or     make clean   # to remove all generated files
   #
   ############################################################################

   SHELL = /bin/bash
   OBJECTS := $(patsubst %.asm,%,$(wildcard *.asm))

   .PHONY : all
   all : $(OBJECTS)

   .PHONY : clean
   clean :
           -rm -f *.hex         \
                  *.bin         \
                  *.lst         \
                  *.inc         \
                  *.p

   % : %.asm
           asl -a -cpu 8080 -L -listradix  8 $<
           mv $@.lst $@.oct.lst
           asl -a -cpu 8080 -L -listradix 16 $<
           mv $@.lst $@.hex.lst
           p2hex $@.p
           p2bin $@.p

----

获取输入 / 显示输出
========================================

如果你为了读懂闪烁的指示灯并理解它们而伤透脑筋，而更想直接看到文本（或者，如果你希望能输入字符串，而不是每次拨动开关输入八位字符串），你就需要深入了解 **88-2SIO 串行输入/输出** 硬件的机制，这在你迄今为止接触过的任何手册中都没有介绍。

* **必须略读**：`Altair 2SIO Serial I/O manual`_（PDF）

* **可选阅读**：`RS-232 Data Control Signals`_ 和 `UART`_

为了理解 Altair 与外部设备（如通过串行 / USB 线缆连接的终端）之间的通信，应当仔细阅读上述文档。它们提供的细节包括：

.. container:: center

   +------+----------------------------------------------+
   | UART | 通用异步接收/发送器                          |
   +------+----------------------------------------------+
   | XMIT | 发送 (OUT)                                   |
   +------+----------------------------------------------+
   | RECV | 接收  (IN)                                   |
   +------+----------------------------------------------+
   | RTS  | 请求发送                                     |
   +------+----------------------------------------------+

以及同步（轮询）通信的设置：

.. container:: tight

    .. code-block:: text

       15H = 0 0 0 1 0 1 0 1
           ▲ ▲ ▲ ▲ ▲ ▲ ▲ ▲
           │ │ │ │ │ │ │ │
           │ │ │ │ │ │ └─┴─► 1 = Clock Divide = 16
           │ │ │ └─┴─┴─────► 5 = 8 Data bits, No parity, 1 Stop bit (8N1)
           │ └─┴───────────► 0 = RTS = Low, XMIT interrupt = disabled
           └───────────────► 0 = RECV interrupt = disabled

----

提示
====

首先阅读 **Macroassembler AS** 手册中的 **第 6 章：实用程序**（第 251 页）。

基于 ``add.asm`` 生成的目标文件……

**plist**

``plist`` 汇总 ``.p`` 文件的数据::

   $ plist add.p
   PLIST/C V1.42 Beta [Bld 174]
   (C) 1992,2020 Alfred Arnold

   Code-Type   Segment    Start-Address  Length (Bytes) End-Address
   ----------------------------------------------------------------
   8080/8085     CODE      00000000          000E       0000000D
   8080/8085     CODE      00000080          0003       00000082
   creator : AS 1.42 Beta [Bld 174]/x86_64-unknown-linux

   altogether 17 bytes CODE

``plist`` 能够分析目标文件并确定：

* 目标代码包含 Intel 8080 或 Intel 8085 的机器操作码。
* 一个 14 字节的代码块，应被载入存储单元 000 至 00D（十六进制），即 000 至 015（八进制）。
* 一个 3 字节的代码块应被载入 080 至 082（十六进制），即 200 至 202（八进制）。

**p2bin**

``p2bin`` 将 ``.p`` 文件转换为二进制存储器转储，不带格式。默认情况下，未初始化的字节变为 ``FF``。尽管加载可能会花费很长时间，但从表面上看，这似乎是最直接地呈现 Altair 存储器在程序载入后样貌的方式。

**p2hex**

``p2hex`` 将 ``.p`` 目标文件转换为该文件的 ASCII 表示（``.hex``）。输出文件有若干种不同的格式可供选择，部分取决于目标机器。在我们的示例中::

   $ p2hex add.p
   $ most add.hex
   :0E0000003A8000473A810080328200C300003F
   :0300800005080070
   :00000001FF

观察上述内容，并将其与汇编器生成的十六进制列表文件进行比较，我们可以确定前两行代表两个数据段：

.. container:: center

   +-------------+---------------------------------------------------------+
   |   Columns   |                Interpretation                           |
   +-------+-----+---------------------------------------------------------+
   | Start | End |                                                         |
   +=======+=====+=========================================================+
   |   1   |  1  | 冒号。记录起始分隔符                                    |
   +-------+-----+---------------------------------------------------------+
   |   2   |  3  | 记录中的数据长度                                        |
   +-------+-----+---------------------------------------------------------+
   |   4   |  7  | 存储器中数据的起始地址                                  |
   +-------+-----+---------------------------------------------------------+
   |   8   |  9  | ? 可能是记录类型？（00 或 01）                          |
   +-------+-----+---------------------------------------------------------+
   |  10   | N-2 | 数据                                                    |
   +-------+-----+---------------------------------------------------------+
   |  N-1  |  N  | ? 可能是记录校验和？                                    |
   +-------+-----+---------------------------------------------------------+

前两行在 8-9 列包含 00，而最后一行与列表文件所示的机器码似乎没有任何关系，它包含 01。也许是一个“数据结束”记录？

看哪，维基百科（理所当然地）有一条关于 `Intel HEX`_ 的词条，它确凿地证实：

* 8-9 是记录类型指示符，其中 ``00`` 表示**数据**，**01** 表示**文件结束**
* 最后两个字符是校验和

该词条还提供了一个 `checksum calculation algorithm`_（校验和计算算法）的示例。

Kermit 说明
============

在 ``minicom`` 中，发送和接收常用的默认 ``kermit`` 选项是 ``-i -l %l -b %b``，根据 `C-KERMIT 9.0 Unix man page and tutorial`_ 的说明，其含义是：

.. container:: center

   +-----------+----------------------------------------------------------+
   | ``-i``    | 强制二进制（镜像）模式进行文件传输；                     |
   +-----------+----------------------------------------------------------+
   |           | 隐含 ``-V``                                              |
   +-----------+----------------------------------------------------------+
   |           | 等同于 ``SET TRANSFER MODE MANUAL``，                    |
   +-----------+----------------------------------------------------------+
   |           | ``SET FILE TYPE BINARY``                                 |
   +-----------+----------------------------------------------------------+
   | ``-l %l`` | 在指定的串行通信上建立连接                               |
   +-----------+----------------------------------------------------------+
   |           | 设备。                                                   |
   +-----------+----------------------------------------------------------+
   |           | 等同于 ``SET LINE``（``SET PORT``）命令                  |
   +-----------+----------------------------------------------------------+
   |           | 参数：串行设备名称，例如 ``/dev/ttyS0``                  |
   +-----------+----------------------------------------------------------+
   | ``-b %b`` | 串行设备的速度                                           |
   +-----------+----------------------------------------------------------+
   |           | 等同于 ``SET SPEED``                                     |
   +-----------+----------------------------------------------------------+
   |           | 参数：每秒比特数的数值，用于串行连接                     |
   +-----------+----------------------------------------------------------+

``gkermit`` 似乎并不像我们曾经熟知的那样是一个完整的 Kermit，而仅仅是传输协议部分，并且依赖已建立的通信通道来确定上述的 ``-l`` 和 ``-b``。因此，我已从自己的 ~/.minirc.altair 配置中移除了这两个选项。

.. note::

   哥伦比亚大学已不再是 Kermit 的归属地。它现在是 `The Kermit Project`_。

.. _Macroassembler AS: http://john.ccac.rwth-aachen.de:8000/as/
.. _latest beta version: http://john.ccac.rwth-aachen.de:8000/ftp/as/source/c_version/asl-current.tar.bz2
.. _Intel 8080 Programming Manual: https://archive.org/download/bitsavers_intelISISIssemblyLanguageProgrammingManualMay81_7150831/9800301-04_8080_8085_Assembly_Language_Programming_Manual_May81.pdf
.. _Intel 8080 Microcomputer Systems Users Manual : https://archive.org/details/bitsavers_intelMCS80ocomputerSystemsUsersManual197509_43049640
.. _Bitsavers archive: https://archive.org/details/bitsavers_intel
.. _Altair clone site: https://altairclone.com/downloads/simh/
.. _GitHub repository: https://github.com/simh/simh
.. _C-KERMIT 9.0 Unix man page and tutorial: https://www.kermitproject.org/ckututor.html
.. _The Kermit Project: https://www.kermitproject.org/
.. _Altair 2SIO Serial I/O manual: https://altairclone.com/downloads/manuals/Altair%202SIO%20Serial%20I-O.pdf
.. _RS-232 Data Control Signals: https://en.wikipedia.org/wiki/RS-232#Data_and_control_signals
.. _UART: https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter
.. _Intel HEX: https://en.wikipedia.org/wiki/Intel_HEX
.. _checksum calculation algorithm: https://en.wikipedia.org/wiki/Intel_HEX#Checksum_calculation
.. _99-local.rules: _static/99-local.rules
.. _Makefile: _static/Makefile
.. _Raspberry Pi Desktop: https://www.raspberrypi.org/downloads/raspberry-pi-desktop/
.. _download page: http://john.ccac.rwth-aachen.de:8000/as/download.html
.. _Part 3, Section B: part-3.html#b-loading-a-sample-program
.. _/usr/local/doc/asl/as_EN.pdf: _static/as_EN.pdf
.. _/usr/local/doc/asl/as_EN.html: _static/as_EN.html
.. _/usr/local/doc/asl/as_EN.doc: _static/as_EN.doc
