#!/usr/bin/python

import smtplib
import sys

from email.mime.text import MIMEText

me = "TusharIsCool@Tushar.net"
you = sys.argv[1]

msg = MIMEText("Hello!!!!")
msg['Subject'] = "Cats with wheels"
msg['From'] = me
msg['To'] = you

s = smtplib.SMTP('localhost')
s.sendmail(me, [you], msg.as_string())
s.quit()
