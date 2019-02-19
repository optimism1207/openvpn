#written by gx
echo  
sed -n '/OpenVPN/p' openvpn-status.log
sed -n '/Updated/p' openvpn-status.log | awk -F, '{printf"%-20s%s\n",$1,$2}'
echo
sed -n '/Bytes Received/,/ROUTING/{/ROUTING TABLE/d;p}' openvpn-status.log | awk -F, '{printf"%-20s%-25s%-15s\t%-15s\t%-15s\n",$1,$2,$3,$4,$5}'
echo
sed -n '/ROUTING/p' openvpn-status.log
sed -n '/Virtual Address/,/GLOBAL/{/GLOBAL STATS/,$d;/.*\..*\..*\.0/d;p}' openvpn-status.log | awk -F, '{printf"%-20s%-15s%-25s\t%-15s\n",$1,$2,$3,$4}'
echo
