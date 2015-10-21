<h2 align="center">IS380-Final-Project</h2>
<h3 align= "center">Database Management</h3>

                                  CALIFORNIA STATE UNIVERSITY, LONG BEACH
                                  IS 380 – Database Management
                                  Spring 2015 Term – Session 1
                                  PROJECT – PART 1
                                  (Not to turn in – Solution Reviewed in Class)

NOTE
Below output is shown using SQL*Plus.  You may use SQL Developer, but keep in mind differences discussed in class.

OVERVIEW
You have recently been hired at A1 Automobile Parts (AA).  All of AA’s work is done in a paper-based system.  Recently, AA has found it difficult to generate reports and process new orders.  So, you have been asked to design and implement an order processing system.  You will first design and implement the system with your current knowledge of Oracle SQL and SQL Plus.  Eventually, you envision that you will generate a web-based or client/server application.  

Although there is a lot you can do to automate AA’s processes, you decide to concentrate on the tasks most frequently performed.  You decide to start the program by completing the following:
•	An Order Entry Screen
•	Receiving an Order
•	Updating Part Information
•	Parts Inventory and Supplier Report
•	Supplier’s Order status Report.

Order Entry Screen (neword.sql)
This is where users begin to place an order.  After your analysis of the current paper based process, you have made the following observations:
•	AA places orders with multiple suppliers
•	For each order placed with a supplier, only one part is ordered.
•	To procure a specific part (to create an order), you must check for approved suppliers.  Although AA uses many suppliers, they have approved designated suppliers for specific parts.  For example, Air Filters (Part Number 101), can only be purchased from either Ace Auto (Supplier Code 101) or Better Auto Buys (Supplier Code 102).  They should not be purchased from other supplier such as Cars R Us (Supplier Code 103) or Delta Parts (Supplier Code 104).  However, Ace Auto and Better Auto Buys may be approved to supply other products.  For simplicity, once a supplier is approved for a part, they are never removed from the list.

You decide to develop the order entry program as follows.  The user begins the program by running the “neword” program.  The system will display an Order Entry banner and today’s date.  The system prompts the user for a Part Number to be ordered.  Then, the part’s description and current quantity in stock is displayed.  Next, the system prompts the user for a Supplier Code.  The Supplier’s address and phone number are displayed (note the format displayed).  Lastly, the system prompts for the quantity to be ordered.  As a result, the system assigns this transaction a unique order number and updates the data in the database.  A message is displayed to the user that the order has been processed and the order number assigned to the transactions.

 
A sample Order Entry Transaction is as follows:
The bold, italic, underlined text indicates user input.

SQL> @ c:\neword
**********  Order Entry Screen  **********


Date:  13-APR-15

Enter Part Number (format 999): 101
Part Description:  Air Filter
Quantity in stock: 120

Enter Supplier Code (format 999): 102
Address:             456 Main Street
City, State  Zip:    Huntington Beach, CA  92647
Phone:               (714) 555-2222

Enter Quantity to Order: 20


Your order has been processed.  Order number is: 1010
SQL>

If there are errors in the order entry process (Order placed with a supplier that is not approved for the part, supplier does not exists, part number does not exist, etc), the order should NOT be processed and the confirmation message should NOT be displayed.

Below is an example of an order placed with a supplier that is not approved for the part:

SQL> @ c:\neword
**********  Order Entry Screen  **********


Date:  13-APR-15

Enter Part Number (format 999): 101
Part Description:  Air Filter
Quantity in stock: 120

Enter Supplier Code (format 999): 104
Address:             444 Auto Way
City, State  Zip:    Long Beach, CA  90840
Phone:               (562) 555-4444

Enter Quantity to Order: 20

INSERT INTO ORD (ORD_NUM, PART_NUM, SUPPLIER_CODE, ORD_QTY, ORD_DATE)
*
ERROR at line 1:
ORA-02291: integrity constraint (AASHER.ORD_PARTNUM_SUPPCODE_FK) violated -
parent key not found

