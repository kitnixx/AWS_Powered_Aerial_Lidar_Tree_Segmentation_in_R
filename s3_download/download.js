const AWS = require("aws-sdk");
AWS.config.update({
    "accessKeyId": "AKIA2KTK4Q4WYRPLFVZW",
    "secretAccessKey": "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",
    "region": "us-east-1"
});
const s3 = new AWS.S3();

const rimraf = require("rimraf");
const fse = require('fs-extra');

const myArgs = process.argv.slice(2);
const DATA_DIR = '../';     // directory to save folder to
const GET_DIR = myArgs[0] + '/';    // folder to download from S3

main();

async function main(){
    if(myArgs[0] != null){
    	console.log("---------------------------------");
    	console.log("Transferring files from S3 to EC2...");
    	await downloadS3Files(GET_DIR, DATA_DIR);	// files are still downloading after this
    	console.log("---------------------------------");
    } else {
        console.log("Pass in folder you want to work with!");
    }
}

async function downloadS3Files(GET_DIR, DATA_DIR){
	const BUCKET = 'canyon-creek-bucket';

	await s3.listObjects({
	    Bucket: BUCKET
	}).promise()
	.then(function(data) {
        console.log(data.Contents.length + " files found in '" + BUCKET + "' bucket");

        data.Contents.forEach(function(currentValue, index, array) {
            console.log("Retrieving: " + currentValue.Key);
            if (!currentValue.Key.endsWith("/") && currentValue.Key.startsWith(GET_DIR)) {
                s3.getObject({
                    Bucket: BUCKET,
                    Key: currentValue.Key
                })
				.on('httpDownloadProgress', function(evt) {
                    var progress = Math.round(evt.loaded / evt.total * 100);
                    console.log(`File Download: ${progress}% - ${currentValue.Key}`)
                })
				.send(function(err, data) {
					if(err)
                        console.log(err);
					else{
						fse.outputFile(DATA_DIR + currentValue.Key, data.Body, err => {	// fse downloads file and automatically creates folders
						  if(err) {
						    console.log(err);
						  } else {
							console.log("Downloaded to: " + DATA_DIR + currentValue.Key);
						  }
                      })
                    }
                });
            }
        });
	});
}
