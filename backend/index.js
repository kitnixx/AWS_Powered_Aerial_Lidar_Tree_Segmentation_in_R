const queue = require('queue');
const uuidv4 = require("uuid/v4");
const bodyParser = require('body-parser');
const express = require('express');
const app = express();
const port = 80;

app.use(bodyParser.json());
app.use(function(req, res, next) {
    res.header('Content-Type', 'application/json');
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization");
    next();
});

var counter = new queue(function (task, cb) {
  console.log("I have %d %ss.", task.count, task.id);
  cb();
})

q = queue();
var results = []
q.autostart = true;
q.concurrency = 1;
// use the timeout feature to deal with jobs that
// take too long or forget to execute a callback
q.timeout = 10000
q.on('timeout', function (next, job) {
  console.log('job timed out:', job)
  next()
})
// get notified when jobs complete
q.on('success', function (result, job) {
  console.log('job finished processing:', job)
})

var x = 0;
var asdf = [];

app.get('/', (req, res) => {
	let id = uuidv4();
	
	q.push(function () {
		return new Promise(function (resolve, reject) {
			setTimeout(function () {
				asdf.push(id);
				resolve()
			}, 5000)
  		})
	})

    res.send({
        id: id
    });
});

app.get('/cancel', (req, res) => {
	//q.stop()
	q.splice(0, 2, function (cb) {
		x++;
		console.log("removed");
		cb();
	})
	//q.start()

    res.send({
    	len: q.length
    });
});

app.get('/get', (req, res) => {
    res.send({
        asdf: asdf
    });
});

app.listen(port, () => console.log(`App listening on http://localhost:${port}`))