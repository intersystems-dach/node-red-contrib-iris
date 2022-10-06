/// <i><b>v 1.2</b></i><br>
/// Server side Interface for <a href = "https://flows.nodered.org/node/node-red-contrib-iris">node-red-contrib-iris</a>
Class Node.IRISInterface [ Abstract ]
{

/// <style>
/// summary {
///    	cursor: pointer;
///  	background: #eee;
///  	margin-bottom: 1rem;
///  	padding: 0.5rem 1rem;
/// }
/// </style>
/// <br>
/// <details>
/// <summary>Creates a new IRIS Class.</summary>
/// <ul>
/// <li>namespace: The namespace where you want to create the class.</li>
/// <li>package: The package name of the class.</li>
/// <li>className: The name of the class.</li>
/// <li>properties: The properties names of the class, written as a String list.</li>
/// <li>propTypes: The types of the properties, written as a String list and in same order as properties.</li>
/// <li>superClasses: Superclasses of the class, written as a String list. (%Persistent and %JSON.Adaptor are always superclasses)</li>
/// </ul>
/// Needs to compile the class afterwards. <br>Use <METHOD>CompileClass</METHOD> or use <EXAMPLE>DO $SYSTEM.OBJ.Compile("className")</EXAMPLE>
/// Old method for node-red-contrib-iris 1.0.2 or before!
/// </details>
ClassMethod CreateClass(namespace As %String = 0, package As %String, className As %String, properties As %String = "", propTypes As %String = "", superClasses As %String = "") As %Status
{
	SET class = package_"."_className
	//Set namespace
	SET beforeNS = $NAMESPACE
	SET:(namespace = 0) namespace = $NAMESPACE
	ZN namespace
	SET exists = ##class(%Dictionary.CompiledClass).%ExistsId(class)
	if exists{
		SET ex = ##class(%Exception.General).%New("Class "_class_" already exists!")
		ZN beforeNS
		throw ex
	}

	//Define Class
	SET cdef = ##class(%Dictionary.ClassDefinition).%New(class)
 	if $SYSTEM.Status.IsError(cdef) {
	 	DO $system.Status.DecomposeStatus(%objlasterror,.Err) 
 		throw Err
 	}

	//Add superclasses
 	SET:(superClasses '= "") superClasses = ","_superClasses
 	SET cdef.Super = "%Persistent"_superClasses

 	// add Properties
 	SET propLst = $LISTFROMSTRING(properties)
 	SET typeLst = $LISTFROMSTRING(propTypes)
 	for i = 1:1:$LL(propLst){
		
		//Get Type of Property
	 	if i > $LL(typeLst){
	 	 SET type = "%String" //Set type to String if no type is given
	 	}
	 	else{
		 	SET type = $LG(typeLst, i)
	 	}

		//SET exist=##class(%Dictionary.CompiledClass).%ExistsId(type)

		//Insert Property
	 	SET pdef = ##class(%Dictionary.PropertyDefinition).%New(className_":"_$LG(propLst,i))
	 	if $SYSTEM.Status.IsError(pdef) {
		 	DO $system.Status.DecomposeStatus(%objlasterror,.Err) 
		 	throw Err
	 	}
	 	
	 	//d pdef.Parameters.SetAt("AGE()", "POPSEC")
	 	DO cdef.Properties.Insert(pdef)
	 	SET pdef.Type = type
		//SET pdef.Required = 1
		//d pdef.ParameterSet("MAXVAL = 100")
 	}
	
	//Save class
 	DO cdef.%Save()
	
	//Set old namespace
 	ZN beforeNS

 	return $$$OK
}
 
/// <details>
/// <summary>Creates a new IRIS Class.</summary>
/// <ul>
/// <li>namespace: The namespace where you want to create the class.</li>
/// <li>package: The package name of the class.</li>
/// <li>className: The name of the class.</li>
/// <li>superClasses: Superclasses of the class, written as a String list. (%Persistent and %JSON.Adaptor are always superclasses)</li>
/// <li>propertiesJSON: A JSON String defining the properties of the class.</li>
/// <li>methodsJSON: A JSON String defining the methods of the class.</li>
/// </ul>
/// Needs to compile the class afterwards. <br>Use <METHOD>CompileClass</METHOD> or use <EXAMPLE>DO $SYSTEM.OBJ.Compile("className")</EXAMPLE>
/// New method for node-red-contrib-iris 1.0.3 or later!
/// </details>
ClassMethod CreateClassNew(namespace As %String = 0, package As %String, className As %String, superClasses As %String = "", propertiesJSON As %String = "", methodsJSON As %String = "") As %Status
{
	SET class = package_"."_className
	//Set namespace
	SET beforeNS = $NAMESPACE
	SET:(namespace = 0) namespace = $NAMESPACE
	ZN namespace
	SET exists = ##class(%Dictionary.CompiledClass).%ExistsId(class)
	if exists{
		SET ex = ##class(%Exception.General).%New("Class "_class_" already exists!")
		ZN beforeNS
		throw ex
	}

	//Define Class
	SET cdef = ##class(%Dictionary.ClassDefinition).%New(class)
 	if $SYSTEM.Status.IsError(cdef) {
	 	DO $system.Status.DecomposeStatus(%objlasterror,.Err) 
 		throw Err
 	}

	//Add superclasses
 	SET:(superClasses '= "") cdef.Super = superClasses


	if propertiesJSON '= ""{
		SET propDA = ##class(%DynamicArray).%FromJSON(propertiesJSON)
		//SET i = propDA.%GetIterator()
		SET i = propDA.%Pop()
		while i '= ""{
			SET pdef = ##class(%Dictionary.PropertyDefinition).%New(className_":"_i.name)
			if $SYSTEM.Status.IsError(pdef) {
		 		DO $system.Status.DecomposeStatus(%objlasterror,.Err) 
		 		throw Err
	 		}
			DO cdef.Properties.Insert(pdef)
			if i.%IsDefined("type"){
				SET type = i.type
			}
			else{
				SET type = "%String"
			}
	 		SET pdef.Type = type

			if i.%IsDefined("required"){
				SET pdef.Required = i.required
			}

			if i.%IsDefined("parameters"){
				SET params = i.parameters
				SET j = params.%Pop()
				while j '= ""{
					do pdef.Parameters.SetAt(j.value, j.name)
					SET j = params.%Pop()
				}
			}

			SET i = propDA.%Pop()
		}
	}

	if methodsJSON '= ""{
		SET methDA = ##class(%DynamicArray).%FromJSON(methodsJSON)
		SET i = methDA.%Pop()
		while i '= ""{
			SET mdef = ##class(%Dictionary.MethodDefinition).%New(className_":"_i.name)
			if $SYSTEM.Status.IsError(mdef) {
		 		DO $system.Status.DecomposeStatus(%objlasterror,.Err) 
		 		throw Err
	 		}

			if i.%IsDefined("parameters"){
				do mdef.FormalSpecSet(i.parameters)
			}
			
			DO cdef.Methods.Insert(mdef)
			if i.%IsDefined("returnType"){
				SET mdef.ReturnType  = i.returnType
			}

			if i.%IsDefined("classMethod"){
				SET mdef.ClassMethod  = i.classMethod
			}

			if i.%IsDefined("body"){
				SET mdef.Implementation.LineTerminator = $c(13,10)
				SET l = $LFS(i.body,";")
				for i = 1:1:$LL(l){
					DO mdef.Implementation.WriteLine("	"_$LG(l,i)_" ")
				}
				//DO mdef.Implementation.Write(i.body)
			}

			SET i = propDA.%Pop()
		}
	}
	//Save class
 	DO cdef.%Save()
	
	//Set old namespace
 	ZN beforeNS
 	return $$$OK
}

