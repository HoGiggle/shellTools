#coding=utf-8

import socket
import logging
from configs import CONFIGS
import codecs

logging.basicConfig(level=logging.INFO)

SMS_TEMPLATE = u'<?xml version="1.0" encoding="UTF-8"?><atpacket domain="web" type="event"><cmd id="send_sm" node="192.168.27.217"><para name="appid" value="100IME"/><para name="src" value="13812121212"/><para name="dst" value="%s"/><para name="context" value="【科大讯飞】%s"/></cmd></atpacket>'

SOCKET_TIMEOUT = 10
HOST = ("1.1.1.1", 11)

def SendSms(phone_no, msg):
    body = SMS_TEMPLATE % (phone_no, msg)
    body = body.encode("gbk")
    length = "0x%08x" % len(body)

    content = length + body

    socket.setdefaulttimeout(SOCKET_TIMEOUT)
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    try:
        s.connect(HOST)
        s.send(bytearray(content))
    except Exception, e:
        print "exception : " + str(e)
        return 1
    finally:
        if s:
            s.close()

    return 0

if __name__ == '__main__':
    import sys
    reload(sys)
    sys.setdefaultencoding("gbk")

    # 发送短息列表
    phone_no_list = CONFIGS.get("SMS_PHONENO_LIST", "").split(',')
    msg = sys.argv[1]

    content = []

    with codecs.open(msg, 'r', 'utf-8') as rf:
        for line in rf:
            line = line.strip()
            if not line:continue
            content.append(u"%s" % line)

    data = u"\r\n".join(content)

    for phone_no in phone_no_list:
        logging.info("send sms notify to %s", phone_no)
        SendSms(phone_no, data)
