'Global vars
Const TEST_DATA_DIR = "C:\Automation\Google\data\google_data.xls"
Const TEST_SUITE_DIR = "C:\Automation\Google\driver\google_driver.xls"
Const TEST_SUITE_SHEET = 1
Const TEST_CASE_SHEET = 2
Const TEST_DATA_SHEET = 3
Set testSuiteDic = CreateObject("Scripting.Dictionary")
Set testResultDic = CreateObject("Scripting.Dictionary")
Set testExecutionReport = CreateObject("Scripting.Dictionary")
Set repoDic = CreateObject("Scripting.Dictionary")
Dim currentTestCaseName
Dim mainBrowser
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8
Const COMMENT_STARTER = "#"
Const ARGUMENT_SPLITTER = "="
Const LOG_SEPARATOR = "############################################################"
Const INIT_FILE_PATH = "C:\framework\Init.ini"
Const DEFAULT_LOG_FILE_PATH = "C:\framework\logFile.txt"
Const DEFAULT_LOG_LEVEL = 3
Const adOpenStatic = 3
Const adLockOptimistic = 3
Const adCmdText = &H0001
     '10
Dim logFile
Dim logLevel
Dim initDic
Dim globalParamsDic, testSuiteDic
