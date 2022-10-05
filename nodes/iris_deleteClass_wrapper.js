const fs = require("fs");
 const path = require("path");

 module.exports = function(RED) {
    const subflowFile = path.join(__dirname,"iris_deleteClass.json");
    const subflowContents = fs.readFileSync(subflowFile);
    const subflowJSON = JSON.parse(subflowContents);

    const serverPropsFile = path.join(__dirname.substring(0,__dirname.lastIndexOf("\\")+1),"ServerProperties.json");
    const serverPropsContents = fs.readFileSync(serverPropsFile);
    const serverPropsJSON = JSON.parse(serverPropsContents);

    for (e in subflowJSON['env']){
      let name = subflowJSON['env'][e]['name'];
      if(name == "Port" || name == "IP" || name == "Namespace" || name == "Username" || name == "Password"){
         subflowJSON['env'][e]['value']  = serverPropsJSON[name];
      }
    }

    RED.nodes.registerSubflow(subflowJSON);
 }