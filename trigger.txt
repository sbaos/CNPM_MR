-- --Trigger4-- 

DELIMITER //

CREATE TRIGGER DELETE_ITEM_FROM_CART_AFTER_BUY
AFTER INSERT ON payment_item
FOR EACH ROW
BEGIN
    DELETE FROM cart_has_article
    WHERE CartID IN (
        SELECT CartID
        FROM reader
        WHERE id IN (
            SELECT ReaderID
            FROM payment
            WHERE payment.id = NEW.paymentID
        )
    )
    AND ArticleID = NEW.ArticleID;
END;
//

DELIMITER ;

-- --Trigger5

DELIMITER //

CREATE TRIGGER CHECK_BEFORE_ADD_ITEM_TO_CART
BEFORE INSERT ON cart_has_article
FOR EACH ROW
BEGIN
    -- Check if the article already exists in payment_item for the same reader
    IF EXISTS (
        SELECT 1
        FROM payment_item
        WHERE ArticleID = NEW.ArticleID
          AND PaymentID IN (
              SELECT id
              FROM payment
              WHERE ReaderID IN (
                  SELECT id
                  FROM reader
                  WHERE CartID = NEW.CartID
              )
          )
    ) THEN
        -- Raise an error to prevent the insertion
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The article already bought so cannot be added to the cart.';
    END IF;
END;
//

DELIMITER ;


-- --trigger6

DELIMITER //

CREATE TRIGGER CHECK_BEFORE_ADD_DISCOUNT_ON_PAYMENT
BEFORE INSERT ON DISCOUNT_ON_PAYMENT
FOR EACH ROW
BEGIN
    DECLARE discount_count_payment INT;
    DECLARE discount_count_payment_item INT;
    DECLARE total_discount_count INT;
    
    SELECT COUNT(*)
    INTO discount_count_payment
    FROM DISCOUNT_ON_PAYMENT
    WHERE PaymentID = NEW.PaymentID;

    SELECT COUNT(*)
    INTO discount_count_payment_item
    FROM DISCOUNT_ON_PAYMENT_ITEM
    WHERE PaymentItemID IN (
        SELECT id
        FROM PAYMENT_ITEM
        WHERE PaymentID = NEW.PaymentID
    );

    SET total_discount_count = discount_count_payment + discount_count_payment_item;

    IF total_discount_count >= 6 THEN
        DELETE FROM PAYMENT WHERE id = NEW.PaymentID;

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The maximum number of discounts for this payment has been reached. The payment has been deleted.';
    END IF;
END;
//

CREATE TRIGGER CHECK_BEFORE_ADD_DISCOUNT_ON_PAYMENT_ITEM
BEFORE INSERT ON DISCOUNT_ON_PAYMENT_ITEM
FOR EACH ROW
BEGIN
    DECLARE discount_count_payment INT;
    DECLARE discount_count_payment_item INT;
    DECLARE total_discount_count INT;
    
    SELECT COUNT(*)
    INTO discount_count_payment
    FROM DISCOUNT_ON_PAYMENT
    WHERE PaymentID = (
        SELECT PaymentID
        FROM PAYMENT_ITEM
        WHERE id = NEW.PaymentItemID
    );

    SELECT COUNT(*)
    INTO discount_count_payment_item
    FROM DISCOUNT_ON_PAYMENT_ITEM
    WHERE PaymentItemID IN (
        SELECT id
        FROM PAYMENT_ITEM
        WHERE PaymentID = (
            SELECT PaymentID
            FROM PAYMENT_ITEM
            WHERE id = NEW.PaymentItemID
        )
    );

    SET total_discount_count = discount_count_payment + discount_count_payment_item;

    IF total_discount_count >= 6 THEN
        DELETE FROM PAYMENT_ITEM WHERE id = NEW.PaymentItemID;

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The maximum number of discounts for this payment has been reached. The payment item has been deleted.';
    END IF;
END;
//

DELIMITER ;

-- trigger 3-- 
DELIMITER //

CREATE TRIGGER 	ADD_SUB_TO_DATA_WHEN_ADD_SA
AFTER INSERT ON science_article
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE datasetName VARCHAR(255);
    DECLARE subcategoryName VARCHAR(255);
    
    DECLARE cur CURSOR FOR
        SELECT abd.DatasetName, acs.SubcategoryName
        FROM article_benchmark_dataset abd
        JOIN article_categorize_subcategory acs
        ON abd.ArticleID = NEW.id
        JOIN dataset d ON abd.DatasetName = d.name
        JOIN subcategory s
        ON acs.CategoryName = s.CategoryName
        AND acs.SubcategoryName = s.SubcategoryName;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO datasetName, subcategoryName;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Check if the Dataset-Subcategory relationship already exists
        IF NOT EXISTS (
            SELECT 1
            FROM dataset_for_subcategory dfs
            WHERE dfs.DatasetName = datasetName
            AND dfs.CategoryName = (SELECT CategoryName FROM subcategory WHERE SubcategoryName = subcategoryName)
            AND dfs.SubcategoryName = subcategoryName
        ) THEN
            -- Insert the new Dataset-Subcategory relationship if it doesn't exist
            INSERT INTO dataset_for_subcategory (DatasetName, CategoryName, SubcategoryName)
            VALUES (datasetName, 
                    (SELECT CategoryName FROM subcategory WHERE SubcategoryName = subcategoryName), 
                    subcategoryName);
        END IF;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;


-- trigger 1
DELIMITER //
CREATE TRIGGER check_viptier_on_update
BEFORE UPDATE ON READER_HAS_DISCOUNT_COUPON
FOR EACH ROW
BEGIN
    DECLARE reader_viptier INT;
    DECLARE coupon_viptier_required INT;

    SELECT VipTier INTO reader_viptier 
    FROM reader 
    WHERE id = NEW.ReaderID;

    SELECT VipTierRequired INTO coupon_viptier_required 
    FROM discount_coupon 
    WHERE id = NEW.CouponID;

    IF reader_viptier < coupon_viptier_required THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Reader\'s VipTier does not meet the required VipTier for the discount coupon.';
    END IF;
END //
DELIMITER ;
