#import "../template.typ": *

#show: project.with(
  title: "软件设计",
  authors: ("absolutex",),
)


= 软件设计与开发

== 主要职责

+ 根据手柄硬件设计文档，设计手柄的软件驱动并完成开发；
+ 对接 Windows/Linux 系统，确保手柄能与 Windows/Linux 通过适当的协议进行通信；
+ #strike[编写测试计划并完成测试。]

== 系统 API 调研

=== 协议对比

// https://learn.microsoft.com/en-us/windows-hardware/drivers/hid/
- Human Interface Devices (HID) 是第一个通用的支持游戏手柄+键盘、鼠标等输入设备的协议标准。在此之前，需要通过游戏端口（D-sub）和专有协议支持游戏输入设备。1996 年 USB-IF 通过了 HID over USB 规范。HID 设备使用报告描述符来定义数据格式，如按键事件、鼠标运动等，所有现代系统都内置支持 HID 协议。

// https://en.wikipedia.org/wiki/DirectInput
- DirectInput 是一个旧版 Microsoft API，是 DirectX 库的一部分，基本兼容 DirectX 8（2001-2002）之后的所有 DirectX 游戏版本。 DirectInput 支持多种类的输入设备和自定义功能，尤其是飞行杆、力反馈设备和自定义按键。

// https://en.wikipedia.org/wiki/DirectInput#XInput
// https://learn.microsoft.com/en-us/windows/win32/xinput/xinput-and-directinput
- XInput 于 2005 年 12 月与 Xbox 360 一起推出。此规范为 Windows XP SP1 和后续操作系统中的 Xbox 360 控制器提供支持，并且被 Microsoft 描述为比 DirectInput 更容易编程且需要的设置更少。XInput 与 DirectX 版本 9 及更高版本兼容。与 DirectInput 相比，XInput 更易于使用，需要的设置更少。XInput 设备可以兼容使用 DirectInput 的游戏，不过部分功能会出现问题。（左/右 trigger 会被视为同一个；振动效果不可用）


// https://stackoverflow.com/questions/73019812/
// https://learn.microsoft.com/en-us/gaming/gdk/_content/gc/input/overviews/input-overview
- Microsoft GameInput API 是 Microsoft Game Development Kit（GDK） 的一部分，于 2021 年 6 月 24 日首次发布，具有最佳性能与100% 的线程安全。GameInput 是所有旧版输入 API（XInput、DirectInput、Raw Input、Human Interface Device （HID） 和 WinRT API）的功能超集，此外还添加了自己的新功能。2024 年 3 月，虚幻引擎 （UE5）发布了实验性插件 “Game Input for Windows” 以支持此 API。
  - 手柄设计无需专门支持此 API。

=== Windows

XInput 是 Windows 上对 Xbox 手柄支持最广的协议，现代 PC 游戏大多数都优先支持 XInput。

=== Linux

Linux 内核使用通用的 HID 协议来识别和处理各种输入设备；用户也可以借助一些第三方工具（如 Wine 和 Proton）在 Linux 上运行 Windows 游戏，这些工具会模拟 Windows 环境，并将 XInput 调用映射到 Linux 下支持的接口（HID, evdev, SDL, ff-memless, uinput），从而使得游戏能够识别 XInput 手柄。

=== 总结

现代手柄（如 Xbox 系列手柄、PlayStation 手柄）大多同时支持 HID 和 XInput；前者主要是出于兼容性与跨平台考虑。因此我们制作的手柄也会支持 HID 和 XInput 协议。

// 对于标准协议无法实现的功能，还需要结合文档进一步研究。

== 嵌入式软件开发

=== 开发环境与基础设施

针对 ESP32-S3 芯片组，有几种不同的开发方式：
+ 使用 Espressif 官方的 #link("https://github.com/espressif/esp-idf", "esp-idf") 开发工具进行开发：`idf.py create-project xxx && idf.py build && idf.py flash`
  - python 作为项目管理，实际开发语言为 C/C++
