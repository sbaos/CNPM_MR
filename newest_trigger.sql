DELIMITER //

CREATE TRIGGER DELETE_ITEM_FROM_CART_AFTER_BUY
AFTER INSERT ON payment_item
FOR EACH ROW
BEGIN
    DELETE FROM cart_has_article
    WHERE CartID = (
        SELECT CartID
        FROM reader
        WHERE id = (
            SELECT ReaderID
            FROM payment
            WHERE payment.id = NEW.paymentID
        )
    )
    AND ArticleID = NEW.ArticleID;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER CHECK_BEFORE_ADD_ITEM_TO_CART
BEFORE INSERT ON cart_has_article
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM payment_item
        WHERE ArticleID = NEW.ArticleID
          AND PaymentID in (
              SELECT id
              FROM payment
              WHERE ReaderID = (
                  SELECT id
                  FROM reader
                  WHERE CartID = NEW.CartID
              )
          )
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The article already bought and cannot be added to the cart.';
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER CHECK_BEFORE_ADD_DISCOUNT_ON_PAYMENT
BEFORE INSERT ON DISCOUNT_ON_PAYMENT
FOR EACH ROW
BEGIN
    DECLARE total_discount_count INT;

   SELECT COUNT(*) into total_discount_count
FROM (
    SELECT PaymentCounponID -- Use the actual column name here
    FROM DISCOUNT_ON_PAYMENT 
    WHERE PaymentID = NEW.PaymentID
    UNION ALL
    SELECT ArticleCouponID -- Use the actual column name here
    FROM DISCOUNT_ON_PAYMENT_ITEM 
    WHERE PaymentItemID IN (
        SELECT Id -- Use the actual column name here
        FROM PAYMENT_ITEM 
        WHERE PaymentID = NEW.PaymentID
    )
) AS DiscountCounts;


    IF total_discount_count >= 6 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Maximum discounts for this payment have been reached.';
    END IF;
END //

DELIMITER ;

-- drop trigger CHECK_BEFORE_ADD_DISCOUNT_ON_PAYMENT;
DELIMITER //

CREATE TRIGGER ADD_SUB_TO_DATA_WHEN_BENCHMARK_SUCCESS
AFTER INSERT ON article_benchmark_dataset
FOR EACH ROW
BEGIN
    -- Only proceed if the result column is "success"
    IF NEW.result is not null THEN
        INSERT INTO dataset_for_subcategory (DatasetName, CategoryName, SubcategoryName)
        SELECT NEW.DatasetName, 
               s.CategoryName, 
               acs.SubcategoryName
        FROM article_categorize_subcategory acs
        JOIN subcategory s ON acs.SubcategoryName = s.SubcategoryName
                          AND acs.CategoryName = s.CategoryName
        LEFT JOIN dataset_for_subcategory dfs ON dfs.DatasetName = NEW.DatasetName
                                              AND dfs.CategoryName = s.CategoryName
                                              AND dfs.SubcategoryName = s.SubcategoryName
        WHERE acs.ArticleID = NEW.ArticleID
          AND dfs.DatasetName IS NULL; -- Ensure no duplicates
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER VIP_UP_UPDATE_STATUS
AFTER UPDATE ON payment
FOR EACH ROW
BEGIN
    DECLARE TOTAL DECIMAL(10, 2);
    DECLARE READER_ID INT;
    IF NEW.status = 'success' THEN

        -- Get the reader ID from the updated payment row
        SELECT readerid 
        INTO READER_ID
        FROM payment
        WHERE id = NEW.id;

        -- Calculate total sum after applying all coupons
        SELECT SUM(CALCULATE_SUM_MONEY_OF_PAYMENT_AFTER_APPLY_ALL_COUPON(id))
        INTO TOTAL
	FROM PAYMENT
	WHERE readerid=READER_ID;

        -- Insert debugging info into log table
      
        -- Update the VIP tier based on the total
        IF TOTAL >= 10 AND TOTAL < 100 THEN
            UPDATE reader SET VipTier = '1' WHERE id = READER_ID;
        ELSEIF TOTAL >= 100 AND TOTAL < 200 THEN
            UPDATE reader SET VipTier = '2' WHERE id = READER_ID;  
        ELSEIF TOTAL >= 200 AND TOTAL < 500 THEN
            UPDATE reader SET VipTier = '3' WHERE id = READER_ID;
        ELSEIF TOTAL >= 500 AND TOTAL < 1000 THEN
            UPDATE reader SET VipTier = '4' WHERE id = READER_ID;
        ELSEIF TOTAL >= 1000 THEN
            UPDATE reader SET VipTier = '5' WHERE id = READER_ID;
        END IF;

    END IF;
