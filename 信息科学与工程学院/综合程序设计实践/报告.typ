#import "./template.typ": *

#show: project.with(
  title: "综合程序设计",
  authors: ("absolutex",),
)

#outline(indent: 1em)

#title("时空刻录器项目设计实践报告")

= 课程设计的内容及要求

综合程序设计实践旨在培养学生综合运用所学基础和专业知识，利用程序开发环境及工具，对所学基础理论知识进行综合运用和实现的能力。
本设计内容包括：在Android Studio编程环境下，学习xml布局文件和Java代码控制UI界面，了解xml与Java的工作原理，运用前后端专业知识，进行APP的程序设计实现。程序界面采用Android Studio开发工具。本设计要求：
+ 熟悉Android Studio编程环境，具有基本的程序设计与开发能力，掌握基本的程序调试能力。
+ 掌握基本的利用Android Studio进行界面开发的方法，学习如何连接模拟器。
+ 学习并应用简单的SQLite语言。
+ 结合以上知识，进行系统综合设计，实现购物APP的基本功能。其中，线条细化功能重点考察学生对算法的分析理解和程序实现能力；其他拓展功能重点考察学生对于给定的需求，自行分析算法思路、设计方法流程并付诸实现的综合设计能力。

= 课程设计的相关设备及开发环境

- OS: Linux (NixOS)
- IDE: Android Studio, Visual Studio Code
- 编程语言: Kotlin

= 程序设计框架简介

== 项目介绍

时空刻录器的目的是记录手机使用者的日常活动，这些活动从两方面分别进行记录：时间和空间。

- 时间：记录所有 APP 使用时长，永久保存，并提供建议的查询与可视化界面。
  - 技术需求：数据库访问，应用使用时长访问，时间范围框选器与柱状图表展示。
- 空间：记录携带者的行动轨迹，并永久保存。
  - 技术需求：数据库访问，地图 API，位置信息访问与显示。

== 程序设计

本次实践我并没有使用传统的 Android xml 进行界面设计，而是使用了 Jetpack Compose 的界面设计方案。Jetpack Compose 是用于构建原生 Android 界面的现代工具包。它通过使用更少的代码、强大的工具和直观的 Kotlin API，简化并加速了 Android 上的 UI 开发。它的最大特点是 无 XML 布局：不需要使用 XML 文件来定义布局，所有界面元素都在 Kotlin 代码中定义。

代码存放在 Github 上，地址：https://github.com/lxl66566/TimeRouteTracker

=== 界面

程序共有三个主要界面，分别是：时间界面、空间界面和设置界面。这三个界面各自都是一个 Composable 对象，通过 androidx.compose.material3.NavigationBar 进行页面间导航。

=== 组件

+ BarChart：由于我的时间图表使用柱状图，并且需要按照软件时间进行分类，因此柱状图的每一节都是分段的。这个需求并不能使用现成charts 库实现，因此我自己写了一个 BarChart 组件，直接使用 Compose 的 Canvas 来画图。
+ EnumDropDownMenu：一个 UI 组件，从 Enum 构造一个下拉菜单。该组件使用了 kotlin 的反射机制，获取 Enum 内部定义的 variant 信息。
+ GmsChecker：Google Map 提供的组件。
+ LocationManager：我封装的用于管理 Location 的组件，包含了调用权限管理器进行权限获取、获取经纬度与后台定位的管理。
+ PermissionManager：权限管理器的封装，内部调用 Android API 进行权限获取。
+ TimeSpan：表示一段时间范围。
+ database：数据库表的各种操作。下分其他子组件。

除此之外，还有许多定义的小型 class 和函数，这里不展开讨论。对于许多逻辑组件，我都进行了 testfile 的编写，以测试功能正常性。

#figure(
  image("assets/project.jpg", width: 60%),
  caption: [项目文件结构],
)

= 程序与组件设计

== 时间界面

=== 柱状图

时间界面里最重要的就是柱状图，柱状图是展示信息的关键。

- 每个柱体代表一个时间段，这个时间段可以是一小时，一天，一月等。
- 柱体的高度表示该时间段内手机的应用使用时长，柱体越高，则表示该时间段的使用时长越长。
- 每一个柱体本身是分段的，每个段具有不同的颜色，代表某个应用分类的使用时长。
- 点击柱体，可以展开一个详细信息列表，表示该时间段内所有应用的使用时长统计。

