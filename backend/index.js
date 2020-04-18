const bodyParser = require('body-parser');
const express = require('express');
const app = express();
const port = 5000;

app.use(bodyParser.json());
app.use(function(req, res, next) {
    res.header('Content-Type', 'application/json');
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization");
    next();
});

app.get('/test', (req, res) => {
    res.send({
        response: "SUCCESS"
    });
});
  
app.post('/startJob', (req, res) => {
    if(req.body){
        
    }
    res.send({
        request: req.body
    });
});

app.listen(port, () => console.log(`App listening on http://localhost:${port}`))