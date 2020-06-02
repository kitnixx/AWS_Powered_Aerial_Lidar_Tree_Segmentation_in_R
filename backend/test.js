const download = require('../s3_download/download.js');
const batch = require('../ec2_batch/batch.js');
const upload = require('../s3_upload/upload.js');
var baseDir = process.cwd().replace('backend', '');
baseDir = baseDir.replace(/\\/g, "/");

main();

async function main(){
	let msg = {
		id: 'asdf',		
		params: {
			bucket: 'canyon-creek-bucket-0',
			data: 'test-small-file',
			algorithm: 'silva2016'
		}
	}

	await batch_process(msg);
}


async function batch_process(msg){
	let id = msg.id;
	let params = msg.params;
	
	/*try{
		await download.main(baseDir, params.bucket, params.data);
	} catch(e){
		return "Failed to download or ran out of memory. Check Cloudwatch logs for more information.";
	}*/

	try{
		await batch.main(baseDir, params, id);
	} catch(e){
		return "Failed do processing. Check Cloudwatch logs for more information.";
	}
	
	// upload jobParams details
  	/*try{
  		// create outputs directory for current file
  		if (!fs.existsSync(baseDir + params.data + '/request/'))
	        fs.mkdirSync(baseDir + params.data + '/request/');
	    if (!fs.existsSync(baseDir + params.data + '/request/outputs/'))
	        fs.mkdirSync(baseDir + params.data + '/request/outputs/');

	  	msg.endTime = (new Date(new Date().toUTCString())).toString();
	  	msg.message = "Successfully ran";
		await writeFile(baseDir + params.data + '/request/outputs/jobParams.json', msg);
		await upload.main(baseDir, params.bucket, params.data, id, 'jobParams');
 	} catch(e){
		return "Failed to upload jobParams. Check Cloudwatch logs for more information.";
	}*/

	return "Successfully ran";
}