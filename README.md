# selenium_vito
基于ruby+selenium的第三方广告检测

# 环境配置
Linux和windows下均可以使用这个脚本，但对于环境配置略有不同。
## Linux下环境配置

### 1.安装ruby
可以参考[这篇文章](https://blog.zengrong.net/post/1933.html)中使用rvm管理ruby的方式安装，要求ruby版本大于等于2.0，具体安装不作更多说明。

### 2.安装ruby版本的selenium
**在`terminal`中执行：**
``` ruby
gem install selenium-webdriver  
```
[selenium-webdriver的Github源码地址](https://github.com/SeleniumHQ/selenium/tree/master/rb)

### 3.安装spreadsheet:
```ruby
gem install spreadsheet
```
[spreadsheet的GitHub源码地址](https://github.com/zdavatz/spreadsheet)

### 4.安装selenium浏览器驱动driver
- Chrome
  - 版本对应：[ChromeDriver与Chrome版本的对应关系](http://blog.csdn.net/goblinintree/article/details/47335563)
  - driver下载：[ChromeDriver - WebDriver for Chrome](https://sites.google.com/a/chromium.org/chromedriver/downloads)
- Firefox
  - driver下载及版本对应：https://github.com/mozilla/geckodriver/releases

根据自己的浏览器版本，选择对应的selenium浏览器驱动版本driver进行下载解压，**将下载解压好的driver文件移动到`/usr/bin/`文件夹下即可。**

以上四步，是linux下运行程序必要的环境配置，务必保证每一步的正确安装。

## Windows下环境配置
windows下的环境配置与Linux下略有不同，但思路是相通的。

### 1.安装ruby
按照这篇文章[《Ruby 安装 - Windows》](http://www.runoob.com/ruby/ruby-installation-windows.html)安装ruby即可，记得勾选` Add Ruby executables to your PATH`这一项。同样，要求ruby版本大于等于2.0。

### 2.安装ruby版本的selenium
**在`cmd`中执行：**
``` ruby
gem install selenium-webdriver  
```
[selenium-webdriver的Github源码地址](https://github.com/SeleniumHQ/selenium/tree/master/rb)

### 3.安装spreadsheet:
```ruby
gem install spreadsheet
```
[spreadsheet的GitHub源码地址](https://github.com/zdavatz/spreadsheet)ß

### 4.安装selenium浏览器驱动driver
- Chrome
  - 版本对应：[ChromeDriver与Chrome版本的对应关系](http://blog.csdn.net/goblinintree/article/details/47335563)
  - driver下载：[ChromeDriver - WebDriver for Chrome](https://sites.google.com/a/chromium.org/chromedriver/downloads)
- Firefox
  - driver下载及版本对应：https://github.com/mozilla/geckodriver/releases

根据自己的浏览器版本，选择对应的selenium浏览器驱动版本driver进行下载解压，**将下载解压好的driver文件放在对应的浏览器安装目录下，之后需要对Windows环境变量进行配置。**
Windows下需要在系统变量的path变量中添加exe文件的位置，配置环境变量可参考这篇文章：[Win7怎样添加环境变量](https://jingyan.baidu.com/article/d5a880eb6aca7213f047cc6c.html)，注意路径中不要有中文。

同样，这四步也是Windows下必备的环境配置。但在自己的测试过程中，由于一些安全问题，Windows下的chrome始终没有调通，但Firefox是可以使用的。

# 脚本使用
已经完成的脚本文件在环境配置成功后，可以直接使用，整个工程中共有三个文件：
- detection_ad.rb：
  可执行文件，在终端terminal中（windows下为cmd）执行命令：
  ```ruby
  >  ruby detection_ad.rb
  ```
  工程即可正常运行。
- weburl.txt：
  这个文件用来放置待检测的网页网址，每一行仅能放置一个网址。程序运行后，脚本会打开`weburl.txt`文件，并依次对文件中的所有网址进行检测。
  当需要修改此文件名称时，需要在脚本中修改相关代码，将`weburl.txt`修改成自己需要的名称：
  ```ruby
  web_file = "weburl.txt"
  ```
- ad_file.xls：
  这个文件用于保存数据，脚本运行后处理得到的所有数据会全部写入这个文件中。如果需要将最终数据写入到其他名称的`xls`文件中，只需要修改`detection_ad.rb`文件中相关代码，将`ad_file.xls`改为自己需要的名称：
  ```ruby
  excel_fil.write "ad_file.xls"
  ```

对于脚本代码的详细说明，请阅读：[基于ruby+selenium的第三方广告检测](http://www.jianshu.com/p/9540e7566192)
