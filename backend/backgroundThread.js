const download = require('../s3_download/download.js');
const batch = require('../ec2_batch/batch.js');
const upload = require('../s3_upload/upload.js');
var baseDir = process.cwd().replace('backend', '');
baseDir = baseDir.replace(/\\/g, "/");

async function batch_process(dataFolder){
    //var dataFolder = 'data';
    await download.main(baseDir, dataFolder);
    await batch.main(baseDir, dataFolder);
    await upload.main(baseDir, dataFolder);
    //console.log("FINISHED");
}

// receive message from master process
process.on('message', async (msg) => {
	//console.log(dataFolder);
  	await batch_process(msg.dataFolder);  
  	// send response to master process
  	process.send({});
});