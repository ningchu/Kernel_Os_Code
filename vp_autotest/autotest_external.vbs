On Error Resume Next

'''''''''''������������

Dim objXML ' object to hold the xml document 

'***************************************************************** 
'** create the xml object 
Set objXML = CreateObject("Msxml2.DOMDocument.6.0") 

dim Nodelist,xmlDoc 
'***************************************************************** 
'** Load the xml from file 
objXML.load("CONFIG.xml") 
'***************************************************************** 
'** Set language for finding information to XPath 
objXML.setProperty "SelectionLanguage", "XPath" 
'***************************************************************** 

set START_TEST_NODE = objXML.selectSingleNode("/property/start_test_node")
num=START_TEST_NODE.text

while 1

objXML.load("CONFIG.xml") 

'** Get a reference to the node 
set VDK_SETUP_PATH = objXML.selectSingleNode("/property/vdk_setup_path") 
set START_TEST_NODE = objXML.selectSingleNode("/property/start_test_node")
set JENKINS_PATH = objXML.selectSingleNode("/property/jenkins_path")
set WAIT_FOR_DOWNLOAD = objXML.selectSingleNode("/property/wait_for_download") 
set ENABLE_NODE =  objXML.selectSingleNode("/property/enable_node")
set EMAIL_SUBJECT = objXML.selectSingleNode("/property/email_subject") 
set EMAIL_RECIEVE =  objXML.selectSingleNode("/property/email_recieve")

If ENABLE_NODE.text = 1 Then
num=START_TEST_NODE.text
GetXml "CONFIG.xml","enable_node"
Nodelist(0).childnodes(0).nodevalue = 0
xmlDoc.save "CONFIG.xml" 
Else

GetXml "CONFIG.xml","start_test_node"
Nodelist(0).childnodes(0).nodevalue = num 
xmlDoc.save "CONFIG.xml" 

End if


''''''''''''�ж�jenkins�����Ƿ��и���

Dim XMLHTTP, STREAM, Url, Fosall, Path
Set Fsoall = CreateObject("Scripting.FileSystemObject")
Path = CreateObject("Wscript.Shell").CurrentDirectory & "\"
Url = JENKINS_PATH.text
Set XMLHTTP = CreateObject("MsXml2.XmlHttp")
XMLHTTP.open "get", Url, False
XMLHTTP.send()
Do Until XMLHTTP.readyState = 4 : WScript.Sleep 200 : Loop
WScript.Sleep 2000
Set STREAM = CreateObject("Adodb.Stream")
STREAM.Type = 1
STREAM.Mode = 3
STREAM.Open()
STREAM.Write XMLHTTP.responseBody
STREAM.SaveToFile "temp.html", 2
XMLHTTP.abort
Set XMLHTTP = Nothing
STREAM.Close
Set STREAM = Nothing
If InStr(Fsoall.OpenTextFile(Path & "temp.html").ReadAll(), "#"&num) Then    
  
fsoall.CreateFolder "autotest\"&num


delay_times = 0
down_finish = 0
while delay_times<100 and down_finish=0


'''''''''''���������µ�img
Set Post = CreateObject("Msxml2.XMLHTTP")
Set Shell = CreateObject("Wscript.Shell")
Post.Open "GET",JENKINS_PATH.text&"/"&num&"/artifact/IMG/iwhale2_vdk-userdebug-native.tar.gz",0
Post.Send()
Set aGet = CreateObject("ADODB.Stream")
aGet.Mode = 3
aGet.Type = 1
aGet.Open() 
aGet.Write(Post.responseBody)
aGet.SaveToFile "autotest\"&num&"\iwhale2_vdk-userdebug-native.tar.gz",2
wscript.sleep 1000



set fso=createobject("Scripting.FileSystemObject")



