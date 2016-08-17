On Error Resume Next
wscript.sleep 1000
Set Shell = CreateObject("Wscript.Shell")
set fso = CreateObject("Scripting.FileSystemObject")

start_time = year(Now)&"-"&Month(Now)&"-"&day(Now)&"-"&Hour(Now)&"-"&Minute(Now)&"-"&Second(Now)

Shell.currentdirectory = "D:\user_autotest"

fso.CreateFolder "work\"&start_time

set logfile = fso.Createtextfile("work\"&start_time&"\start_time.log",true)

logfile.writeline("start to check the arguments")

wscript.echo "start to check the arguments"

num=0
Do while ubound(split(wscript.arguments(num),"end"))<=0
	num = num + 1
loop

if ubound(split(wscript.arguments(num),cstr(num))) > 0 then
	logfile.writeline("arguments number is right")
	wscript.echo "arguments number is right"
else
	logfile.writeline("arguments number is wrong")
	wscript.echo "arguments number is wrong"
end if

''''''''''''''''''''''''''判断是否需要使用指定镜像文件
if wscript.arguments(3)<>"none" then
	logfile.writeline("Start to download Img at "&wscript.arguments(3))
	wscript.echo "Start to download Img at "&wscript.arguments(3)
	Set Postimg = CreateObject("Msxml2.XMLHTTP")
	Postimg.Open "GET",wscript.arguments(3),0
	Postimg.Send()
	Set imgGet = CreateObject("ADODB.Stream")
	imgGet.Mode = 3
	imgGet.Type = 1
	imgGet.Open() 
	imgGet.Write(Postimg.responseBody)

	imgGet.SaveToFile "work\"&start_time&"\IMG.tar.gz",2

	wscript.sleep 10000
	Shell.Run("winrar X -o+ work\"&start_time&"\IMG.tar.gz work\"&start_time&"\")
	wscript.sleep 10000
end if

if wscript.arguments(4)<>"none" then
	logfile.writeline("Start to download cache img at "&wscript.arguments(2))
	wscript.echo "Start to download cache img at "&wscript.arguments(2)

'''''''''''先下载最新的img
	Set Post = CreateObject("Msxml2.XMLHTTP")
	Post.Open "GET",wscript.arguments(2),0
	Post.Send()
	Set aGet = CreateObject("ADODB.Stream")
	aGet.Mode = 3
	aGet.Type = 1
	aGet.Open() 
	aGet.Write(Post.responseBody)

	aGet.SaveToFile "work\"&start_time&"\cache.img",2	
end if

'''''''''''''''''解析文件判断使用哪个vdk版本
	
logfile.writeline("project is "&wscript.arguments(0))

wscript.echo "project is "&wscript.arguments(0)
if wscript.arguments(0)="isharkl2" Then
	Shell.currentdirectory = "D:\Program Files (x86)\Synopsys\Butter2Refresh-0.0.3\skins\Linux\Scripts"
	Path = "D:\Program Files (x86)\Synopsys\Butter2Refresh-0.0.3"
else
	Shell.currentdirectory = "D:\Program Files (x86)\Synopsys\Butter3-0.0.6.8\skins\Linux\Scripts"
	Path = "D:\Program Files (x86)\Synopsys\Butter3-0.0.6.8"
end if


'''''''''''''''''判断是否可以获得锁，相同锁超过30分钟没有释放则自动强制释放
re = 0
while fso.fileexists("D:/lock.txt")
	set fn = fso.getfile("D:/lock.txt")
	createtime = fn.datecreated
	if oldtime <> createtime then
		oldtime = createtime
		re = 180   ''''''''''''''''''''''''''''''单位为10s
		wscript.echo "lock is checked , start to wait "&re&"0 sec"
	end if

	if re <> 0 then
		wscript.sleep 10000
		re = re - 1
	else
		fso.deletefile("D:/lock.txt")
		wscript.sleep 10000
	end if
	
	logfile.writeline("vdk is running by others,please wait ......")
	wscript.echo "vdk is running by others,please wait ......"
wend

logfile.writeline("create vdk lock")
wscript.echo "create vdk lock"

set lockfile = fso.createtextfile("D:/lock.txt",true)

if wscript.arguments(4)<>"none" then
'''''''''''''''''将cache.img拷贝到指定路径下
	fso.CopyFile "D:\user_autotest\work\"&start_time&"\cache.img","..\..\..\other\Software\OS\",True
end if

if wscript.arguments(3)<>"none" then
	fso.CopyFile "D:\user_autotest\work\"&start_time&"\u-boot-dtb.bin","..\..\..\other\Software\UBOOT\",True
	fso.CopyFile "D:\user_autotest\work\"&start_time&"\boot.img","..\..\..\other\Software\OS\",True
	fso.CopyFile "D:\user_autotest\work\"&start_time&"\system.img","..\..\..\other\Software\OS\",True
	fso.CopyFile "D:\user_autotest\work\"&start_time&"\userdata.img","..\..\..\other\Software\OS\",True
end if


'''''''''''''''''关闭上次的VDK
Close_Process("_ui_vpexplorer.exe") 
Close_Process("sim.exe") 
Close_Process("ATPS2LCD.exe") 
'Close_Process("cmd.exe")

wscript.sleep 2000

logfile.writeline("start to boot VDK")
wscript.echo "start to boot VDK"

''''''''''''''启动VP以及激活窗口
dim wsh
set wsh = CreateObject("Wscript.Shell")
wsh.run "start_vpx_Main.bat"

wscript.sleep 150000

wsh.appactivate "cockpit.skn"
wscript.sleep 4000
wsh.appactivate "cockpit.skn"
wscript.sleep 4000
wsh.appactivate "cockpit.skn"

''''''''''''''计算需要点击的坐标

Set mouse=New SetMouse 
'mouse.getpos x,y ''获得鼠标当前位置坐标
'MsgBox x & " " & y 
width=CreateObject("HtmlFile").ParentWindow.Screen.AvailWidth
height=CreateObject("HtmlFile").ParentWindow.Screen.AvailHeight
'MsgBox width & " " & height 
mouse.move width/4,height/3 '把鼠标移动到坐标
WScript.Sleep 2000
mouse.clik "LEFT"


wscript.sleep 10000

wsh.sendkeys " "
wscript.sleep 1000
wsh.sendkeys "s"
wscript.sleep 1000
wsh.sendkeys "u"
wscript.sleep 1000
wsh.sendkeys " "
wscript.sleep 1000
wsh.sendkeys "{ENTER}"
wscript.sleep 10000

if wscript.arguments(4)<>"none" then
''''''''''''''输入su mount


	logfile.writeline("start to mount cache image")
	wscript.echo "start to mount cache image"

	command="mount -t ext4 -o rw /dev/block/memdisk.2 cache"
	for i = 1 to len(command) 
		wsh.sendkeys mid(command,i,1)
		wscript.sleep 1000
	next
	wsh.sendkeys "{ENTER}"

	wscript.sleep 10000

	num = 4

	logfile.writeline("start to run benchmark")
	wscript.echo "start to run benchmark"

	Do while ubound(split(wscript.arguments(num),"end"))<=0
		mes=wscript.arguments(num)
		if ubound(split(wscript.arguments(num),";;"))>0 then
			com1 = split(wscript.arguments(num),";;")
			com2 = split(com1(1),"am ")
			wscript.sleep 10000
			for i = 1 to len(com1(0)) 
				wsh.sendkeys mid(com1(0),i,1)
				wscript.sleep 1000
			next
			wsh.sendkeys "{ENTER}"
			wscript.sleep 300000

			wscript.sleep 10000
			for i = 1 to len(com2(1)) 
				wsh.sendkeys mid(com2(1),i,1)
			wscript.sleep 1000
			next
			wsh.sendkeys "{ENTER}"
			wscript.sleep 300000
		else
			wscript.sleep 10000
			for i = 1 to len(mes) 
			wsh.sendkeys mid(mes,i,1)
			wscript.sleep 1000
			next
			wsh.sendkeys "{ENTER}"
			wscript.sleep 300000
		end if

		num = num + 1
	loop
end if


wscript.sleep 10000

command="logcat -v time"
for i = 1 to len(command) 
	wsh.sendkeys mid(command,i,1)
	wscript.sleep 1000
next
wsh.sendkeys "{ENTER}"

wscript.sleep 20000

mlog = "none"
if wscript.arguments(4)<>"none" then

'''''''''''''''''''分析提取log''''''''''''''''''

	set Myfile = fso.OpenTextFile("..\..\..\simulation\terminal.log",1,TRUE)
	ss = split(Myfile.readall()," su ")
	mes_log = split(ss(1),"logcat -v time")
	mlog = mes_log(0)
	Myfile.Close
else
	wscript.sleep 600000
end if

wscript.sleep 10000

set Myfile = fso.OpenTextFile("..\..\..\simulation\terminal.log",1,TRUE)

if ubound(split(Myfile.readall(),"Boot is finished")) <= 0 Then
	fso.CopyFile "..\..\..\simulation\terminal.log","D:\user_autotest\work\"&start_time&"\fail.log"
	result = "FAIL"
else
	fso.CopyFile "..\..\..\simulation\terminal.log","D:\user_autotest\work\"&start_time&"\pass.log"
	result = "PASS"
end if

Myfile.Close

attachmentlog= Path&"\simulation\terminal.log"

set out = WScript.CreateObject("Outlook.Application")   
set oitem = out.CreateItem(olMailItem)
With oitem
	.Subject = "VDK_AUTOTEST RESULT EMAIL"
 	.To = wscript.arguments(1)&";ning.chu@spreadtrum.com"
 	.Body = "Board : "&wscript.arguments(0)&vbcrlf&"Start Time : "&start_time&vbcrlf&"Use Image : The newest node image"&vbcrlf&"Androird Boot : "&result&vbcrlf&"Test Result :"&vbcrlf&mlog&vbcrlf&vbcrlf&"数据平台地址：http://tjsdelab.spreadtrum.com/autotestUpload.action"&vbcrlf&vbcrlf&"Attachment is log file" '电子邮件内容
 	.Attachments.Add(attachmentlog)
 	.Send
End With
set out=nothing
set oitem=nothing

lockfile.close


fso.deletefile("D:/lock.txt")

logfile.writeline("Test is end,email of result has been sent to "&wscript.arguments(1))
wscript.echo "Test is end,email of result has been sent to "&wscript.arguments(1)

logfile.close

wscript.sleep 15000

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''辅助函数'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 

'''''''''''结束进程
sub Close_Process(ProcessName)  
On Error Resume Next  
     for each ps in getobject("winmgmts:\\.\root\cimv2:win32_process").instances_ '循环进程  
           if Ucase(ps.name)=Ucase(ProcessName) then  
                 ps.terminate  
           end if  
     next  
end sub  

'''''''''''''''获得xml文件中的操作结点
Function GetXml(byval strXmlFilePath,byval xmlNodename)
dim xmlRoot 
Set xmlDoc = CreateObject("Microsoft.XMLDOM")
xmlDoc.async = False
xmlDoc.load strXmlFilePath
if xmlDoc.parseError.errorCode <> 0  then
msgbox "XML文件格式不对，原因是： "& xmlDoc.parseError.reason
Exit Function
end if
Set xmlRoot = xmlDoc.documentElement
set Nodelist = xmlRoot.getElementsByTagname(xmlNodename)
GetXml = True 
end function




''''''''''点击鼠标类

Class SetMouse
 private S
 private xls, wbk, module1
 private reg_key, xls_code, x, y
 

Private Sub Class_Initialize()
 Set xls = CreateObject("Excel.Application") 
Set S = CreateObject("wscript.Shell")
 'vbs 完全控制excel
 reg_key = "HKEY_CURRENT_USER\Software\Microsoft\Office\$\Excel\Security\AccessVBOM"
 reg_key = Replace(reg_key, "$", xls.Version)
 S.RegWrite reg_key, 1, "REG_DWORD"
 'model 代码
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
 



'关闭
 Private Sub Class_Terminate
 xls.DisplayAlerts = False
 wbk.Close
 xls.Quit
 End Sub
 
'可调用过程
 

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
