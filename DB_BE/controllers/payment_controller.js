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

async function createPaymentItemv2(item,paymentid) {
    try {
        const payment_item = await db.query(`INSERT INTO payment_item(ArticleID,PaymentID) VALUES(?,?)` , [item.ArticleID,paymentid])
        const PaymentItemID = payment_item[0].insertId
        for (const coupon of item.CouponID){
            const response = await db.query(`INSERT INTO discount_on_payment_item(ArticleCounponID,PaymentItemID) VALUES(?,?)` , [coupon,PaymentItemID])
        }

        return {
            success : true,
            id : PaymentItemID,
            ArticleID : item.ArticleID,
            PaymentID : paymentid,
            CouponID : item.CouponID
        }

        
    } catch (error) {
        console.log(error)
        return {
            success : false ,
            message : 'error in create payment item v2',
            error
        }
    }
}


async function applyPaymentDiscount(item,paymentid){
    try {
        
        const discount_on_payment_data = await db.query(`INSERT INTO discount_on_payment VALUES (?,?)` , [item.CouponID,paymentid])

        return {
            success : true ,
            message : 'add discount on payment successfull',
            data : {
                PaymentCouponID : item.CouponID,
                PaymentID : paymentid,
                coupon_type : item.coupon_type
            }
        }


        
    } catch (error) {
        console.log(error);
        return {
            success : false ,
            message : 'error in apply payment discount function',
            error
        }
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


const createPaymentWithReaderIDv2 = async (req,res) => {
    try {
        const ReaderID = req.params.ReaderID;
        const {Items , paymentApply} = req.body;

        const create_payment = await db.query(`INSERT INTO payment(Time,ReaderID) VALUES (NOW(),?)` , [ReaderID])
        const PaymentID = create_payment[0].insertId
        const payment_item_promises = Items.map(item => createPaymentItemv2(item,PaymentID))
        const payment_item = await Promise.all(payment_item_promises)


        const discount_payment_promises = paymentApply.map(item => applyPaymentDiscount(item,PaymentID))
        const discount_payment = await Promise.all(discount_payment_promises)


        const update_payment_status_data = await db.query(`UPDATE payment SET status = 'success' WHERE id = ?` , [PaymentID])




        res.status(200).send({
            success : true ,
            message : 'create payment successfully',
            payment_item : payment_item,
            discount_payment : discount_payment,
            status : update_payment_status_data[0]
        })


        
    } catch (error) {
        console.log(error);
        res.status(500).send({
            success : false ,
            message : 'Error in create payment with reader ID',
            error
        })
    }
}

const getAllPaymentHistory = async (req,res) => {
    try {
        
        
    } catch (error) {
        console.log(error),
        res.status(500).send({
            success : false,
            message : 'error in get all payment history ',
            error
        })
    }
}


module.exports = {createPaymentWithReaderID , createPaymentWithReaderIDv2 , getAllPaymentHistory}