移动硬盘系统使用说明
===========================================================

1. Arch

   登录账户: arch/arch

   * Docker

     + jenkins(banrieen/123456; qinxing/123456)
     docker run --name SEJenkins -d -p 8082:8080 -p 50000:50000 -v /usr/local/share/jenkins:/var/jenkins_home jenkins

   network::

      eht0 dhcp
      eth1 192.168.56.202

2. Debian-Jesse

   登录账户: pi/raspberry

   network::

      eht0 dhcp
      eth1 192.168.56.204

3. Ubuntu

   登录账户: pi/13760112192

   network::

      eht0 dhcp
      eth1 192.168.56.203

4. VirtualRouter

   openwrt （CLI 无登录密码 ，Web admin/admin)

5. Windows 10

   登录账户： 13760112192

6. kali

  登录账号： root/13760112192 kali/13760112192

  network::

     eth0 dhcp
     eth1 192.168.56.200/24

7. openSUSE LTE

   登录账号 suse/13760112192

   network::

      eth0 dhcp
      eth1 192.168.56.201
