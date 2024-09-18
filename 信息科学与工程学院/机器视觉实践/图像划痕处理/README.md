# 1

首日任务，划痕处理。

有几种做法，一个是直接全局高斯模糊加过去，另一个是调库 inpaint，需要有一层 mask 代表需要 inpaint 的地方，而 mask 的生成比较困难，一般需要用大模型。

- [PyInpaint](https://github.com/aGIToz/PyInpaint)：inpaint，需要图 + 蒙版。实际测试挺效果挺差的。
- [ComfyUI](https://github.com/cdb-boop/ComfyUI-Bringing-Old-Photos-Back-to-Life)：直接用大模型来修复。

## 我的代码

```py
python -m src 0
# 0 自动检测
# 1 高斯模糊
# 2 蒙版绘制
```

就能跑了。记得依赖都得装，写在 `shell.nix` 内。

用了三个方法，第一个是自动检测白色划痕并移除，第二个是高斯模糊再解模糊。