柱状图具有自适应功能，可以根据手机屏幕大小与柱状图本身的柱数量进行间距调整。以下是柱体的定义：

```kotlin
@Composable
fun BarChart(
  data: List<List<Pair<Long, Color>>>,  // 每个柱体的数据（成分占比及颜色）
  dataUpLimit: Long,  // 数据上限
  modifier: Modifier = Modifier,
  xAxisBegin: Int = 0,  // 横坐标起点
  xAxisStep: Int? = null,  // 横坐标间隔
  yAxisTransform: (Long) -> Long = { it },  // 纵坐标转换
  onBarClick: (Int) -> Unit,  // 每个柱体的点击处理
) {
  // 实际绘制代码，由于直接在 Canvas 上绘制，代码长度超过 200 行，这里暂时不显示。
}
```

自适应功能中用到了 Ratio.kt 类的函数，这是一个线性拟合函数，可以根据手机屏宽，柱的数量计算柱体宽度与间距。它还接受 aMax，aMin 两个参数，柱体粗细会在此范围波动，但一定不会超出给定的此范围。bMin, bExpectedMax 是设置间隔的最小宽度与预期宽度，间隔宽度只有下限，没有上限。

```kotlin
val RatioTag = "Ratio"
public fun linearRatio(aMin: Dp, aMax: Dp, bMin: Dp, bExpectedMax: Dp, x: Dp): Pair<Dp, Dp> {
  require(aMin < aMax && bMin < bExpectedMax) { "Min value should be less than max" }

  if (x >= (aMax + bExpectedMax)) return Pair(aMax, bExpectedMax)
  if (x < (aMin + bMin)) {
    Log.w(RatioTag, "linear: x < (aMin + bMin)")
    return Pair(aMin, bMin)
  }

  val aRatio =
    (aMax.value - aMin.value) / (aMax.value - aMin.value + bExpectedMax.value - bMin.value)
  val remain = x.value - (aMin.value + bMin.value)
  val aResult = Dp(aRatio * remain + aMin.value)
  val bResult = Dp(remain * (1 - aRatio) + bMin.value)

  return Pair(aResult, bResult)
}
```

在调试过程中，我还发现暗黑模式下会有对比度问题：如果直接将字设为某个颜色，可能出现字或柱颜色看不清的问题。因此我添加了动态调整对比度的功能：

```kotlin
private val colors = listOf(
  Color.Black,
  Color.White,
  Color.Red,
  Color.Gray,
  Color.Green,
  Color.Blue,
  Color.Yellow,
  Color.Magenta,
  Color.Cyan
).map { it.toArgb() }

fun getHighContrastColor(backgroundColor: Int?): Int? {
  return backgroundColor?.let { bc -> colors.maxByOrNull { ColorUtils.calculateContrast(bc, it) } }
}
```

=== 日期选择器

日期选择器是一个可以选择日期的组件，使用 Row 布局。正中是日期显示器，点击则进入选择器；左边和右边都是一个按钮用于将日期向前或向后移动一天。

日期选择器内部调用的是 com.google.android.material.datepicker.MaterialDatePicker 组件。

```kotlin
@Composable
fun DateHeader(
  selectedDate: MutableState<LocalDate>,
  onPreviousDate: (LocalDate) -> Unit = {},
  onNextDate: (LocalDate) -> Unit = {},
  onDateRangePicked: (LocalDate, LocalDate) -> Unit = { _, _ -> }
) {
  Row(...
  ) {
    // Left button
    IconButton(onClick = {
      selectedDate.value = selectedDate.value.minusDays(1)
      onPreviousDate(selectedDate.value)
    }) {
      Icon(
        imageVector = Icons.Filled.ChevronLeft,
        contentDescription = "Previous"
      )
    }
    // Date selector box
    Box(
      modifier = modifier...
        .clickable {
          PickDateRange(onDateRangePicked)
        },
    ) {
      Text(
        ...
        (DateTimeFormatter.ofPattern("yyyy-MM-dd")),
      )
    }
    // Right button
    IconButton(onClick = {
      selectedDate.value = selectedDate.value.plusDays(1)
      onNextDate(selectedDate.value)
    }) {
      Icon(
        imageVector = Icons.Filled.ChevronRight,
        contentDescription = "Next"
      )
    }
  }
}
```

