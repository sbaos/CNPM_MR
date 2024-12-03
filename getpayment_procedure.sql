DROP procedure get_payment_history;

DELIMITER //
CREATE PROCEDURE get_payment_history(
	IN reader_id INT,
    IN time_start timestamp,
    IN time_end timestamp,
    IN min_price DECIMAL(10,2),
    IN max_price DECIMAL(10,2),
    IN order_flag INT
)
BEGIN

	SET @where_clause = 'WHERE 1=1';
    IF reader_id IS NOT NULL THEN
		SET @where_clause = CONCAT(@where_clause, ' AND  payment.ReaderID = ', reader_id);
	END IF;
    
    IF time_start IS NOT NULL THEN
		SET @where_clause = CONCAT(@where_clause, ' AND  payment.Time >= " ', time_start, '"');
	END IF;
    
    IF time_end IS NOT NULL THEN
		SET @where_clause = CONCAT(@where_clause, ' AND  payment.Time <= " ', time_end,'"');
	END IF;
    
    SET @having_clause = 'HAVING cost >=0  ';
    IF min_price IS NOT NULL THEN
		SET @having_clause = CONCAT(@having_clause, ' AND  cost >= ', min_price);
	END IF;
    
    IF max_price IS NOT NULL THEN
		SET @having_clause = CONCAT(@having_clause, ' AND  cost <= ', max_price);
	END IF;
    
    SET @order_clause = 'ORDER BY cost ';
    IF order_flag IS NULL OR order_flag = 0 THEN
		SET @order_clause = CONCAT(@order_clause , 'DESC');
	ELSE
		SET @order_clause = CONCAT(@order_clause , 'ASC');
	END IF;
    
    SET @sql = CONCAT('    SELECT payment.id , payment.time , CALCULATE_SUM_MONEY_OF_PAYMENT_AFTER_APPLY_ALL_COUPON(payment.id) as cost,(CALCULATE_SUM_MONEY_OF_PAYMENT_BEFORE_APPLY_COUPON(payment.id) - CALCULATE_SUM_MONEY_OF_PAYMENT_AFTER_APPLY_ALL_COUPON(payment.id)) as discount, AVG(science_article.Price - CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_ARTICLE_DC(payment_item.Id) - CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_ASD_ON_P(payment_item.Id) - CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_PAEDC_ON_P(payment_item.Id)) as average_item_cost
	FROM payment join (payment_item JOIN science_article ON payment_item.ArticleID = science_article.id) ON payment.id = payment_item.PaymentID ',@where_clause,' 	GROUP BY payment.id ' ,@having_clause,' ',@order_clause);
		
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;