SQL>

 
Below is an example of the error messages that should be displayed when the user enters characters instead of number for part number, supplier code, or quantity (the error also appears if part numbers or supplier numbers are more than three digits).  Also, notice the information displayed for non-existent parts and/or supplier codes.

Make sure to display similar error messages in your program.

SQL> @ c:\neword
**********  Order Entry Screen  **********


Date:  13-APR-15

Enter Part Number (format 999): Hello
SP2-0598: "Hello" does not match input format "999"
Enter Part Number (format 999): 9999
SP2-0598: "9999" does not match input format "999"
Enter Part Number (format 999): 250
Part Description:  Part does not exist
Quantity in stock: N/A

Enter Supplier Code (format 999): Test
SP2-0425: "Test" is not a valid NUMBER
Enter Supplier Code (format 999): 1
Address:             Supplier Not Found
City, State  Zip:    NA
Phone:               NA

Enter Quantity to Order: Ten
SP2-0425: "Ten" is not a valid NUMBER
Enter Quantity to Order: 10

INSERT INTO ORD (ORD_NUM, PART_NUM, SUPPLIER_CODE, ORD_QTY, ORD_DATE)
*
ERROR at line 1:
ORA-02291: integrity constraint (AASHER.ORD_PARTNUM_SUPPCODE_FK) violated -
parent key not found

SQL>

 
Receiving an Order (receive.sql) and Updating Existing Parts (partupdate.sql)
Details for these transactions will be discussed later.

Parts Inventory and Supplier Report (partsupp.sql)
The users at AA spend a lot of time verifying which suppliers are approved for specific part numbers.  They have requested a report that shows this data.  Additionally, it would be helpful to know how much of each part number is in inventory.  If the item is low, new orders must be placed.  The below report would solve the users requests.  They could use it to see which items need to be orders and which suppliers are approved.

SQL> @ C:\PARTSUPP

                -------- Parts Inventory Level and Supplier Report --------Page:         1


      Part                          Qty In   Supplier Supplier             Supplier
       No. Description               Stock       Code Name                 Phone
---------- -------------------- ---------- ---------- -------------------- --------------
       100 Oil Filter                   75        101 ACE Auto             (562) 555-1234

       101 Air Filter                  120        101 ACE Auto             (562) 555-1234
                                                  102 Better Auto Buys     (714) 555-2222

       102 Oil Can                     320        101 ACE Auto             (562) 555-1234
                                                  102 Better Auto Buys     (714) 555-2222
                                                  103 Cars R Us            (562) 555-3333
                                                  104 Delta Parts          (562) 555-4444

       103 Spark Plugs                 200        101 ACE Auto             (562) 555-1234
                                                  103 Cars R Us            (562) 555-3333
                                                  104 Delta Parts          (562) 555-4444

       104 Antifreeze                  100        101 ACE Auto             (562) 555-1234
                                                  104 Delta Parts          (562) 555-4444
SQL>


 
Supplier’s Order status Report (suppstatus.sql)
The users at AA also spend a lot of time searching for completed and open orders.  Additionally, they would like to know which of their suppliers deliver parts quickly and which take a long time.  This is tracked by computing the time for the order to get delivered (Order Receive Date minus Order Placed Date) and averaging this for all of the supplier’s orders (closed orders).  You develop the following report.

SQL> @ c:\suppstatus

                -------- Supplier's Order Status Report -------- Page:


  Supplier Supplier                  Order Order    Receive     Number
      Code Name                        No. Date     Date       of Days STATUS
---------- -------------------- ---------- -------- -------- --------- --------
       101 ACE Auto                   1000 04/03/15 04/06/15      3.00 Complete
                                      1001 04/03/15 04/05/15      2.00 Complete
                                      1002 04/04/15 04/05/15      1.00 Complete
                                      1003 04/04/15 04/05/15      1.00 Complete
                                      1004 04/03/15 04/06/15      3.00 Complete
                                      1013 04/13/15                    Open
