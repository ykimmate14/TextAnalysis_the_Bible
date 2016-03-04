# ui.R

shinyUI(navbarPage("Text Analysis on the Bible",
    
    tabPanel("String Count",
             titlePanel("String Count"),
             fluidRow(
                 column(3, 
                        helpText("The app counts the user's word of interest and graphically shows its frequency of being 
                     referred in the Bible. The Bible is King James Version. The text file used in the app can be downloaded ",
                                 a("here.", href = "http://www.truth.info/download/bible.htm")),
                        textInput("text", label = "Enter the word of interest", value = "")
                        ),
                 
                 column(4,
                        h4("The table shows 5 books with most word count.", align = "center"),
                        tableOutput("freqdt"), align = "center"),
                 column(4,
                        h4("String count pie chart", align = "center"),
                        plotOutput("freqplot", height = 300), align = "center")
             ),
             
             mainPanel(
                 
                 h3("Old Testament", align = "center"),
                 plotOutput("OTplot", height = 300),
                 h3("New Testament", align = "center"),
                 plotOutput("NTplot", height = 300),
                 width = 12
             )
             
    ),
    tabPanel("Word Cloud",
             titlePanel("The Bible word cloud"),
             fluidRow(
                 column(3,
                        helpText("The app prompts a user to select one of the books from the Bible and shows the 50 most frquent string in
                                 a word cloud format for the selected book."),
                        selectInput("select.1", "Select a Book",
                                    c("Old.Testament", "New.Testament")),
                        uiOutput("ui")

                        ),
                 column(4,
                        plotOutput("wc", height = 500)
                 )
             )
             
        
    )
    )
)

