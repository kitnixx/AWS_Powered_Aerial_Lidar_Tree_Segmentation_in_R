const AWS = require("aws-sdk");
const s3 = new AWS.S3();

const rimraf = require("rimraf");
const fse = require('fs-extra');

//const myArgs = process.argv.slice(2);
//const DATA_DIR = '../';     // directory to save folder to
//const GET_DIR = myArgs[0] + '/';    // folder to download from S3

//main();

exports.main = async (baseDir, dataFolder) => {
    if(baseDir != null && dataFolder != null){
    	console.log("----------------------------------------------");
    	console.log("Downloading files from S3 to Local...");
        console.log("----------------------------------------------");

    	await downloadS3Files(baseDir, dataFolder);

    	console.log("----------------------------------------------");
    } else {
        console.log("Pass in folder you want to work with!");
    }
}

async function downloadS3Files(baseDir, dataFolder){
	const BUCKET = 'canyon-creek-bucket-0';

    var data = await new Promise(async function(resolve, reject) {
    	await s3.listObjects({
    	    Bucket: BUCKET
    	}).promise()
    	.then(function(data) {
            console.log(data.Contents.length + " files found in '" + BUCKET + "' bucket");
            resolve(data.Contents);
    	});
    });

    const start = async () => {
      await asyncForEach(data, async (currentValue, index, array) => {        
        if (currentValue.Key.startsWith(dataFolder+'/') && currentValue.Key.endsWith('.las')) {
            console.log("Retrieved: " + currentValue.Key);

            var lastProgress = 0;
            await new Promise(async function(resolve, reject) {
                s3.getObject({
                    Bucket: BUCKET,
                    Key: currentValue.Key
                })
                .on('httpDownloadProgress', function(evt) {
                    var progress = Math.round(evt.loaded / evt.total * 100);
                    if(lastProgress != progress){
                        lastProgress = progress;
                        console.log(`File download: ${progress}% - ${currentValue.Key}`);
                    }
                })
                .send(async function(err, data) {
                    if(err)
                        console.log(err);
                    else{
                        fse.outputFile(baseDir + currentValue.Key, data.Body, err => {  // fse downloads file and automatically creates folders
                            if(err) {
                                console.log(err);
                            } else {
                                console.log("File downloaded successfully to: ", baseDir+currentValue.Key);                                
                            }
                            resolve();
                        })
                    }                    
                });
            });
        }
      });
    }
    await start();
    
}

async function asyncForEach(array, callback) {
  for (let index = 0; index < array.length; index++) {
    await callback(array[index], index, array);
  }
}