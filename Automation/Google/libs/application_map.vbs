Public Function performActionOnObject(action, objName, param)
	'Here's where the magic happens.  
	'First, get the actual UFT object from the repository, 
	'or build a description from param.  
	'param might contain more than one property:value pair. 
	'use a select case to discriminate the different types of objects, 
	'and call specific functions for each type of object
	'TODO
	Print "Performing " & action & " operation on object " & objName & " with param " & param
	If InStr(1, objName, "generic") <> 1 Then
		performActionOnRepoObject action, getRepositoryObject(objName), param
	Else
		performActionOnDescriptiveObject action, objName, param
	End If
	
End Function

Public Function getRepositoryObject(objName)
	Set getRepositoryObject = repoDic(objName)
End Function

Public Function performActionOnRepoObject(action, webObj, param)
	With webObj
		objClass = .GetRoProperty("micclass")
		Select Case objClass
			Case "WebEdit"
				performActionOnWebEdit action, webObj, param
				mainBrowser.Sync
			Case "WebButton"
				performActionOnWebButton action, webObj
				mainBrowser.Sync
			Case "WebElement"
				performActionOnWebElement action, webObj
				mainBrowser.Sync
			Case "Link"
				performActionOnWebLink action, webObj
				mainBrowser.Sync
			Case Else
				print "This object is not yet supported."
		End Select
	End With
End Function

Public Function performActionOnWebEdit(action, webObj, param)
	Select Case action
		Case "set"
			webObj.Set param
			mainBrowser.Sync
			'Report Step goes here.
		Case "verify_exists"
			If webObj.Exist(5) Then
				Reporter.ReportEvent micPass, "Verify WebEdit Existence", "Web edit " & webObj.getRoProperty("name") & " exists."
			Else
				Reporter.ReportEvent micFail,"Verify WebEdit Existence", "Web edit " & webObj.getRoProperty("name") & " does not exist."
			End If
			'there should also be a Report Step function call.
	End Select
	
	
End Function

Public Function performActionOnWebButton(action, webObj)
	Select Case action
		Case "click"
			webObj.Click
			mainBrowser.Sync
			mainBrowser.Sync
			'Report Step goes here.
		Case "verify_exists"
			If webObj.Exist(5) Then
				Reporter.ReportEvent micPass, "Verify WebButton Existence",  "WebButton " & webObj.getRoProperty("name") & " exists."
			Else
				Reporter.ReportEvent micFail, "Verify WebButton Existence",  "WebButton " & webObj.getRoProperty("name") & " does not exist."
			End If
			'there should also be a Report Step function call.
		End Select
	
End Function

Public Function performActionOnWebLink(action, webObj)
	Select Case action		
		Case "click"
			mainBrowser.Sync
			webObj.Click
			mainBrowser.Sync
			'Report Step goes here.
		Case "verify_exists"
			mainBrowser.Sync
			While not mainBrowser.WaitProperty("attribute/readyState", "complete", 3000)
				wait(2)
				print "waiting for page"
			Wend
			wait(5)
			If webObj.Exist(5) Then
				Reporter.ReportEvent micPass, "Verify WebLink Existence",  "WebLink " & webObj.getRoProperty("name") & " exists."
			Else
				Reporter.ReportEvent micFail, "Verify WebLink Existence",  "WebLink " & webObj.getRoProperty("name") & " does not exist."
			End If
			'there should also be a Report Step function call.
	End Select
	
End Function

Public Function performActionOnWebElement(action, webObj)
	Select Case action
		Case "click"
			webObj.Click
			mainBrowser.Sync
			'Report Step goes here.
		Case "verify_exists"
			If webObj.Exist(5) Then
				Reporter.ReportEvent micPass, "Verify WebElement Existence", "WebElement " & webObj.getRoProperty("name") & " exists."
			Else
				Reporter.ReportEvent micFail, "Verify WebElement Existence", "WebElement " & webObj.getRoProperty("name") & " does not exist."
			End If
			'there should also be a Report Step function call.
	End Select
	
End Function

Public Function performActionOnDescriptiveObject(action, objName, param)
	'First we have to determine what sort of object the objName is.
	'Next, create an object description and hence the object
	'Next, call performActionOnWebXXXXXXX
	'The exception, genericBrowser, which has to actually start the browser. 
	objClass = Mid(objName, Len("generic") + 1)
	Select Case objClass
		Case "Browser"
			closeAllBrowsers
			SystemUtil.Run "iexplore.exe", param
			Set mainBrowser = Browser("CreationTime:=0").Page("title:=.*")
			mainBrowser.Sync
		Case "Link"
			While not mainBrowser.WaitProperty("attribute/readyState", "complete", 3000)
				wait(2)
				print "waiting for page"
			Wend
			wait(15)
			Set webLinkObjDesc = getObjectDesc(objClass, param)
			Set linkColl = mainBrowser.ChildObjects(webLinkObjDesc)
			'msgbox linkColl.count
			If linkColl.Count >= 1 Then
				Set webLinkObj = linkColl(0)
			Else
				Reporter.ReportEvent micFail, "Web Link Object exists", "Web Link Object " & param & " does not exist"
			End If
			'Set webLinkObj = mainBrowser.Link(webLinkObjDesc)
			performActionOnWebLink action, webLinkObj
			mainBrowser.Sync	
		Case "Element"
			Set webElementObjDesc = getObjectDesc(objClass, param)
			Set webElementObj = mainBrowser.WebElement(webElementObjDesc)
			performActionOnWebElement action, webLinkObj
			mainBrowser.Sync
		Case "Button"
			Set webButtonObjDesc = getObjectDesc(objClass, param)
			Set webButtonObj = mainBrowser.WebButton(webButtonObjDesc)
			performActionOnWebElement action, webButtonObj
			mainBrowser.Sync
		Case Else
			Print "This object is not yet supported."
	End Select
	Print "creating object with action, objName and param"
End Function

Public Function closeAllBrowsers()
	Set ab=Description.Create
	ab("micclass").value="Browser" 
	Set obj=Desktop.ChildObjects(ab)
	For i=0 to obj.count-1
		c=obj(i).getroproperty("name") 
		Print c
	 	obj(i).Close 
	Next
End Function

Public Function getObjectDesc(objClass, param)
	Set objDesc = Description.Create
	Select Case objClass
		Case "Link"
			objDesc("micclass").Value = "Link"
			objDesc("html tag").Value = "A"
			objDesc("innertext").Value = param	
		Case "Element"
			objDesc("micclass").Value = "WebElement"
			objDesc("html tag").Value = "SPAN"
			objDesc("innertext").Value = param			
		Case "Button"
			objDesc("micclass").Value = "WebButton"
			objDesc("html tag").Value = "BUTTON"
			objDesc("innertext").Value = param			
		Case Else
			Print "This object is not yet supported."
	End Select
	Set getObjectDesc = objDesc
	
End Function
