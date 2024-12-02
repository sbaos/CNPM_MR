const db = require("../config/db");


const getAllAppliableCouponByReader = async (req,res) => {
    try {
        const ReaderID = req.params.ReaderID
        const article_coupon_data = await db.query(`SELECT *
            FROM (reader_has_discount_coupon JOIN discount_coupon ON reader_has_discount_coupon.CoupinID = discount_coupon.id) JOIN valid_article_coupon ON reader_has_discount_coupon.CoupinID = valid_article_coupon.ArticleCouponID
            WHERE reader_has_discount_coupon.ReaderID = ? AND reader_has_discount_coupon.use = 0` , [ReaderID])

        const cost_base_discount = await db.query(`SELECT *
            FROM  (reader_has_discount_coupon JOIN discount_coupon ON reader_has_discount_coupon.CoupinID = discount_coupon.id) JOIN cost_base_discount_coupon ON reader_has_discount_coupon.CoupinID = cost_base_discount_coupon.Id
            WHERE reader_has_discount_coupon.ReaderID = ? AND reader_has_discount_coupon.use = 0` , [ReaderID])

        const cost_base_discount_data = cost_base_discount[0].map(item => item = {...item , coupon_type : 'cost_base_discount'})
        const discount_on_academic_event = await db.query(`SELECT *
            FROM  (reader_has_discount_coupon JOIN discount_coupon ON reader_has_discount_coupon.CoupinID = discount_coupon.id) JOIN discount_on_subcategory ON reader_has_discount_coupon.CoupinID = discount_on_subcategory.SubcategoryCouponID
            WHERE reader_has_discount_coupon.ReaderID = ? AND reader_has_discount_coupon.use = 0` , [ReaderID])

        const discount_on_academic_event_data = discount_on_academic_event[0].map(item => item = {...item , coupon_type : 'discount_on_academic_event'})

        const discount_on_subcategory = await db.query(`SELECT *
            FROM  (reader_has_discount_coupon JOIN discount_coupon ON reader_has_discount_coupon.CoupinID = discount_coupon.id) JOIN discount_on_subcategory ON reader_has_discount_coupon.CoupinID = discount_on_subcategory.SubcategoryCouponID
            WHERE reader_has_discount_coupon.ReaderID = ? AND reader_has_discount_coupon.use = 0` , [ReaderID])
            
        
        const discount_on_subcategory_data = discount_on_subcategory[0].map(item => item = {...item , coupon_type : 'discount_on_subcategory'})

        
        const discount_on_payment_data = [...cost_base_discount_data,...discount_on_academic_event_data,...discount_on_subcategory_data]

        

        return res.status(200).send({
            success : true ,
            message : 'get all appliable coupon by reader successfully',
            article_coupon_data : article_coupon_data[0],
            payment_coupon_data : discount_on_payment_data
        })
        
    } catch (error) {
        console.log(error)
        res.status(500).send({
            success : false , 
            message : 'Error in get all applicable coupon by reader',
            error
        })
    }
}


module.exports = {getAllAppliableCouponByReader}