    DROP PROCEDURE IF EXISTS filter_science_article;
DELIMITER //

CREATE PROCEDURE filter_science_article (
IN _author VARCHAR(255),
    IN _title VARCHAR(255),
    IN year_num INT,
    IN _academic_event VARCHAR(255),
    IN _subcategory VARCHAR(255),
    IN priceMin DECIMAL(10, 2),
    IN priceMax DECIMAL(10, 2)
)
BEGIN
SET @where_clause = 'WHERE 1=1';
    
IF _author IS NOT NULL THEN
        SET @where_clause = CONCAT(@where_clause, ' AND author.PenName LIKE "%', _author, '%"');
    END IF;
    
    IF _title IS NOT NULL THEN
        SET @where_clause = CONCAT(@where_clause, ' AND science_article.Title LIKE "%', _title, '%"');
    END IF;
    
    IF year_num IS NOT NULL THEN
SET @where_clause = CONCAT(@where_clause, ' AND YEAR(science_article.PublishDate) = ', year_num);
    END IF;
    
    IF _academic_event IS NOT NULL THEN
SET @where_clause = CONCAT(@where_clause, ' AND academic_event.name LIKE "%', _academic_event, '%"');
    END IF;
    
    IF _subcategory IS NOT NULL THEN
SET @where_clause = CONCAT(@where_clause, ' AND article_categorize_subcategory.SubcategoryName LIKE "%', _subcategory, '%"');
    END IF;
    
    IF priceMin IS NOT NULL THEN
SET @where_clause = CONCAT(@where_clause, ' AND science_article.Price >=', priceMin);
    END IF;
    
    IF priceMax IS NOT NULL THEN
SET @where_clause = CONCAT(@where_clause, ' AND science_article.Price <=', priceMax);
    END IF;
    
    SET @sql = CONCAT('
    SELECT science_article.id, Title, PublishDate, GithubCode, link, LastModified, Price, deleteAt FROM science_article
LEFT JOIN author_write_article ON science_article.id = author_write_article.ArticleID
LEFT JOIN author ON author_write_article.ORCID = author.orcid
LEFT JOIN paper ON paper.id = science_article.id
LEFT JOIN academic_event ON paper.EventID = academic_event.id
LEFT JOIN article_categorize_subcategory ON article_categorize_subcategory.ArticleID = science_article.id
', @where_clause);
    SET @sql = CONCAT(@sql, ' GROUP BY science_article.id');
    SET @sql = CONCAT(@sql, ' ORDER BY science_article.PublishDate DESC');
    
PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//

DELIMITER ;

CALL filter_science_article(NULL, NULL, NULL, NULL, NULL, NULL, 30);


-- DROP PROCEDURE IF EXISTS filter_science_article;