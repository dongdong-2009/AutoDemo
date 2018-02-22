================================
xtcAuto FAQ
================================


安装Docker 如果发现与之前安装的冲突，请完整卸载docker
--------------------------------------------------------

::
  yum  -y remove  docker-common docker container-selinux docker-selinux docker-engine


Powershell 执行权限
--------------------------------------------------------

::
  Set-ExecutionPolicy Unrestricted yes

使用java调用powershell脚本，可以使用以下命令：
--------------------------------------------------------

::
  String cmd = "cmd /c powershell -ExecutionPolicy RemoteSigned -noprofile -noninteractive -file \""+ scriptFilename + "\"";

使用powershell 安装Chocolatey
--------------------------------------------------------

::
  Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
