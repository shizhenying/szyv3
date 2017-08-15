#ssr_v3
对于许多懒得折腾或者不会折腾的小白，可以选择使用一键脚本搭建

针对本脚本已经做了许多优化与升级，在食用过程中有什么疑问可以QQ找我或者留言

此脚本有以下特性：

 - 依赖魔改官方文档制作升级
 - 支持ubuntu or Centos 6.x 7.x系统
 - PHP采用性能较高的lnmp一键包，安装速度优化
 - 脚本自带BBR加速与锐速破解版
 - 前端使用最新官方魔改版，兼容SS和SSR
 - 后端使用最新版ShadowsocksR，兼容性极高，与前端完美对接。
 - 脚本只适合懒人或小白，商业化请自行修改相关密码(数据库账号密码默认为root)



> wget --no-check-certificate https://git.oschina.net/marisn/ssr_v3/raw/master/ssrv3.sh&&chmod +x ssrv3.sh&&bash ssrv3.sh


搭建要求：
-----

支持ubuntu or Centos 6.x 7.x系统

部分截图：
-----
![QQ截图20170815112040.png][1]

![TIM截图20170607204211.png][2]

![QQ截图20170815110538.png][3]

![QQ截图20170815111133.png][4]

一键脚本
----

    wget --no-check-certificate https://git.oschina.net/marisn/ssr_v3/raw/master/ssrv3.sh&&chmod +x ssrv3.sh&&bash ssrv3.sh 


请根据提示完成搭建

**默认账号：marisn@67cc.cn**

**默认密码：marisn**

**搭建完后请务必在前端后台更改账号密码**

**完成前端搭建请在网站内新建节点**

**!!!注意进入前端后，第一件事就是先新建节点**

**管理面板–>节点列表–>右下角加号–>输入信息**

**新建节点名请按照 `XX - ShadowsocksR` 的格式填写，避免不必要的问题出现**

![TIM截图20170607205802.png][5]

![TIM截图20170608213043.png][6]

**<font color="red">再次运行</font>上面的脚本**

**选择添加节点，根据脚本提示操作**

`mukey`值请在配置文件中更改，默认可不更改

配置文件路径：

    /home/wwwroot/default/config/.config.php

因为文件被隐藏，所以用SFTP下载下来修改，推荐使用<font color="red">notepad++</font>修改

<font color="red">所有要自定义的东西请在配置文件中更改</font>
------------------

![TIM截图20170607210157.png][7]

其他问题
----
 - 以后新建ss-panel魔改节点的时候，遵循先第二步后第三步的顺序，切勿没有节点即新建node,否则可能因为读取不到id信息而报错。
 - 如果你想自定义端口，可以在后台管理中心修改用户端口，从而达到自定义端口。
   管理面板–>节点列表–>编辑用户资料–>修改连接端口，保存
   PS：如果相关端口已经被占用，则保存时会提示空白，请选择未开端口自定义
 - 已经在阿里云,腾讯云，华为云，vultr，快云服务器上通过测试


更多问题请留言。
--------


  [1]: https://blog.67cc.cn/usr/uploads/2017/08/1138351756.png
  [2]: https://blog.67cc.cn/usr/uploads/2017/06/3938669715.png
  [3]: https://blog.67cc.cn/usr/uploads/2017/08/2181240716.png
  [4]: https://blog.67cc.cn/usr/uploads/2017/08/644865995.png
  [5]: https://blog.67cc.cn/usr/uploads/2017/06/241652535.png
  [6]: https://blog.67cc.cn/usr/uploads/2017/06/3273668271.png
  [7]: https://blog.67cc.cn/usr/uploads/2017/06/2496029466.png