+ 使用 Arduino Core for ESP32，直接使用 Arduino IDE 进行开发。
+ 使用 #link("https://github.com/esp-rs/esp-idf-sys", "esp-idf-sys") 进行 Rust 和 C 语言的混合开发；cargo 作为项目管理。

=== 步骤

+ 实现各按钮/摇杆的信号输出
+ 实现硬件时钟与中断
+ 实现蓝牙协议与 USB 通信

== HID 实现

- 任务：实现手柄与主机的 HID 通信。
- 调研：ESP-IDF 官方提供了 HID 相关的 API，支持 USB HID 设备的开发。
- 任务细分：
  + 配置 USB 外设：在开发板上配置 USB 接口为 USB Device 模式，使设备可以作为 HID 设备与主机通信。
  + 定义 HID 描述符（HID Device Descriptor）：该描述符告诉操作系统设备的功能（如按键、摇杆、触觉反馈等）。
    - 这一步需要拿到硬件接口图。
  // ```
  // const uint8_t hid_report_descriptor[] = {
  //   0x05, 0x01,  // Usage Page (Generic Desktop)
  //   ...
  //   0xC0         // End Collection
  // };
  // ```
  + 实现数据报告：HID 设备通过中断端点与主机通信，每次状态改变时发送数据包（报告）。


== XInput 实现

+ 实现数据报告格式：XInput 定义了特定的数据报告格式，支持的功能包括：按钮输入（如 A、B、X、Y 按钮等）、摇杆输入（模拟摇杆）、触发器输入（LT/RT 触发器）、震动反馈。
+ 定义 XInput HID 描述符：XInput 与标准 HID 描述符略有不同。
+ 实现数据报告：与 HID 相同，通过中断传输。
+ 实现震动反馈：为设备配置一个输出端点来接收主机的震动指令，并控制开发板上的振动马达。


== 手柄调试与测试

=== 驱动测试

==== #link("https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/driver-verifier", [Driver Verifier])

Driver Verifier 可以使 Windows 驱动程序承受各种压力和测试，以检测可能损坏系统的非法函数调用或操作，查找不当行为。

==== #link("https://github.com/Maschell/hid_test", [HID-TEST])

可视化 HID 协议的接收信息。

==== #link("https://garythegoof.github.io/X-Input-Test/", [X-Input-Test])

多方位测试 XInput 设备。

=== 兼容性测试

使用 Windows, Linux, Macos, Android 及其他系统进行测试。

#pagebreak(weak: true)

= 演讲部分

- HID 协议：需要讲 Linux 的仅支持
- XBOX 兼容性问题：
  - 部分功能会出现问题：左/右 trigger 会被视为同一个；振动效果不可用
  - 一些较早发布的PC游戏只适配 DirectInput，而不适配 XInput。例如 Microsoft Flight Simulator 微软模拟飞行，Richard Burns Rally 赛车拉力
  - 现代手柄在兼容性上作出的努力：
    - 许多第三方游戏手柄提供两种模式，可以通过硬件开关或特定的按键组合在两者之间切换。例如：罗技、雷蛇等品牌的手柄。
    - Xbox 360 和 Xbox One 只支持 XInput 模式。
- 本公司：优先支持 HID 和 XInput，钱到位了再支持 DirectInput。

// - 图片解释： I2C 的时序示意图，上面是写，下面是读。
//   - HID 的初始化需要设备先发出写指令，告诉设备要读哪个寄存器。然后才将自身设为读模式。
//   - 游戏控制器使用定时轮询中断，因为摇杆等模拟输入设备的状态是连续的，需要不断采样位置数据，以保证游戏的流畅性。鼠标、键盘是事件中断。
//
+ 死区：在物理层面进行了移动而没有信号响应的区域
  - 外死区；为了防止在摇杆推到最大时 输出值达不到1，给摇杆输出信号的数值进行增大处理，然后过滤掉大于1的部分
    - 不同的外死区会对手感造成极大影响。（FPS）
+ 线性扳机
+ 十字吸附：不讲
+ 校准：碳粉摇杆会漂移
+ 非线性马达：增强手感，需要游戏配合。Xinput 和 directinput 不支持非线性手柄。

开发技术栈

- 对比单片机：自由度高很多，社区完善