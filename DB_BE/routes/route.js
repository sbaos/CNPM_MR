const express = require('express');
const { getScienceArticle, getScienceArticleByID, addScienceArticle, updateArticle, deleteArticle } = require('../controllers/science_article_controller');

const router = express.Router()

router.get('/science_article' , getScienceArticle ) 

router.get('/science_article/:id' , getScienceArticleByID )

// add paper 
router.post('/science_article/add' , addScienceArticle  )

//UPDATE ARTICLE
router.put('/science_article/update/:id' , updateArticle )

//DELETE ARTICLE
router.delete('/science_article/delete/:id' ,  deleteArticle)

module.exports = router