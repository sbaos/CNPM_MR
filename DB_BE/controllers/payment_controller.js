const db = require("../config/db");



async function createPaymentItem(item , paymentid) {
    try {
        const payment_item_data = await db.query(`INSERT INTO payment_item(ArticleID,PaymentID) VALUES(?,?)` , [item.ArticleID,paymentid])
        return {
            id : payment_item_data[0].insertId,
            ArticleID : item.ArticleID,
            PaymentID : paymentid
        }        
    } catch (error) {
        console.log(error);
        return null;
    }
}


const createPaymentWithReaderID = async (req,res) => {
    try {
        const ReaderID = req.params.ReaderID;
        const {Time} = req.body;
        const create_payment = await db.query(`INSERT INTO payment(Time,ReaderID) VALUES (?,?)` , [Time,ReaderID])
        const PaymentID = create_payment[0].insertId
        const article_in_cart_data = await db.query(`SELECT * 
            FROM cart_has_article JOIN reader ON cart_has_article.CartID = reader.CartID 
            WHERE reader.id = ? ;` , [ReaderID]);
        const promises = article_in_cart_data[0].map(item => createPaymentItem(item,PaymentID) )
        const results = await Promise.all(promises)
        res.status(200).send({
            success : true ,
            message : 'Create payment success',
            data : results
        })
        
    } catch (error) {
        console.log(error);
        res.status(200).send({
            success : false ,
            message : 'Error in create payment API',
            error
        })
    }
}




module.exports = {createPaymentWithReaderID}