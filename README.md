
<img src="/src/InterSystemsLogo.png" width = "200">
<h1>node-red-contrib-iris</h1>
<details>
    <summary><b>General</b></summary>
    <p>
       An interface for <a href = 'https://nodered.org/'>Node-Red</a> to <a href = 'https://www.intersystems.com/data-platform/'>InterSystems IRIS Data Platform</a>. 
    </p>
</details>

<details>
    <summary><b>Required</b></summary>
    <p>
        <ul>
            <li><a href="https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=PAGE_nodejs_native">Native API</a> installed in Node-Red.</li>
            <li><a href = "https://github.com/phil1436/node-red-iris/tree/master/ObjectScript">Node.IRISInterface</a> (v 1.0) class installed in Intersystems IRIS and mapped to Namespace     <b>%ALL</b>.</li>
        </ul>
    </p>
</details>

<details>
    <summary><b>Install</b></summary>
    <p>
       Either use the <i>Node-RED Menu - Manage Palette - Install</i>, or run the following command in your Node-Red user directory - typically <code>~/.node-red</code>

```shell
npm i node-red-iris
``` 
    
</p>
</details>

<details>
    <summary><b>Import Native API</b></summary>
    <p>
        In <code>~/.node-red/settings.js</code> add module in <code>functionGlobalContext</code>!
        
<pre>
functionGlobalContext: {
    iris:require('C:/InterSystems/IRIS/dev/nodejs/intersystems-iris-native')
}
</pre>
</p>
</details>

<details>  
    <summary><b>Connect to IRIS</b></summary>
    <p>
        Set connection properties via the node properties. The Node will build a connection when you deploy and will hold that connection up until you redeploy or disconnect manually.
    </p>
        <img src = "/src/NodeProps.png">
</details>

<details>  
    <summary><b>Usage</b></summary>
    <p>
        Pass the SQL statement as a string in the <b>msg.data</b> field and the nodes will parameterize the statement itself.
    </p>
<pre>
msg.data = "SELECT * FROM NodeREd.Person WHERE Age >= 42 AND Name = 'Max' "
</pre>
Or parameterize statement:
<pre>
msg.data = { 
    "sql": "SELECT * FROM NodeREd.Person WHERE Age >= ? AND Name = ? ",
    "values": [42, "Max"]
}
</pre>
</details>

<details>
    <summary><b>Nodes</b></summary>
    <p>
        <ul>
            <li><b>IRIS</b>: A Node for executing SQL-Statements in Intersystems IRIS.</li>
            <li><b>IRIS_CREATE</b>: Creates a class in Intersystems IRIS.</li>
            <li><b>IRIS_DELETE_CLASS</b>: Deletes a class in Intersystems IRIS.</li>
            <li><b>IRIS_INSERT</b>: A Node for only SQL-INSERT-Statements. Can also generate the class, if it does not already exists, based on the statement.</li>
            <li><b>IRIS_OO</b>: Can insert a hierarchical JSON-Object.</li>
        </ul>
    </p>
    <img src = "/src/NodesOverview.png">

<p> See Node description for further informations.</p>
</details>

<br>
<br>
<p >by Philipp Bonin<br>Powered by <a href= "https://www.intersystems.com/" style="color: #00b4ae">InterSystems</a>.</p>