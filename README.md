<h2 align="center">IS380 Final Project</h2>
<h3 align= "center">Database Management</h3>

<h4 align="center">CALIFORNIA STATE UNIVERSITY, LONG BEACH</h4>
<h4 align="center">IS 380 – Database Management</h4>
<h4 align="center">Spring 2015 Term – Session 1</h4>
<h4 align="center">PROJECT – PART 1</h4>

NOTE
Below output is shown using SQL*Plus.  You may use SQL Developer, but keep in mind differences discussed in class.

OVERVIEW
You have recently been hired at A1 Automobile Parts (AA).  All of AA’s work is done in a paper-based system.  Recently, AA has found it difficult to generate reports and process new orders.  So, you have been asked to design and implement an order processing system.  You will first design and implement the system with your current knowledge of Oracle SQL and SQL Plus.  Eventually, you envision that you will generate a web-based or client/server application.  

Although there is a lot you can do to automate AA’s processes, you decide to concentrate on the tasks most frequently performed.  You decide to start the program by completing the following:<br>
<ul>
<li>An Order Entry Screen</li>
<li>Receiving an Order</li>
<li>Updating Part Information</li>
<li>Parts Inventory and Supplier Report</li>
<li>Supplier’s Order status Report</li>
</ul>
<br>
<strong>Order Entry Screen (neword.sql)</strong><br>
This is where users begin to place an order.  After your analysis of the current paper based process, you have made the following observations: <br>
<ul>
<li>AA places orders with multiple suppliers</li>
<li>For each order placed with a supplier, only one part is ordered</li>
<li>To procure a specific part (to create an order), you must check for approved suppliers.  Although AA uses many suppliers, they have approved designated suppliers for specific parts.  For example, Air Filters (Part Number 101), can only be purchased from either Ace Auto (Supplier Code 101) or Better Auto Buys (Supplier Code 102).  They should not be purchased from other supplier such as Cars R Us (Supplier Code 103) or Delta Parts (Supplier Code 104).  However, Ace Auto and Better Auto Buys may be approved to supply other products.  For simplicity, once a supplier is approved for a part, they are never removed from the list</li>
</ul>
You decide to develop the order entry program as follows.  The user begins the program by running the “neword” program.  The system will display an Order Entry banner and today’s date.  The system prompts the user for a Part Number to be ordered.  Then, the part’s description and current quantity in stock is displayed.  Next, the system prompts the user for a Supplier Code.  The Supplier’s address and phone number are displayed (note the format displayed).  Lastly, the system prompts for the quantity to be ordered.  As a result, the system assigns this transaction a unique order number and updates the data in the database.  A message is displayed to the user that the order has been processed and the order number assigned to the transactions. <br>

A sample Order Entry Transaction is as follows:<br>
The bold, italic, underlined text indicates user input.

SQL> @ c:\neword<br>
**********  Order Entry Screen  **********<br>

Date:  13-APR-15<br>

Enter Part Number (format 999): 101<br>
Part Description:  Air Filter<br>
Quantity in stock: 120<br>

Enter Supplier Code (format 999): 102<br>
Address:             456 Main Street<br>
City, State  Zip:    Huntington Beach, CA  92647<br>
Phone:               (714) 555-2222<br>

Enter Quantity to Order: 20<br>


Your order has been processed.  Order number is: 1010<br>
SQL>

If there are errors in the order entry process (Order placed with a supplier that is not approved for the part, supplier does not exists, part number does not exist, etc), the order should NOT be processed and the confirmation message should NOT be displayed.

Below is an example of an order placed with a supplier that is not approved for the part:

SQL> @ c:\neword<br>
**********  Order Entry Screen  **********


Date:  13-APR-15

Enter Part Number (format 999): 101<br>
Part Description:  Air Filter<br>
Quantity in stock: 120<br>

Enter Supplier Code (format 999): 104<br>
Address:             444 Auto Way<br>
City, State  Zip:    Long Beach, CA  90840<br>
Phone:               (562) 555-4444<br>

Enter Quantity to Order: 20<br>

INSERT INTO ORD (ORD_NUM, PART_NUM, SUPPLIER_CODE, ORD_QTY, ORD_DATE)<br>
*<br>
ERROR at line 1:<br>
ORA-02291: integrity constraint (AASHER.ORD_PARTNUM_SUPPCODE_FK) violated -
parent key not found<br>

