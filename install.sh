#Make btserial executable
chmod 755 btserial.sh

#Delete last line from rc.local, assumed to contain "exit 0"
sed -i '$ d' /etc/rc.local

#Add btserial to rc.local
echo "sudo ${PWD}/btserial.sh &" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
