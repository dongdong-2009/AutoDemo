

## Centos 7 首次安装saltstack 需要更新psutil
一般出现错误如下：
import psutil._pslinux as _psplatform
AttributeError: 'module' object has no attribute '_pslinux'
    ```
    sudo pip install --upgrade psutil
    ```