set objfile=fso.getfile("autotest\"&num&"\iwhale2_vdk-userdebug-native.tar.gz")

If objfile.size < 5000 Then
down_finish = 0
delay_times = delay_times+1
wscript.sleep WAIT_FOR_DOWNLOAD.text
Else
down_finish = 1

'''''''''''''''��ѹimg��������ָ��·����
Shell.Run("winrar X -o+ autotest\"&num&"\iwhale2_vdk-userdebug-native.tar.gz autotest\"&num&"\")

wscript.sleep 100000

fso.CopyFile "autotest\"&num&"\u-boot-dtb.bin","..\..\..\other\Software\UBOOT\",True

fso.CopyFile "autotest\"&num&"\boot.img","..\..\..\other\Software\OS\",True

fso.CopyFile "autotest\"&num&"\system.img","..\..\..\other\Software\OS\",True
fso.CopyFile "autotest\"&num&"\userdata.img","..\..\..\other\Software\OS\",True

wscript.sleep 30000

''''''''''�ȹر��ϴ�������VP
Close_Process("_ui_vpexplorer.exe") 
Close_Process("sim.exe") 
Close_Process("ATPS2LCD.exe") 
Close_Process("cmd.exe")

fso.deleteFile "..\..\..\simulation\terminal.log" '''''''''''ɾ���ϴε�log�ļ�
foldername=num-10
fso.deletefolder "autotest\"&foldername'''''''''''''''ֻ�������10�ε��ļ���

''''''''''''''����VP�Լ������
dim wsh
set wsh = CreateObject("Wscript.Shell")
wsh.run "start_vpx_Main.bat"
wscript.sleep 300000
wsh.appactivate "cockpit.skn"




''''''''''''''������Ҫ���������

Set mouse=New SetMouse 
'mouse.getpos x,y ''�����굱ǰλ������
'MsgBox x & " " & y 
width=CreateObject("HtmlFile").ParentWindow.Screen.AvailWidth
height=CreateObject("HtmlFile").ParentWindow.Screen.AvailHeight
'MsgBox width & " " & height 
mouse.move width/4,height/3 '������ƶ�������
WScript.Sleep 200
mouse.clik "LEFT"



''''''''''''''����logcat -v time

wscript.sleep 40000

wsh.sendkeys "l"
wscript.sleep 1000
wsh.sendkeys "o"
wscript.sleep 1000
wsh.sendkeys "g"
wscript.sleep 1000
wsh.sendkeys "c"
wscript.sleep 1000
wsh.sendkeys "a"
wscript.sleep 1000
wsh.sendkeys "t"
wscript.sleep 1000
wsh.sendkeys " "
wscript.sleep 1000
wsh.sendkeys "-"
wscript.sleep 1000
wsh.sendkeys "v"
wscript.sleep 1000
wsh.sendkeys " "
wscript.sleep 1000
wsh.sendkeys "t"
wscript.sleep 1000
wsh.sendkeys "i"
wscript.sleep 1000
wsh.sendkeys "m"
wscript.sleep 1000
wsh.sendkeys "e"
wscript.sleep 1000
wsh.sendkeys "{ENTER}"

wscript.sleep 350000

'''''''''''ɾ��img
'fso.deletefile "..\..\..\other\Software\UBOOT\u-boot-dtb.bin"
'fso.deletefile "..\..\..\other\Software\OS\boot.img"
'fso.deletefile "..\..\..\other\Software\OS\system.img"
'fso.deletefile "..\..\..\other\Software\OS\userdata.img"

End If '''''''����ѹ������С�ж�
Wend '''''''�����½��img�����Ƿ�ɹ����������30000�뻹û���ص�����Ϊ�Ǹý������ʧ�ܡ�

''''''''''�ж�log�ļ����Ƿ�ɹ�����android

 
dim logname,use_time


logname=year(Now)&"-"&Month(Now)&"-"&day(Now)&"-"&Hour(Now)&"-"&Minute(Now)&"-"&Second(Now)

set fso = createobject("scripting.filesystemobject") 
 
set stream = fso.opentextfile("..\..\..\simulation\terminal.log",1)
 
content = stream.readall()
 
If down_finish=0 Then
set file=fso.createtextfile("autotest\"&num&"\fail-"+logname+"",2,true)
file.writeline "Download is fail!"
file.close
result="FAIL"
fail_reason="Download is fail! Maybe the node don't product IMG . Please to check it"
use_time=0
attachment=VDK_SETUP_PATH.text&"\skins\Linux\Scripts\autotest\"&num&"\fail-"&logname

Elseif ubound(split(content,"Boot is finished"))<=0 Then
fso.CopyFile "..\..\..\simulation\terminal.log","autotest\"&num&"\fail-"+logname+""
result="FAIL"
use_time=0
attachment=VDK_SETUP_PATH.text&"\skins\Linux\Scripts\autotest\"&num&"\fail-"&logname
if ubound(split(content,"logcat -v time"))<=0 Then
fail_reason="Don't enter <logcat -v time>,so the android log is not in the logfile."
else
fail_reason="Start android fail,Please to check the logfile!"
End If
Else
fso.CopyFile "..\..\..\simulation\terminal.log","autotest\"&num&"\pass-"+logname+""
result="PASS"
fail_reason="None"

''''''''''''''''''''''��ȡ�������ѵ�ʱ��
Mystr = split(content,"Boot is finished")
str=left(Mystr(1),10)
st=split(str,"(")
s=left(st(1),4)
use_time=Cint(s)


attachment=VDK_SETUP_PATH.text&"\skins\Linux\Scripts\autotest\"&num&"\pass-"&logname

End If


wscript.sleep 5000

'''''''''''''''���ͽ���ʼ� 

set out=WScript.CreateObject("Outlook.Application")   
set oitem = out.CreateItem(olMailItem)
 With oitem
 .Subject =EMAIL_SUBJECT.text '�����ʼ�����
 .To =EMAIL_RECIEVE.text
 .Body = "Node Number : #"&num&vbcrlf&"Test Date : "&logname&vbcrlf&"Test Result : "&result&vbcrlf&"Use_time : "&use_time&vbcrlf&"fail_reason : "&fail_reason&vbcrlf&"Log And IMG Path : "&VDK_SETUP_PATH.text&"\skins\Linux\Scripts\autotest\"&num&"\"&vbcrlf&vbcrlf&"Attachment is log file ..."&vbcrlf&vbcrlf&"Jenkins��ַ��http://10.0.1.90:8080/jenkins/job/sprdroid6.0_iwhale2_presi_dev/"&vbcrlf&vbcrlf&"����ƽ̨��ַ��http://tjsdelab.spreadtrum.com/autotest.action" '�����ʼ�����
 '�����ʼ�����
 .Attachments.Add(attachment)
 .Send
 End With
 set out=nothing
 set oitem=nothing


'''''''''''''''''''''����excel����

Dim FileName, SheetName, Text, ExcelApp, ExcelBook, ExcelSheet 
FileName = "D:/autotest_result.xlsx" 
Number = "����"
Cost_Time = "����ʱ��"
Res = "���"
Test_Time = "����ʱ��"
Log_Addr = "Log��ַ"
Set ExcelApp = CreateObject("Excel.Application") 
Set ExcelBook= ExcelApp.Workbooks.Open(FileName) 
Set ExcelSheet = ExcelBook.Sheets(1) '���ָ��������' *************** �����ݱ��Ĳ��� *************** 

ExcelSheet.Cells(1,1).Value = Number
ExcelSheet.Cells(1,2).Value = Cost_Time
ExcelSheet.Cells(1,3).Value = Res
ExcelSheet.Cells(1,4).Value = Test_Time
ExcelSheet.Cells(1,5).Value = Log_Addr

ExcelSheet.Cells(2,1).Value = num
ExcelSheet.Cells(2,2).Value = use_time
ExcelSheet.Cells(2,3).Value = result
ExcelSheet.Cells(2,4).Value = logname
ExcelSheet.Cells(2,5).Value = VDK_SETUP_PATH.text&"\skins\Linux\Scripts\autotest\"&num&"\"

ExcelBook.Save 
ExcelBook.Close 
ExcelApp.Quit 
Set ExcelBook = Nothing 
Set ExcelApp = Nothing 
call stream.close()


''''''''''''''''''�ϴ�����
set oShell = WScript.CreateObject("WSCript.shell")
oShell.run "python autotestToMysql.py D:/autotest_result.xlsx"
set oShell = Nothing


num=num+1

Fso.DeleteFile "temp.html"

Else ''''''''''���jenkins����û�и���

wscript.sleep WAIT_FOR_DOWNLOAD.text

End If

Wend '''��ѭ������



'''''''''''''''���xml�ļ��еĲ������
Function GetXml(byval strXmlFilePath,byval xmlNodename)
dim xmlRoot 
Set xmlDoc = CreateObject("Microsoft.XMLDOM")
xmlDoc.async = False
xmlDoc.load strXmlFilePath
if xmlDoc.parseError.errorCode <> 0  then
msgbox "XML�ļ���ʽ���ԣ�ԭ���ǣ� "& xmlDoc.parseError.reason
Exit Function
end if
Set xmlRoot = xmlDoc.documentElement
set Nodelist = xmlRoot.getElementsByTagname(xmlNodename)
GetXml = True 
end function




'''''''''''��������
sub Close_Process(ProcessName)  
On Error Resume Next  
     for each ps in getobject("winmgmts:\\.\root\cimv2:win32_process").instances_ 'ѭ������  
           if Ucase(ps.name)=Ucase(ProcessName) then  
                 ps.terminate  
           end if  
     next  
end sub  




''''''''''��������

Class SetMouse
 private S
 private xls, wbk, module1
 private reg_key, xls_code, x, y
 

Private Sub Class_Initialize()
 Set xls = CreateObject("Excel.Application") 
Set S = CreateObject("wscript.Shell")
 'vbs ��ȫ����excel
 reg_key = "HKEY_CURRENT_USER\Software\Microsoft\Office\$\Excel\Security\AccessVBOM"
 reg_key = Replace(reg_key, "$", xls.Version)
 S.RegWrite reg_key, 1, "REG_DWORD"
 'model ����
xls_code = _
 "Private Type POINTAPI : X As Long : Y As Long : End Type" & vbCrLf & _
 "Private Declare Function SetCursorPos Lib ""user32"" (ByVal x As Long, ByVal y As Long) As Long" & vbCrLf & _
 "Private Declare Function GetCursorPos Lib ""user32"" (lpPoint As POINTAPI) As Long" & vbCrLf & _
 "Private Declare Sub mouse_event Lib ""user32"" Alias ""mouse_event"" " _
 & "(ByVal dwFlags As Long, ByVal dx As Long, ByVal dy As Long, ByVal cButtons As Long, ByVal dwExtraInfo As Long)" & vbCrLf & _
 "Public Function getx() As Long" & vbCrLf & _
 "Dim pt As POINTAPI : GetCursorPos pt : getx = pt.X" & vbCrLf & _
 "End Function" & vbCrLf & _
 "Public Function gety() As Long" & vbCrLf & _
 "Dim pt As POINTAPI: GetCursorPos pt : gety = pt.Y" & vbCrLf & _
 "End Function"
 Set wbk = xls.Workbooks.Add 
Set module1 = wbk.VBProject.VBComponents.Add(1)
 module1.CodeModule.AddFromString xls_code 
End Sub
 



'�ر�
 Private Sub Class_Terminate
 xls.DisplayAlerts = False
 wbk.Close
 xls.Quit
 End Sub
 
'�ɵ��ù���
 

Public Sub getpos( x, y) 
x = xls.Run("getx") 
y = xls.Run("gety") 
End Sub 


Public Sub move(x,y)
 xls.Run "SetCursorPos", x, y
 End Sub 

 
 
Public Sub clik(keydown)
 Select Case UCase(keydown)
 Case "LEFT"
 xls.Run "mouse_event", &H2 + &H4, 0, 0, 0, 0
 Case "RIGHT"
 xls.Run "mouse_event", &H8 + &H10, 0, 0, 0, 0
 Case "MIDDLE"
 xls.Run "mouse_event", &H20 + &H40, 0, 0, 0, 0
 Case "DBCLICK"
 xls.Run "mouse_event", &H2 + &H4, 0, 0, 0, 0
 xls.Run "mouse_event", &H2 + &H4, 0, 0, 0, 0
 End Select
 End Sub 


End Class