-----------------------------------                             ---------
Avg Days                                                          2.00

       102 Better Auto Buys           1005 04/04/15 04/04/15       .00 Complete
                                      1006 04/03/15 04/06/15      3.00 Complete
                                      1010 04/13/15                    Open
                                      1011 04/13/15 04/13/15       .00 Complete
-----------------------------------                             ---------
Avg Days                                                          1.00

       103 Cars R Us                  1007 04/05/15 04/07/15      2.00 Complete
                                      1012 04/13/15                    Open
-----------------------------------                              ---------
Avg Days                                                          2.00

       104 Delta Parts                1008 04/05/15 04/06/15      1.00 Complete
                                      1009 04/03/15 04/05/15      2.00 Complete
-----------------------------------                              ---------
Avg Days                                                          1.50

SQL>

 

PART 1 – PROJECT Deliverable – Review Solution In Class – NOT TO TURN IN
Note: this is to make sure that you have the proper table structures to continue with the program.

•	Detailed ER Diagram
o	Show Entities, all attributes, and relationships
o	Note: Tables should be in Third Normal Form
•	Oracle Script to create all the tables.
o	create.sql  – SQL code that creates all the tables, with Primary and Foreign keys defined.  
o	CreateOutput.txt – Output of above script (Recall, in your script file or in SQL*Plus, SET ECHO ON and spool the output to CreateOuput.txt)  
o	See print outs of both files: create.sql and CreateOutput.txt.  

                                  ----------------------------------------------
                                  CALIFORNIA STATE UNIVERSITY, LONG BEACH
                                  IS 380 – Database Management
                                  Spring 2015 Term
                                  PROJECT – PART 2
                                  Monday Class/Session 2 – Monday, May 4
                                  Wednesday Class/Session 1 – Wednesday, May 6

NOTE
Below output is shown using SQL*Plus.  You may use SQL Developer, but keep in mind differences discussed in class.

OVERVIEW
(See last page for project deliverables)
This is part 2 of the project which you have already began working on.
For part 2, you are going to implement the system using SQL Plus.

This will involve the following five scripts:
1.	neword.sql
2.	receive.sql
3.	partupdate.sql
4.	partsupp.sql
5.	suppstatus.sql

DETAILS
Detailed screen shots were already shown in Part 1 of the project for neword.sql, partsupp.sql, and suppstatus.sql.  The remaining two scripts and details of the reports are shown below:

 
Receiving an Order (receive.sql)
This is the transaction used to receive an order.  To initiate this program, the user runs the “receive” program.  The system displays a Receive Order Screen banner and prompts for an order number.  Next, relevant information regarding the order is displayed (See screen below).  The system asks the user if the information is OK and if he/she would like to continue processing the receipt.  If not, the user presses [CTRL] [C] twice to abort the program.  If the user wants to continue, he/she presses the [ENTER] key.  Notice that you CAN NOT receive a partial order.  By pressing [ENTER], you accept the entire quantity.  This is consistent with your observation at AA’s receiving dock.  After pressing the [ENTER] key, the system updates the database and displays the new quantity in stock.

A sample receipt transaction is as follows:

SQL> @ c:\receive
**********  Receive Order Screen  **********


Date:  13-APR-15

Enter Order Number to Receive (format 9999): 1010
SP2-0137: DEFINE requires a value following equal sign

Order Found.  Verify the following:

Part Number               : 101
Part Description          : Air Filter
Current Inventory Quantity: 120

Supplier Code: 102
Supplier Name: Better Auto Buys

Date Ordered    : 13-APR-15
Date Received   :
Quantity Ordered: 20

** Again, verify order information:                               **
** In case of discrepancy (Order not found, Wrong quantity, etc.) **
**    Press [CTRL] [C] twice to ABORT                             **
** If correct, press [ENTER] to continue                          **


New Quantity in Stock: 140

