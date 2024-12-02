const db = require("../config/db");

const getScienceArticle =  async (req,res) => {
    try {
        const data = await db.query('SELECT * FROM SCIENCE_ARTICLE');
        if (!data){
            return res.status(404).send({
                success : false,
                message : 'No records found',

            })
        }
        res.status(200).send({
            success : true , 
            message : 'All science article records',
            data : data[0],
        })
    } catch (error) {
        console.log(error);
        res.status(500).send({
            success : false,
            message : 'Error in get all science articles API',
            error
        })
    }

}



const getScienceArticleByID = async (req,res) => {
    try {
        const articleID = req.params.id ;
        console.log(articleID)
        if (!articleID){
            return res.status(404).send({
                success : false,
                message : 'Invalid id'
            })
        }

        const data = await db.query(`SELECT * FROM SCIENCE_ARTICLE WHERE id = ?` , [articleID])
        if(!data){
            return res.status(404).send({
                success : false,
                message : 'No records found',
                error
            })
        }

        res.status(200).send({
            success : true ,
            data : data[0]
        })
        
    } catch (error) {
        console.log(error);
        res.status(500).send({
            success : false ,
            message : "Error in get Get article by id",
            error
        })
    }
}



//ADD ARTICLE 
const addScienceArticle = async (req,res) => {
    try {
        const {id , Title , PublishDate , GithubCode , link , LastModified , Price} = req.body
        if(!Title || !link || !GithubCode){
            return res.status(500).send({
                success : false , 
                message : 'Please provide all fields',
            })
        }

        const data = await db.query(`CALL insert_science_article(?,?,?,?,?,?,?)` , [id? id : null , Title , PublishDate , GithubCode , link , LastModified , Price] );
        if (!data){
            return res.status(404).send({
                success : false ,   
                message : 'Error in Insert query'
            })
        }

        res.status(201).send({
            success : true,
            message : 'New article record created',
            data : data[0]
        })
        
    } catch (error) {
        console.log(error);
        res.status(500).send({
            success : false , 
            message : 'Error in add article API',
            error
        })
    }
}


const updateArticle = async (req,res) => {
    try {
        data = []
        const id = req.params.id ;
        console.log(id)
        if(!id){
            return res.status(404).send({
                success : false ,
                message : 'Invalid id or Provide id'
            })
        }
        const {Title , PublishDate , GithubCode , link , LastModified , Price} = req.body
        if(Title){
            const title_data = await db.query(`CALL update_Title_science_article(? , ? )` , [id,Title])
            if (!title_data){
                data.push({
                    success : false ,
                    db_message : 'Error in updating '
                })
            }
            else{
                data.push({
                    success : true,
                    db_message : 'Updating Title field success',
                    data : title_data[0]
                })
            }
        }
        else{
            data.push({
                success : true ,
                db_message : 'No modified title field'
            })
        }


        if(PublishDate){
            const publish_date_data = await db.query(`CALL update_Publish_date_science_article(? , ? )` , [id,PublishDate])
            if (!publish_date_data){
                data.push({
                    success : false ,
                    db_message : 'Error in updating '
                })
            }
            else{
                data.push({
                    success : true,
                    db_message : 'Updating Publish Date field success',
                    data : publish_date_data[0]
                })
            }
        }
        else{
            data.push({
                success : true ,
                db_message : 'No modified publish date field'
            })
        }


        if(GithubCode){
            const github_data = await db.query(`CALL update_github_code_science_article(? , ? )` , [id,GithubCode])
            if (!github_data){
                data.push({
                    success : false ,
                    db_message : 'Error in updating '
                })
            }
            else{
                data.push({
                    success : true,
                    db_message : 'Updating github field success',
                    data : github_data[0]
                })
            }
        }
        else{
            data.push({
                success : true ,
                db_message : 'No modified github code field'
            })
        }


        if(link){
            const link_data = await db.query(`CALL update_Link_science_article(? , ? )` , [id,link])
            if (!link_data){
                data.push({
                    success : false ,
                    db_message : 'Error in updating '
                })
            }
            else{
                data.push({
                    success : true,
                    db_message : 'Updating link field success',
                    data : link_data[0]
                })
            }
        }
        else{
            data.push({
                success : true ,
                db_message : 'No modified link field'
            })
        }



        if(LastModified){
            const last_modified_data = await db.query(`CALL update_last_modified_science_article(? , ? )` , [id,LastModified])
            if (!last_modified_data){
                data.push({
                    success : false ,
                    db_message : 'Error in updating '
                })
            }
            else{
                data.push({
                    success : true,
                    db_message : 'Updating last modified field success',
                    data : last_modified_data
                })
            }
        }
        else{
            data.push({
                success : true ,
                db_message : 'No modified lastmodified field'
            })
        }


        if(Price){
            const price_data = await db.query(`CALL update_price_science_article(? , ? )` , [id,Price])
            if (!price_data){
                data.push({
                    success : false ,
                    db_message : 'Error in updating '
                })
            }
            else{
                data.push({
                    success : true,
                    db_message : 'Updating price field success',
                    data : price_data
                })
            }
        }
        else{
            data.push({
                success : true ,
                db_message : 'No modified price field'
            })
        }


        return res.status(200).send({
            success : true , 
            message : 'Update article success',
            data : data
        })
        
    } catch (error) {
        console.log(error);
        res.status(500).send({
            success : false ,
            message : 'Error in update article API',
            error
        })
    }
}


const deleteArticle = async (req,res) => {
    try {
        const articleID = req.params.id
        if(!articleID){
            return res.status(404).send({
                success : false ,
                message : 'Provide article ID'
            })
        }

        const data = await db.query(`CALL delete_article(?)` , [articleID])
        res.status(200).send({
            success : true,
            message : 'delete article successfully',
            data : data[0]
        })
        
    } catch (error) {
        console.log(error)
        res.status(500).send({
            success : false,
            message : 'Error in delete article api',
            error
        })
    }

}

module.exports = {getScienceArticle,getScienceArticleByID , addScienceArticle , updateArticle , deleteArticle}