SQL>

 
Below is an example of the error messages that should be displayed when the user enters characters instead of number for part number, supplier code, or quantity (the error also appears if part numbers or supplier numbers are more than three digits).  Also, notice the information displayed for non-existent parts and/or supplier codes.

Make sure to display similar error messages in your program.

SQL> @ c:\neword<br>
**********  Order Entry Screen  **********

Date:  13-APR-15

Enter Part Number (format 999): Hello<br>
SP2-0598: "Hello" does not match input format "999"<br>
Enter Part Number (format 999): 9999<br>
SP2-0598: "9999" does not match input format "999"<br>
Enter Part Number (format 999): 250<br>
Part Description:  Part does not exist<br>
Quantity in stock: N/A<br>

Enter Supplier Code (format 999): Test<br>
SP2-0425: "Test" is not a valid NUMBER<br>
Enter Supplier Code (format 999): 1<br>
Address:             Supplier Not Found<br>
City, State  Zip:    NA<br>
Phone:               NA<br>

Enter Quantity to Order: Ten<br>
SP2-0425: "Ten" is not a valid NUMBER<br>
Enter Quantity to Order: 10<br>

INSERT INTO ORD (ORD_NUM, PART_NUM, SUPPLIER_CODE, ORD_QTY, ORD_DATE)<br>
*<br>
ERROR at line 1:<br>
ORA-02291: integrity constraint (AASHER.ORD_PARTNUM_SUPPCODE_FK) violated -
parent key not found<br>

SQL>

Receiving an Order (receive.sql) and Updating Existing Parts (partupdate.sql)<br>
Details for these transactions will be discussed later.<br>

<strong>Parts Inventory and Supplier Report (partsupp.sql)</strong><br>
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

 
<strong>Supplier’s Order status Report (suppstatus.sql)</strong><br>
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


<hr>
<h2 align="center"> Part 2 </h2>
OVERVIEW
This is part 2 of the project which you have already began working on.<br>
For part 2, you are going to implement the system using SQL Plus.<br>

This will involve the following five scripts:<br>
<ol>
<li>neword.sql</li>
<li>receive.sql</li>
<li>partupdate.sql</li>
<li>partsupp.sql</li>
<li>suppstatus.sql</li>
</ol>

DETAILS<br>
Detailed screen shots were already shown in Part 1 of the project for neword.sql, partsupp.sql, and suppstatus.sql.  The remaining two scripts and details of the reports are shown below:<br>

<strong>Receiving an Order (receive.sql)</strong><br>
This is the transaction used to receive an order.  To initiate this program, the user runs the “receive” program.  The system displays a Receive Order Screen banner and prompts for an order number.  Next, relevant information regarding the order is displayed (See screen below).  The system asks the user if the information is OK and if he/she would like to continue processing the receipt.  If not, the user presses [CTRL] [C] twice to abort the program.  If the user wants to continue, he/she presses the [ENTER] key.  Notice that you CAN NOT receive a partial order.  By pressing [ENTER], you accept the entire quantity.  This is consistent with your observation at AA’s receiving dock.  After pressing the [ENTER] key, the system updates the database and displays the new quantity in stock.

A sample receipt transaction is as follows:<br>

SQL> @ c:\receive<br>
**********  Receive Order Screen  **********

Date:  13-APR-15

Enter Order Number to Receive (format 9999): 1010<br>
SP2-0137: DEFINE requires a value following equal sign<br>

Order Found.  Verify the following:<br>

Part Number               : 101<br>
Part Description          : Air Filter<br>
Current Inventory Quantity: 120<br>

Supplier Code: 102<br>
Supplier Name: Better Auto Buys<br>

Date Ordered    : 13-APR-15<br>
Date Received   :<br>
Quantity Ordered: 20<br>

** Again, verify order information:                               ** <br>
** In case of discrepancy (Order not found, Wrong quantity, etc.) ** <br>
**    Press [CTRL] [C] twice to ABORT                             ** <br>
** If correct, press [ENTER] to continue                          ** <br>


New Quantity in Stock: 140

SQL>
 
If you attempt to receive an order that has already been received, the order should not be processed.  See the following transaction and notice that that the New Quantity in Stock does not change.

