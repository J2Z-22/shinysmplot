#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

options(shiny.maxRequestSize = 200*1024^2)

shinyServer(
  function(input, output, session){
    observe({
      if(input$submit1 > 0){
        isolate({
          if(input$seluploaddata == "1"&& !is.null(input$Upload_data)) {
            data_info <- file.info(input$Upload_data$datapath)
            if(data_info$size == 0) {
              sendSweetAlert(
                session = session,
                title = "Error !!",
                text = "The file can't be empty.",
                type = "error"
              )
            } 
            else {
              data <- read.table(input$Upload_data$datapath,  sep = "\t", head = T, as.is = T)
              if(dim(data)[2] != 3) {
                sendSweetAlert(
                  session = session,
                  title = "Data formatting error !", type = "error",
                  text = "Please check the input data format!"
                )
              }
              
              }
          }
          
          if(input$seluploaddata == "2" && !is.null(input$Paste_data)) {
            if (input$Paste_data == "") {
              sendSweetAlert(
                session = session,
                title = "No input data received!", type = "error",
              )
            } else{
              data <- unlist(strsplit(input$Paste_data,"\n"))
              data <- strsplit(data,"\t")
              if(length(data[[1]]) != 3)  {
                sendSweetAlert(
                  session = session,
                  title = "Data formatting error !", type = "error",
                  text = "Please check the input data format!"
                )
              }
              data <- unlist(data)
              data <- data.frame(t(matrix(data, 3)),stringsAsFactors = F)
              names(data) <- data[1, ]
              data <- data[-1, ]
              data[,2] <- as.numeric(data[,2])
            }
          }
          B <- function(){
            if(input$plot ==  1){              
              data[,3] <- as.numeric(data[,3])
              p1 <- ggplot(data, aes(x = data[,2], y=data[,3])) +
                geom_point(shape = 21, fill = input$v1, color = 'white',
                           size = 3) + sm_corr_theme(borders = FALSE) +
                sm_statCorr(color = input$v2, corr_method = 'pearson',
                            label_x = input$v3, label_y = input$v4, text_size = input$v5)+
                ggtitle(input$tt) + 
                xlab(input$xt) + ylab(input$yt)
              p <- p1
              }
            if(input$plot ==  2){
              first <- as.numeric(data[,2])
              second <- as.numeric(data[,3])
              res <- sm_statBlandAlt(first,second)
              p2 <- sm_bland_altman(first, second, shape = 21,
                                    color = 'white',
                                    fill = input$v1) + 
                annotate('text', label = 'Mean', x = input$v3, y = res$mean_diff + 0.2,size = input$v5) +
                annotate('text', label = signif(res$mean_diff,3), x = input$v3, y = res$mean_diff - 0.2,size = input$v5) +
                annotate('text', label = 'Upper limit', x = input$v3, y = res$upper_limit + 0.2,size = input$v5) +
                annotate('text', label = signif(res$upper_limit,3), x = input$v3, y = res$upper_limit - 0.2,size = input$v5) +
                annotate('text', label = 'Lower limit', x = input$v3, y = res$lower_limit + 0.2,size = input$v5) +
                annotate('text', label = signif(res$lower_limit,3), x = input$v3, y = res$lower_limit - 0.2,size = input$v5) + 
                ggtitle(input$tt) 
            p <- p2
            }
            if(input$plot ==  3){
              p3 <- ggplot(data, aes(x = data[,3], y = data[,2], fill= data[,3], group = data[,1])) +
                sm_slope(labels = c(values=rainbow(length(unique(data[,1])))),
                         shape = 21, color = 'white', line_alpha = 0.3) +
                ggtitle(input$tt) + 
                theme(plot.title = element_text(face="bold")) +
                ylab(input$yt)
              p <- p3
            }
            
            return(p)
          }
          output$SC <- renderPlot({B()})  
        })
      } else{
        NULL
      }
      ## *** Download example data ***
      output$Example_data.txt <- downloadHandler(
        filename <- function() {
          paste('Example_data.txt')
        },
        content <- function(file) {
          input_file <- "Example_data.txt"
          example_dat <- read.table(input_file, head = T, as.is = T, sep = "\t", quote = "")
          write.table(example_dat, file = file, row.names = F, quote = F, sep = "\t")
        }, contentType = 'text/csv') 
      
      ## paste example input 
      observe({
        if (input$Paste_example >0) {
          isolate({
            exam <- readLines("Paste_example.txt")
            updateTextAreaInput(session, "Paste_data", value = paste0(exam,collapse = "\n"))
          })
        } else {NULL}
      })

      output$downloadSCplot.pdf <- downloadHandler(
        filename <- function() { paste('B.pdf') },
        content <- function(file) {
          pdf(file)
          p4 <- B()
          grid.draw(p4)
          dev.off()
        }, contentType = 'application/pdf')
      

      output$downloadSCplot.png <- downloadHandler(
        filename <- function() { paste('B.png') },
        content <- function(file) {
          png(file)
          p4 <- B()
          grid.draw(p4)
          dev.off()
        }, contentType = 'image/png')
    }) 
  })