const PORT = 5000,
express = require('express');
path = require('path')
app = express();

app.use(express.static(path.join(__dirname, 'build')))
app.locals.blockchainurl = process.env.BLOCKCHAIN_SERVICE_URL;

app.get('/urltouse', function(req, res) {
    res.send(process.env.BLOCKCHAIN_SERVICE_URL);
});
app.listen(PORT)
console.log("BLOCKCHAIN_SERVICE_URL IS "+process.env.BLOCKCHAIN_SERVICE_URL)
