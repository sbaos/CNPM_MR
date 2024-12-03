
drop function if EXISTS CALCULATE_SUM_MONEY_OF_PAYMENT_BEFORE_APPLY_COUPON ;
DELIMITER //
CREATE FUNCTION CALCULATE_SUM_MONEY_OF_PAYMENT_BEFORE_APPLY_COUPON(P_ID int) 
RETURNS decimal(10,2) DETERMINISTIC
BEGIN
 DECLARE total_price decimal(10,2);
 select sum(Price)
 into total_price
 from science_article as SA
 join payment_item as PI on SA.id = PI.ArticleID
 where PI.PaymentID = P_ID;
 return total_price;
END //

DELIMITER ;

drop function if EXISTS CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_ARTICLE_DC ;
DELIMITER //

CREATE FUNCTION CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_ARTICLE_DC(PI_ID INT) 
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE total_discounted_price DECIMAL(10,2);

    SELECT 
         IFNULL(SUM(DiscountedPrice), 0)
    INTO 
        total_discounted_price
    FROM (
        SELECT 
            ArticleCouponID,
            PaymentItemID,
            ArticleID,
            PaymentID,
            CASE 
                WHEN DiscountUnit = '$' THEN Discount
                WHEN DiscountUnit = '%' THEN (Discount * Price / 100)
                ELSE 0
            END AS DiscountedPrice,
            Price AS BasePrice
        FROM (
            SELECT 
                dopi.ArticleCouponID,
                dopi.PaymentItemID,
                pi.ArticleID,
                pi.PaymentID,
                dc.Discount AS Discount,
                dc.DiscountUnit,
                sa.Price
            FROM 
                discount_on_payment_item dopi
            JOIN 
                payment_item pi ON dopi.PaymentItemID = pi.id
            JOIN 
                discount_coupon dc ON dopi.ArticleCouponID = dc.id
            JOIN 
                science_article sa ON pi.ArticleID = sa.id
            WHERE 
                dopi.PaymentItemID = PI_ID
        ) AS SubQuery
    ) AS Final;

    RETURN total_discounted_price;
END //

DELIMITER ;

drop function if EXISTS CAL_SUM_MONEY_DISCOUNT_ON_P_AFTER_APPLY_COSTB_DC ;

DELIMITER //

CREATE FUNCTION CAL_SUM_MONEY_DISCOUNT_ON_P_AFTER_APPLY_COSTB_DC(P_ID INT) 
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE total_discounted_price DECIMAL(10,2);
    DECLARE base_price DECIMAL(10,2);
    select CALCULATE_SUM_MONEY_OF_PAYMENT_BEFORE_APPLY_COUPON(P_ID)
    into base_price;
    select  IFNULL(sum(DiscountedPrice),0) as Total
    into total_discounted_price
from (
select 
    Discount, 
    DiscountUnit,
    BasePrice,
     CASE 
                WHEN DiscountUnit = '$' THEN Discount
                WHEN DiscountUnit = '%' THEN (Discount * BasePrice / 100)
                ELSE 0
	END AS DiscountedPrice
from (
select Discount as Discount, DiscountUnit, base_price as BasePrice
from discount_on_payment as dop
join discount_coupon as dc on dop.PaymentCounponID = dc.id
join cost_base_discount_coupon as cbdc on cbdc.id = PaymentCounponID
where dop.PaymentID = P_ID and base_price >= cbdc.CostCondition
) as A ) as B;
    RETURN total_discounted_price;
END //

DELIMITER ;



drop function if EXISTS CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_ASD_ON_P ;

DELIMITER //