/// <details>
/// <summary>Compiles a Class.</summary>
/// <ul>
/// <li>namespace: The namespace containing the given class</li>
/// <li>package: The package of the given class</li>
/// <li>className: the Name of the class</li>
/// </ul>
/// </details>
ClassMethod CompileClass(namespace As %String, package As %String, className As %String) As %Status
{
	#dim tEx as %Exception.SystemException
    #dim tSc as %Status = $$$OK
	#dim class as %String = package_"."_className

	//Set namespace
	SET bns = $NAMESPACE
	ZN namespace

	//compile
	try{
		$$$ThrowOnError($System.OBJ.Compile(class, "/Display=none"))
	}
	catch tEx {
		SET tSc = tEx.AsStatus()
	}

	ZN bns
	return tSc
}

/// <details>
/// <summary>Deletes a Class.</summary>
/// <ul>
/// <li>namespace: The namespace containing the given class</li>
/// <li>package: The package of the given class</li>
/// <li>className: the Name of the class</li>
/// </ul>
/// </details>
ClassMethod DeleteClass(namespace As %String, package As %String, className As %String) As %Status
{
	SET class = package_"."_className
	//Set namespace
	SET bns = $NAMESPACE
	ZN namespace

	SET exists = ##class(%Dictionary.CompiledClass).%ExistsId(class)
	if 'exists{
		SET ex = ##class(%Exception.General).%New("Class "_class_" does not exists!")
		ZN bns
		throw ex
	}

	//delete
	try{
		SET status = $System.OBJ.Delete(class, "/Display=none")
	}
	catch e {
		throw e
	}

	ZN bns
	return status
}

