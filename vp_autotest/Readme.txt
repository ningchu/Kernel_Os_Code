vp_autotest��װ����
1�����ļ����µ����ж�������������VDK�İ�װĿ¼�µ�scripts�£���autotest_result�ļ�������D�̸�Ŀ¼��
2������python�ļ����ù���Ա���ִ��python-3.4.16490.1437702276
�ڻ�������PATH������python�İ�װĿ¼·��
3������cmd���ڽ���xlrd-0.9.3�ļ�����ִ��
python setup.py build
python setup.py install
4����ѹPyMySQL3-0.5.tar
�����ļ���ִ���������
python setup.py build
python setup.py install
5������CONFIG�ļ�
6��������ʱ������Ϊ���
7������VDK�ű������������������������
  puts "CPU Loaded"
  vpx::continue_simulation
8������outlook�ʻ�������
9��˫��autotest_externel����

ʹ�÷�����
��CONFIG�ļ��е�enable_nodeΪ1ʱ��start_test_node�Ľ�����Ч�����´β��ԵĽ��š����ַ�ʽ���Բ��ô��������ű����ɿ��Ʋ��Խ��ŵ��޸ġ�
��CONFIG�ļ��е�enable_nodeΪ0ʱ����Ҫstart_test_node�Ľ�����Ч��������������ű���
CONFIG�ļ��е�wait_for_download����ȡxml�����ļ��ļ��ʱ��300000��300�룬��ÿ����Ӷ�ȡһ��
Ҳ����ͨ���ļ��е�email_subject�����ʼ���Ŀ
ͨ��email_recieve�����ռ����б�

ע�⣺�޸�CONFIG�ļ�ʱ����ȸ���һ�ݣ�Ȼ�������ֱ��ճ������������ĵ�ʱ��������ڼ�ű��ֶ�ȡ���ļ����³�ͻ


boss�飺

Ning Chu (����); Platform SW Andr Apps Performance Kernel Group; Yelianna Zhao (�Ծ���); Guoliang Ren (�ι���); Fiona Zhang (�ŵ�); Tim Luo (����ǿ); Tony_lin Yang (����); Chunji Chen (�´���); Gary Gao (����); Chunsi He (�δ�˼); Zhenliang Wang (����); Xiaojun Liang (������); Jim Li (����ǿ); Yu Zhao (����); Wei Qiao (��ΰ); Billy Zhang (����); Xiaobo Dong (��С��); Xiaolong Zhang (��С��); Yaping Long (����ƽ); Infi Chen (�·�); Ellen Zhuang (ׯ����); Richard Sun (����); Heying Ma (���Ӫ); Jie Dai (����); Jianguo Du (�Ž���); Tim Xia (���); Sheng Zhu (��ʤ)
Cc: Ximing Shan (��ϣ��); Mengya Liu (������); Yuzhu Shao (������); Ellen Yang (����); Jeffery L (Jeffery L); Jimmy Jian (Jimmy Jian); Bo1 Liu (����); Richard Guan (��ά); Xiangpeng Meng (������); Junhao Zheng (֣����); Benjamin Wang (���); David L (David L); Bravo Lee (Shen-Wei Lee)
