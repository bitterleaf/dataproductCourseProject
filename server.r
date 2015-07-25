require(shiny)
require(stringr)
require(quantmod)

# load NYSE stock abbreviation/name data
Stocks_NYSE <- read.delim('data/NYSE.txt',header=TRUE,sep='\t')
Stocks_AMEX <- read.csv('data/AMEX.csv',header=TRUE)
Stocks_NASDAQ <- read.csv('data/NASDAQ.csv',header=TRUE)

# create list of symbols and company names to search through
Symbols <- c(as.character(Stocks_NYSE$Symbol),as.character(Stocks_AMEX$Symbol),
             as.character(Stocks_NASDAQ$Symbol))
Symbols <- str_trim(Symbols)
FullNames <- c(as.character(Stocks_NYSE$Description),as.character(Stocks_AMEX$Name),
               as.character(Stocks_NASDAQ$Name))

shinyServer(
        function(input, output) {
                
                # reactive update for Symbol index
                nName <- eventReactive(input$goButton,{
                        which(Symbols == input$test)
                })
                
                # reactive update for name match
                nMatch <- eventReactive(input$goButton,{
                        grep(as.character(input$test),FullNames,ignore.case=TRUE)
                })
                
                # reactive update for time range
                nDate <- eventReactive(input$goButton,{
                        input$dates
                })
                
                # text output of company name / putative stock symbol
                output$textS <- renderText({
                        nameSearch <- nMatch()
                        if (length(nName()) == 0 && length(nameSearch) == 0) {
                                "Invalid symbol / name. Please try again!"
                        } else if (length(nName()) == 0 & length(nameSearch >= 0)) {
                                if (length(nameSearch) >= 10) {
                                        listo <- Symbols[nameSearch[1:10]]
                                } else {
                                        listo <- Symbols[nameSearch]
                                }
                                c("You may be looking for the following 
                                  (the first of which is currently displayed): ",
                                as.character(listo))
                        } else if (length(nName()) >= 1) {
                                FullNames[nName()]
                        }
                })
                                
                # fluff
                output$textB <- renderText({
                        date_subset <- as.character(nDate())
                        date_subset <- paste(date_subset[1],'::',date_subset[2],sep="")
                        if (input$goButton == 0) "Awaiting stock selection..."
                        else date_subset
                })
                
                # Plot stock summary
                output$summary <- renderPlot({
                        # set query for stock data
                        UseSymbol <- nName()
                        nameSearch <- nMatch()
                        date_subset <- as.character(nDate())
                        date_subset <- paste(date_subset[1],'::',date_subset[2],sep="")
                        
                        # generate bar plot
                        if (length(UseSymbol) != 0) {
                                dataChar <- Symbols[UseSymbol[1]]
                        } else {
                                dataChar <- Symbols[nameSearch[1]]
                        }
                        if (length(nName()) != 0 || length(nameSearch) != 0) {
                                getSymbols(dataChar)
                                chartSeries(get(dataChar),subset=date_subset,
                                            theme=chartTheme('white'))
                                addBBands()
                        }
                })
        }
)