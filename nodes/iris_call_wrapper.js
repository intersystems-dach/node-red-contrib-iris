const fs = require('fs');
const path = require('path');

module.exports = function (RED) {
  const subflowFile = path.join(__dirname, 'iris_call.json');
  const subflowContents = fs.readFileSync(subflowFile);
  const subflowJSON = JSON.parse(subflowContents);

  const serverPropsFile = path.join(
    path.resolve(__dirname, '..'),
    'ServerProperties.json'
  );
  try {
    const serverPropsContents = fs.readFileSync(serverPropsFile);
    const serverPropsJSON = JSON.parse(serverPropsContents);

    for (e in subflowJSON['env']) {
      let name = subflowJSON['env'][e]['name'];
      if (
        name == 'Port' ||
        name == 'IP' ||
        name == 'Namespace' ||
        name == 'Username' ||
        name == 'Check Connection'
      ) {
        subflowJSON['env'][e]['value'] = serverPropsJSON[name];
      }
      if (name == 'Password' && serverPropsJSON['Hide Password']) {
        let password = {
          name: 'Password',
          type: 'cred',
          ui: {
            icon: 'font-awesome/fa-ellipsis-h',
          },
        };
        subflowJSON['env'][e] = password;
      }
      if (name == 'Password' && !serverPropsJSON['Hide Password']) {
        let password = {
          name: 'Password',
          type: 'str',
          value: serverPropsJSON[name],
          ui: {
            icon: 'font-awesome/fa-ellipsis-h',
            type: 'input',
            opts: {
              types: ['str', 'env'],
            },
          },
        };
        subflowJSON['env'][e] = password;
      }
    }
  } catch (e) {}

  RED.nodes.registerSubflow(subflowJSON);
};
