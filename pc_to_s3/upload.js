const AWS = require("aws-sdk");
AWS.config.update({
    "accessKeyId": "AKIA2KTK4Q4WYRPLFVZW",
    "secretAccessKey": "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",
    "region": "us-east-1"
});
const s3 = new AWS.S3();

const fs = require('fs');

const myArgs = process.argv.slice(2);
const DATA_DIR = '../' + myArgs[0];
const BUCKET = 'canyon-creek-bucket';

const OUTPUT_DIR = 'data/';

main();

async function main(){
    if(myArgs[0] != null){
        console.log("Starting...");

        var folders = await getDataFolders(DATA_DIR);

        for (var i=0; i<folders.length; i++) {
            var folderPath = folders[i];
            var items = await getDataFolders(`${DATA_DIR}/${folderPath}`);

            await uploadFiles(items, folderPath);                
        }

    } else {
        console.log("Pass in folder you want to work with!");
    }
}

function uploadFiles(items, folderPath){
    return new Promise(async function(resolve, reject) {

        for (var i=0; i<items.length; i++){
            let dir = `${DATA_DIR}/${folderPath}/${items[i]}`;
            console.log(`Reading ${dir}`)
            const fileContent = fs.readFileSync(dir);
            const params = {
                Bucket: BUCKET,
                Key: `${OUTPUT_DIR}/${folderPath}/${items[i]}`, // File name you want to save as in S3
                Body: fileContent
            };

            s3.upload(params)
                .on('httpUploadProgress', function(evt) {
                    var progress = Math.round(evt.loaded / evt.total * 100);
                    console.log(`File uploading: ${progress}% - ${params.Key}`)
                })
                .send(function(err, data) {
                    if(err)
                        console.log(err);
                    else
                        console.log(`File uploaded successfully. ${data.Location}`);
                });
        }

        resolve();
    });
}

function getDataFolders(dir){
    return new Promise(function(resolve, reject) {
        fs.readdir(dir, function(err, items) {
            resolve(items);
        });
    });
}
