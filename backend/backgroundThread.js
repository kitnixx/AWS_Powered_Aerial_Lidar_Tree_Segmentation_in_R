const download = require('../s3_download/download.js');
const batch = require('../ec2_batch/batch.js');
const upload = require('../s3_upload/upload.js');
var baseDir = process.cwd().replace('backend', '');
baseDir = baseDir.replace(/\\/g, "/");

async function batch_process(params){
    await download.main(baseDir, params.data);
    await batch.main(baseDir, params);
    await upload.main(baseDir, params.data);
}

// receive message from master process
process.on('message', async (msg) => {
  	await batch_process(msg.params);  
  	// send response to master process
  	process.send({});
});