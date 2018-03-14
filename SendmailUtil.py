#coding=utf-8

import os, smtplib, mimetypes, sys
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart

MAIL_HOST = ""
MAIL_POSTFIX = ""

SIGNATURE = "\r\n\r\n-----------------\r\n这是一封系统自动发送的通知邮件，请勿直接回复\r\n-----------------"

def send_mail(subject, content, filename = None):
	try:
		content = content + SIGNATURE

		message = MIMEMultipart()
		message.attach(MIMEText(content, _subtype='plain',  _charset='UTF-8'))
		message["Subject"] = subject
		message["From"]	= MAIL_FROM
		message["To"] = ";".join(MAIL_LIST)

		if filename != None and os.path.exists(filename):
			ctype, encoding = mimetypes.guess_type(filename)
			Title = filename.split("/")[-1]
			if ctype is None or encoding is not None:
				ctype = "application/octet-stream"
			maintype, subtype = ctype.split("/", 1)

			attachment = MIMEImage((lambda f: (f.read(), f.close()))(open(filename,"rb"))[0], _subtype = subtype)
			attachment.add_header("Content-Disposition", "attachment", filename = Title)
			message.attach(attachment)

		smtp = smtplib.SMTP()
		smtp.connect(MAIL_HOST)
		smtp.login(MAIL[1], MAIL[2])
		smtp.sendmail(MAIL_FROM, MAIL_LIST, message.as_string())
		smtp.quit()

		return True
	except Exception, e:
		print "Send mail failed to:%s"% e 
		return False

if __name__ == '__main__':
	MAIL = []
	ConfPath = sys.argv[1]
	print ConfPath
	for line in open(ConfPath):
		MAIL.append(line.split("=")[1].strip('\n'))
	MAIL_LIST = MAIL[0].split(",")
	MAIL_FROM = MAIL[1] + "<" + MAIL[1] + "@" + MAIL_POSTFIX + ">"
	
	if send_mail(MAIL[3],MAIL[4], MAIL[-1]):
		print "cong!I send it :)"
	else:
		print "ooooooooooops!not sended:("
