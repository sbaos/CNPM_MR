const mysql =  require('mysql2/promise');

const mySqlPool = mysql.createPool({
    host : 'localhost',
    user : 'root',
    password : '12032004',
    database : 'database'
})


module.exports = mySqlPool;