其中的 PickDateRange 函数也是自己封装的，它将 MaterialDatePicker 组件的结果转换为 LocalDate 时间戳对象。这个时间戳稍后将被传入 TimeSpan 表示的时间范围。

```kotlin
private fun PickDateRange(onDateRangePicked: (LocalDate, LocalDate) -> Unit) {
  dateRangePicker.show(fragmentManager, "time_range_picker")
  dateRangePicker.addOnPositiveButtonClickListener {
    val temp = convertToLocalDatePair(it)
    Log.d(TAG, "Date range picked: $temp")
    onDateRangePicked(temp.first, temp.second)
  }
}

fun convertToLocalDatePair(pair: androidx.core.util.Pair<Long, Long>): Pair<LocalDate, LocalDate> {
  val zoneId = ZoneId.systemDefault()
  val startDate = Instant.ofEpochMilli(pair.first).atZone(zoneId).toLocalDate()
  val endDate = Instant.ofEpochMilli(pair.second).atZone(zoneId).toLocalDate()
  return Pair(startDate, endDate)
}
```

== 空间界面

=== 地图

地图使用 Google Maps Android API 实现。这里包括了地图显示与画轨迹的功能。

```kotlin
if (mapVisible) {
  GoogleMap(
    modifier = modifier,
    cameraPositionState = cameraPositionState,
    properties = mapProperties,
    uiSettings = uiSettings,
    onMapLoaded = onMapLoaded,
    onPOIClick = {},
  ) {
    MarkerInfoWindowContent(
      state = startPosState,
      title = "Start",
      draggable = false,
    ) {
      Text(it.title ?: "Title", color = Color.Red)
    }
    if (!mock) {
      Polyline(
        points = polylineSpanPoints ?: emptyList(),
        spans = styleSpanList,
        tag = "Polyline",
      )
    } else {
      Polyline(
        points = polylineSpanPointsMocked.value,
        spans = styleSpanList,
        tag = "Polyline",
      )
    }
    content()
  }
}
```

=== 控制按钮

控制按钮是一个可以控制地图的组件，它包括了两个按钮：重置地图，暗黑模式。

- 重置地图：将相机视角，相机缩放移动到默认位置。这个默认位置在非测试（!mock）时是当天的第一个位置。
- 暗黑模式：切换地图的显示模式。在暗黑模式下，地图上的空白区域将显示为黑色。

=== 路线记录

地图初始化时会读取*当日*的路线，并将其绘制到地图上。

申请到位置信息权限后，地图将每秒获取一次经纬度信息，并存到数据库中。该时间间隔可以在设置中修改。

该位置信息还会被同步绘制到地图上，与上一秒的位置信息相连，形成一条折线图。上面代码中的 Polyline 就是绘制线条的组件，它绑定到了 polylineSpanPoints。

== 设置界面

设置界面是针对时间界面和空间界面的设置项。设置界面主要包括了以下几个功能：

- 时间界面：
  - 应用分类：可以选择应用的分类，并在时间界面中显示对应的分类颜色。
- 空间界面：
  - 后台定位：设置是否在后台进行定位。
  - 采样频率：设置定位采样频率，默认为每秒获取一次位置信息。
- 其他设置：
  - 导入数据：导入数据库。
  - 数据备份：导出数据库。
  - 清空数据：清空数据库。

设置界面本身的变量也存放在 sqlite 数据库中。我专门为其开了一张 kv 表用于存放设置变量。

设置的界面制作使用 com.alorma.compose.settings.ui，这是一个基于 Jetpack Compose 和 Material Design 的第三方设置组件库。

== 数据库设计

数据库基于 android.database.sqlite.SQLiteDatabase。

这个项目的数据库是项目中复杂度非常高的一部分。下面展示表结构。

=== Route

Route 表用来存储路线信息。每一行有一个 time 代表记录的时刻，location 是经纬度，存储为 BLOB 类型。

```
+----+-------+----------+
| id | time  | location |
+----+-------+----------+
| I  | I     | B        |
+----+-------+----------+
```

