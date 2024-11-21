
DELIMITER //

CREATE TRIGGER VIP_UP 
AFTER UPDATE ON payment_item
FOR EACH ROW
BEGIN
    DECLARE TOTAL DECIMAL(10, 2);
    DECLARE READER_ID INT;

    -- Get the readerid from the updated payment_item row
    SELECT readerid 
    INTO READER_ID
    FROM payment
    WHERE id = NEW.PaymentID;

    -- Calculate the total sum after applying all coupons for the given reader
    SELECT SUM(CALCULATE_SUM_MONEY_OF_PAYMENT_AFTER_APPLY_ALL_COUPON(pi.PaymentID))
    INTO TOTAL
    FROM PAYMENT p
    JOIN payment_item pi ON pi.PaymentID = p.id
    WHERE p.readerid = READER_ID;

    -- Update the VIP tier based on the total
    IF TOTAL >= 10 AND TOTAL < 100 THEN
        UPDATE READER SET VIP_TIER = 1 WHERE ID = READER_ID;
    ELSEIF TOTAL >= 100 AND TOTAL < 200 THEN
        UPDATE READER SET VIP_TIER = 2 WHERE ID = READER_ID;
    ELSEIF TOTAL >= 200 AND TOTAL < 500 THEN
        UPDATE READER SET VIP_TIER = 3 WHERE ID = READER_ID;
    ELSEIF TOTAL >= 500 AND TOTAL < 1000 THEN
        UPDATE READER SET VIP_TIER = 4 WHERE ID = READER_ID;
    ELSEIF TOTAL >= 1000 THEN
        UPDATE READER SET VIP_TIER = 5 WHERE ID = READER_ID;
    END IF;
END //

DELIMITER ;



DELIMITER //

CREATE TRIGGER VIP_UP_INSERT
AFTER INSERT ON payment_item
FOR EACH ROW
BEGIN
    DECLARE TOTAL DECIMAL(10, 2);
    DECLARE READER_ID INT;

    -- Get the readerid from the updated payment_item row
    SELECT readerid 
    INTO READER_ID
    FROM payment
    WHERE id = NEW.PaymentID;

    -- Calculate the total sum after applying all coupons for the given reader
    SELECT SUM(CALCULATE_SUM_MONEY_OF_PAYMENT_AFTER_APPLY_ALL_COUPON(pi.PaymentID))
    INTO TOTAL
    FROM PAYMENT p
    JOIN payment_item pi ON pi.PaymentID = p.id
    WHERE p.readerid = READER_ID;

    -- Update the VIP tier based on the total
    IF TOTAL >= 10 AND TOTAL < 100 THEN
        UPDATE READER SET VIPTIER = 1 WHERE ID = READER_ID;
    ELSEIF TOTAL >= 100 AND TOTAL < 200 THEN
        UPDATE READER SET VIPTIER = 2 WHERE ID = READER_ID;
    ELSEIF TOTAL >= 200 AND TOTAL < 500 THEN
        UPDATE READER SET VIPTIER = 3 WHERE ID = READER_ID;
    ELSEIF TOTAL >= 500 AND TOTAL < 1000 THEN
        UPDATE READER SET VIPTIER = 4 WHERE ID = READER_ID;
    ELSEIF TOTAL >= 1000 THEN
        UPDATE READER SET VIPTIER = 5 WHERE ID = READER_ID;
    END IF;
END //

DELIMITER ;



drop trigger VIP_UP_INSERT

