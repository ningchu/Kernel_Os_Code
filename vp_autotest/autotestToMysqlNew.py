# This Python file uses the following encoding: utf-8
#coding=utf-8
#!/usr/bin/python
################################################################
#Purpose:deal with excel and insert into mysql
import xlrd
import sys,os.path,datetime
import time
import pymysql
import warnings
warnings.filterwarnings("ignore")
fname = sys.argv[1]
import os
password='SDE#sciuser'
username='qilongyin'
Linux_ip='10.5.2.48'
Linux_basepath='/home7/qilongyin/apache-tomcat-7.0.55/webapps/autotestFiles/'
def Window_to_Linux_File(window_path, Linux_path, Linux_ip, username, password):
    print ('Window_to_Linux_File begin')
    cmd='D:\pscp.exe -pw {password} "{window_path}" {username}@{Linux_ip}:{Linux_path}'.format(password=password, window_path=window_path, username=username, Linux_ip=Linux_ip, Linux_path=Linux_path)
    os.system(cmd)
    print ('Window_to_Linux_File end')

if not os.path.isfile(fname):
    print('FILE OPEN FAILED')
    sys.exit()
data = xlrd.open_workbook(fname)            # 打开fname文件
data.sheet_names()                          # 获取xls文件中所有sheet的名�?
table = data.sheet_by_index(0)              # 通过索引获取xls文件�?个sheet
nrows = table.nrows                         # 获取table工作表总行�?
ncols = table.ncols                         # 获取table工作表总列�?#获取当前日期
date = time.strftime("%Y-%m-%d")
row_list = []
manifestPathList=[]
#获取各行数据
for i in range(1,nrows):
    row_data = table.row_values(i)
    row_data[6] = row_data[6].replace('\\', '\\\\')
    row_list.append(row_data)
    Linux_upperpath=row_list[i-1][1]+"_"+row_list[i-1][4]+"_"+str(int(row_list[i-1][0]))+"_manifest"
    Linux_path=Linux_basepath+Linux_upperpath
    window_path=row_list[i-1][5]
    #print Linux_path
    print (window_path)
    Window_to_Linux_File(window_path, Linux_path, Linux_ip, username, password)
    manifestPath="http://10.5.2.48:80/autotestFiles/"+Linux_upperpath
    manifestPathList.append(manifestPath)


#插入数据
try:
    conn = pymysql.connect(host='10.5.2.48', user='admin', passwd='adminUse', db='autotest',charset = 'utf8')
    #conn = MySQLdb.connect(host='localhost', user='root', passwd='123456', db='autotest',charset = 'utf8')
    cur=conn.cursor()
    #conn.select_db('autotest')
    for i in range(0,len(row_list)):
        select = "SELECT id FROM ProjectInfo where project = '%s' "%(row_list[i-1][1])
        cur.execute(select)
        projectListId=cur.fetchone()
        if projectListId==None:
            #插入数据到ProjectInfo表中
            insertToProjectList='''insert into ProjectInfo(project,flag) values('%s','%d')'''%(row_list[i-1][1],1)
            #print (insertToProjectList)
            cur.execute(insertToProjectList)	
            conn.commit()
            select = "SELECT id FROM ProjectInfo where project = '%s' "%(row_list[i-1][1])
            cur.execute(select)
            conn.commit()
            projectListId=cur.fetchone()
            print ("insert into ProjectInfo success, projectId =%d"%(projectListId[0]))
        else:
            print ("Project already exists, projectId =%d"%(projectListId[0]))
        insertToAutotestList='''insert into AutotestInfo(logSite,nodeID,result,startTime,testTime,projectID_id,manifestPath) values('%s','%s','%s','%s','%s','%d','%s')''' %(row_list[i-1][6],row_list[i-1][0],row_list[i-1][3],row_list[i-1][2],row_list[i-1][4],projectListId[0],manifestPathList[i-1])
        #print (insertToAutotestList)
        cur.execute(insertToAutotestList)
        conn.commit()
    print ("insert AutotestInfo success!!!")
    cur.close()
    conn.commit()
    conn.close()
except  Exception :print('insert data error') 
	
