--SET ENVIRONMENT 
SET FEEDBACK OFF
SET HEADING OFF
SET VERIFY OFF

--DISPLAY THE INPUT SCREEN
PROMPT **********  Order Entry Screen  **********
PROMPT
SELECT 'DATE: ', SYSDATE FROM DUAL;
PROMPT 

--DEFINE VARIABLES
DEFINE v_part_desc = 'Part Does Not Exist'
DEFINE v_part_qty = 'N/A'
DEFINE v_sup_address = 'Supplier Not Found'
DEFINE v_sup_city = 'N/A'
DEFINE v_sup_state = ''
DEFINE v_sup_zip = ''
DEFINE v_sup_phone = 'N/A'


--PROMPT USER TO ENTER PART NUMBER TO ORDER
ACCEPT v_part_num NUMBER FORMAT 999 PROMPT 'Enter Part Number (format 999): '
PROMPT

--CREATE FILE TO CHANGE VARIABLES' VALUES
SET TERMOUT OFF
SPOOL /home/oracle/IS380/partinfo.sql

SELECT 'DEFINE v_part_desc = ' || '''' || part_description || '''' || CHR(10) ||
       'DEFINE v_part_qty = ' || '''' || part_qtyonhand || ''''
FROM part
WHERE part_num = &v_part_num;

SPOOL OFF

--RUN FILE TO CHANGE VARIABLES' VALUES
@/home/oracle/IS380/partinfo.sql
SET TERMOUT ON

--DISPLAY PART'S INFORMATION
PROMPT Part Description : &v_part_desc
PROMPT Quantity In Stock: &v_part_qty
PROMPT

--PROMPT USER TO ENTER SUPPLIER CODE
ACCEPT v_sup_code NUMBER FORMAT 999 PROMPT 'Enter Supplier Code (format 999): '
PROMPT

--CREATE FILE TO CHANGE VARIABLES' VALUES
SET TERMOUT OFF
SPOOL /home/oracle/IS380/suppinfo.sql

SELECT 'DEFINE v_sup_address= ' || '''' || supplier_address || '''' || CHR(10) ||
       'DEFINE v_sup_city= ' || '''' || supplier_city || '''' || CHR(10) ||
       'DEFINE v_sup_state= ' || '''' || supplier_state || '''' || CHR(10) ||
       'DEFINE v_sup_zip= ' || '''' || supplier_zip|| '''' || CHR(10) ||
       'DEFINE v_sup_phone= ''(' || supplier_areacode || ') ' || supplier_phone || ''''
FROM supplier
WHERE supplier_code = &v_sup_code;

SPOOL off

--RUN FILE TO CHANGE VARIABLES' VALUES
@ /home/oracle/IS380/suppinfo.sql
SET TERMOUT ON

--DISPLAY SUPPLIER'S INFORMATION
PROMPT Address        : &v_sup_address
PROMPT City, State-Zip: &v_sup_city, &v_sup_state &v_sup_zip 
PROMPT Phone          : &v_sup_phone
PROMPT

--PROMPT USER TO ENTER QUANTITY TO ORDER
ACCEPT v_ord_qty NUMBER PROMPT "Enter Quantity to Order: "
PROMPT

--UPDATE ORDER TABLE WITH NEW ORDER
INSERT INTO ord (ord_num, part_num, supplier_code, ord_qty, ord_date)
  VALUES ((SELECT MAX(ord_num)+1 FROM ord), &v_part_num, &v_sup_code, &v_ord_qty, TRUNC(SYSDATE));
  

--CREATE FILE TO GET NEW ORDER NUMBER  
SET TERMOUT OFF
SPOOL /home/oracle/IS380/ordnumber.sql

SELECT 'DEFINE v_ord_number= ' || MAX(ord_num)
FROM ord;

SPOOL OFF

--RUN FILE TO GET NEW ORDER NUMBER
@ /home/oracle/IS380/ordnumber.sql
SET TERMOUT ON

--PRINT OUT NEW ORDER NUMBER
SELECT  'Your order has been processed. Order number is: ' || &v_ord_number
FROM ord
WHERE ord_num = &v_ord_number;

COMMIT;

SET FEEDBACK ON
SET HEADING ON
SET VERIFY ON
