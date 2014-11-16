library(shiny)
library(Quandl)
library(ggplot2)
Quandl.auth("jeN-qLxHN41omaKx3_Dk")

# Getting Default Data

getdata <-function(currentdate)
{
  brent = Quandl("CHRIS/CME_CL1", trim_start="2014-01-01", trim_end=currentdate, authcode="jeN-qLxHN41omaKx3_Dk")
  wti = Quandl("CHRIS/ICE_B1", trim_start="2014-01-01", trim_end=currentdate, authcode="jeN-qLxHN41omaKx3_Dk")
  
  #Aligning Timeline Of Data
  diff = union(setdiff(as.character(brent$Date),as.character(wti$Date)),  setdiff(as.character(wti$Date),as.character(brent$Date)))
  brentindex = numeric()
  wtiindex = numeric()
  for(i in 1: length(diff))
  {
    if(length(which(wti$Date == diff[i]))!=0)
    {
      wtiindex = rbind(wtiindex,which(wti$Date == diff[i]))
    }
    if(length(which(brent$Date == diff[i]))!=0)
    {
      brentindex = rbind(brentindex,which(brent$Date == diff[i]))
    }
  }
  if(length(brentindex)!=0)
  {brent = brent[-brentindex,]}
  if(length(wtiindex!=0))
  {wti = wti[-wtiindex,]}
  
  s = data.frame(Date = brent$Date, Brent = brent$Settle, WTI = wti$Settle, Spread = brent$Settle- wti$Settle, Change = c(-diff(log(brent$Settle))*100,0)- c(-diff(log(wti$Settle))*100,0))
  
  return(s)
}
currentdate = as.character(Sys.Date())
data = getdata(currentdate)
#

shinyServer(
  function(input, output) {

    
  
    output$CurrentSpread <- renderPrint({data$Spread[1] })
    output$LongPNL <- renderPrint({(data$Spread[1] - input$EntryPrice)*input$Size*10 })
    output$ShortPNL <- renderPrint({(-data$Spread[1] + input$EntryPrice)*input$Size*10})


    
    
    #spreadplot<-
    
    output$Graph <- renderPlot({
      
      ggplot(data=data[which(as.Date(data$Date) >=input$Date),],aes(x=Date,y=Spread)) +
        geom_line(color="Black")+
        # Adding a colored line
        theme(panel.background =element_rect(fill="Grey"),
              panel.grid.major.x =element_blank(),
              panel.grid.major.y =element_line(colour="White",size=0.1),
              panel.grid.minor = element_line(colour="White",size=0.1 )) 
    })
    
    output$Change <- renderPlot({
      
      ggplot(data=data[which(as.Date(data$Date) >=input$Date),],aes(x=Date,y=Change)) +
        geom_line(color="Black")+
        # Adding a colored line
        theme(panel.background =element_rect(fill="Grey"),
              panel.grid.major.x =element_blank(),
              panel.grid.major.y =element_line(colour="White",size=0.1),
              panel.grid.minor = element_line(colour="White",size=0.1 )) 
    })
    
  }
)