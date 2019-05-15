##openvpn 配置学习记录
##证书模式带密码,TUN/UDP
##环境centos7

    yum install openvpn easy-rsa
    mkdir -p /etc/openvpn/easy-rsa
    cp /usr/share/doc/easy-rsa-3.0.3/vars.example /etc/openvpn/easy-rsa/vars
    cp -r /usr/share/easy-rsa/3.0.3/* /etc/openvpn/easy-rsa
    cp /usr/share/doc/openvpn-2.4.6/sample/sample-config-files/server.conf /etc/openvpn/

    cd /etc/openvpn/easy-rsa/
    ./easyrsa init-pki

    ./easyrsa build-ca
    pem [密码自定义]
    commonname [server名称自定义]
    得到/etc/openvpn/easy-rsa/pki/ca.crt

    ./easyrsa gen-req [server名称自定义] nopass
    common [server名称自定义]
    得到 req: /etc/openvpn/easy-rsa/pki/reqs/server.req
        key: /etc/openvpn/easy-rsa/pki/private/server.key

    ./easyrsa sign server [server上面定义的名字] 
    pem [密码自定义]
    得到etc/openvpn/easy-rsa/pki/issued/server.crt

    ./easyrsa gen-dh
    得到/etc/openvpn/easy-rsa/pki/dh.pem

    openvpn --genkey --secret /etc/openvpn/easy-rsa/ta.key

    mkdir /etc/openvpn/easy-rsa-c/
    cd /etc/openvpn/easy-rsa-c/
    cp -r /usr/share/easy-rsa/3.0.3/* ./
    ./easyrsa init-pki
    ./easyrsa gen-req [client名称自定义]
    pem pass phrase [密码自定义] 登录用

    切换到刚才配置server的那个目录
    ./easyrsa import-req /root/client/pki/reqs/[client.req刚才生成的] [client自定义]

    ./easyrsa sign client[必须是client表示客户端] [client与上面一致]
    得到/etc/openvpn/easy-rsa/pki/issued/client.crt

##服务器和客户端证书整理
    
    cp pki/ca.crt /etc/openvpn/server
    cp pki/private/server.key /etc/openvpn/server
    cp pki/issued/server.crt /etc/openvpn/server
    cp pki/dh.pem /etc/openvpn/server
    cp /etc/openvpn/easy-rsa/ta.key /etc/openvpn/server

    cp pki/ca.crt /etc/openvpn/client/(server生成的ca）
    cp pki/issued/xxxx.crt /etc/openvpn/client/
    cp /etc/openvpn/easy-rsa-c/pki/private/client.key /etc/openvpn/client/
    cp /etc/openvpn/easy-rsa/ta.key /etc/openvpn/client/
    cp /usr/share/doc/openvpn-2.4.6/sample/sample-config-files/client.conf /etc/openvpn/client

 ##内核转发
 
    编辑 /etc/sysctl.conf 文件,将　net.ipv4.ip_forward = 0　修改为：net.ipv4.ip_forward = 1
    执行sysctl -p

    firewalld相关
    ip伪装
    firewall-cmd --zone=home --permanent --add-masquerade 
    端口转发
    firewall-cmd --permanent --zone=home --add-forward-port=port=xxxx:proto=xxx:toaddr=xxx.xx.xx.xxx:toport=xxxx

    firewall-cmd --reload

##客户端证书自动生成和吊销脚本
    
    配置文件通过修改sample.ovpn
    需要安装expect，脚本有点问题，vpn_client_build.sh要执行两次才成功，第一次肯定失败
    auto文件夹里的都要加执行权限，client_revoke.expect要移到/etc/openvpn/easy-rsa/
    sever.conf,sample.ovpn放于/etc/openvpn

    client_status_log.sh 格式化输出当前statuslog
    log.py 跟上面的差不多，练习python3写的

    openvpn_connect_history.sh 忘记当初干嘛写这个了，要统计ip历史好像，没写完

##分流改进，默认不走tun，走本地，未验证

    客户端添加

    route-nopull
    route x.x.x.x x.x.x.x vpn_gateway
    route x.x.x.x x.x.x.x vpn_gateway
    route x.x.x.x x.x.x.x vpn_gateway

##带宽改进，实测还是有点用的
    
    sndbuf 0
    rcvbuf 0
    push 'rcvbuf 393216'
    push 'rcvbuf 393216'

    txqueuelen 1000

    mssfix 1432


