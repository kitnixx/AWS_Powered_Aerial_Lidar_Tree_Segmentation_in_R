const shell = require("shelljs");

var ws = 30;
var hmin = 1;

for (var i = 10; i < 50; i += 5) {
  var script = "C:\\Users\\nicolatk\\Desktop\\test\\segmentation_new.R";
  var outputLocation = "";

  if (
    shell.exec(`Rscript ${script} ${ws} ${hmin} ${outputLocation}`).code !== 0
  ) {
    shell.echo("Error: IDK");
    shell.exit(1);
  }
}
