#written by gx
cat openvpn.log | awk '/VERIFY OK: depth=0, CN=/{print $0}'| sed -n 's/VERIFY OK: depth=0, CN=//p' > /etc/openvpn/log_temp/openvpn-`date +%y%m%d`.txt
sed -i 's/ [a-z].*\// /' /etc/openvpn/log_temp/openvpn-`date +%y%m%d`.txt
cat /etc/openvpn/log_temp/openvpn-`date +%y%m%d`.txt | awk '{printf"%-5s%-5s%-4s%-10s%-6s%-23s%-6s\n",$1,$2,$3,$4,$5,$6,$7}'

