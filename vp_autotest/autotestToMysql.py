# This Python file uses the following encoding: utf-8
#coding=utf-8
#!/usr/bin/python
################################################################
#Purpose:deal with excel and insert into mysql
import pymysql
import xlrd
import sys,os.path,datetime
import time
import warnings
warnings.filterwarnings("ignore")
fname = sys.argv[1]
if not os.path.isfile(fname):
    print('文件路径不存在')
    sys.exit()
data = xlrd.open_workbook(fname)            # 打开fname文件
data.sheet_names()                          # 获取xls文件中所有sheet的名称
table = data.sheet_by_index(0)              # 通过索引获取xls文件第0个sheet
nrows = table.nrows                         # 获取table工作表总行数
ncols = table.ncols                         # 获取table工作表总列数
#获取当前日期
date = time.strftime("%Y-%m-%d")
row_list = []
#获取各行数据   
for i in range(1,nrows):
    row_data = table.row_values(i)
    row_data[4] = row_data[4].replace('\\', '\\\\')
    row_list.append(row_data)
    print (row_list[i-1][4])
#插入数据
try:
    conn = pymysql.connect(host='10.5.2.48', user='admin', passwd='adminUse', db='autotest',charset = 'utf8') 
    #conn = pymysql.connect(host='localhost', user='root', passwd='123456', db='autotest',charset = 'utf8')
    cur=conn.cursor()
    #conn.select_db('autotest')
    #插入数据到ProjectForm表中
    for i in range(0,len(row_list)):
        insertToAutotestList='''insert into AutotestInfo(logSite,nodeID,result,startTime,testTime) values('%s','%s','%s','%s','%s')''' %(row_list[i-1][4],row_list[i-1][0],row_list[i-1][2],row_list[i-1][1],row_list[i-1][3])
        print (insertToAutotestList)
        cur.execute(insertToAutotestList)
        conn.commit()
    print ("insert AutotestInfo success!!!")
    cur.close()
    conn.commit()
    conn.close()
except  Exception :print("插入数据发生异常") 

