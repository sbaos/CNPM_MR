const express = require('express');
const colors = require('colors');
const morgan = require('morgan');
const dotenv = require('dotenv');
const mySqlPool = require('./config/db');
const bodyParser = require('body-parser');

//config dotenv
dotenv.config();


//rest object

const app = express();

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended : true}));


//middlewares
app.use(express.json());
app.use(morgan('dev'));


//routes
app.use('/api/v1' , require('./routes/route'))
app.get('/test', (req,res) => {
    res.status(200).send('<h1>Node js Mysql APP</h1>');
})

//port 
const PORT = process.env.PORT || 8000;

//conditionally listen
mySqlPool.query('SELECT 1').then(() => {
    console.log('MYSQL DB Connected'.bgCyan.white);
    app.listen(PORT, () => {
        console.log(`Server running on port ${process.env.PORT}`.bgMagenta.white);
    });
}).catch((error) => {
    console.log(error);
})






