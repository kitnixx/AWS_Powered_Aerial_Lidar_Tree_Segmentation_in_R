const download = require('../s3_download/download.js');
const batch = require('../ec2_batch/batch.js');
const upload = require('../s3_upload/upload.js');
var baseDir = process.cwd().replace('backend', '');
baseDir = baseDir.replace(/\\/g, "/");

var params = {
	data: 'test-small-file',
	algorithm: 'silva2016'
};

batch_process(params);

async function batch_process(params){
	let id = 'myjobid';
    await download.main(baseDir, params.data);
    await batch.main(baseDir, params, id);
    console.log("FINISHED");
}