SQL> @ c:\receive<br>
**********  Receive Order Screen  **********<br>


Date:  13-APR-15

Enter Order Number to Receive (format 9999): 1010

Order Found.  Verify the following:

Part Number               : 101<br>
Part Description          : Air Filter<br>
Current Inventory Quantity: 140<br>

Supplier Code: 102<br>
Supplier Name: Better Auto Buys<br>

Date Ordered    : 13-APR-15<br>
Date Received   : 13-APR-15<br>
Quantity Ordered: 20<br>

** Again, verify order information:                               **<br>
** In case of discrepancy (Order not found, Wrong quantity, etc.) **<br>
**    Press [CTRL] [C] twice to ABORT                             **<br>
** If correct, press [ENTER] to continue                          **<br>


New Quantity in Stock: 140

SQL>

 
Not only is the New Quantity in Stock not changed, but the Date Received should not be changed either.  The following screens demonstrate this:

SQL> @ c:\receive<br>
**********  Receive Order Screen  **********<br>


Date:  13-APR-15

Enter Order Number to Receive (format 9999): 1000

Order Found.  Verify the following:

Part Number               : 101<br>
Part Description          : Air Filter<br>
Current Inventory Quantity: 140<br>

Supplier Code: 101<br>
Supplier Name: ACE Auto<br>

Date Ordered    : 03-APR-15<br>
Date Received   : 06-APR-15<br>
Quantity Ordered: 20<br>

** Again, verify order information:                               **<br>
** In case of discrepancy (Order not found, Wrong quantity, etc.) **<br>
**    Press [CTRL] [C] twice to ABORT                             **<br>
** If correct, press [ENTER] to continue                          **<br>


New Quantity in Stock: 140

SQL> @ c:\receive<br>
**********  Receive Order Screen  **********<br>


Date:  13-APR-15

Enter Order Number to Receive (format 9999): 1000

Order Found.  Verify the following:

Part Number               : 101<br>
Part Description          : Air Filter<br>
Current Inventory Quantity: 140<br>

Supplier Code: 101<br>
Supplier Name: ACE Auto<br>

Date Ordered    : 03-APR-15<br>
Date Received   : 06-APR-15<br>
Quantity Ordered: 20<br>

** Again, verify order information:                               **<br>
** In case of discrepancy (Order not found, Wrong quantity, etc.) **<br>
**    Press [CTRL] [C] twice to ABORT                             **<br>
** If correct, press [ENTER] to continue                          **<br>


New Quantity in Stock: 140

SQL>


Finally, the system should catch common data entry errors.  The system should not accept order numbers that are not numeric or longer than four digits in length.  Additionally, if an order number does not exist, they system should display the data as shown below:


SQL> @ c:\receive<br>
**********  Receive Order Screen  **********<br>


Date:  13-APR-15

Enter Order Number to Receive (format 9999): seven<br>
SP2-0425: "seven" is not a valid NUMBER<br>
Enter Order Number to Receive (format 9999): test<br>
SP2-0425: "test" is not a valid NUMBER<br>
Enter Order Number to Receive (format 9999): 1<br>

ORDER NOT FOUND!!! Rerun the program!!!

Part Number               : N/A<br>
Part Description          : N/A<br>
Current Inventory Quantity: N/A<br>

Supplier Code: N/A<br>
Supplier Name: N/A<br>

Date Ordered    : N/A<br>
Date Received   : N/A<br>
Quantity Ordered: N/A<br>

** Again, verify order information:                               **<br>
** In case of discrepancy (Order not found, Wrong quantity, etc.) **<br>
**    Press [CTRL] [C] twice to ABORT                             **<br>
** If correct, press [ENTER] to continue                          **<br>

SQL>

 
<strong>Updating Part Information (partupdate.sql)</strong><br>
Occasionally, you have found that the Inventory Control users need to modify part information.  They either need to change the part description (rare) or adjust quantity on hand (more common).  This is due to parts getting damaged, misplaced, stolen, etc.<br>

