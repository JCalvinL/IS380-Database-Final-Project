SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET ESCAPE ON

DEFINE warning = 'PART NUMBER NOT FOUND!!! Rerun the program!!!'
DEFINE v_part_desc = 'N/A'
DEFINE v_part_qty = 'N/A'

PROMPT ********** Update Part Information **********
PROMPT
ACCEPT v_part_num NUMBER FORMAT 999 PROMPT 'Enter Part Number to Update (format 999): '
PROMPT

SET TERMOUT OFF
SPOOL /home/oracle/IS380/partupdateinfo.sql

SELECT  'DEFINE warning = ''Part Number Found. Below is the current information:''' || CHR(10) ||
        'DEFINE v_part_desc = ' || '''' || part_description || '''' || CHR(10) ||
        'DEFINE v_part_qty  = ' || '''' || part_qtyonhand || ''''
FROM part
WHERE part_num = &v_part_num;

SPOOL OFF
SET TERMOUT ON

@/home/oracle/IS380/partupdateinfo

PROMPT &warning
PROMPT Part Description          : &v_part_desc
PROMPT Current Inventory Quantity: &v_part_qty
PROMPT
PROMPT ** Verify part information: **
PROMPT ** If you DON\'T want to update OR Part NOT FOUND, **
PROMPT ** Press [CTRL] [C] twice to ABORT **
Pause "** If you wish to continue and update, press [ENTER] **"

PROMPT Type New Description or press [ENTER] to accept current description
ACCEPT v_new_desc CHAR PROMPT '(Current Description: &v_part_desc): ' DEFAULT '&v_part_desc'
PROMPT

PROMPT Type New Quantity or press [ENTER] to accept current inventory quantity
ACCEPT v_new_qty NUMBER PROMPT '(Current Inventory Quantity: &v_part_qty): ' DEFAULT '&v_part_qty'
PROMPT

UPDATE part
SET part_description = '&v_new_desc',
    part_qtyonhand = '&v_new_qty'
WHERE part_num = &v_part_num;

PROMPT Updated Part Number Information:
SELECT 'Part Number               : ' || part_num,
       'Part Description          : ' ||  part_description,
       'Current Inventory Quantity: ' || part_qtyonhand
FROM part
WHERE part_num = &v_part_num;

COMMIT;


