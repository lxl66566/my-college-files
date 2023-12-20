# my college files

记录我（和大家？）大学生涯中的一些文件。

本校学生若需要其他更全面的文件，请移步 [ecust-CourseShare](https://github.com/tianyilt/ecust-CourseShare)。

> 当然，除了此处的课件，我也写了一点没啥用的[学习笔记](https://absx.pages.dev/farraginous/learning/)。

将 url 中的 `github` 改为 `gitee` 即为镜像，方便国内访问。镜像有可能落后几个 commit。

## 仓库构成

1. 作业 | 答案、实验报告、论文。我的作业**不保证正确率**，~~但可以打印后当成自己的交~~。（我自己就是打印交，很难看出非手写）
2. 少量小体积课件。
3. 部分考试原题。
4. 含有足够信息量的军机文件。（重要隐私文件已作出 >20 位符号混合加密）
5. 本人的私人文件。（也进行了加密）

大三开始部分作业/论文由 [typst](https://github.com/typst/typst) 写成（`*.typ`），在仓库中可能只有源码，不会放出成品 pdf，有需要的可以自己编译。（非常简单，注意 include 的文件）

1. 下载最新版本的 [typst 可执行文件](https://github.com/typst/typst/releases)（windows 可以放到 `C:\Windows\System32`）
2. 下载 typ 文件，一般还需要下载 `template.typ`，不同课程使用的 template 可能不同，需要看清楚 include 的是哪个。
   - 有的可能还需要下载目录下的图片，代码文件等。
3. `typst compile xxx.typ`

## 贡献规则

~~会不会有人来贡献呢，会不会呢？不会吧~~

0. 本人拥有对贡献的最终决定权。
   > 题外话：[ecust-CourseShare](https://github.com/tianyilt/ecust-CourseShare) 初期（包括现在）并没有定下贡献规则，随意接受 pr 导致该仓库大小超 10G，内容混乱。因此在此制定严格的贡献规则。
1. 禁止视频音频等媒体文件。若有需要请以外链形式传入。
2. 对于提交内的所有图片，请移步 [imagestool - compress](https://imagestool.com/compress-images.html) 压缩后再上传。（网站支持 select folder，若图片过多可以上传文件夹压缩，下载 zip 并解压后直接合并替换原先的图片）
3. 考虑隐私，提交的文件需要除名化。
4. 对于能直接在 Github 上打开查看的文件（pdf，文本），请不要上传压缩包。
5. 一般地，ppt 文件应导出为 pdf 后再进行上传。（以 office 为例：_文件 - 导出 - 创建 PDF/XPS - 优化：最小文件大小 (联机发布)_）
6. 电子书等大文件上传请移步 [Release](https://github.com/lxl66566/my-college-files/releases) & [Issues](https://github.com/lxl66566/my-college-files/issues) 寻找对应板块。若不存在，可提出新 issue or 联系管理员。
7. 超星学习通文件请使用接口下载体积较小的文字版。具体的：
   - 在显示文件的界面按 `F12`，打开控制台，在元素中按 `Ctrl+F` 搜索 `objectid`，复制此 32 位字符串
   - 将其填入 `http://cs.e.ecust.edu.cn/download/[objectID]` 接口下载。（记得去除 `[]`）
8. 对于清晰的打印文字，可以考虑 [OCR](https://absx.pages.dev/articles/ocr.html) 以后放在 markdown 中。

## TODO

- [x] 部分课件/答案为学习通爬取的图片，体积较大，最好能替换成文字版。（当时不懂超星 objectID 接口，因此只能爬图片了，血亏）
  - 20230330：已替换为文字版
- [x] 仓库由单人维护，目录结构差。若有机会包含其他专业的内容，届时将重构目录。
  - 20230330：已重构目录，销毁仓库后重新上传。
