shinyUI(pageWithSidebar(
  headerPanel("Spread Calculator for Brent - WTI in 2014"),
  sidebarPanel(
    numericInput('EntryPrice', 'Spread Entry Price', 0, step = 0.01),
    numericInput('Size', 'No. of  Contracts', 1, min = 1, step = 1),
    dateInput("Date", "Start Date:", min ="2014-01-02", max =  as.character(Sys.Date()), value="2014-02-02"),
    h4('Explanation'),
    p('1. Brent and WTI are both exchange traded Crude Oil Futures '),
    p('2. The "Spread" refers to takinng daily Brent Price - WTI Price'),
    p('3. 0.01 Change in Spread Price will affect Profit and Loss by $10 '),
    p('4. Spread Entry Price - Current Spread will output Profit and Loss '),
    p('5. Changing the number of contracts will affect Profit and Loss'),
    p('6. Date will affect the amount of data shown on the plots '),
    p(em("Github repository documentation:",a("Github repo",href="https://github.com/nzx89/Shiny/blob/master/index.Rmd")))
  ),
  mainPanel(
    p('Please Wait For About 30s While The Initial DataSet Loads from QuanDL Server'),

    h4('Current Spread is'),
    verbatimTextOutput("CurrentSpread"),
    
    h4('Long Profit/Loss is '),
    verbatimTextOutput("LongPNL"),
    
    h4('Short Profit/Loss is '),
    verbatimTextOutput("ShortPNL"),

    h4('Graph Of Spread '),
    plotOutput('Graph'),
    
    h4('Graph Of Difference in % Change'),
    plotOutput('Change')
  )
))
