const shell = require("shelljs");
var fs = require('fs');

const JSON_FILE = "json.json"

//const myArgs = process.argv.slice(2);
//const DATA_DIR = '../' + myArgs[0];     // directory to data

//main();

exports.main = async (baseDir, params) => {
    if(baseDir != null && params != null){
    	console.log("----------------------------------------------");
    	console.log("Running Rscript for each LAS file...");
    	console.log("----------------------------------------------");

    	var dataDir = baseDir + params.data + '/';
        var folders = await getItems(dataDir);        

        for (var i=0; i<folders.length; i++) {
        	var folderPath = dataDir + folders[i] + '/';
            var items = await getItems(folderPath); 

            if (!fs.existsSync(folderPath+'outputs'))
			    fs.mkdirSync(folderPath+'outputs');

			for(let i in items){
				if(items[i].endsWith('.las')){					
	                console.log(params);
	                var jsonLocation = baseDir+'ec2_batch/'+JSON_FILE;
	                await writeFile(jsonLocation, params);

					await runRScript(
                        baseDir,
                        folderPath,
                        items[i],
                        jsonLocation
                    );
				}				
			}

            //await getFileNames(items, folderPath).then(async function(response) {
                /*var json = {
                    dir: `${folderPath}`,
                    shpFile: response.shpFile,
                    lasFiles: response.lasFiles
                };
                console.log(json);
                await writeFile(JSON_FILE, json);*/

                // create outputs directory if doesn't exist
	        	/*if (!fs.existsSync(currentDir+'/outputs'))
				    fs.mkdirSync(currentDir+'/outputs');*/

				/*for(let j in response.lasFiles){
					console.log(response.lasFiles[j]);
					//await runRScript(currentDir, response.lasFiles[j]);
				}*/
            //});
        }

        console.log("----------------------------------------------");
    } else {
        console.log("Pass in folder you want to work with!");
    }
}

function runRScript(baseDir, arg1, arg2, arg3){
    var script = baseDir+"ec2_batch/las_processing_CGG.R";

    if (
      shell.exec(`Rscript ${script} "${arg1}" "${arg2}" "${arg3}"`).code !== 0
    ) {
      shell.echo("Error: Rscript failed");
      shell.exit(1);
    }
}

function getItems(dir){
    return new Promise(function(resolve, reject) {
        fs.readdir(dir, function(err, items) {
            resolve(items);
        });
    });
}

function writeFile(fileName, content){
    return new Promise(function(resolve, reject) {
        fs.writeFile(fileName, JSON.stringify(content), function(err) {
            resolve();
        });
    });
}

/*function getFileNames(items, folderPath){
    return new Promise(async function(resolve, reject) {
        var shpFile;
        var lasFiles = [];

        for (var i=0; i<items.length; i++) {
            if(items[i].endsWith(".shp"))
                shpFile = items[i];
            else if(items[i].endsWith(".las")){
                if(items[i].includes("_clipped") || items[i].includes("_normalize")){
                    try {
                        await fs.unlinkSync(`${folderPath}/${items[i]}`)
                        //file removed
                    } catch(err) {
                        console.error(err)
                    }
                }

                lasFiles.push(items[i]);
            }
        }

        var ret = {
            shpFile: shpFile,
            lasFiles: lasFiles
        }

        resolve(ret);
    });
}*/
