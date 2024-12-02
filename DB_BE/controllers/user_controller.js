const db = require("../config/db");
const bcrypt = require('bcrypt');
const saltRounds = 10;

const createAdmin = async (req,res) => {
    try {
        const {Username , Password} = req.body
        const check = await db.query(`SELECT * FROM user WHERE Username LIKE ?`,['%' + Username+'%'])
        if (check[0].length){
            return res.status(404).send({
                success : false ,
                message : 'User already exist'
            })
        }
        const hashPassword = await bcrypt.hash(Password,saltRounds)
        const user_data = await db.query(`INSERT INTO user(Username,Hashpassword) VALUES(?,?)` , [Username,hashPassword])
        id = user_data[0].insertId
        const admin_data = await db.query(`INSERT INTO admin(id) VALUES(?)` , [id])
        res.status(201).send({
            success : true ,
            message : 'create admin success',
            data : [user_data[0],admin_data[0]]
        })
    } catch (error) {
        console.log(error);
        res.status(500).send({
            success : false,
            message : 'create reader API error',
            error
        })
    }

    
}




const createReader = async (req,res) => {
    try {
        const {Username , Password , creditcard ,VipTier} = req.body
        const check = await db.query(`SELECT * FROM user WHERE Username LIKE ?`,['%' + Username+'%'])
        if (check[0].length){
            return res.status(404).send({
                success : false ,
                message : 'User already exist'
            })
        }
        const hashPassword = await bcrypt.hash(Password,saltRounds)
        const user_data = await db.query(`INSERT INTO user(Username,Hashpassword) VALUES(?,?)` , [Username,hashPassword])
        const cart_data = await db.query(`INSERT INTO cart VALUES()`)

        const reader_data = await db.query(`INSERT INTO reader(id,creditcard,VipTier,CartID) VALUES(?,?,?,?)` , [user_data[0].insertId,creditcard,VipTier? VipTier.toString() : '0',cart_data[0].insertId])
        res.status(201).send({
            success : true ,
            message : 'create reader success',
            data : [user_data[0],cart_data[0] , reader_data[0]]
        })
    } catch (error) {
        console.log(error);
        res.status(500).send({
            success : false,
            message : 'create reader API error',
            error
        })
    }

    
}



const userLogin = async (req,res) => {
    try {
        const {Username , Password} = req.body
        const user_data = await db.query(`SELECT * FROM user WHERE Username LIKE ?`,['%' + Username+'%'])
        if (!user_data[0].length){
            return res.status(404).send({
                success : false ,
                message : 'User not found'
            })
        }
        const isMatchPassword = await bcrypt.compare(Password,user_data[0][0].Hashpassword,)
        if (!isMatchPassword){
            return res.status(403).send({
                success : false,
                message : 'Username/Password invalid'
            })
        }
        else{
            const check = await db.query(`SELECT * FROM reader WHERE id = ? ` , [user_data[0][0].id])
            if (!check[0].length){
            return res.status(200).send({
                success : true ,
                message : 'Login success',
                data : {
                    id : user_data[0][0].id,
                    Username : user_data[0][0].Username,
                    role : 'admin'
                }
            })
        }
        else{
            return res.status(200).send({
                success : true ,
                message : 'Login success',
                data : {
                    id : check[0][0].id,
                    Username : check[0][0].Username,
                    creditcard : check[0][0].creditcard,
                    VipTier : check[0][0].VipTier,
                    CartID : check[0][0].CartID,
                    role : 'reader',
                }
            })    
        }
        }

        
    } catch (error) {
        console.log(error)
        res.status(500).send({
            success : false ,
            message : 'Login API failed',
            error
        })
    }
}





module.exports = {createAdmin , createReader , userLogin}