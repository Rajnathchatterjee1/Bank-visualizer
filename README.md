# Bank-visualizer

Access to this web app- https://h1ndfp-rajnath-chatterjee.shinyapps.io/visualizer/ 

This is a project in order to build a web app for employee of a bank to make their work easier of getting a visualized data 
of 1 person who has an account in their bank through that person's Account number.

It is expected from a bank that they would keep a track of a transactions happening on a database whether its a excel sheet, csv or JSON. Any form.
This web app accepts that excel sheet and gives the user a visualized data.

As an example we have taken an extensive spreadsheet of Transactions named as- "bank .xlsx"

This web app has 2 parts :- 
1. Overview
2. Transaction History

OVERVIEW :- 
This page of the app shows the Transactional Overview. That includes that persons Maximum,Minimum and Average Transactions, Transaction details of the 
Maximum Withdrawl and Deposit and a Graphical Overview of the similar.

This page takes the maintained Excel sheet and the account number you desire as input and gives the complete overview.

TRANSACTION HISTORY :-
This page gives the entire transaction history, of the account number entered. It gives out every Transaction Detail including cash deposit or Withdrawl.
Also this page takes another input called "Maximum amount of transaction considered as not suspicious." The default value for this input is 0.

In this output A whole data frame is given as an output along with an extra coloumn called "Alert". This coloumn denotes which transaction is Suspicious according 
to the given input.

This page also takes the excel sheet and the account number as input and also another input called "Maximum amount of transaction considered as not suspicious."

In order to access this web app user just have to get access to the website given at the first line of this README. Anyone having this URL can access to this app.