END //

DELIMITER ;

DROP TRIGGER IF EXISTS CHECK_VIP_TIER_BEFORE_USE_DISCOUNT;

DELIMITER //

CREATE TRIGGER CHECK_VIP_TIER_BEFORE_USE_DISCOUNT
BEFORE INSERT ON discount_on_payment
FOR EACH ROW
BEGIN
    DECLARE R_VipTier VARCHAR(10);
    DECLARE VipTierRequired_ VARCHAR(10);
    DECLARE A VARCHAR(10);  
    
    select VipTierRequired
    into VipTierRequired_
    FROM discount_coupon AS dc
	WHERE dc.id = NEW.PaymentCounponID ;
    
    SELECT VipTier
    INTO R_VipTier
    FROM reader
    WHERE reader.id = (SELECT readerID FROM payment WHERE payment.ID = NEW.PaymentID);

    IF R_VipTier < VipTierRequired_ THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Reader does not meet VIP tier requirement for this discount';
    END IF;

END //

DELIMITER ;



DROP TRIGGER IF EXISTS CHECK_VIP_TIER_BEFORE_USE_DISCOUNT_ON_A;

DELIMITER //

CREATE TRIGGER CHECK_VIP_TIER_BEFORE_USE_DISCOUNT_ON_A
BEFORE INSERT ON discount_on_payment_item
FOR EACH ROW
BEGIN
    DECLARE R_VipTier VARCHAR(10);
    DECLARE VipTierRequired_ VARCHAR(10);
    DECLARE A VARCHAR(10);  
    
    select VipTierRequired
    into VipTierRequired_
    FROM discount_coupon AS dc
	WHERE dc.id = NEW.ArticleCouponID ;
    
    SELECT VipTier
    INTO R_VipTier
    FROM reader
    WHERE reader.id = (SELECT readerID FROM payment WHERE payment.ID in 
    (
    select PaymentID 
    from payment_Item
    where 1 = 1
    and payment_Item.id = NEW.PaymentItemID));

    IF R_VipTier < VipTierRequired_ THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Reader does not meet VIP tier requirement for this discount';
    END IF;

END //

DELIMITER ;


DROP TRIGGER IF EXISTS UPDATE_USE_ATTRIBUTE_WHEN_A_DOP;

DELIMITER //

CREATE TRIGGER UPDATE_USE_ATTRIBUTE_WHEN_A_DOP
AFTER INSERT ON discount_on_payment
FOR EACH ROW
BEGIN
	DECLARE R_ID int;

    SELECT reader.id
    INTO R_ID
    FROM reader
    WHERE reader.id = (SELECT readerID FROM payment WHERE payment.ID = NEW.PaymentID);
	
    UPDATE reader_has_discount_coupon set reader_has_discount_coupon.use = 1
    where ReaderID = R_ID and CoupinID  = NEW.PaymentCounponID; 

END //

DELIMITER ;

DROP TRIGGER IF EXISTS UPDATE_USE_ATTRIBUTE_WHEN_A_ADC;

DELIMITER //

CREATE TRIGGER UPDATE_USE_ATTRIBUTE_WHEN_A_ADC
AFTER INSERT ON discount_on_payment_item
FOR EACH ROW
BEGIN
	DECLARE R_ID int;

	SELECT reader.id
    INTO R_ID
    FROM reader
    WHERE reader.id = (SELECT readerID FROM payment WHERE payment.ID in 
    (
    select PaymentID 
    from payment_Item
    where 1 = 1
    and payment_Item.id = NEW.PaymentItemID));

	
    UPDATE reader_has_discount_coupon set reader_has_discount_coupon.use = 1
    where ReaderID = R_ID and CoupinID  = NEW.ArticleCouponID; 

END //

DELIMITER ;




