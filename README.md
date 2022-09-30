
<img src="/src/InterSystemsLogo.png" width = "200">
<h1>node-red-iris</h1>
<details>
    <summary>General</summary>
    <p>
       An Interface for Node-Red to <a href = 'https://www.intersystems.com/data-platform/'>InterSystems IRIS Data Platform</a>. 
    </p>
</details>

<style>
    details > summary {
      cursor: pointer;
      font-size:20px;
      background: #eee;
      margin-bottom: 1rem;
      padding: 0.5rem 1rem;
    }
</style>

<details>
    <summary>Required</summary>
    <p>
        <ul>
            <li><a href="https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=PAGE_nodejs_native">Native API</a> installed in Node-Red.</li>
            <li><b>Node.IRISInterface</b> (v 1.0) class installed in IRIS and mapped to Namespace     <b>%ALL</b>.</li>
        </ul>
    </p>
</details>

<details>
    <summary>Install</summary>
    <p>
       Either use the <i>Node-RED Menu - Manage Palette - Install</i>, or run the following command in your Node-RED user directory - typically <code>~/.node-red</code>

```shell
npm i node-red-iris
``` 
    
</p>
</details>

<details>
    <summary>Import Native API</summary>
    <p>
        In <code>.node-red\settings.js</code> add Module in <code>functionGlobalContext</code>!
        
<pre>
functionGlobalContext: {
    iris:require('C:/InterSystems/IRIS/dev/nodejs/intersystems-iris-native')
}
</pre>
</p>
</details>

<details>  
    <summary>Connect to IRIS</summary>
    <p>
        Set connection properties via the node properties. The Node will build a connection when you deploy and will hold that connection up until you redeploy or disconnect manually.
    </p>
        <img src = "/src/NodeProps.png">
</details>

<details>
    <summary>Nodes</summary>
    <p>
        <ul>
            <li><b>IRIS</b>: A Node for executing SQL-Statements in IRIS.</li>
            <li><b>IRIS_CREATE</b>: Creates a class in IRIS.</li>
            <li><b>IRIS_DELETE_CLASS</b>: Deletes a class in IRIS.</li>
            <li><b>IRIS_INSERT</b>: A Node for only SQL-INSERT-Statements. Can also generate the class, if it does not already exists, based on the statement.</li>
            <li><b>IRIS_OO</b>: Can insert a hierarchical JSON-Object.</li>
        </ul>
    </p>
    <img src = "/src/NodesOverview.png">

<p> See Node description for futher informations.</p>
</details>

<br>
<br>
<p >by Philipp Bonin<br>Powered by <a href= "https://www.intersystems.com/" style="color: #00b4ae">InterSystems</a>.</p>