CREATE FUNCTION CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_ASD_ON_P(PI_ID INT) 
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE total_discounted_price DECIMAL(10,2);
    
    SELECT IFNULL(SUM(DiscountedPrice), 0) AS Total
    INTO total_discounted_price
    FROM (
        
  
     select Price,Discount,DiscountUnit,
 	  CASE 
                 WHEN DiscountUnit = '$' THEN Discount
                 WHEN DiscountUnit = '%' THEN (Discount * Price / 100)
                 ELSE 0
END AS DiscountedPrice
from (
SELECT 
    AVG(Price) AS Price,
    AVG(Discount) AS Discount,
    DiscountUnit
FROM payment_item AS pi
JOIN discount_on_payment AS dop ON dop.PaymentID = pi.PaymentID
JOIN discount_coupon AS dc ON dop.PaymentCounponID = dc.id
JOIN discount_on_subcategory AS dos ON dos.SubcategoryCouponID = dc.id
JOIN science_article AS sa ON sa.id = pi.ArticleID
JOIN article_categorize_subcategory AS acs 
    ON acs.ArticleID = sa.id 
    AND acs.SubcategoryName = dos.SubcategoryName 
    AND acs.CategoryName = dos.CategoryName
WHERE pi.id = PI_ID
GROUP BY dop.PaymentCounponID, DiscountUnit
) as A) as B;
    
    RETURN total_discounted_price;
END //

DELIMITER ;


drop function if EXISTS CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_PAEDC_ON_P ;


DELIMITER //

CREATE FUNCTION CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_PAEDC_ON_P(PI_ID INT) 
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE total_discounted_price DECIMAL(10,2);
    select  IFNULL(sum(DiscountedPrice),0) as Total
	into total_discounted_price
from (
select Discount, DiscountUnit,  Price,
	  CASE 
                WHEN DiscountUnit = '$' THEN Discount
                WHEN DiscountUnit = '%' THEN (Discount * Price / 100)
                ELSE 0
	END AS DiscountedPrice
from (
select  Price, Discount as Discount, DiscountUnit
from payment_item as pi 
join discount_on_payment as dop on dop.PaymentID = pi.PaymentID
join science_article as sa on sa.id = pi.ArticleID 
join discount_coupon as dc on dop.PaymentCounponID = dc.id
join discount_on_academic_event as padc on padc.EventCouponID = dc.id 
join paper as p on p.id = sa.id and p.EventID = padc.EventID
where pi.id = PI_ID
) as A) as B;
    RETURN total_discounted_price;
END //

DELIMITER ;

drop function CALCULATE_SUM_MONEY_OF_PAYMENT_AFTER_APPLY_ALL_COUPON;
DELIMITER //

CREATE FUNCTION CALCULATE_SUM_MONEY_OF_PAYMENT_AFTER_APPLY_ALL_COUPON(P_ID INT) 
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE total_base_price DECIMAL(10,2);
    DECLARE total_discount_all_total_price DECIMAL(10,2);
    DECLARE total_price_all_item_price DECIMAL(10,2);

    -- Calculate total base price before applying coupons
    SELECT CALCULATE_SUM_MONEY_OF_PAYMENT_BEFORE_APPLY_COUPON(P_ID)
    INTO total_base_price;

    -- Calculate the total price of all items after discounts
    SELECT 
        SUM(CASE
                WHEN Price - (PAEDC + ASD + ADC) > 0 THEN Price - (PAEDC + ASD + ADC)
                ELSE 0
            END) AS FinalPrice
    INTO total_price_all_item_price
    FROM (
        SELECT 
            pi.id, 
            ArticleID,
            CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_PAEDC_ON_P(pi.id) AS PAEDC,
            CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_ASD_ON_P(pi.id) AS ASD,
            CAL_SUM_MONEY_DISCOUNT_ON_PI_AFTER_APPLY_ARTICLE_DC(pi.id) AS ADC,
            Price
        FROM 
            payment_item AS pi
        JOIN 
            science_article AS sa ON sa.id = pi.ArticleID
        WHERE 
            PaymentID = P_ID
    ) AS A;

    -- Calculate the total discount after applying all costs
    SELECT 
        CAL_SUM_MONEY_DISCOUNT_ON_P_AFTER_APPLY_COSTB_DC(P_ID)
    INTO total_discount_all_total_price;

    -- Return the final price after applying all discounts and items, ensuring a minimum of 0
    RETURN total_price_all_item_price - total_discount_all_total_price;
END //

DELIMITER ;


select CALCULATE_SUM_MONEY_OF_PAYMENT_AFTER_APPLY_ALL_COUPON(2);
