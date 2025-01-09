const express = require('express');
const { getScienceArticle, getScienceArticleByID, addScienceArticle, updateArticle, deleteArticle, getFilteredArticles, getBoughtScienceArticle } = require('../controllers/science_article_controller');
const { createAdmin ,createReader, userLogin, userChangePassword } = require('../controllers/user_controller');
const { getAllArticleByReaderID, addArticleToCart, removeArticlefromCart } = require('../controllers/cart_controller');
const { createPaymentWithReaderID, createPaymentWithReaderIDv2, getAllPaymentHistory } = require('../controllers/payment_controller');
const { getAllAppliableCouponByReader } = require('../controllers/coupon_controller');

const router = express.Router()


//GET FILTERED ARTICLE
router.get('/science_article/filtered/:ReaderID' , getFilteredArticles)


router.get('/science_article/:ReaderID' , getScienceArticle ) 



router.get('/science_article/:id' , getScienceArticleByID )

router.get('/bought_science_article/:ReaderID' , getBoughtScienceArticle )

// add paper 
router.post('/science_article/add' , addScienceArticle  )

//UPDATE ARTICLE
router.put('/science_article/update/:id' , updateArticle )

//DELETE ARTICLE
router.delete('/science_article/delete/:id' ,  deleteArticle)

//CREATE ADMIN
router.post('/admin/create' , createAdmin)

//CREATE READER
router.post('/reader/create' , createReader)

//LOGIN 
router.post('/user/login' ,  userLogin)

//CHAGE PASSWORD
router.post('/user/change_password' , userChangePassword )

//GET ALL ITEM OF READER 
router.get('/cart/getall/reader/:id' , getAllArticleByReaderID)

//ADD ARTICLE TO CART
router.post('/cart/add/:cartID' ,addArticleToCart)

//REMOVE ARTICLE FROM CART
router.delete('/cart/remove/:cartID' , removeArticlefromCart)

//CREATE PAYMENT WITH READER ID
router.post('/cart/payment/:ReaderID' ,  createPaymentWithReaderID)

//GET ALL APPLIABLE COUPON BY USER
router.get('/coupon/appliable/:ReaderID' , getAllAppliableCouponByReader)

//CREATE PAYMENT
router.post('/payment/create/:ReaderID' ,  createPaymentWithReaderIDv2)


//GET PAYMENT
router.get('/payment/getall/:ReaderID' ,  getAllPaymentHistory)




module.exports = router