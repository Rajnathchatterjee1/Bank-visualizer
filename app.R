library(shiny)
pacman::p_load(rio)
library(formattable)
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
          textInput("txt1","Account Number","")
          
        ),
        
        mainPanel(
          tags$h3("Withdrawl Overview :-"),
          plotOutput(outputId<-"wa"),
          tags$h3("Deposit Overview"),
          plotOutput(outputId<-"da"),
          tags$h3("Maximum Transactions :-"),
          tableOutput(outputId<-"ss"),
          tags$h3("Maximum Withdrawl Transaction details:-"),
          tableOutput("waa"),
          tags$h3("Maximum Deposit Transaction details:-"),
          tableOutput(outputId<-"daa"),
          tags$h3("Average Transaction Amount :-"),
          tableOutput(outputId<-"avgtr"),
          
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
    plot(na.omit(waa),ylab="Withdrawl Amount")
  })
  output$da<-renderPlot({
    ff<-input$f1
    bank<-import(ff$datapath)
    
    daa<-bank$`DEPOSIT AMT`[bank$`Account No`==input$txt1]
    plot(na.omit(daa),ylab="Deposit Amount")
  })
    
  output$with<-renderTable({
    ff<-input$f2
    bank<-import(ff$datapath)
    sus<-input$stxt
    bank$Alert<- ifelse(bank$`WITHDRAWAL AMT`>sus | bank$`DEPOSIT AMT`>sus, "SUSPICIOUS","")
    
    
    b<- subset(bank,bank$`Account No`==input$txt2)
    
    
   
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