# server.R

shinyServer(function(input, output) {
    
        output$OTplot <- renderPlot({
            OTfreqPlot(input$text)
        })
        output$NTplot <- renderPlot({
            NTfreqPlot(input$text)
        })
        output$freqdt <- renderTable({
            freqTable(input$text)[1:5,]
        })
        output$freqplot <- renderPlot({
            ggplot(freqTable(input$text), aes(factor(1), word.count, fill = factor(Book))) + geom_bar(stat = "identity") + 
                coord_polar(theta = "y") + xlab("") + ylab("") + scale_fill_discrete(name = "") + 
                theme(legend.text=element_text(size=20))
        })
        
        output$ui <- renderUI({
            switch(input$select.1,
                "Old.Testament" = selectInput("book", "", 
                                              choices = c(titleindex$title[1:39]),
                                              selected = ""),
                "New.Testament" = selectInput("book", "", 
                                              choices = c(titleindex$title[40:66]),
                                              selected = "")
            )
        })
        output$wc <- renderPlot({
            wcplot(input$book)
        })
    }
)