To update part information, the user executes the “partupdate” program.  A part update banner is shown and the user is prompted for a part number.  When the part number is entered, the system displays the part description and current quantity on hand.  They user is then asked to verify the information and press [ENTER] to proceed or [CTRL] [C] twice to abort.  If enter is pressed, the user is prompted to a new part description.  Notice that if [ENTER] is pressed, the default value is the current parts description.  Next, the user is asked for the current inventory quantity.  Again, if the user presses enter, the default value is the current inventory count.  Once these values are entered, the system updates the database and displays the new values.

See the following transaction:

SQL> @ c:\partupdate<br>
**********  Update Part Information  **********<br>

Enter Part Number to Update (format 999): 101

Part Number Found.  Below is the current information:<br>
Part Description          : Air Filter<br>
Current Inventory Quantity: 140<br>

** Verify part information:                            **<br>
** If you DON'T want to update OR Part NOT FOUND,      **<br>
**    Press [CTRL] [C] twice to ABORT                  **<br>
** If you wish to continue and update, press [ENTER]   **[ENTER]<br>

Type New Description or press [ENTER] to accept current description<br>
(Current Description: Air Filter): [ENTER]<br>

Type New Quantity or press [ENTER] to accept Current Inventory Quantity<br>
(Current Inventory Quantity: 140): 145<br>

Updated Part Number Information:<br>
Part Number               :        101<br>
Part Description          : Air Filter<br>
Current Inventory Quantity: 145<br>

SQL>

 
If you were to type data at both prompts, both values will be updated.  See the following transaction:


SQL> @ c:\partupdate<br>
**********  Update Part Information  **********<br>

Enter Part Number to Update (format 999): 101

Part Number Found.  Below is the current information:<br>
Part Description          : Air Filter<br>
Current Inventory Quantity: 145<br>

** Verify part information:                            **<br>
** If you DON'T want to update OR Part NOT FOUND,      **<br>
**    Press [CTRL] [C] twice to ABORT                  **<br>
** If you wish to continue and update, press [ENTER]   **[ENTER]<br>

Type New Description or press [ENTER] to accept current description<br>
(Current Description: Air Filter): Air Filter<br>

Type New Quantity or press [ENTER] to accept Current Inventory Quantity<br>
(Current Inventory Quantity: 145): 155<br>

Updated Part Number Information:<br>
Part Number               :        101<br>
Part Description          : Air Filter<br>
Current Inventory Quantity: 155<br>

SQL>

As with the previous transactions, the system should catch common user data entry errors.  If non-numeric data or numbers that are greater than three digits in length are entered at the prompt, the user should see the errors below.  Additionally, if a non-existent part number is entered, the data below should be displayed.

SQL> @ c:\partupdate<br>
**********  Update Part Information  **********<br>

Enter Part Number to Update (format 999): twenty<br>
SP2-0598: "twenty" does not match input format "999"<br>
Enter Part Number to Update (format 999): 2000<br>
SP2-0598: "2000" does not match input format "999"<br>
Enter Part Number to Update (format 999): 20<br>

PART NUMBER NOT FOUND!!! Rerun the program!!!<br>
Part Description          : N/A<br>
Current Inventory Quantity: N/A<br>

** Verify part information:                            **<br>
** If you DON'T want to update OR Part NOT FOUND,      **<br>
**    Press [CTRL] [C] twice to ABORT                  **<br>
** If you wish to continue and update, press [ENTER]   **<br>


<strong>Parts Inventory and Supplier Report (partsupp.sql)</strong><br>
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

Note the following report characteristics:<br>
•	Report title<br>
•	Headings titles<br>
•	Report skips line after each part number<br>
•	Report only displays the part number, description, and quantity in stock once<br>
•	Suppliers for the same product are displayed in ascending order by supplier name (in this case supplier number also, but in your case make sure to sort by supplier name)<br>
•	Supplier’s phone number format<br>

 
<strong>Supplier’s Order status Report (suppstatus.sql)</strong><br>
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

Note the following report characteristics:<br>
•	Report title.<br>
•	Headings titles.<br>
•	Report computes average after each supplier.<br>
•	Note format of average days and title for average line.<br>
•	Report skips a line after every supplier.<br>
•	Report only displays the supplier number and supplier name once.<br>
•	Suppliers are displayed in ascending order (by supplier number). For each supplier, the orders are displayed in ascending order.<br>
•	Status is shown for each order as Open or Complete (Determined by Receive Date).<br>
•	Date formats (Order Date and Receive Date).<br>

