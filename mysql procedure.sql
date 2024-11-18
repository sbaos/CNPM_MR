-- INSERT PROCEDURE
USE lmao;

DELIMITER //

CREATE PROCEDURE insert_science_article(
	IN article_id INT,
    IN article_title VARCHAR(255),
    IN article_publish_date TIMESTAMP,
    IN article_github_code VARCHAR(255),
    IN article_link VARCHAR(255),
    IN article_last_modified TIMESTAMP,	
    IN article_price DECIMAL(10,2)
    )
BEGIN

    DECLARE v_has_github BOOLEAN DEFAULT FALSE;

    SET v_has_github = LOCATE('github.com', article_github_code) > 0;

    IF NOT v_has_github THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Src Code must contain github.com !!!';
    END IF;
    
    IF article_price < 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Price must not be negative !!!';
	END IF;
    
    IF article_last_modified >= CURRENT_TIMESTAMP THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid modified time';
	END IF;
    
    IF article_publish_date >= CURRENT_TIMESTAMP THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid pulish date' ;
	END IF;
    
    
    

	IF article_id IS NOT NULL THEN
		INSERT INTO science_article(id,Title,PublishDate, GithubCode,link,LastModified,Price) 
        VALUES(article_id,article_title,article_publish_date,article_github_code,article_link,article_last_modified,article_price);
	ELSE
		INSERT INTO science_article(Title,PublishDate, GithubCode,link,LastModified,Price) 
        VALUES(article_title,article_publish_date,article_github_code,article_link,article_last_modified,article_price);
	END IF;
END;

DELIMITER ;

-- UPDATE PROCEDURE
    
DELIMITER //

CREATE PROCEDURE update_Title_science_article(
	IN article_id INT,
    IN article_title VARCHAR(255)
    )
    
BEGIN 
	
    UPDATE science_article
    SET Title = article_title
    WHERE id = article_id;

END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE update_Publish_date_science_article(
	IN article_id INT,
    IN article_publish_date TIMESTAMP
    )
BEGIN 

    
    IF article_publish_date >= CURRENT_TIMESTAMP THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid publish date !!!';
	END IF;
	
    UPDATE science_article
    SET PublishDate = article_publish_date
    WHERE id = article_id;

END //

DELIMITER ;



CREATE PROCEDURE update_last_modified_science_article(
	IN article_id INT,
    IN article_last_modified TIMESTAMP
    )
BEGIN 

    
    IF article_last_modified > CURRENT_TIMESTAMP THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid last modified time !!!';
	END IF;
	
    UPDATE science_article
    SET LastModified = article_last_modified 
    WHERE id = article_id;

END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE update_github_code_science_article(
	IN article_id INT,
    IN article_github_code VARCHAR(255)
    )
BEGIN 

    DECLARE v_has_github BOOLEAN DEFAULT FALSE;

    SET v_has_github = LOCATE('github.com', article_github_code) > 0;

    IF NOT v_has_github THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Src Code must contain github.com !!!';
    END IF;

	
    UPDATE science_article
    SET GithubCode = article_github_code
    WHERE id = article_id;

END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE update_price_science_article(
	IN article_id INT,
    IN article_price VARCHAR(255)
    )
BEGIN 

    IF article_price < 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Price must not be negative !!!';
	END IF;

	
    UPDATE science_article
    SET Price = article_price
    WHERE id = article_id;

END //

DELIMITER ;


-- DELETE PROCEDURE
DELIMITER //

CREATE PROCEDURE delete_article(
	IN article_id INT
    )
BEGIN 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error deleting article';
    END;

    DELETE FROM science_article
    WHERE id = article_id;

END //

DELIMITER ;








