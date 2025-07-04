# my college files

![GitHub repo size](https://img.shields.io/github/repo-size/lxl66566/my-college-files)

[Github 地址](https://github.com/lxl66566/my-college-files) | [Gitee 镜像](https://gitee.com/lxl66566/my-college-files)，如果能帮到你的话，请到 Github 地址点个 Star ⭐，谢谢！

记录我大学本科生涯中的所有文件，~~属于遗产性质~~。本校学生若需要其他专业的更全面的文件，请移步 [ecust-CourseShare](https://github.com/tianyilt/ecust-CourseShare)。

本人已毕业，内容可能过期，欢迎 issue / PR。

Support:

- [ecust-electricity-statistics](https://github.com/lxl66566/ecust-electricity-statistics)：电费统计
- [ECUST-typst-template](https://github.com/lxl66566/ECUST-typst-template)：本科论文 typst 模板
- [ecustbook](https://github.com/lxl66566/ecustbook)：“回忆录”
- [学习笔记](https://absx.pages.dev/learning/)，虽然没什么用

## 仓库构成与使用方法

1. 作业 | 答案、实验报告、论文。我的作业**不保证正确率**，但可以打印后当成自己的交。（我自己就是打印交，很难看出非手写）
2. 考试真题（原题 / 回忆版），都是我带出来/记出来的。
3. 少量小体积课件。
4. 本人的私人文件与含有足够信息量的军机文件。（重要隐私文件已作出 >20 位符号混合加密）

大学中期开始，我的大部分报告使用 [typst](https://github.com/typst/typst) 写成，所有 `.typ` 文件均为 typst 源码文件。typst 是一个对标 latex 的排版工具，它可以将 `.typ` 源码编译导出为 pdf，而仓库中很可能只上传了源码而没有成品 pdf，需要[自己编译](https://absx.pages.dev/learning/typst.html#%E5%AE%89%E8%A3%85%E4%B8%8E%E9%85%8D%E7%BD%AE)（对信工同学来说应该非常简单）（部分早期文件在 typst 0.13 及以上无法编译。你可能需要下载 0.11-0.12）。编译可能需要下载 `.typ` 源码中 include 的其他文件，例如图片，代码，模板等。建议直接 clone 整个仓库/下载整仓库 zip 后再编译，可以省去很多麻烦。

所有 `.enc`, `.zst.enc` 文件均为加密文件，使用 [git-simple-encrypt](https://github.com/lxl66566/git-simple-encrypt)（git 仓库加密软件）进行加密。

## 贡献规则

0. 本人拥有对贡献的最终决定权。
   > 题外话：[ecust-CourseShare](https://github.com/tianyilt/ecust-CourseShare) 初期（包括现在）并没有定下贡献规则，随意接受 pr 导致该仓库大小超 10G，内容混乱。因此在此制定严格的贡献规则。  
   > 我也为 ecust-CourseShare PR 好多次了，大部分信工的资料都是我传的。先不说 commit 记录混乱，没有 squash，单单就各种奇怪路径就已经跟 windows git 爆了。
1. 禁止视频音频等媒体文件。若有需要请以外链形式传入。
2. 对于提交内的所有图片，请移步 [imagestool - compress](https://imagestool.com/compress-images.html) 压缩后再上传。（网站支持 select folder，若图片过多可以上传文件夹压缩，下载 zip 并解压后直接合并替换原先的图片）
3. 考虑隐私，提交的文件需要除名化。
4. 对于能直接在 Github 上打开查看的文件（pdf，文本），请不要上传压缩包。
5. 一般地，ppt 文件应导出为 pdf 后再进行上传。（以 office 为例：_文件 - 导出 - 创建 PDF/XPS - 优化：最小文件大小 (联机发布)_）
   - 更好的方法是不传 ppt，因为大部分 ppt 确实没有太多价值。
6. 电子书，部分手写作业等大文件上传请移步 [Release](https://github.com/lxl66566/my-college-files/releases) & [Issues](https://github.com/lxl66566/my-college-files/issues) 寻找对应板块。若不存在，可提出新 issue or 联系管理员。
   - 实际上我的手写作业也没有太多价值，这只不过是我的个人行为（）
7. 超星学习通文件请使用接口下载体积较小的文字版。具体的：
   - 在显示文件的界面按 `F12`，打开控制台，在元素中按 `Ctrl+F` 搜索 `objectid`，复制此 32 位字符串
   - 将其填入 `http://cs.e.ecust.edu.cn/download/[objectID]` 接口下载。（记得去除 `[]`）
   - 对于不是非常重要的超星文件，你可以直接在 markdown 里放链接，而不是下载到仓库里。
8. 对于清晰的打印文字，可以考虑 [OCR](https://absx.pages.dev/articles/ocr.html) 以后放在 markdown 中。
9. 对于代码文件，尽可能使用 utf-8 编码。

## TODO

- [x] 部分课件/答案为学习通爬取的图片，体积较大，最好能替换成文字版。（当时不懂超星 objectID 接口，因此只能爬图片了，血亏）
  - 20230330：已替换为文字版
- [x] 仓库由单人维护，目录结构差。若有机会包含其他专业的内容，届时将重构目录。
  - 20230330：已重构目录

## 日志

本仓库还有多次的销毁重传经历。实际上 ecust-CourseShare 也有过多次销毁重传的经历，毕竟大量文件确实很难编排整理。不过本仓库比较好的一点就是由我自己进行内容物的价值判断，尽可能保证**内容的高质量**。

- 20240628：将以往的大体积作业放到 release，重传
- 20230330：重构目录重传。