- id: INTEGER PRIMARY KEY AUTOINCREMENT
- time: INTEGER，index
- location: BLOB

在 time 上创建索引，因为每次都只需要获取当天的路线数据，也就是一段时间内的所有经纬度列表。以下是创建索引和获取路线的代码，后续表的命令差不多相同，因此只展示一次：

```kotlin
private fun createIndex() {
  dbHelper.writableDatabase.use { db ->
    val createIndexSQL = """
                CREATE INDEX IF NOT EXISTS idx_time ON $tableName (time)
            """
    db.execSQL(createIndexSQL)
  }
}

fun getSpan(start: LocalDateTime, end: LocalDateTime): MutableList<LatLng> {
  val cursor = dbHelper.readableDatabase.query(
    tableName,
    arrayOf("location"),
    "time >= ? AND time <= ?",
    arrayOf(
      LocalDateTimeConverter.from(start).toString(),
      LocalDateTimeConverter.from(end).toString()
    ),
    null,
    null,
    "time ASC"
  )
  return cursor.use {
    val result = mutableListOf<LatLng>()
    while (it.moveToNext()) {
      result.add(LatLngConverter.to(it.getBlob(it.getColumnIndexOrThrow("location"))))
    }
    result
  }
}
```

=== CategoryInfo

CategoryInfo 表存储了应用的分类信息。用户可以自行创建应用的分类，并在时间界面中显示对应的分类颜色。该表是时间表中多表查询的一部分。

```
+-------------+---------------+---------------+
| categoryId  | categoryName  | categoryColor |
+-------------+---------------+---------------+
| I           | T             | I             |
+-------------+---------------+---------------+
```

- categoryId: INTEGER PRIMARY KEY AUTOINCREMENT
- categoryName: TEXT UNIQUE
- categoryColor: INTEGER

=== AppInfo

AppInfo 表存储了应用的信息。其中 packageName 为应用包名，每个包名都不同。appName 为应用名，categoryId 是其所在的分类 ID，是指向 CategoryInfo 的外键。

该表是时间表中多表查询的一部分。

```
+----+---------------+-----------+------------+
| id | packageName   | appName   | categoryId |
+----+---------------+-----------+------------+
| I  | T             | T         | I          |
+----+---------------+-----------+------------+
```

- id: INTEGER PRIMARY KEY AUTOINCREMENT
- packageName: TEXT NOT NULL UNIQUE
- appName: TEXT
- categoryId: INTEGER FOREIGN KEY REFERENCES CategoryInfo(categoryId)

=== AppTimeRecord

AppTimeRecord 表存储了应用的时间记录。每一行有一个 time 代表记录的持续时间，datetime 是该条记录的开始时刻。还有一个外键 appId 指向 AppInfo 表。

```
+----------+--------+--------+------------+
| recordId | appId  | time   | datetime   |
+----------+--------+--------+------------+
| I        | I      | I      | I          |
+----------+--------+--------+------------+
```

- recordId: INTEGER PRIMARY KEY AUTOINCREMENT
- appId: INTEGER NOT NULL FOREIGN KEY REFERENCES AppInfo(id)
- time: INTEGER (持续时间以毫秒为单位)
- datetime: INTEGER (开始时间以时间戳形式存储)

=== KV 表

KV 表存储了设置的变量。其中 key 是变量的名称，value 是变量的值。

```
+----+------------+------------+
| id | key        | value      |
+----+------------+------------+
| I  | T          | T          |
+----+------------+------------+
```

- id: INTEGER PRIMARY KEY AUTOINCREMENT
- key: TEXT UNIQUE
- value: TEXT

=== 外部接口

数据库包把所有关于 SQL 与数据库框架的使用封装在内部。对外只暴露了一些查询接口与数据类型。这样做的好处是解耦，便于外部逻辑编写，并且修改也方便。


以下是封装的数据类型：

