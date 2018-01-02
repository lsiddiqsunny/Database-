1.
CREATE OR REPLACE TRIGGER Updaterating
BEFORE INSERT
ON REVIEW
FOR EACH ROW
DECLARE
CO number;
Total Number;
BEGIN
CO:=1;
Total:= :NEW.RATING;
FOR R IN (SELECT RATING FROM REVIEW WHERE BOOK_ID= :NEW.BOOK_ID)
LOOP
CO :=CO+1;
Total:= Total+R.Rating;
END LOOP;
Update Book
Set Rating=(Total/CO)
Where Book_id= :NEW.BOOK_ID;
END ;
/
2.
CREATE OR REPLACE TRIGGER Updatestatus
AFTER INSERT
ON CUSTOMER_PURCHASE
FOR EACH ROW
DECLARE
BEGIN
UPDATE CUSTOMER_ORDER
SET STATUS=1
WHERE ORDER_ID= :NEW.ORDER_ID;
END ;
/

3.
CREATE OR REPLACE TRIGGER Updatebookamount
AFTER INSERT
ON CUSTOMER_ORDER
FOR EACH ROW
DECLARE

BEGIN
UPDATE BOOK
SET TOTAL_IN_STORAGE=TOTAL_IN_STORAGE- :NEW.AMOUNT
WHERE BOOK_ID= :NEW.BOOK_ID;
UPDATE BOOK
SET TOTAL_SOLD=TOTAL_SOLD+ :NEW.AMOUNT
WHERE BOOK_ID= :NEW.BOOK_ID;
END ;
/
4.

CREATE OR REPLACE TRIGGER NoticeAll
BEFORE INSERT
ON Notice
FOR EACH ROW
DECLARE

BEGIN
IF :NEW.JOB_ID IS NULL THEN
FOR R IN (select distinct JOB_ID from employee e where manager_id= :NEW.GIVENBY)
LOOP
INSERT INTO NOTICE VALUES((SELECT COUNT(*) FROM NOTICE)+1,:NEW.NOTICE,SYSDATE,:NEW.GIVENBY,:NEW.BRANCH_ID,R.JOB_ID);
END LOOP;
END IF;

END ;
/
