<div align="center">
    <br />
    <img src="https://raw.githubusercontent.com/phil1436/node-red-contrib-iris/master/src/InterSystemsLogo.png" alt="node-red-contrib-irisLogo" width="30%"/>
    <h1>node-red-contrib-iris</h1>
    <p>
        An interface for <a href = 'https://nodered.org/'>Node-RED</a> to <a href = 'https://www.intersystems.com/data-platform/'>InterSystems IRIS Data Platform</a>.
    </p>
</div>

<div align="center">
    <a href="https://github.com/phil1436/node-red-contrib-iris/releases">
        <img src= "https://img.shields.io/github/v/release/phil1436/node-red-contrib-iris?display_name=tag" alt="current release">
    </a>
    <a href="https://github.com/phil1436/node-red-contrib-iris/blob/master/LICENSE">
        <img src="https://img.shields.io/github/license/phil1436/node-red-contrib-iris" alt="license">
    </a>
    <a href="https://github.com/phil1436/node-red-contrib-iris/stargazers">
        <img src="https://img.shields.io/github/stars/phil1436/node-red-contrib-iris" alt="stars">
    </a>
    <a href="https://github.com/phil1436/node-red-contrib-iris/commits/master">
        <img src="https://img.shields.io/github/last-commit/phil1436/node-red-contrib-iris" alt="last commit">
    </a>
</div>

---

-   [Requirements](#requirements)
-   [Installation](#installation)
    -   [Install the Node-RED package](#install-the-node-red-package)
    -   [Import Native API](#import-native-api)
    -   [Download Node.IRISInterface](#download-nodeirisinterface)
-   [Connect to IRIS](#connect-to-iris)
-   [Usage](#usage)
-   [Nodes](#nodes)
-   [Bugs](#bugs)

---

## Requirements

-   [Native API](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=PAGE_nodejs_native) (_v 1.2.0_) installed in Node-RED.
-   [Node.IRISInterface](https://github.com/phil1436/node-red-iris/tree/master/ObjectScript) (_v 1.3_) class installed in Intersystems IRIS.

---

## Installation

### Install the Node-RED package

Either use the _Node-RED Menu - Manage Palette - Install_ menu, or run the following command in your Node-RED user directory - typically `~/.node-red`

```shell
npm install node-red-contrib-iris
```

### Import Native API

In the `~/.node-red/settings.js` file add module in (_already existing_) `functionGlobalContext`:

```javascript
functionGlobalContext: {
    // os:require('os'),
    iris: require('./node_modules/node-red-contrib-iris/intersystems-iris-native'),
}
```

You can find the API package under `.node-red/node_modules/node-red-contrib-iris/intersystems-iris-native`. Please check the [README](https://github.com/phil1436/node-red-contrib-iris/blob/master/intersystems-iris-native/README.md) file for supported operating systems. If your OS is not supported you can get the API from your Intersystems IRIS instance under: `~/IRIS/dev/nodejs/intersystems-iris-native`.

See the [documentation](https://nodered.org/docs/user-guide/writing-functions#loading-additional-modules) for how to load additional modules into Node-RED.

### Download Node.IRISInterface

Go to [raw.githubusercontent](https://raw.githubusercontent.com/phil1436/node-red-contrib-iris/master/ObjectScript/Node.IRISInterface.cls). Do a right click on the page and choose _Save Page As..._ . Afterwards go to the InterSystems Management Portal and navigate to _System Explorer > Classes_ and click on _Import_. There you select the file you just downloaded and click _Import_.
When you only operate in one namespace, import the class into this namespace. When you have multiple namespaces you want to have access to, [map the class to namespace _%ALL_](https://docs.intersystems.com/iris20221/csp/docbook/DocBook.UI.Page.cls?KEY=GSA_config_namespace#GSA_config_namespace_addmap_all).

---

## Connect to IRIS

Set connection properties via the node properties. The Node will build a connection when you deploy and will hold that connection up until you redeploy or disconnect manually.

<img src = "https://raw.githubusercontent.com/phil1436/node-red-contrib-iris/master/src/NodeProps.png" width = "400" alt="NodeProperties">

You can set the default properties in `~/.node-red/node_modules/node-red-contrib-iris/ServerProperties.json`. Or use the [SetServerProperties flow](https://github.com/phil1436/node-red-contrib-iris/blob/master/examples/SetServerProperties.json) under _Import > Examples > node-red-contrib-iris > SetServerProperties_.

---

## Usage

The nodes are secure against SQL injection by parametrize the statements.
Pass the SQL statement as a string in the _msg.data_ field and the node will parameterize the statement itself.

```javascript
msg.data = "SELECT * FROM NodeRed.Person WHERE Age >= 42 AND Name = 'Max' ";
```

Or a parameterized statement:

```javascript
msg.data = {
    sql: 'SELECT * FROM NodeRed.Person WHERE Age >= ? AND Name = ? ',
    values: [42, 'Max'],
};
```

---

## Nodes

-   **IRIS** - A Node for executing DML statements such as SELECT, UPDATE, INSERT and DELETE and DDL statements such as CREATE, ALTER and DROP in Intersystems IRIS.
-   **IRIS_CREATE** - Creates a class in Intersystems IRIS.
-   **IRIS_DELETE_CLASS** - Deletes a class in Intersystems IRIS.
-   **IRIS_INSERT** - A Node for only SQL-INSERT-Statements. Can also generate the class, if it does not already exists, based on the statement.
-   **IRIS_OO** - Can insert a hierarchical JSON-Object.
-   **IRIS_CALL** - Call Intersystems IRIS classmethods.

<img src = "https://raw.githubusercontent.com/phil1436/node-red-contrib-iris/master/src/NodesOverview.png" width = "200">

> See Node description for further informations.

---

## Bugs

-   Currently does not work in Docker Container!
-   The statement will be parametrized wrong if whitespaces and commas used in strings. Please parametrize the Statement before. Example:

Does not work:

```javascript
msg.data = "SELECT * FROM NodeRed.Person WHERE Name = 'Smith, John'";
```

But this will work:

```javascript
msg.data = {
    "sql":"SELECT * FROM NodeRed.Person WHERE Name = ?,
    "values":["Smith, John"]
    }
```

---

<p>
<br>
<a href= "https://www.npmjs.com/package/node-red-contrib-iris">npm</a><br>
<a href= "https://github.com/phil1436/node-red-contrib-iris">GitHub</a><br>
<a href= "https://flows.nodered.org/node/node-red-contrib-iris">nodered.org</a><br>
<a href= "https://github.com/phil1436/node-red-contrib-iris/blob/master/CHANGELOG.md">CHANGELOG</a><br>
<a href= "https://community.intersystems.com/post/intersystems-iris-integration-node-red">InterSystems Developer Community</a>
</p>
<br>
<p>by Philipp Bonin<br>Powered by <a href= "https://www.intersystems.com/" style="color: #00b4ae">InterSystems</a>.</p>
