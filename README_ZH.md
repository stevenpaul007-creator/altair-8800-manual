# Altair 8800 操作手册（中英双语项目）

本目录包含 **Altair 8800 操作手册** 的英文原版（`Altair8800/`）及其简体中文翻译（`Altair8800-zh/`）。
源文件使用 reStructuredText（ReST）编写，借助 [Sphinx](https://www.sphinx-doc.org/) 与
`cloud_sptheme` 主题构建为 HTML。

---

## 1. 目录结构

```
altair-8800-manual/
├── Altair8800/        # 英文原版手册
│   ├── source/        # ReST 源文件（index + part-0~4 + appendix + linux + ...）
│   ├── build/html/    # 构建产物（HTML）
│   ├── Makefile       # Sphinx Makefile（make html）
│   └── requirements.txt
├── Altair8800-zh/     # 简体中文翻译
│   ├── source/        # 中文 ReST 源文件
│   ├── build/html/    # 中文构建产物
│   └── tools/         # 校验脚本（如 CJK 表格检查器）
└── .venv/             # Python 虚拟环境（含 sphinx + cloud_sptheme，已打补丁）
```

> 说明：`.venv` 位于仓库之外（PEP 668 禁止在系统 Python 直接安装），供两个子项目共用。

---

## 2. 构建方法

需要 Python 3 与虚拟环境 `.venv`（已安装 `sphinx` 与 `cloud-sptheme`）。
`cloud_sptheme` 已针对 Jinja2 3.1 打补丁：其 `ext/index_styling.py` 改为从 `markupsafe` 导入 `Markup`。

```bash
# 进入任一子项目目录（英文或中文）
cd Altair8800          # 或 cd Altair8800-zh

# 使用共享虚拟环境的 sphinx-build 构建 HTML
PATH=../.venv/bin:$PATH make html

# 等价写法：
# ../.venv/bin/sphinx-build -M html source build
```

构建完成后，打开 `build/html/index.html` 即可阅读。
（中文版构建时存在少量非阻塞的排版告警，主要来自 Part 4 跨表格行的行内字面量，构建退出码为 0。）

---

## 3. 手册内容概览

| 文件 | 内容 |
|------|------|
| `index` | 总目录 |
| `part-0` | 项目说明：从扫描件到可检索文本的来历 |
| `part-1` | 数制、逻辑与程序设计基础 |
| `part-2` | 前面板、内存、CPU 结构 |
| `part-3` | 程序装载与指令入门（含前面板开关/指示灯说明） |
| `part-4` | 指令集参考（78 条指令） |
| `appendix` | 附录 |
| `linux` | 在 Linux 下使用 SIMH 等工具的说明 |
| `addendum` / `resources` / `service` / `price-list` | 补充资料、资源、维修、价格表 |

---

## 4. 源项目

英文原版手册及其源文件由 Kevin Cole（"The Ubuntourist"）维护于 Codeberg：

- 源码仓库：https://codeberg.org/ubuntourist/Altair8800
- 问题反馈：https://codeberg.org/ubuntourist/Altair8800/issues

---

## 5. 许可证

参见 `Altair8800/LICENSE.md`。