SQL>

 
If you attempt to receive an order that has already been received, the order should not be processed.  See the following transaction and notice that that the New Quantity in Stock does not change.

SQL> @ c:\receive
**********  Receive Order Screen  **********


Date:  13-APR-15

Enter Order Number to Receive (format 9999): 1010

Order Found.  Verify the following:

Part Number               : 101
Part Description          : Air Filter
Current Inventory Quantity: 140

Supplier Code: 102
Supplier Name: Better Auto Buys

Date Ordered    : 13-APR-15
Date Received   : 13-APR-15
Quantity Ordered: 20

** Again, verify order information:                               **
** In case of discrepancy (Order not found, Wrong quantity, etc.) **
**    Press [CTRL] [C] twice to ABORT                             **
** If correct, press [ENTER] to continue                          **


New Quantity in Stock: 140

SQL>

 
Not only is the New Quantity in Stock not changed, but the Date Received should not be changed either.  The following screens demonstrate this:

SQL> @ c:\receive
**********  Receive Order Screen  **********


Date:  13-APR-15

Enter Order Number to Receive (format 9999): 1000

Order Found.  Verify the following:

Part Number               : 101
Part Description          : Air Filter
Current Inventory Quantity: 140

Supplier Code: 101
Supplier Name: ACE Auto

Date Ordered    : 03-APR-15
Date Received   : 06-APR-15
Quantity Ordered: 20

** Again, verify order information:                               **
** In case of discrepancy (Order not found, Wrong quantity, etc.) **
**    Press [CTRL] [C] twice to ABORT                             **
** If correct, press [ENTER] to continue                          **


New Quantity in Stock: 140

SQL> @ c:\receive
**********  Receive Order Screen  **********


Date:  13-APR-15

Enter Order Number to Receive (format 9999): 1000

Order Found.  Verify the following:

Part Number               : 101
Part Description          : Air Filter
Current Inventory Quantity: 140

Supplier Code: 101
Supplier Name: ACE Auto

Date Ordered    : 03-APR-15
Date Received   : 06-APR-15
Quantity Ordered: 20

** Again, verify order information:                               **
** In case of discrepancy (Order not found, Wrong quantity, etc.) **
**    Press [CTRL] [C] twice to ABORT                             **
** If correct, press [ENTER] to continue                          **


New Quantity in Stock: 140

SQL>


Finally, the system should catch common data entry errors.  The system should not accept order numbers that are not numeric or longer than four digits in length.  Additionally, if an order number does not exist, they system should display the data as shown below:


SQL> @ c:\receive
**********  Receive Order Screen  **********


Date:  13-APR-15

Enter Order Number to Receive (format 9999): seven
SP2-0425: "seven" is not a valid NUMBER
Enter Order Number to Receive (format 9999): test
SP2-0425: "test" is not a valid NUMBER
Enter Order Number to Receive (format 9999): 1

ORDER NOT FOUND!!! Rerun the program!!!

Part Number               : N/A
Part Description          : N/A
Current Inventory Quantity: N/A

Supplier Code: N/A
Supplier Name: N/A

Date Ordered    : N/A
Date Received   : N/A
Quantity Ordered: N/A

** Again, verify order information:                               **
** In case of discrepancy (Order not found, Wrong quantity, etc.) **
**    Press [CTRL] [C] twice to ABORT                             **
** If correct, press [ENTER] to continue                          **

SQL>

 
Updating Part Information (partupdate.sql)
Occasionally, you have found that the Inventory Control users need to modify part information.  They either need to change the part description (rare) or adjust quantity on hand (more common).  This is due to parts getting damaged, misplaced, stolen, etc.

To update part information, the user executes the “partupdate” program.  A part update banner is shown and the user is prompted for a part number.  When the part number is entered, the system displays the part description and current quantity on hand.  They user is then asked to verify the information and press [ENTER] to proceed or [CTRL] [C] twice to abort.  If enter is pressed, the user is prompted to a new part description.  Notice that if [ENTER] is pressed, the default value is the current parts description.  Next, the user is asked for the current inventory quantity.  Again, if the user presses enter, the default value is the current inventory count.  Once these values are entered, the system updates the database and displays the new values.