/// <details>
/// <summary>Checks if the class exists.</summary>
/// <ul>
/// <li>namespace: The namespace where to look in</li>
/// <li>className: The name of the class</li>
/// </ul>
/// </details>
ClassMethod CheckIfClassExists(namespace As %String, className As %String) As %Status
{
	//Set namespace
	SET bns = $NAMESPACE
	ZN namespace

	SET exists = ##class(%Dictionary.CompiledClass).%ExistsId(className)

	ZN bns
	return exists
}

/// <details>
/// <summary>Executes a SQL Insert Statement</summary>
/// <ul>
/// <li>sql: The sql Statement</li>
/// <li>params: The Parameter for the Statement</li>
/// <li>namespace: The Namespace in which the Class is</li>
/// </ul>
/// </details>
ClassMethod exInsert(sql As %String, params As %String = "", namespace As %String = 0) As %Status
{
	#dim tEx as %Exception.SystemException
    #dim tSc as %Status = $$$OK
	#dim tStmt as %SQL.Statement = ##class(%SQL.Statement).%New()

	if namespace = 0{
		SET namespace = $NAMESPACE
	}
	SET beforeNamespace = $NAMESPACE
	ZN namespace

	//parseStringToArray
	SET list = $LISTFROMSTRING(params)
	SET values = $LL(list)
	for i = 0:1:$LL(list)
	{
		SET values(i) = $LG(list,i)
	}
	s b = 1
	//Make Execute
	try{
		SET tStmt.%SelectMode = 1
        $$$ThrowOnError(tStmt.%Prepare(sql))
		SET result = tStmt.%Execute(values...)
		if result.%SQLCODE < 0{
			SET tSc = 0
		}
	}
	catch tEx{
		SET tSc = tEx.OnAsStatus()
	}
	ZN beforeNamespace
	return tSc
}