```kotlin
/*
 * 存储分类信息
 */
data class CategoryInfo(
  val categoryName: String,
  val categoryColor: Int,
)
data class CategoryInfoWithId(
  val id: Int,
  val categoryName: String,
  val categoryColor: Int,
)
/*
 * 存储应用信息
 */
data class AppInfo(
  val packageName: String,
  val appName: String,
  val categoryId: Int,
)
/*
 * 每一条用时记录，适用于 hours, daily, monthly, yearly
 */
data class AppTimeRecord(
  val appId: Int,
  val time: Duration,
  val datatime: LocalDateTime,
)
// 用于插入的数据结构
data class AppTimeInsertion(
  val packageName: String,
  val time: Duration,
  val datetime: LocalDateTime,
)
// 查询的结果结构体
data class AppTimeQuery(
  // 应用名
  val appName: String,
  // 分类的颜色
  val categoryColor: Int,
  // 开始时间
  val datetime: LocalDateTime,
  // 持续时间
  val time: Duration,
)
// 时间记录的查询结果
typealias AppTimeQueries = List<AppTimeQuery>

// 路线信息
data class RouteItem(
  val time: LocalDateTime,
  val location: LatLng,
)
// 路线信息的查询结果
typealias RouteInfo = MutableList<LatLng>
```

= 界面展示

本项目大部分工作量集中在逻辑编写，因此界面数量较少。各个界面之间通过 Jetpack Compose 的 NavHost 实现导航跳转，因此界面跳转部分也没有太多的内容。

#figure(
  image("assets/result.jpg", width: 100%),
  caption: [界面展示。左一：时间界面，左二：日期选择，右二：空间界面，右一：设置界面],
)

= 遇到的问题

Android 的权限获取与调试都过于繁琐，例如我给了位置信息权限，开启了后台记录，却无法在后台读取到位置信息；或者是很难写出获取应用使用时长信息的代码。并且在 Android Studio 的模拟器里也无法模拟真实设备的某些权限，例如位置信息。因此我不得不使用自己的手机进行调试。

在使用数据库框架时，我先尝试了 kotlin 的 Room 框架，并在实际项目中使用。这是一个基于 model 的数据库 ORM，设计比手写 SQL 更加简单易用。但是后来我发现 Room 框架的报错非常具有迷惑性，看报错原因根本无法定位错误。在折腾许久后无果，因此我决定将数据库切换到原生的 SQLiteDatabase 框架。

在编写 kotlin 的反射时我也遇到了一些问题。kotlin 的反射使用的是 kclass，而 java 的反射用的是 java class，这两个class 之间需要一层转换。如果遗漏了这个转换，反射就不成立了。

还有包括数据库的备份，我使用纯二进制流写入文件进行备份，设想写入用户的 Downloads 文件夹，但是Android 从某个版本开始就不允许应用写入到 Downloads 文件夹下。这也是万恶的 Android 权限系统的问题。后来我只好写入其他文件夹，让用户自行处理路径的变化。

#pagebreak(weak: true)

= 心得体会

本次实验中我学习了 Android Studio 的使用，Gradle 进行包管理，Jetpack Compose 框架的使用与 Kotlin 语言的学习；在此过程中我获得了宝贵的实践经验，并对Android应用开发有了更深入的理解。

在项目初期，我选择了Jetpack Compose作为UI框架，这是一个大胆的决定，因为它是一个相对较新的技术。通过学习和适应，我逐渐掌握了Compose的设计理念，体会到了它在减少代码量和提高开发效率方面的优势。这次经历教会了我，勇于尝试新技术可以带来意想不到的收获。

项目中涉及到数据库和地图API的集成，这要求我不仅要掌握SQLite语言，还要了解如何与第三方服务 Google Maps 进行交互。这一过程加深了我对数据存储和网络通信的理解。

在处理位置信息和应用使用时长时，我深刻体会到了权限管理的重要性。用户对隐私的保护意识越来越强，因此，合理请求和处理权限成为了提升用户体验的关键。但是目前 Android 的权限管理部分做得还是不够好，对于开发者来说，权限获取与调试都过于繁琐。包括 Android Studio 的模拟器里也无法模拟真实设备的某些权限，我觉得这方面 Google 还有很大的工作要做。

在开发过程中，我编写了大量的测试用例来确保各个组件的功能正确性。这个过程让我认识到了测试在软件开发中的重要性，以及如何通过自动化测试提高开发效率。

总的来说，时空刻录器项目不仅提升了我的技术能力，也锻炼了我的项目管理和团队协作能力。这些经验将对我的未来职业生涯产生深远的影响。