See the following transaction:

SQL> @ c:\partupdate
**********  Update Part Information  **********

Enter Part Number to Update (format 999): 101

Part Number Found.  Below is the current information:
Part Description          : Air Filter
Current Inventory Quantity: 140

** Verify part information:                            **
** If you DON'T want to update OR Part NOT FOUND,      **
**    Press [CTRL] [C] twice to ABORT                  **
** If you wish to continue and update, press [ENTER]   **[ENTER]

Type New Description or press [ENTER] to accept current description
(Current Description: Air Filter): [ENTER]

Type New Quantity or press [ENTER] to accept Current Inventory Quantity
(Current Inventory Quantity: 140): 145

Updated Part Number Information:
Part Number               :        101
Part Description          : Air Filter
Current Inventory Quantity: 145

SQL>

 
If you were to type data at both prompts, both values will be updated.  See the following transaction:


SQL> @ c:\partupdate
**********  Update Part Information  **********

Enter Part Number to Update (format 999): 101

Part Number Found.  Below is the current information:
Part Description          : Air Filter
Current Inventory Quantity: 145

** Verify part information:                            **
** If you DON'T want to update OR Part NOT FOUND,      **
**    Press [CTRL] [C] twice to ABORT                  **
** If you wish to continue and update, press [ENTER]   **[ENTER]

Type New Description or press [ENTER] to accept current description
(Current Description: Air Filter): Air Filter

Type New Quantity or press [ENTER] to accept Current Inventory Quantity
(Current Inventory Quantity: 145): 155

Updated Part Number Information:
Part Number               :        101
Part Description          : Air Filter
Current Inventory Quantity: 155

SQL>

As with the previous transactions, the system should catch common user data entry errors.  If non-numeric data or numbers that are greater than three digits in length are entered at the prompt, the user should see the errors below.  Additionally, if a non-existent part number is entered, the data below should be displayed.

SQL> @ c:\partupdate
**********  Update Part Information  **********

Enter Part Number to Update (format 999): twenty
SP2-0598: "twenty" does not match input format "999"
Enter Part Number to Update (format 999): 2000
SP2-0598: "2000" does not match input format "999"
Enter Part Number to Update (format 999): 20

PART NUMBER NOT FOUND!!! Rerun the program!!!
Part Description          : N/A
Current Inventory Quantity: N/A

** Verify part information:                            **
** If you DON'T want to update OR Part NOT FOUND,      **
**    Press [CTRL] [C] twice to ABORT                  **
** If you wish to continue and update, press [ENTER]   **


 

Parts Inventory and Supplier Report (partsupp.sql)
The users at AA spend a lot of time verifying which suppliers are approved for specific part numbers.  They have requested a report that shows this data.  Additionally, it would be helpful to know how much of each part number is in inventory.  If the item is low, new orders must be placed.  The below report would solve the users requests.  They could use it to see which items need to be orders and which suppliers are approved.

SQL> @ C:\PARTSUPP

                -------- Parts Inventory Level and Supplier Report --------Page:         1


      Part                          Qty In   Supplier Supplier             Supplier
       No. Description               Stock       Code Name                 Phone
---------- -------------------- ---------- ---------- -------------------- --------------
       100 Oil Filter                   75        101 ACE Auto             (562) 555-1234

       101 Air Filter                  120        101 ACE Auto             (562) 555-1234
                                                  102 Better Auto Buys     (714) 555-2222

       102 Oil Can                     320        101 ACE Auto             (562) 555-1234
                                                  102 Better Auto Buys     (714) 555-2222
                                                  103 Cars R Us            (562) 555-3333
                                                  104 Delta Parts          (562) 555-4444

       103 Spark Plugs                 200        101 ACE Auto             (562) 555-1234
                                                  103 Cars R Us            (562) 555-3333
                                                  104 Delta Parts          (562) 555-4444

       104 Antifreeze                  100        101 ACE Auto             (562) 555-1234
                                                  104 Delta Parts          (562) 555-4444

