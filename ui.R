

library(shiny)
library(shinydashboard)#主题
library(shinyBS)#按钮
library(shinythemes)
library(shinyWidgets)#提示
library(RLumShiny)#颜色
library(tidyverse)
library(smplot)
library(grid)#下载
library(gridExtra)





sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("plot", tabName = "plot", icon = icon("archive")),
    checkboxInput("abcc","choose color ",FALSE),
    conditionalPanel(
      condition = "input.abcc",
      fluidRow(column(12,"date color 1",
                      jscolorInput("v1",label = NULL,value = "#000000"))),
      br(),
      fluidRow(column(12,"date color 2",
                      jscolorInput("v2",label = NULL,value = "#000000")))
    ),
    checkboxInput("xyt","Add plot title",FALSE),
    conditionalPanel(
      condition = "input.xyt",
      textInput("xt","add x axis title",value = "x axis"),
      textInput("yt","add y axis title",value = "y axis"),
      textInput("tt","add plot title",value = "plot title")
    ),
    actionButton("submit1",width = 200, strong("Action"), styleclass = "success") ,
    menuItem("Download", tabName = "Download", icon = icon("download")),
    menuItem(text = "Help",  # item名字
             tabName = "Help", # 传递到tab的变量名称
             icon = icon("book"))
  ))


body <- dashboardBody(
  tabItems(
    tabItem(tabName = "plot",
            fluidRow(#图像输出
              box(width = 12,height = 500,
                  plotOutput("SC"))
            ),
            fluidRow(
              box(
                selectInput("seluploaddata", h4("Input Data",
                                                bsButton("bs00", label="", icon=icon("question"), style="info", size="small")
                ), c("Upload data" = "1","Paste data" = "2"), "1"),
                bsPopover("bs00", 'Select Input data type',"可下载、粘贴数据.数据需要三列，第二列为X轴，第三列为Y轴,当选择plot type为slope时，数据第一列为组，第二列为y轴，第三列为x轴",trigger = "focus"),
                conditionalPanel(condition="input.seluploaddata == '1'",#选择上传数据
                                 fileInput("Upload_data",label="",multiple = FALSE,
                                           accept = c("text/csv",
                                                      "text/comma-separated-values,text/plain",
                                                      ".csv")),
                                 downloadButton("Example_data.txt", "Example data"),
                ),
                conditionalPanel(condition="input.seluploaddata == '2'",#选择粘贴数据
                                 textAreaInput("Paste_data",label="",width="100%", resize="vertical", 
                                               height="200px",placeholder = "Paste text to upload data"),
                                 actionButton("Paste_example", strong("Paste example data"), styleclass = "info"),      
                ),
                
              ),
              box(
                radioButtons("plot", label = h3("plot type",bsButton("bs02", label="", icon=icon("question"), style="info", size="small")),
                               choices = list("correlation plot" = 1, "bland-altman plot" = 2, "slope chart" = 3), 
                               selected = 1),
                bsPopover("bs02", 'Select plot type',"选择合适的图像类型",trigger = "focus")
              ),
              box(
                title = "Adjust the printed texts parameter",#调整文本参数
                bsButton("bs01", label="", icon=icon("question"), style="info", size="small"),
                bsPopover("bs01", 'adjust the label size',"用于调整标签的位置，slope chart的标签位置是自动生成且固定的，无法调整，由于图像特殊性，颜色则是随机的",trigger = "focus"),
                sliderInput("v3","label_x",min = 0,max = 100,step = 0.1,value = 5),
                sliderInput("v4","label_y",min = -100,max = 100,step = 0.1,value = 10),
                sliderInput("v5","text_size",min = 0,max = 10,step = 0.1,value = 5)
                
                
              )
            )
    ),
    
    tabItem(tabName = "Download",
            downloadButton("downloadSCplot.pdf", "Download PDF File"),
            downloadButton("downloadSCplot.png", "Download PNG File")
    ),
    tabItem(tabName = "Help",
            fluidRow(box(width = 20,
                         includeMarkdown("README.md")
              
            )
              
            ))
  )
)
# Put them together into a dashboardPage
dashboardPage(
  dashboardHeader(title = "Shinysmplot"),
  sidebar,
  body
)

