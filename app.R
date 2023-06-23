library(shiny)
pacman::p_load(rio)

options(shiny.maxRequestSize=30*1024^2)
ui<-fluidPage(
    navbarPage(
      "Transaction Analysis",
      tabPanel(
        "Overview",
        
        sidebarPanel(
          fileInput("f1","Upload your 'bank.xlsx' file for analysis. Max file size = 30MB"),
          
          tags$h4("Please enter the account number according to the dataset uploaded"),
          tags$h4("Please wait , this app might take a bit time to respond"),
          textInput("txt1","Account Number",""),
          selectInput("po","Select the type of graph",c("Histogram", "Scatter Plot"))

        
          
        ),
        
        mainPanel(
          tags$h3("Overview :-"),
          h4("RED Withdrawl"),
          h4("BLUE- Deposit"),
          plotOutput(outputId<-"wa"),
          tags$h3("Maximum Transactions :-"),
          tableOutput(outputId<-"ss"),
          tags$h3("Maximum Withdrawl Transaction details:-"),
          tableOutput("waa"),
          tags$h3("Maximum Deposit Transaction details:-"),
          tableOutput(outputId<-"daa"),
          tags$h3("Average Transaction Amount :-"),
          tableOutput(outputId<-"avgtr")
          
        )
      ),
      
      
      tabPanel(
        "Transaction History",
        sidebarPanel(
          fileInput("f2","Upload your 'bank.xlsx' file for analysis. Max file size = 30MB"),
          
          tags$h4("Please enter the account number according to the dataset uploaded."),
          tags$h4("Please wait , this app might take a bit time to respond"),
          tags$h4("If minimum suspicious amount is not entered, it is considered 0 by default and will show every transaction as suspicious "),
          textInput("txt2","Account Number",""),
          textInput("stxt","Maximum amount considered as not suspicious","0")
      ),
      
      mainPanel(
        tags$h3("Transaction details :-"),
        tableOutput(outputId<-"with")
        
      )
      
    )
    
    
  
)
)
   
 

server<-function(input,output){
  output$wa<-renderPlot({
    ff<-input$f1
    bank<-import(ff$datapath)
    waa<-bank$`WITHDRAWAL AMT`[bank$`Account No`==input$txt1]
    transaction<-na.omit(waa)
    mt<-max(transaction)
    daa<-bank$`DEPOSIT AMT`[bank$`Account No`==input$txt1]
    daa<-na.omit(daa)
    md<-max(daa)
    m<-ifelse(mt>md, mt, md)
    h1<-hist(transaction)
    h2<-hist(daa)
    if(input$po=="Histogram"){
    plot(h1,col=rgb(1,0,0,0.75), xlab= "Transaction Amount",xaxp=c(0,m,100000))
    
    plot(h2,col=rgb(0,0,1,0.75), add=T, xlab= "Transaction Amount", xaxp=c(0,m,100000))
    }
    else{
      plot(transaction, col=rgb(1,0,0,0.75), xlab="Transaction Amount", xaxp=c(0,m,100000))
      points(daa, col=rgb(0,0,1,0.75), add=T, xlab="Transaction Amount", xaxp=c(0,m,100000))

    }
    

  })
      
  output$with<-renderTable({
    ff<-input$f2
    bank<-import(ff$datapath)
    sus<-input$stxt
        
    b<- subset(bank,bank$`Account No`==input$txt2)
    Alert<- ifelse(as.numeric(b$`WITHDRAWAL AMT`)>as.numeric(sus) | as.numeric(b$`DEPOSIT AMT`)>as.numeric(sus), "SUSPICIOUS","")
    bb<-cbind(b,Alert)
    bb
    
   
  })
 

  output$ss<-renderTable({
    f<-input$f1
    bank<-import(f$datapath)
    
    withdrawl<-bank$`WITHDRAWAL AMT`[bank$`Account No`==input$txt1]
    deposit<-bank$`DEPOSIT AMT`[bank$`Account No`==input$txt1]
    maximum_withdrawl<-max(na.omit(withdrawl))
    maximum_deposit<-max(na.omit(deposit))
    data.frame(maximum_withdrawl,maximum_deposit)
  })

  output$waa<-renderTable({
    f<-input$f1
    bank<-import(f$datapath)
    
    withdrawl<-bank$`WITHDRAWAL AMT`[bank$`Account No`==input$txt1]
    maximum_withdrawl<-max(na.omit(withdrawl))
    table(bank$`TRANSACTION DETAILS`[bank$`Account No`==input$txt1 & bank$`WITHDRAWAL AMT`==maximum_withdrawl])
    
    
    
  })
  
  output$daa<-renderTable({
    f<-input$f1
    bank<-import(f$datapath)
    
    deposit<-bank$`DEPOSIT AMT`[bank$`Account No`==input$txt1]
    maximum_deposit<-max(na.omit(deposit))
    table(bank$`TRANSACTION DETAILS`[bank$`Account No`==input$txt1 & bank$`DEPOSIT AMT`==maximum_deposit])
    
    
  })
  
  
  output$avgtr<-renderTable({
    f<-input$f1
    bank<-import(f$datapath)
    deposit<-bank$`DEPOSIT AMT`[bank$`Account No`==input$txt1]
    average_deposit<- mean(na.omit(deposit))
    withdrawl<-bank$`WITHDRAWAL AMT`[bank$`Account No`==input$txt1]
    average_withdrawl<-mean(na.omit(withdrawl))
    data.frame(average_withdrawl,average_deposit)
    
  })
  
  
  
  
}

shinyApp(ui = ui,server = server)