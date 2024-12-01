const db = require("../config/db");


const getAllArticleByReaderID = async (req,res) => {
    try {
        const id = req.params.id
        const reader_data = await db.query(`SELECT * FROM reader WHERE id = ?` , [id])
        const cart_id = reader_data[0][0].CartID

        const article_data = await db.query(`SELECT * 
            FROM CART_HAS_ARTICLE JOIN SCIENCE_ARTICLE ON CART_HAS_ARTICLE.ArticleID = SCIENCE_ARTICLE.id 
            WHERE CartID = ?;`, [cart_id])

        if (!article_data[0].length){
            return res.status(200).send({
                success : true ,
                message : 'no records found'
            })
        }
        else{
            return res.status(200).send({
                success : true ,
                message : 'get all articles by reader ID successful',
                data : article_data[0]
            })
        }
    } catch (error) {
        console.log(error)
        return res.status(500).send({
            success : false ,
            message : 'Error in get all article by reader id API',
            error
        })
    }
}



const addArticleToCart = async (req,res) => {
    try {
        const cart_id = req.params.cartID;
        const {ArticleID} = req.body;

        const cart_has_article_data = await db.query(`INSERT INTO cart_has_article VALUES(?,?)` , [cart_id,ArticleID])

        res.status(200).send({
            success : true ,
            message : 'add article to cart successfully',
            data : cart_has_article_data[0]
        })
        
    } catch (error) {
        console.log(error);
        res.status(500).send({
            success : false ,
            message : 'error in add article to cart ',
            error
        })
    }
}


const removeArticlefromCart = async (req,res) => {
    try {
        const cart_id = req.params.cartID
        const {ArticleID} = req.body

        const response_data = await db.query(`DELETE FROM cart_has_article WHERE CartID = ? AND ArticleID = ? ` , [cart_id,ArticleID])

        res.status(200).send({
            success : true ,
            message : 'remove from cart successfully',
            data : response_data[0]
        })
        
    } catch (error) {
        console.log(error),
        res.status(200).send({
            success : false,
            message : 'remove article from cart API failed',
            error
        })
    }
}

module.exports = {getAllArticleByReaderID ,addArticleToCart,removeArticlefromCart}