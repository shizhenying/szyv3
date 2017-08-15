#!/bin/bash
#重新整理代码
#Time:2017/8/14 下午7:47:55
#Author: marisn
#Blog: blog.67cc.cn
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
ulimit -c 0
rm -rf ssr*
clear
echo -e "\033[33m=====================================================================\033[0m"
echo -e "\033[33m                   一键SS-panel V3_mod_panel搭建脚本                 \033[0m"
echo -e "\033[33m                                                                     \033[0m"
echo -e "\033[33m                  本脚本由marisn编写，用于学习与交流！               \033[0m"                                                 
echo -e "\033[33m                                                                     \033[0m"
echo -e "\033[33m=====================================================================\033[0m"
echo
echo -e "脚本已由阿里云/腾讯云等正规vps测试通过";
echo
pass='blog.67cc.cn';
echo -e "请输入Marisn'blog地址:[\033[32m $pass \033[0m] "
read inputPass
if [ "$inputPass" != "$pass" ];then
    #网址验证
     echo -e "\033[31m很抱歉,输入错误\033[0m";
     exit 1;
fi;
function UTC() {
echo
echo "正在同步时间..."
echo 
echo "如果提示ERROR请无视..."
systemctl stop ntpd.service >/dev/null 2>&1
service ntpd stop >/dev/null 2>&1
\cp -rf /usr/share/zoneinfos/Asia/Shanghai /etc/localtime >/dev/null 2>&1
ntpServer=(
[0]=s2c.time.edu.cn
[1]=s2m.time.edu.cn
[2]=s1a.time.edu.cn
[3]=s2g.time.edu.cn
[4]=s2k.time.edu.cn
[5]=cn.ntp.org.cn
)
serverNum=`echo ${#ntpServer[*]}`
NUM=0
for (( i=0; i<=$serverNum; i++ )); do
    echo
    echo -en "正在和NTP服务器 \033[34m${ntpServer[$NUM]} \033[0m 同步中..."
    ntpdate ${ntpServer[$NUM]} >> /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\t\t\t[  \e[1;32mOK\e[0m  ]"
		echo -e "当前时间：\033[34m$(date -d "2 second" +"%Y-%m-%d %H:%M.%S")\033[0m"
    else
        echo -e "\t\t\t[  \e[1;31mERROR\e[0m  ]"
        let NUM++
    fi
    #sleep 2
done
hwclock --systohc
systemctl start ntpd.service >/dev/null 2>&1
service ntpd start >/dev/null 2>&1
return 1
}
#一键SS-panel V3_mod_panel搭建 
function install_ss_panel_mod_v3(){
	yum -y remove httpd
	yum install -y unzip zip git
    wget -c https://git.oschina.net/marisn/ssr_v3/raw/master/lnmp1.3.zip && unzip lnmp1.3.zip && cd lnmp1.3 && chmod +x install.sh && ./install.sh lnmp
	cd /home/wwwroot/default/
	rm -rf index.html
	git clone https://git.oschina.net/marisn/mod.git tmp && mv tmp/.git . && rm -rf tmp && git reset --hard
	cp config/.config.php.example config/.config.php
	chattr -i .user.ini
	mv .user.ini public
	chown -R root:root *
	chmod -R 777 *
	chown -R www:www storage
	chattr +i public/.user.ini
	wget -N -P  /usr/local/nginx/conf/ http://home.ustc.edu.cn/~mmmwhy/nginx.conf 
	service nginx restart
	mysql -uroot -proot -e"create database sspanel;" 
	mysql -uroot -proot -e"use sspanel;" 
	mysql -uroot -proot sspanel < /home/wwwroot/default/sql/sspanel.sql
	cd /home/wwwroot/default
	php composer.phar install
	php -n xcat initdownload
	yum -y install vixie-cron crontabs
	rm -rf /var/spool/cron/root
	echo 'SHELL=/bin/bash' >> /var/spool/cron/root
	echo 'PATH=/sbin:/bin:/usr/sbin:/usr/bin' >> /var/spool/cron/root
	echo '0 0 * * * php /home/wwwroot/default/xcat dailyjob' >> /var/spool/cron/root
	echo '*/1 * * * * php /home/wwwroot/default/xcat checkjob' >> /var/spool/cron/root
	echo "*/1 * * * * php /home/wwwroot/default/xcat synclogin" >> /var/spool/cron/root
	echo "*/1 * * * * php /home/wwwroot/default/xcat syncvpn" >> /var/spool/cron/root
	echo '*/20 * * * * /usr/sbin/ntpdate pool.ntp.org > /dev/null 2>&1' >> /var/spool/cron/root
	echo '30 22 * * * php /home/wwwroot/default/xcat sendDiaryMail' >> /var/spool/cron/root
	/sbin/service crond restart
	IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
	echo "#############################################################"
	echo "# 前端部分安装完成，登录http://${IPAddress}看看吧~          #"
	echo "#默认账号：marisn@67cc.cn                                   #"
	echo "#默认密码：marisn                                           #"
	echo "#搭建完后请务必在前端后台更改账号密码                       #"
	echo "#完成前端搭建请在网站内新建节点                             #"
	echo "#############################################################"
}
# 一键添加SS-panel节点
function install_centos_ssr(){
	yum -y update
	yum -y install git 
	yum -y install python-setuptools && easy_install pip 
	yum -y groupinstall "Development Tools" 
	#512M的小鸡增加1G的Swap分区
	dd if=/dev/zero of=/var/swap bs=1024 count=1048576
	mkswap /var/swap
	chmod 0644 /var/swap
	swapon /var/swap
	echo '/var/swap   swap   swap   default 0 0' >> /etc/fstab
	wget http://git.oschina.net/marisn/ssr_v3/raw/master/libsodium-1.0.13.tar.gz
	tar xf libsodium-1.0.13.tar.gz && cd libsodium-1.0.13
	./configure && make -j2 && make install
	echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
	ldconfig
	yum -y install python-setuptools
	easy_install supervisor
	#clone shadowsocks
	cd /root
	git clone -b manyuser https://github.com/glzjin/shadowsocks.git "/root/shadowsocks"
	#install devel
	cd /root/shadowsocks
	yum -y install lsof lrzsz
	yum -y install python-devel
	yum -y install libffi-devel
	yum -y install openssl-devel
	pip install -r requirements.txt
	cp apiconfig.py userapiconfig.py
	cp config.json user-config.json
}
function install_ubuntu_ssr(){
	apt-get update -y
	apt-get install supervisor lsof -y
	apt-get install build-essential wget -y
	apt-get install iptables git -y
	wget http://git.oschina.net/marisn/ssr_v3/raw/master/libsodium-1.0.13.tar.gz
	tar xf libsodium-1.0.13.tar.gz && cd libsodium-1.0.13
	./configure && make -j2 && make install
	echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
	ldconfig
	apt-get install python-pip git -y
	pip install cymysql
	cd /root
	git clone -b manyuser https://github.com/glzjin/shadowsocks.git "/root/shadowsocks"
	cd shadowsocks
	pip install -r requirements.txt
	chmod +x *.sh
	# 配置程序
	cp apiconfig.py userapiconfig.py
	cp config.json user-config.json
}
function install_node(){
	clear
	check_sys(){
		if [[ -f /etc/redhat-release ]]; then
			release="centos"
		elif cat /etc/issue | grep -q -E -i "debian"; then
			release="debian"
		elif cat /etc/issue | grep -q -E -i "ubuntu"; then
			release="ubuntu"
		elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
			release="centos"
		elif cat /proc/version | grep -q -E -i "debian"; then
			release="debian"
		elif cat /proc/version | grep -q -E -i "ubuntu"; then
			release="ubuntu"
		elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
			release="centos"
	    fi
		bit=`uname -m`
	}
	install_ssr_for_each(){
		check_sys
		if [[ ${release} = "centos" ]]; then
			install_centos_ssr
		else
			install_ubuntu_ssr
		fi
	}
	# 取消文件数量限制
	sed -i '$a * hard nofile 512000\n* soft nofile 512000' /etc/security/limits.conf
	read -p "请输入你的域名(请加上http:// 如果是本机请直接回车): " Userdomain
	read -p "请输入muKey(在你的配置文件中 如果是本机请直接回车):" Usermukey
	read -p "请输入你的节点编号(非常重要，必须填，不能回车):  " UserNODE_ID
	install_ssr_for_each
	IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
	cd /root/shadowsocks
	echo -e "modify Config.py...\n"
	Userdomain=${Userdomain:-"http://${IPAddress}"}
	sed -i "s#https://zhaoj.in#${Userdomain}#" /root/shadowsocks/userapiconfig.py
	Usermukey=${Usermukey:-"mupass"}
	sed -i "s#glzjin#${Usermukey}#" /root/shadowsocks/userapiconfig.py
	UserNODE_ID=${UserNODE_ID:-"3"}
	sed -i '2d' /root/shadowsocks/userapiconfig.py
	sed -i "2a\NODE_ID = ${UserNODE_ID}" /root/shadowsocks/userapiconfig.py
	# 启用supervisord守护
	echo_supervisord_conf > /etc/supervisord.conf
  sed -i '$a [program:ssr]\ncommand = python /root/shadowsocks/server.py\nuser = root\nautostart = true\nautorestart = true' /etc/supervisord.conf
	supervisord
	#iptables
	iptables -I INPUT -p tcp -m tcp --dport 104 -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 104 -j ACCEPT
	iptables -I INPUT -p tcp -m tcp --dport 1024: -j ACCEPT
	iptables -I INPUT -p udp -m udp --dport 1024: -j ACCEPT
	iptables-save >/etc/sysconfig/iptables
	echo 'iptables-restore /etc/sysconfig/iptables' >> /etc/rc.local
	echo "/usr/bin/supervisord -c /etc/supervisord.conf" >> /etc/rc.local
	chmod +x /etc/rc.d/rc.local
	UTC
	echo "#############################################################"
	echo "#          安装完成，节点即将重启使配置生效                 #"
	echo "#############################################################"
	reboot now
}
function install_BBR(){
     wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh&&chmod +x bbr.sh&&./bbr.sh
}
function install_RS(){
     wget -N --no-check-certificate https://github.com/91yun/serverspeeder/raw/master/serverspeeder.sh && bash serverspeeder.sh
}
echo -e "\033[31m#############################################################\033[0m"
echo -e "\033[32m#欢迎使用一键SS-panel V3_mod_panel搭建脚本 and 节点添加     #\033[0m"
echo -e "\033[34m#Blog: http://blog.67cc.cn/                                 #\033[0m"
echo -e "\033[35m#请选择你要搭建的脚本：                                     #\033[0m"
echo -e "\033[36m#1.  一键SS-panel V3_mod_panel搭建                          #\033[0m"
echo -e "\033[37m#2.  一键添加SS-panel节点                                   #\033[0m"
echo -e "\033[36m#3.  一键  BBR加速  搭建                                    #\033[0m"
echo -e "\033[35m#4.  一键锐速破解版搭建                                     #\033[0m"
echo -e "\033[34m#                              PS:建议先搭建加速再搭建SSR-V3#\033[0m"
echo -e "\033[33m#                       已兼容  ubuntu or Centos 6.x 7.x系统#\033[0m"
echo -e "\033[31m#############################################################\033[0m"
echo
read num
if [[ $num == "1" ]]
then
install_ss_panel_mod_v3
fi;
if [[ $num == "2" ]]
then
install_node
fi;
if [[ $num == "3" ]]
then
install_BBR
fi;
if [[ $num == "4" ]]
then
install_RS
fi;
