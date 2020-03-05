const shell = require("shelljs");
var fs = require('fs');

const jsonFileName = "json.json"

batch();

async function batch(){
  var folders = await getDataFolders("./data");
  for (var i=0; i<folders.length; i++) {
      var items = await getDataFolders(`./data/${folders[i]}`);

      var folderPath = folders[i];

      await getFileNames(items, folderPath).then(async function(response) {
          var json = {
              dir: `${folderPath}`,
              shpFile: response.shpFile,
              lasFiles: response.lasFiles
          };

          console.log(json);

          await writeFile(jsonFileName, json);
          await runRScript(jsonFileName);
      });
  }
}

function runRScript(arg){
    var script = "./CanyonCreekLidar.R";

    if (
      shell.exec(`Rscript ${script} "${arg}"`).code !== 0
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
                        await fs.unlinkSync(`./data/${folderPath}/${items[i]}`)
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
