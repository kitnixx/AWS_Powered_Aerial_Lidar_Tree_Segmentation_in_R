const queue = require('queue');
const uuidv4 = require("uuid/v4");
const bodyParser = require('body-parser');
const express = require('express');
const app = express();
const port = 80;

const rimraf = require("rimraf");

var q = queue();
q.autostart = true;
q.concurrency = 1;
q.timeout = 2*60*1000;  // 2 min timeout

app.use(bodyParser.json());
app.use(function(req, res, next) {
    res.header('Content-Type', 'application/json');
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization");
    next();
});

let finishedIds = []
let queuedIds = [];

const { fork } = require('child_process');
let childProcess;

q.on('timeout', function (next, job) {
    if(childProcess != null){
        childProcess.kill('SIGINT');
    }

    console.log('Job timed out:', queuedIds[0]);
    finishedIds.push(queuedIds[0]);
    queuedIds.shift(queuedIds[0]);
    next()
})
// get notified when jobs complete
q.on('success', function (result, job) {
    console.log('Job finished processing:', queuedIds[0]);
    finishedIds.push(queuedIds[0]);
    queuedIds.shift(queuedIds[0]);
})

var baseDir = process.cwd().replace('backend', '');
baseDir = baseDir.replace(/\\/g, "/");

app.get('/start/:dataFolder', (req, res) => {
    let dataFolder = req.params.dataFolder;

	q.push(async function () {        
        return new Promise(function (resolve, reject) {
            // fork another process
            childProcess = fork('./backgroundThread.js');         
            // send dataFolder to forked process
            childProcess.send({
                dataFolder: dataFolder
            });
            // listen for messages from forked process
            childProcess.on('message', async (message) => {
                console.log(`DONE PROCESSING`);

                // delete the data directory
                await new Promise(function(resolve, reject) {
                    rimraf(baseDir + dataFolder + '/', function () {
                        console.log("Cleaned up data directory");
                        resolve();
                    });
                });

                resolve();
            });

            childProcess.on('close', async (code, signal) => {
                console.log(`child process terminated due to receipt of signal ${signal}`);

                // delete the data directory
                await new Promise(function(resolve, reject) {
                    rimraf(baseDir + dataFolder + '/', function () {
                        console.log("Cleaned up data directory");
                        resolve();
                    });
                });

                resolve();
            });
        });
	})

    let id = uuidv4();
    queuedIds.push(id);
    res.send({
        id: id,
        queuePos: queuedIds.length-1
    });
});

app.get('/status/:id', (req, res) => {
    let id = req.params.id;
    let finishedPos = finishedIds.indexOf(id);
    let queuePos = queuedIds.indexOf(id);

    let ret = {
        id: id
    };

    if(finishedPos >= 0)
        ret.status = "Finished";
    else if(queuePos > 0){
        ret.queuePos = queuePos;
        ret.status = "In Queue";
    }
    else if(queuePos == 0){
        ret.queuePos = queuePos;
        ret.status = "Job is Running";
    }    
    else
        ret.status = "Unknown ID";

    res.send(ret);
});

app.get('/cancel/:id', (req, res) => {  // TODO: remove from queue as well
    let id = req.params.id;
    let finishedPos = finishedIds.indexOf(id);
    let queuePos = queuedIds.indexOf(id);

    let ret = {
        id: id
    };

    if(finishedPos >= 0)
        ret.status = "Already Finished";
    else if(queuePos > 0){
        queuedIds.splice(queuePos, 1);
        ret.status = "Removed from Queue";
    }
    else if(queuePos == 0){
        if(childProcess != null){
            childProcess.kill('SIGINT');
            ret.status = "Job is Stopped";
        }        
    }
    else
        ret.status = "Unknown ID";

    res.send(ret);
});

app.listen(port, () => console.log(`App listening on http://localhost:${port}`));