/// <details>
/// <summary>Inserts a JSON Object into IRIS</summary>
/// <ul>
/// <li>namespace: The Namespace of the Classes</li>
/// <li>JSONString: The JSON String of the Object</li>
/// <li>obj: Only for recursively purpose</li>
/// <li>recursiveBeginning: Only for recursively purpose</li>
/// </ul>
/// </details>
ClassMethod InsertObjectOriented(namespace As %String = 0, JSONString As %String = "", obj As %DynamicAbstractObject = -1, recursiveBeginning As %Integer = 1)
{
	if recursiveBeginning = 1{
		SET beforeNamespace = $NAMESPACE
		ZN namespace
	}
	if obj = -1{
		try{
			//Convert to Dynamic Abstract Object
			SET obj = ##class(%DynamicAbstractObject).%FromJSON(JSONString)
		}catch ex{
			if recursiveBeginning = 1{
				//Return Message to Node-Red
				RETURN "Cannot convert JSON String "_ex.AsSystemError()
			}else{
				//Throw for lower recursive
				THROW ##class(%Exception.SystemException).%New("CANNOT CONVERT TO JSON STRING","999",,"Cannot convert JSON String: "_ex.AsSystemError())
			}
		}
	}
	SET iter = obj.%GetIterator() //Get Iterator 
	SET className = obj.className //Get className
	try{
		SET o = $SYSTEM.OBJ.New(className) //Make new Instance of class
	}catch ex{
		if recursiveBeginning = 1{
			//Return Message to Node-Red
			RETURN className_" does not exists: "_ex.AsSystemError()
		}else{
			//Throw for lower recursive
			THROW ##class(%Exception.SystemException).%New("CLASS DOES NOT EXISTS","999",,className_" does not exists: "_ex.AsSystemError())
		}
	}
	
	//Check if id Property exists and then return already existing object
	if (obj.%IsDefined("id")){
		SET id = obj.id
		RETURN $SYSTEM.OBJ.New(className).%OpenId(id)
	}

	//Iterate through JSON Object
	while iter.%GetNext(.key, .value, .type ) {
		if key = "className"{
			CONTINUE
		}
		//If Property is an object go recursive with that object
		if type = "object"{
			try{
				SET value = ##class(Node.IRISInterface).InsertObjectOriented(,value,0)
			}catch ex{
				if recursiveBeginning = 1{
					//Return Message to Node-Red
					RETURN ex.AsSystemError()
				}else{
					//Throw for lower recursive
					THROW ex
				}
			}
		}
		SET $PROPERTY(o,key) = value //Set Property
	}
	try{
		DO o.%Save() //Save object
	}catch ex{
		if recursiveBeginning = 1{
			//Return Message to Node-Red
			RETURN "Cannot save class "_ex.AsSystemError()
		}else{
			//Throw for lower recursive
			THROW ##class(%Exception.SystemException).%New("CANNOT SAVE CLASS","999",,"Cannot save class: "_ex.AsSystemError())

		}
	}

	if recursiveBeginning = 1{
		ZN beforeNamespace
		RETURN 1 //Return ok to Node Red
	}
	else{
		RETURN o //Return object for lower recursive
	}
}

ClassMethod ExecArray(sql As %String, params As %String = "", namespace As %String = 0) As %String
{
	#dim tEx as %Exception.SystemException
    #dim tSc as %Status = $$$OK
	#dim tStmt as %SQL.Statement = ##class(%SQL.Statement).%New()
	//Set namespace
	if namespace = 0{
		SET namespace = $NAMESPACE
	}
	SET beforeNamespace = $NAMESPACE
	ZN namespace
	
	//parseStringToArray
	//parse the parameters into an array
	SET list = $LISTFROMSTRING(params)
	SET values = $LL(list)
	for i = 0:1:$LL(list)
	{
		SET values(i) = $LG(list,i)
	}
	try{

		//Make Execute
		SET tStmt.%SelectMode = 1
		$$$ThrowOnError(tStmt.%Prepare(sql))
		SET result = tStmt.%Execute(values...)
		if result.%SQLCODE < 0{
			ZN beforeNamespace
			throw result.%Message
		}
		
		//Parse to JSON
		SET colList = result.%GetMetadata().columns
		SET cols = ""
		SET colArray = ##class(%DynamicArray).%New()

		for i = 1:1:colList.Size{
			SET cols(i) = colList.GetAt(i).colName
			DO colArray.%Push(cols(i))
		}
		
		SET a = $LB(colArray.%ToJSON())

		//iterate through results
		while result.%Next(){

			SET obj = ##class(%DynamicArray).%New()

			//iterate through coulmns in result
			for i = 1:1:colList.Size{
				SET value = result.%Get(cols(i))
				DO obj.%Push(value)	
			}
			SET a = a_$LB(obj.%ToJSON())
		}
	}
	catch tEx{
		RETURN tEx.AsStatus()
	}
	ZN beforeNamespace
	
	RETURN "["_$LISTTOSTRING(a)_"]"
}

