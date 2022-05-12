# Help of shinysmplot

---

这是对“shinysmplot”中呈现的Shiny应用程序的帮助：用Shiny制作R中的correlation plot,bland-altman plot,slope chart。本文档可以解决用户遇到的一些常见问题。

## 1 Shinysmplot 简介



- 支持三种图形的绘制，分别为correlation plot,bland-altman plot,slope chart
- 部分图像支持修改坐标轴和标题以及图像颜色
- 支持用户上传数据和下载输出图像

---

## 2 Shinysmplot使用说明

### 2.1基本介绍

#### 2.1.1上传数据

用户可根据需求选择上传文件或是粘贴数据，数据集应该包含数据需要三列，第二列为X轴，第三列为Y轴,当选择plot type为slope时，数据第一列为组，第二列为y轴，第三列为x轴。用户可先点击Upload input data选择上传文件，再点击Browse上传本地数据；用户如果想要了解数据格式和画出的图形效果，可以先点击Download example data下载样本文档，再点击Browse上传样本数据。用户也可以点击Paste input data来选择粘贴上传数据，此时文本框中就会出现样本数据。

**数据上传支持表格和txt格式。**

#### 2.1.2画图

点击Action运行这个shiny程序，进而出来用上传数据画出所选择的图像类型。

#### 2.1.3图像相关

用户可以通过界面的一些控件来获得想要的图形效果，"Add plot title"为添加图像的x轴，y轴,标题名字，"choose color "可以用于更改图像数据的颜色，"Adjust the printed texts parameter"则用于调整图像所显示出的文本位置，直到得到用户所需的心仪图像

### 2.1.4 下载界面
在完成Shinysmplot图编辑之后，可以将Shinysmplot图下载到本地，本应用程序提供了两种下载文件的格式，分别是pdf和png文件格式，用户可根据点击"Download PDF File"和"Download PNG File"进而来依据喜好和需求选择下载。

### 2.2 注意事项

#### 2.2.1 关于图像

在修改图像相关内容时，三种图像所能调整的范围不同，具体如下：

- correlation plot 能够修改所有控件所提供的功能，其中"date colcor 1"用于修改散点图的颜色，"date colcor 2"用于修改线的颜色

- bland-altman plot只能修改散点的颜色和标签的x轴位置与大小size，x轴与y轴的名字则是固定的，标题中能修改的只有图像标题，即Plot title

- slope chart的图像颜色是随机的，无法自行更改，x轴则是自动生成的，即为数据组名， 允许更改y轴名字与图像标题，同时由于slope chart的特殊性，其标签即为x轴，无法更改大小与位置

#### 2.2.1 关于数据上传

**数据上传支持txt与csv，但由于图像类型不同，所需要的数据格式也有差别**

对于correlation plot与bland-altman plot，两者可以公用一个数据格式，即2.1.1中的格式要求，其中txt与csv的格式如下：

| char   |   x |     y|
| :----- | :--: | -------: |
| char1 |  18  | 19 |
| char2 |  20  |21 |
| char3 |  22  | 23 |

当plot type 为slope char时，其数据格式则发生更改，无法使用correlation plot与bland-altman plot的数据进行计算，需要重新上传新的数据，其txt与csv的格式要求如下：

| group   |   date   |     x|
| :----- | :--: | -------: |
| char1 |  18  | char1 |
| char2 |  20  |char1 |
| char1 |  22  | char2 |
| char2 |  24  | char2 |

为了方便用户理解数据格式，在程序自带的Example data与Paste input data中有所差别。
- 前者为correlation plot与bland-altman plot的格式，用户可以点击Download example data下载样本文档来查看所需的格式要求
- 后者为slope char的格式，用户可以点击Paste input data来查看格式要求