SQL>

Note the following report characteristics:
•	Report title.
•	Headings titles
•	Report skips line after each part number
•	Report only displays the part number, description, and quantity in stock once.
•	Suppliers for the same product are displayed in ascending order by supplier name (in this case supplier number also, but in your case make sure to sort by supplier name)
•	Supplier’s phone number format.

 
Supplier’s Order status Report (suppstatus.sql)
The users at AA also spend a lot of time searching for completed and open orders.  Additionally, they would like to know which of their suppliers deliver parts quickly and which take a long time.  This is tracked by computing the time for the order to get delivered (Order Receive Date minus Order Placed Date) and averaging this for all of the supplier’s orders (closed orders).  You develop the following report.

SQL> @ c:\suppstatus

                -------- Supplier's Order Status Report -------- Page:


  Supplier Supplier                  Order Order    Receive     Number
      Code Name                        No. Date     Date       of Days STATUS
---------- -------------------- ---------- -------- -------- --------- --------
       101 ACE Auto                   1000 04/03/15 04/06/15      3.00 Complete
                                      1001 04/03/15 04/05/15      2.00 Complete
                                      1002 04/04/15 04/05/15      1.00 Complete
                                      1003 04/04/15 04/05/15      1.00 Complete
                                      1004 04/03/15 04/06/15      3.00 Complete
                                      1013 04/13/15                    Open
-----------------------------------                              ---------
Avg Days                                                          2.00

       102 Better Auto Buys           1005 04/04/15 04/04/15       .00 Complete
                                      1006 04/03/15 04/06/15      3.00 Complete
                                      1010 04/13/15                    Open
                                      1011 04/13/15 04/13/15       .00 Complete
-----------------------------------                              ---------
Avg Days                                                          1.00

       103 Cars R Us                  1007 04/05/15 04/07/15      2.00 Complete
                                      1012 04/13/15                    Open
-----------------------------------                              ---------
Avg Days                                                          2.00

       104 Delta Parts                1008 04/05/15 04/06/15      1.00 Complete
                                      1009 04/03/15 04/05/15      2.00 Complete
-----------------------------------                              ---------
Avg Days                                                          1.50

SQL>

Note the following report characteristics:
•	Report title.
•	Headings titles
•	Report computes average after each supplier.
•	Note format of average days and title for average line.
•	Report skips a line after every supplier
•	Report only displays the supplier number and supplier name once.
•	Suppliers are displayed in ascending order (by supplier number). For each supplier, the orders are displayed in ascending order.
•	Status is shown for each order as Open or Complete (Determined by Receive Date).
•	Date formats (Order Date and Receive Date).

 

PART 2 – PROJECT Deliverable

Note:  Run CREATE.SQL (solution to project part 1) to create the appropriate tables.  This script will also create a sequence to be used for the Order Numbers.  Details of the sequence are:
Sequence Name:  ORDERNUMBER
Starts with: 1010
Increments by:  1.

If you decide to use different table structures and/or different data, you must resubmit your create script with your project deliverables.  

You need to submit the following:

•	Electronic copy of the following programs:
o	CREATE.SQL – Optional (see above)
o	NEWORD.SQL – Described in this document.
o	RECEIVE.SQL – Described in this document.
o	PARTUPDATE.SQL – Described in this document.
o	PARTSUPP.SQL – Described in this document.
o	SUPPSTATUS.SQL – Described in this document.
•	A print out of the following:
o	Each of the above SQL files
o	Table structures (Optional) – If you modified the tables given in the solution, provide a listing of the new table structures (use the DESC command.  e.g. DESC SUPPLIER) for all tables used.  Additionally, provide your detailed ER Diagram.