/// <details>
/// <summary>Executes a SQl Query. params (optional) are the values of a paramerized query</summary>
/// <ul>
/// <li>sql: The SQL Query</li>
/// <li>params: The parameter of the Query in form of a String-List</li>
/// <li>namespace: The namespace in which the Query should be Executed</li>
/// </ul>
/// Returns the result in form of a JSON-String.
/// </details>
ClassMethod Exec(sql As %String, params As %String = "", namespace As %String = 0) As %String
{
	#dim tEx as %Exception.SystemException
    #dim tSc as %Status = $$$OK
	#dim tStmt as %SQL.Statement = ##class(%SQL.Statement).%New()
	//Set namespace
	if namespace = 0{
		SET namespace = $NAMESPACE
	}
	SET beforeNamespace = $NAMESPACE
	ZN namespace
	
	//parseStringToArray
	//parse the parameters into an array
	SET list = $LISTFROMSTRING(params)
	SET values = $LL(list)
	for i = 0:1:$LL(list)
	{
		SET values(i) = $LG(list,i)
	}
	try{

		//Make Execute
		SET tStmt.%SelectMode = 1
		$$$ThrowOnError(tStmt.%Prepare(sql))
		SET result = tStmt.%Execute(values...)
		if result.%SQLCODE < 0{
			ZN beforeNamespace
			THROW result.%Message
		}
		
		//Parse to JSON
		SET colList = result.%GetMetadata().columns
		SET cols = ""
		for i = 1:1:colList.Size{
			SET cols(i) = colList.GetAt(i).colName
		}
		
		SET a = ""

		//iterate through results
		while result.%Next(){

			SET obj = ##class(%DynamicObject).%New()

			//iterate through coulmns in result
			for i = 1:1:colList.Size{
				SET value = result.%Get(cols(i))
				//d obj.%Set(value)
				DO obj.%Set(cols(i),value)

				
				
			}
			SET a = a_$LB(obj.%ToJSON())
		}
	}
	catch tEx{
		return tEx.AsStatus()
	}
	ZN beforeNamespace

	///REST Service write über standard io
	
	return "["_$LISTTOSTRING(a)_"]"
}

ClassMethod ExecProduction(sql As %String, params As %String = "", namespace As %String = 0) As %List
{
	#dim tEx as %Exception.SystemException
    #dim tSc as %Status = $$$OK
	#dim tStmt as %SQL.Statement = ##class(%SQL.Statement).%New()
	//Set namespace
	if namespace = 0{
		SET namespace = $NAMESPACE
	}
	SET beforeNamespace = $NAMESPACE
	ZN namespace
	
	//parseStringToArray
	//parse the parameters into an array
	SET list = $LISTFROMSTRING(params)
	SET values = $LL(list)
	for i = 0:1:$LL(list)
	{
		SET values(i) = $LG(list,i)
	}
	try{

		//Make Execute
		SET tStmt.%SelectMode = 1
		$$$ThrowOnError(tStmt.%Prepare(sql))
		SET result = tStmt.%Execute(values...)
		if result.%SQLCODE < 0{
			ZN beforeNamespace
			throw result.%Message
		}
		
		//Parse to JSON
		//DO result.%NormalizeObject()
		SET colList = result.%GetMetadata().columns
		SET cols = ""
		for i = 1:1:colList.Size{
			SET cols(i) = colList.GetAt(i).colName
		}
		
		SET a = ""

		//iterate through results
		while result.%Next(){

			SET obj = ##class(%DynamicObject).%New()

			//iterate through coulmns in result
			for i = 1:1:colList.Size{
				SET value = result.%Get(cols(i))
				DO obj.%Set(cols(i),value)
				
				
			}
			SET a = a_$LB(obj.%ToJSON())
		}
	}
	catch tEx{
		return tEx.AsStatus()
	}
	ZN beforeNamespace
	///REST Service write über standard io
	
	return "["_$LISTTOSTRING(a)_"]"
}

}
