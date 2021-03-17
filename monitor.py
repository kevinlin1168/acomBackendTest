# -*- coding: UTF-8 -*-

import sys
import configparser
import os
from datetime import datetime

def loadConfig(section, name):
    curpath = os.path.dirname(os.path.realpath(__file__))
    cfgpath = os.path.join(curpath, 'config.ini')
    # 創建對象
    conf = configparser.SafeConfigParser()
    # 讀取INI
    conf.read(cfgpath, encoding='utf-8')
    return conf.get(section, name)

url = loadConfig('system', 'URL')
isLogger = loadConfig('system', 'logger')

resp = requests.get(url)
response = resp.json()
time = '['+datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")+']'
fp = open("../home/logs/monitor.log", 'a+')
if(resp.status_code == requests.codes.ok):
        response = resp.json()
        fp.write(time+ ' '+ response['mysql_status']+':PID:'+str(os.getpid())+' ,response'+str(response)+'\n')
else:
        fp.write(time+ ' ERROR:PID:'+str(os.getpid())+' ,ERROR-Can\'t connect to ' + url + '\n')