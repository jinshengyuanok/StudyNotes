# JavaWeb开发实操笔记

# Tomcat相关配置

## 1. 文件上传虚拟目录配置

### 1.1 server.xml文件配置

在server.xml文件中的Host标签内的末尾添加如下代码：

`<Context path="/expDump" docBase="D:\BackupDatabase"></Context>	`

- path="/expDump"中的`/`代表的是 D:\apache-tomcat-XXX\webapps 目录下，expDump文件是webapps的子目录，一般事先创建好此文件夹
- docBase="D:\BackupDatabase" 中的`D:\BackupDatabase`是操作系统物理硬盘的目录

具体配置如下：

```xml
<Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">        
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log." suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />
		<Context path="/expDump" docBase="D:\BackupDatabase"></Context>			       
</Host>
```

### 1.2 文件下载

1. 文件下载时使用下面URI即可，不需要再编写文件下载代码

http://ip:port/虚拟目录/文件名称

如：http://localhost:8080/expDump/test.txt

2. 如果文件名称中有中文，则会出现乱码的情况，解决乱码有两种方法：

- 对象 request 与 response 对象 设置编码，setCharacterEncoding=UTF-8

```java

 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"  %>
 <%
      //解决post/get 请求中文乱码的方法
      request.setCharacterEncoding("UTF-8");
      response.setCharacterEncoding("UTF-8");
%>  
```

- 找到tomcat 配置文件 server.xml ,加入代码： URIEncoding="utf-8"，如：

```xml
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
			   URIEncoding="utf-8" <!--就加这句代码可解决乱码问题-->
               redirectPort="8443" />
```

# 文件上传与下载

## 1. 文件上传

### 1.1 Struts2文件上传

1. 基于表单的文件上传

```html
<form method="post" action="/upload/uploadFile.do" enctype="multipart/form-data">
    文件上传：<input type="file" id="fileData2" name="file">
    <input type="submit" value="提交">
</form>
```

注意：在建立表单时，指定下enctype属性，并将它的值设置为`multipart/form-data`。表单enctype属性的缺省值是`application/x-www-form-urlencoded`,这种编码方案使用有限的字符集，当使用了非字母和数字的字符时，必须使用“%HH”代替(这里的H表示的是十六进制数字)，如一个中文字符，将被表示为“%HH%HH”。如果采用这种编码方式上传文件，那么上的数量将会是原来的2-3倍大，对应传送那些大容量的二进制数据或包含非ASCII字符的文本来说，application/x-www-form-urlencoded 编码类型远远不能满足需求，**于是RFC1867定义了一种新的媒体类型`multipart/form-data`,这是一种将填写好的表单内容从客户端传送到服务器端的高效方式。新的编码类型只是在传送数据的周围加上简单的头部标识文件的内容**。

2. Struts2对文件上传的支持

- Struts2本身没有提供解析上传文件内容的功能，Struts2默认使用的上传组件是Apache组织的Commons-fileupload组件，该组件性能优异，而且支持任意大小文件的上传。String2还支持两张文件上传组件：pell和cos,可以通过配置struts.multipart.parser属性来切换struts2使用的上传组件。

- 导入`commons-fileupload-x.x.x.jar` 与`commons-io-x.x.jar`即可
- Struts2提供了衣蛾文件上传拦截器：org.apache.struts2.interceptor.FileUploadInterceptor,它负责调用底层的文件上传主键解析文件内容，并为Action准备与上传文件相关属性的值。**处理文件上传的请求Action必须提供特殊样式命名的属性，例如，假设表单中文件选择框(<input type="file" name="file"/>)的name属性值时file,那么Action类中应该提供下列三个属性,并提供getter/setter方法**，如下：

```java
   //java.io.File类型，指的是已上传文件的File对象
    private File file;
    //上传文件的文件名
    private String fileFileName;
    //上传文件的文件类型(MIME类型)
    private String fileContentType;
    //这三个属性会由FileUploadInterceptor拦截器为你准备好
    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }

    public String getFileFileName() {
        return fileFileName;
    }

    public void setFileFileName(String fileFileName) {
        this.fileFileName = fileFileName;
    }

    public String getFileContentType() {
        return fileContentType;
    }

    public void setFileContentType(String fileContentType) {
        this.fileContentType = fileContentType;
    }

    //如果表单文件选择框中<input type="file" name="image"/>中的name属性值为image，则
    private File image; 
    private String imageFileName;
    private String imageContentType;
```

3. 上传文件相关配置属性文件 dataMove.properties

```properties
# 导入配置
imp_oracle_sid=orcl
imp_username=test
imp_password=test
imp_server_path =impDump
imp_saveFilePath=D:/impDumpFileManager

```

3. 上传文件的Action

```java
package com.rskytech.dataMove.action;


public class DataMoveAction extends ActionSupport {

    private File file;

    private String fileFileName;

    private String fileContentType;

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }

    public String getFileFileName() {
        return fileFileName;
    }

    public void setFileFileName(String fileFileName) {
        this.fileFileName = fileFileName;
    }

    public String getFileContentType() {
        return fileContentType;
    }

    public void setFileContentType(String fileContentType) {
        this.fileContentType = fileContentType;
    }

    /**
     * 初始化数据导入页面
     *
     * @return
     */
    public String importDataInit() {
        return "importData";
    }

    /**
     * 文件上传方法
     * @return
     */
    public String importData() {
        //字节缓冲输入流
        BufferedInputStream bufferedInputStream = null;
        //字节缓冲输出流
        BufferedOutputStream bufferedOutputStream = null;
        try {
            //读取属性文件相关配置
            Properties properties = new Properties();
            InputStream inStream = DataMoveAction.class.getResourceAsStream("dataMove.properties");
            properties.load(inStream);//加载资源文件
            String jdbc_username = properties.getProperty("imp_username");
            String jdbc_password = properties.getProperty("imp_password");
            String imp_server_path = properties.getProperty("imp_server_path");//服务器虚拟映射目录
            String imp_saveFilePath = properties.getProperty("imp_saveFilePath");//导入文件保存位置
            String oracle_sid = properties.getProperty("imp_oracle_sid");

            String importDumpSyntax = "imp " + jdbc_username + "/" + jdbc_password + "@" + oracle_sid + " file=" + fileFileName;


            //文件存放目录不存在则创建
            File saveFile = new File(imp_saveFilePath);
            if (!saveFile.exists()) {// 如果目录不存在
                saveFile.mkdirs();// 创建文件夹
            }
            //字节输入流
            FileInputStream inputStream = new FileInputStream(file);

            bufferedInputStream = new BufferedInputStream(inputStream);

            //字节输出流
            FileOutputStream outputStream = new FileOutputStream(new File(saveFile, fileFileName));

            bufferedOutputStream = new BufferedOutputStream(outputStream);
            //字节数组
            byte[] bytes = new byte[2048];
            int len = 0;
            while ((len = bufferedInputStream.read(bytes)) != -1) {
                bufferedOutputStream.write(bytes, 0, len);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (null != bufferedInputStream) {
                    bufferedInputStream.close();
                }
                if (null != bufferedOutputStream) {
                    bufferedOutputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

```

4. 文件保存位置

```java
//上文中文件的保存位置直接是属性文件的“D:/impDumpFileManager”目录，如果要保存到服务器中的某个目录下，可使用下面代码获取保存位置
String saveFilePath = ServletActionContext.getServletContext().getRealPath(uploadDir);
```

