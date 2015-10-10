--SET ENVIRONMENT
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF

--DISPLAY INPUT SCREEN
PROMPT ********** Receive Order Screen **********
PROMPT
SELECT 'DATE: ', SYSDATE FROM DUAL;
PROMPT

--DEFINE VARIABLE
DEFINE warning = 'ORDER NOT FOUND!!! Rerun the program!!!'
DEFINE v_part_num = 'N/A'
DEFINE v_part_description = 'N/A'
DEFINE v_part_qtyonhand = 'N/A'
DEFINE v_supplier_code = 'N/A'
DEFINE v_supplier_name = 'N/A'
DEFINE v_ord_date = 'N/A'
DEFINE v_ord_recdate ='N/A'
DEFINE v_ord_qty = 'N/A'

--PROMPT USER TO INPUT ORDER NUMBER TO RECEIVE
ACCEPT v_ord_num NUMBER FORMAT 9999 PROMPT "Enter Order Number to Receive: "

--CREATE FILE TO CHANGE VARIABLES' VALUES
SET TERMOUT OFF
SPOOL /home/oracle/IS380/receiveinfo.sql

SELECT 'DEFINE warning = ''Order Found. Verify the following: ''' || CHR(10) ||
       'DEFINE v_part_num = '         || '''' || o.part_num || '''' || CHR(10) ||
       'DEFINE v_part_description = ' || '''' || part_description || '''' || CHR(10) ||
       'DEFINE v_part_qtyonhand = '   || '''' || part_qtyonhand || '''' || CHR(10) ||
       'DEFINE v_supplier_code = '    || '''' || s.supplier_code || '''' || CHR(10) ||
       'DEFINE v_supplier_name = '    || '''' || supplier_name || '''' || CHR(10) ||
       'DEFINE v_ord_date = '         || '''' || ord_date || '''' || CHR(10) ||
       'DEFINE v_ord_recdate = '      || '''' || ord_recdate || '''' || CHR(10) ||
       'DEFINE v_ord_qty = '          || '''' || ord_qty || ''''
FROM ord o INNER JOIN part p     ON o.part_num = p.part_num
           INNER JOIN supplier s ON s.supplier_code = o.supplier_code
WHERE ord_num = &v_ord_num;
           
SPOOL OFF
SET TERMOUT ON

--RUN FILE TO CHANGE VARIABLES' VALUES
START /home/oracle/IS380/receiveinfo

--DISPLAY ORDER'S INFORMATION
PROMPT
PROMPT &warning
PROMPT
PROMPT Part Number               : &v_part_num
PROMPT Part Description          : &v_part_description
PROMPT Current Inventory Quantity: &v_part_qtyonhand
PROMPT
PROMPT Supplier Code: &v_supplier_code
PROMPT Supplier Name: &v_supplier_name
PROMPT
PROMPT Date Ordered    : &v_ord_date
PROMPT Date Received   : &v_ord_recdate
PROMPT Quantity Ordered: &v_ord_qty
PROMPT
PROMPT ** Again, verify order information: ** 
PROMPT ** In case of discrepancy (Order not found, Wrong quantity, etc.) **
PROMPT ** Press [CTRL] [C] twice to ABORT **
PAUSE "** If correct, press [ENTER] to continue **"


SET TERMOUT OFF
SPOOL /home/oracle/IS380/newqty.sql

SELECT 'DEFINE v_newqty= ' || '''' || DECODE (o.ord_recdate, NULL, p.part_qtyonhand + o.ord_qty
                                           , p.part_qtyonhand) ||  ''''
FROM part p INNER JOIN ord o ON p.part_num = o.part_num
WHERE ord_num = &v_ord_num;

SPOOL OFF
SET TERMOUT ON

--RUN FILE TO UPDATE PART QTY
@/home/oracle/IS380/newqty.sql
                                
--UPDATE PART QTY                                                                                                                                                  
UPDATE part
SET part_qtyonhand = &v_newqty
WHERE part_num = (SELECT part_num
                  FROM ord
                  WHERE ord_num = &v_ord_num);

--UPDATE DATE
UPDATE ord
SET ord_recdate = TRUNC(SYSDATE),
    ord_recqty = &v_ord_qty
WHERE ord_num = &v_ord_num
AND ord_recdate IS NULL;

--DISPLAY NEW QUANTITY
SELECT 'New Quantity in Stock: ' || part_qtyonhand
FROM part p INNER JOIN ord o ON p.part_num = o.part_num
WHERE o.ord_num = &v_ord_num;

COMMIT;

SET FEEDBACK ON
SET VERIFY ON
SET HEADING ON


