vp_autotest安装流程
1、把文件夹下的所有东西拷贝到本机VDK的安装目录下的scripts下，把autotest_result文件拷贝到D盘根目录下
2、进入python文件夹用管理员身份执行python-3.4.16490.1437702276
在环境变量PATH中增加python的安装目录路径
3、进入cmd窗口进入xlrd-0.9.3文件夹下执行
python setup.py build
python setup.py install
4、解压PyMySQL3-0.5.tar
进入文件夹执行下面操作
python setup.py build
python setup.py install
5、配置CONFIG文件
6、把屏保时间设置为最大
7、设置VDK脚本里面自启动即添加下面内容
  puts "CPU Loaded"
  vpx::continue_simulation
8、配置outlook帐户并启动
9、双击autotest_externel启动

使用方法：
当CONFIG文件中的enable_node为1时，start_test_node的结点号有效，即下次测试的结点号。这种方式可以不用从新启动脚本即可控制测试结点号的修改。
当CONFIG文件中的enable_node为0时，想要start_test_node的结点号有效，必须从新启动脚本。
CONFIG文件中的wait_for_download结点读取xml配置文件的间隔时间300000是300秒，即每五分钟读取一次
也可以通过文件中的email_subject配置邮件题目
通过email_recieve配置收件人列表

注意：修改CONFIG文件时最好先复制一份，然后改完再直接粘贴，这样避免改的时间过长，期间脚本又读取该文件导致冲突


boss组：

Ning Chu (初宁); Platform SW Andr Apps Performance Kernel Group; Yelianna Zhao (赵景珠); Guoliang Ren (任国良); Fiona Zhang (张旦); Tim Luo (骆张强); Tony_lin Yang (杨林); Chunji Chen (陈春季); Gary Gao (高勇); Chunsi He (何春思); Zhenliang Wang (王亮); Xiaojun Liang (梁晓军); Jim Li (李文强); Yu Zhao (赵宇); Wei Qiao (乔伟); Billy Zhang (张昆); Xiaobo Dong (董小波); Xiaolong Zhang (张小龙); Yaping Long (龙亚平); Infi Chen (陈丰); Ellen Zhuang (庄兆艳); Richard Sun (孙丰军); Heying Ma (马合营); Jie Dai (戴杰); Jianguo Du (杜建国); Tim Xia (夏璐); Sheng Zhu (朱胜)
Cc: Ximing Shan (单希明); Mengya Liu (刘梦亚); Yuzhu Shao (邵雨竹); Ellen Yang (杨欣); Jeffery L (Jeffery L); Jimmy Jian (Jimmy Jian); Bo1 Liu (刘博); Richard Guan (关维); Xiangpeng Meng (孟祥鹏); Junhao Zheng (郑俊浩); Benjamin Wang (王骞); David L (David L); Bravo Lee (Shen-Wei Lee)
