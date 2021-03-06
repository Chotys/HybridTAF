'let us introduce a change for GitHUB

Public Function initialize_framework()
	'Main tasks carried out in the initialization:
	'1.  Import the Data files for the test suite.
	DataTable.ImportSheet TEST_SUITE_DIR, TEST_SUITE_SHEET, TEST_SUITE_SHEET
	counter = 0
	
	rowCount = DataTable.GetSheet(TEST_SUITE_SHEET).GetRowCount
	For Iterator = 1 To rowCount
		DataTable.GetSheet(TEST_SUITE_SHEET).SetCurrentRow(Iterator)
		If DataTable.GetSheet(TEST_SUITE_SHEET).GetParameter("Execute").Value = "Y" Then
			counter = counter + 1
			testSuiteDic.Add DataTable.GetSheet(TEST_SUITE_SHEET).GetParameter("TEST_NAME").Value, DataTable.GetSheet(TEST_SUITE_SHEET).GetParameter("MAP_TEST").Value 
		End If		
	Next
	
	For each key in testSuiteDic
		print "The testcase " & key & " executes the test case " & testSuiteDic.Item(key)
	Next
	
	initializeRepoDic()
		
End Function


Public Function run_tests()
	'take advantage of test suite dic to execute the suite.  
	For each key in testSuiteDic	
		executeTestCase(key)
	Next
	
End Function

Public Function generate_reports()
	
End Function

Public Function executeTestCase(key)
	'a)  import test case procedure
	'b)  iterate through steps.  
	'for each step, 
	'1.  obtain input string, 
	'2.  import test data, if necessary,
	'3.  run test component.
	'create a datasheet with the name of the excel sheet, them import testProcedure Sheet into it.
	currentTestCaseName = key
	currentTestStepsName = testSuiteDic(key)
	DataTable.AddSheet currentTestStepsName
	DataTable.ImportSheet TEST_SUITE_DIR, currentTestStepsName, currentTestStepsName
	'Now iterate through every step, and execute them.  
	Set tcSheet = DataTable.GetSheet(currentTestStepsName)
	numSteps = tcSheet.GetRowCount
	For tcIterator = 1 To numSteps
		tcSheet.SetCurrentRow(tcIterator)
		executeStep(tcSheet)
	Next '	
End Function

Public Function executeStep(ByRef tcSheet)
	'import data, if necessary
	'get input string and set parameters
	'run component,
	'report step.  Use a testSuiteReportDic, whose keys are names of test cases.
	'the value is another dictionary that contains as keys the step numbers, 
	'and as values the concatenation of all info related to the data.  
	Dim action, objName, param, dataSheet
	dataSheetName = tcSheet.GetParameter("DATA_SHEET")
	If dataSheetName <> "" Then
		DataTable.AddSheet dataSheetName
		DataTable.ImportSheet TEST_DATA_DIR, dataSheetName, dataSheetName
		Set dataSheet = DataTable.GetSheet(dataSheetName)
		'find the TC row 
		setDataSheetRow(dataSheet)	
		
	End If
	
	setInputString tcSheet, action, objName, param
	'check whether param comes with brackets.  If it does, get the actual param from the data sheet.
	If dataSheetName <> "" and InStr(param, "[") = 1 Then
		'get the param from the datasheet, removing the brackets
		param_key = Mid(param, 2, Len(param) - 2)
		param = dataSheet.GetParameter(param_key)
	End If
	

	stepResult = performActionOnObject(action, objName, param)
	'Report step
	'TODO
	
	
	
End Function

Public Function setInputString(ByVal tcSheet, ByRef action, ByRef objName, ByRef param)
	inputString = tcSheet.GetParameter("INPUT")
	inputStringArr = Split(inputString, ":")
	If Ubound(inputStringArr) <> 0 Then
		'check that inputStringArr is not nothing.  otherwise ignore that line.
		action = inputStringArr(0)
		If Ubound(inputStringArr) > 0 Then		
			objName = inputStringArr(1)
		End IF
		If Ubound(inputStringArr) > 1 Then
			param = inputStringArr(2)
		End If
	End If
	
End Function

Public Function setDataSheetRow(ByRef ds)
	dataSheetCount = ds.GetRowCount
	For dsIterator = 1 To dataSheetCount
		ds.SetCurrentRow(dsIterator)
		If ds.GetParameter("TEST_NAME") = currentTestCaseName Then
			Exit For
		End If
	Next 
End Function

Public Function getTestCaseIndex(key)
	Set objExcel = CreateObject("Excel.Application")
	Set workBookObj = objExcel.Workbooks.Open(TEST_SUITE_DIR)
	testProcedureIndex = 0
	For Iterator = 1 To workBookObj.Sheets.Count
		If workBookObj.Sheets.Item(Iterator).Name = testSuiteDic.Item(key) Then
			testProcedureIndex = Iterator
			workBookObj.Close
			Exit For
		End If
		Print workBookObj.Sheets.Item(Iterator).Name	
	Next
	Set getTestCaseIndex = testProcedureIndex
End Function

Public Function initializeRepoDic()
	repoDic.Add "search", Browser("Google").Page("Google").WebEdit("Buscar")
	repoDic.Add "search_button", Browser("Google").Page("Google").WebButton("Buscar con Google_2")
	repoDic.Add "p", Browser("Yahoo").Page("Yahoo").WebEdit("p")
	repoDic.Add "buscar_web", Browser("Yahoo").Page("Yahoo").WebButton("Buscar en la Web")
End Function

Public Function getDataParam(ByRef ds, ByRef param)
	
	
End Function
