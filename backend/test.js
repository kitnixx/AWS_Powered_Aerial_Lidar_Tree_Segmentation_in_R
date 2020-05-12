const download = require('../s3_download/download.js');
const batch = require('../ec2_batch/batch.js');
const upload = require('../s3_upload/upload.js');
var baseDir = process.cwd().replace('backend', '');
baseDir = baseDir.replace(/\\/g, "/");

//console.log(baseDir);

batch_process('test-small-file');

async function batch_process(dataFolder){
    await download.main(baseDir, dataFolder);
    //await batch.main(baseDir, dataFolder);
    //await upload.main(baseDir, dataFolder);
    console.log("FINISHED");
}
