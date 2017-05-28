# openvpn
openvpn for raspberry
## 新的vpn节点需要做的初始化需要做的事情
### 服务端准备
1. 证书生成
```
source vars
./build-key clientname
```
2. 导出配置文件
```
python3 gen_client.py clientname>clientname.conf
#如果需要生成ovpn文件给windows客户端
python3 gen_client.py clientname>clientname.ovpn
```
3. 服务端内容调整
* 添加节点路由到openvpn server,如果服务端需要通过路由访问子节点的话
编辑**server.conf**
```
#添加节点的网段到路由
route 192.168.x.0 255.255.255.0 10.8.0.1 
#如果需要向所有的字节点推送这个网段的话
push "route 192.168.x.0 255.255.255.0"
```
* 控制连接的客户端信息
配置client文件,控制节点的信息
```
ifconfig-push 10.8.0.101 255.255.255.0#推送给节点，tun0接口ip地址
iroute 192.168.200.0 255.255.255.0#告诉服务器这个节点是这个网段
push "route 192.168.2.0 255.255.255.0"#向该节点推送其他网段的信息
```
### 节点准备
1. 安装openvpn，获取前面生成的配置文件，放置到/etc/openvpn/
并且下载客户端脚本
```
cd /etc/openvpn
wget https://raw.githubusercontent.com/mhye/openvpn/master/script/client.sh

```
2. 修改节点开启路由转发
编辑`/etc/sysctl.conf`，设置`net.ipv4.ip_forward = 1`,使设置即刻生效
```
systemctl -p
```
3. 编辑修改设置静态ip
编辑`/etc/network/interfaces`,设置静态ip，模板大致类似于
```
auto eth0
iface eth0 inet static
        netmask 255.255.255.0
        address 192.168.x.x
        gateway 192.168.x.1
        dns-nameservers 223.5.5.5 114.114.114.114
```
关闭eth0接口的dhcp获取，或者直接禁用dhcpcd
```
sudo echo "denyinterfaces eth0">>/etc/dhcpcd.conf
```

```
