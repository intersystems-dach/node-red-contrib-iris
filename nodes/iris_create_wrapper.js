const fs = require("fs");
 const path = require("path");

 module.exports = function(RED) {
    const subflowFile = path.join(__dirname,"iris_create.json");
    const subflowContents = fs.readFileSync(subflowFile);
    const subflowJSON = JSON.parse(subflowContents);
   
    const serverPropsFile = path.join(path.resolve(__dirname,'..'),"ServerProperties.json");
    try{
      const serverPropsContents = fs.readFileSync(serverPropsFile);
      const serverPropsJSON = JSON.parse(serverPropsContents);
  
      for (e in subflowJSON['env']){
        let name = subflowJSON['env'][e]['name'];
        if(name == "Port" || name == "IP" || name == "Namespace" || name == "Username" || name == "Password"){
           subflowJSON['env'][e]['value']  = serverPropsJSON[name];
        }
      }
   }catch(e){
     
   }

    RED.nodes.registerSubflow(subflowJSON);
 }