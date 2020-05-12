const rimraf = require("rimraf");
const queue = require('queue');
const { fork } = require('child_process');
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

var q = queue();
q.autostart = true;
q.concurrency = 1;
q.timeout = 2*60*1000;  // 2 min timeout

let finishedIds = []
let queuedIds = [];
let childProcess;

q.on('timeout', function (next, job) {
    if(queuedIds[0] != null){
        console.log('Job timed out:', queuedIds[0]);
        finishedIds.push({
            id: queuedIds[0].id,
            startTime: queuedIds[0].startTime,
            endTime: (new Date()).toString(),
            params: queuedIds[0].params,
            status: "Timed Out"
        });
        queuedIds.shift();
        if(childProcess != null){
            childProcess.kill('SIGINT');
        }
    }
    next();
})
// get notified when jobs complete
q.on('success', function (result, job) {
    if(queuedIds[0] != null){
        console.log('Job finished processing:', queuedIds[0]);
        finishedIds.push({
            id: queuedIds[0].id,
            startTime: queuedIds[0].startTime,
            endTime: (new Date()).toString(),
            params: queuedIds[0].params,
            status: "Finished"
        });
        queuedIds.shift();
    }
})

var baseDir = process.cwd().replace('backend', '');
baseDir = baseDir.replace(/\\/g, "/");

app.post('/start', (req, res) => {
    let params = req.body;
    let id = uuidv4();
    let job = {
    	id: id,
    	startTime: (new Date()).toString(),
    	params: params
    }
    queuedIds.push(job);

	q.push(async function () {
        return new Promise(function (resolve, reject) {
        	let queuePos = queuedIds.map(item => item.id).indexOf(id);
            if(queuePos >= 0){
                console.log("----------------------------------------------");
                console.log("Starting Job:", id);
                console.log("----------------------------------------------");

                // fork another process
                childProcess = fork('./backgroundThread.js');         
                // send dataFolder to forked process
                childProcess.send({
                    params: queuedIds[queuePos].params
                });
                // listen for messages from forked process
                childProcess.on('message', async (message) => {
                    console.log(`Child process completed successfully`);

                    // delete the data directory
                    await new Promise(function(resolve, reject) {
                        rimraf(baseDir + queuedIds[queuePos].params.data + '/', function () {
                            console.log("Cleaned up data directory:", queuedIds[queuePos].params.data);
                            resolve();
                        });
                    });

                    resolve();
                });

                childProcess.on('close', async (code, signal) => {
                    console.log(`Child process terminated due to receipt of signal ${signal}`);

                    // delete the data directory
                    await new Promise(function(resolve, reject) {
                        rimraf(baseDir + queuedIds[queuePos].params.data + '/', function () {
                            console.log("Cleaned up data directory:", queuedIds[queuePos].params.data);
                            resolve();
                        });
                    });

                    resolve();
                });
            }
            else
                resolve();
        });
	})

	job.queuePos = queuedIds.length-1
    res.send(job);
});

app.get('/status/:id', (req, res) => {
    let id = req.params.id;
    let finishedPos = finishedIds.map(item => item.id).indexOf(id);
    let queuePos = queuedIds.map(item => item.id).indexOf(id);

    let ret = {};

    if(finishedPos >= 0){
    	ret = finishedIds[finishedPos];
        ret.status = finishedIds[finishedPos].status;
    }
    else if(queuePos > 0){
    	ret = queuedIds[queuePos];
        ret.queuePos = queuePos;
        ret.status = "In Queue";
    }
    else if(queuePos == 0){
    	ret = queuedIds[queuePos];
        ret.queuePos = queuePos;
        ret.status = "Job is Running";
    }    
    else
        ret.status = "Unknown ID";

    res.send(ret);
});

app.get('/cancel/:id', (req, res) => {  // TODO: remove from queue as well
    let id = req.params.id;
    let finishedPos = finishedIds.map(item => item.id).indexOf(id);
    let queuePos = queuedIds.map(item => item.id).indexOf(id);

    let ret = {};

    if(finishedPos >= 0){
    	ret = finishedIds[finishedPos];
    }
    else if(queuePos > 0){
    	ret = {
            id: queuedIds[queuePos].id,
            startTime: queuedIds[queuePos].startTime,
            endTime: (new Date()).toString(),
            params: queuedIds[queuePos].params,
            status: "Canceled"
        };
        finishedIds.push(ret);
        queuedIds.splice(queuePos, 1);        
    }
    else if(queuePos == 0){        
        ret = {
            id: queuedIds[queuePos].id,
            startTime: queuedIds[queuePos].startTime,
            endTime: (new Date()).toString(),
            params: queuedIds[queuePos].params,
            status: "Canceled"
        };
        finishedIds.push(ret);
        queuedIds.shift();
        if(childProcess != null){
            childProcess.kill('SIGINT');            
        }
    }
    else
        ret.status = "Unknown ID";

    res.send(ret);
});

app.listen(port, () => console.log(`App listening on http://localhost:${port}`));