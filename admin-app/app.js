const PORT = 5000,
express = require('express');
path = require('path')
app = express();

app.use(express.static(path.join(__dirname, 'build')))
app.locals.blockchainurl = process.env.BLOCKCHAIN_SERVICE_URL;

app.get('/urltouse', function(req, res) {
    res.send(req.app.locals.blockchainurl);
});
app.listen(PORT)
console.log("BLOCKCHAIN_SERVICE_URL is "+process.env.BLOCKCHAIN_SERVICE_URL)
