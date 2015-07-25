shinyUI(pageWithSidebar(
        headerPanel("Welcome to SnapStock!"),
        sidebarPanel(
                textInput(inputId="test", label = "Please enter the ticker symbol of a 
                          stock you are interested in, e.g. \"AAPL\" for Apple.
                          (Quotation marks are for emphasis; please do not enter them 
                          alongside the ticker symbol!)"),
                dateRangeInput("dates", label = "Please enter a time period of interest."),
                actionButton("goButton", "Get Summary")
        ),
        mainPanel(
                h4('Documentation'),
                p('Only U.S. stocks (Nasdaq, NYSE, AMEX) are current supported. To start,
                  please follow the input instructions to the right, and press \"Get Summary\".
                  The full name of the company that corresponds to the ticker symbol will be 
displayed above the plot. In order to get a new summary plot for another symbol and/or another time 
period, once you have updated the symbol name/dates, please press the "Get Summary" button again 
to refresh the page. If you are not sure what the ticker symbol for a company is, you can type in
                  the text box the partial/full name of the company and press "Get Summary", and 
a list of recommended symbols will be provided if your text input matches any of the company names 
that are included in the Yahoo Finance database.'),
                textOutput('textS'),
                p(),
                textOutput('textB'),
                imageOutput("summary"),
                p('You can access the server.R and ui.R via this Github url: 
                https://github.com/bitterleaf/dataproductCourseProject ')
        )
))
