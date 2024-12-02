const db = require("../config/db");


async function AcademicEventDiscountHelper(item){
    try {
        const academic_event_coupon_data = await db.query(`SELECT * FROM discount_on_academic_event JOIN academic_event ON EventID = id WHERE EventCouponID = ?` , [item.CoupinID])

        return {
            ...item,
            academic_event : academic_event_coupon_data[0],
            coupon_type : 'discount_on_academic_event'
        }

    } catch (error) {
        console.log(error);
        return {
            success : false ,
            message : 'error in academic event discount coupon helper',
        }
    }
}


async function SubcategoryDiscountHelper(item){
    try {
        const subcategory_coupon_data = await db.query(`SELECT * FROM discount_on_subcategory WHERE SubcategoryCouponID = ?` , [item.CoupinID])

        return {
            ...item,
            subcategory : subcategory_coupon_data[0],
            coupon_type : 'discount_on_subcategory'
        }

    } catch (error) {
        console.log(error);
        return {
            success : false ,
            message : 'error in academic event discount coupon helper',
        }
    }

}

const getAllAppliableCouponByReader = async (req,res) => {
    try {
        const ReaderID = req.params.ReaderID
        const reader_data = await db.query(`SELECT * FROM reader WHERE id = ? `, [ReaderID])
        const VipTier = reader_data[0][0].VipTier
        const article_coupon_data = await db.query(`SELECT *
            FROM (reader_has_discount_coupon JOIN discount_coupon ON reader_has_discount_coupon.CoupinID = discount_coupon.id) JOIN valid_article_coupon ON reader_has_discount_coupon.CoupinID = valid_article_coupon.ArticleCouponID
            WHERE reader_has_discount_coupon.ReaderID = ? AND reader_has_discount_coupon.use = 0 AND VipTierRequired <= ? ` , [ReaderID,VipTier])

        const cost_base_discount = await db.query(`SELECT *
            FROM  (reader_has_discount_coupon JOIN discount_coupon ON reader_has_discount_coupon.CoupinID = discount_coupon.id) JOIN cost_base_discount_coupon ON reader_has_discount_coupon.CoupinID = cost_base_discount_coupon.Id
            WHERE reader_has_discount_coupon.ReaderID = ? AND reader_has_discount_coupon.use = 0 AND VipTierRequired <= ? ` , [ReaderID,VipTier])

        const cost_base_discount_data = cost_base_discount[0].map(item => item = {...item , coupon_type : 'cost_base_discount'})

        const discount_on_academic_event = await db.query(`SELECT *
            FROM  reader_has_discount_coupon JOIN discount_coupon ON reader_has_discount_coupon.CoupinID = discount_coupon.id
            WHERE reader_has_discount_coupon.ReaderID = ? AND reader_has_discount_coupon.use = 0 AND VipTierRequired <= ? AND discount_coupon.id IN (SELECT paper_academic_discount_coupon.Id FROM paper_academic_discount_coupon)` , [ReaderID,VipTier])

        const discount_on_academic_event_data_promise = discount_on_academic_event[0].map(item => AcademicEventDiscountHelper(item))
        const discount_on_academic_event_data = await Promise.all(discount_on_academic_event_data_promise)

        const discount_on_subcategory = await db.query(`SELECT *
            FROM  reader_has_discount_coupon JOIN discount_coupon ON reader_has_discount_coupon.CoupinID = discount_coupon.id
            WHERE reader_has_discount_coupon.ReaderID = ? AND reader_has_discount_coupon.use = 0 AND VipTierRequired <= ? AND discount_coupon.id IN (SELECT article_subcategory_discount_coupon.Id FROM article_subcategory_discount_coupon)` , [ReaderID,VipTier])
            
        
        const discount_on_subcategory_data_promise = discount_on_subcategory[0].map(item => SubcategoryDiscountHelper(item))
        const discount_on_subcategory_data = await Promise.all(discount_on_subcategory_data_promise)

        
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