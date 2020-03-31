const shell = require("shelljs");
var fs = require('fs');

const JSON_FILE = "json.json"

const myArgs = process.argv.slice(2);
const DATA_DIR = '../' + myArgs[0];     // directory to data

main();

async function main(){
    if(myArgs[0] != null){
        var folders = await getDataFolders(DATA_DIR);

        for (var i=0; i<folders.length; i++) {
            var items = await getDataFolders(`${DATA_DIR}/${folders[i]}`);
            var folderPath = folders[i];

            await getFileNames(items, folderPath).then(async function(response) {
                var json = {
                    dir: `${folderPath}`,
                    shpFile: response.shpFile,
                    lasFiles: response.lasFiles
                };

                console.log(json);

                await writeFile(JSON_FILE, json);
                var currentDir = process.cwd().replace('ec2_batch', '');
                currentDir = currentDir.replace(/\\/g, "/");
                currentDir += DATA_DIR.replace('../', '') + '/';
                //console.log(currentDir);
                await runRScript(currentDir, JSON_FILE);
            });
        }

        console.log("---------------------------------");
        console.log("Exiting now.");
        process.exit();	// Force exit b/c shelljs  doesn't provide any way to disconnect
    } else {
        console.log("Pass in folder you want to work with!");
    }
}

function runRScript(arg1, arg2){
    var script = "./CanyonCreekLidar.R";

    if (
      shell.exec(`Rscript ${script} "${arg1}" "${arg2}"`).code !== 0
    ) {
      shell.echo("Error: IDK");
      shell.exit(1);
    }
}

function writeFile(fileName, content){
    return new Promise(function(resolve, reject) {
        fs.writeFile(fileName, JSON.stringify(content), function(err) {
            resolve();
        });
    });
}

function getFileNames(items, folderPath){
    return new Promise(async function(resolve, reject) {
        var shpFile;
        var lasFiles = [];

        for (var i=0; i<items.length; i++) {
            if(items[i].endsWith(".shp"))
                shpFile = items[i];
            else if(items[i].endsWith(".las")){
                if(items[i].includes("_clipped") || items[i].includes("_normalize")){
                    try {
                        await fs.unlinkSync(`${DATA_DIR}/${folderPath}/${items[i]}`)
                        //file removed
                    } catch(err) {
                        console.error(err)
                    }
                }

                lasFiles.push(items[i]);
            }
        }

        var json = {
            shpFile: shpFile,
            lasFiles: lasFiles
        }

        resolve(json);
    });
}

function getDataFolders(dir){
    return new Promise(function(resolve, reject) {
        fs.readdir(dir, function(err, items) {
            resolve(items);
        });
    });
}
