const express = require('express');

const app = express();
require('./route')(app);

const port = process.env.PORT || 3000;
app.server = app.listen(port);

module.exports = app;
