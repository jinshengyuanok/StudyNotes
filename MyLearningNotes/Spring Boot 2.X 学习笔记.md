# Spring Boot 2.X 学习笔记

##  拦截器 webmvcconfigureradapter 替代的替代类

Spring Boot 2.0后，WebMvcConfigurerAdapter 已过时，可以通过下面两种方式来替代

1. 直接实现WebMvcConfigurer

```java
@Configuration
public class MyWebMVCConfigOne implements WebMvcConfigurer {
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/login").setViewName("login");
    }
}
```

2.  直接继承WebMvcConfigurationSupport

```java
@Configuration
public class MyWebMvcConfigTwo extends WebMvcConfigurationSupport {
    @Override
    protected void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/login").setViewName("login");
    }
}
```

**注：如果使用使用第二种实现方式，则Spring Boot自动配置的静态资源路径（classpath:/META/resources/，classpath:/resources/，classpath:/static/，classpath:/public/）不生效，如果既要使用SpringBoot的自动配置，又要按照自己的需要重写某些方法，则推荐使用第一种实现方式】**

# SpringMVC实操笔记

## 从一个Controller调整到另一个controller中的方法：

使用请求转发或重定向，参考网址：https://www.cnblogs.com/wkrbky/p/5962905.html

```java
//能正常跳转的写法如下：
return "forward:aaaa/bbbb.do";

return "redirect:aaaa/bbbb.do";

return new ModelAndView("forward:bbbb.do", null);

return new ModelAndView("redirect:bbbb.do", null);

注意：一般在同一个controller类中，只写方法名即可
```

## SpringMvc+MyBatis+Bootstrap+pageHelper案例

- maven中加入pageHelper依赖jar

```xml
<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper</artifactId>
    <version>5.1.8</version>
</dependency>
```

- mybatis-config.xml中添加配置

```xml
<!--配置分页插件-->
<plugins>
    <plugin interceptor="com.github.pagehelper.PageInterceptor"></plugin>
</plugins>
```

- 只需要传递页码(pageNum)即可

实现分页的Controller类与empList.jsp如下：

1. Controller中核心代码,EmployeeController.java

```java
@Controller
@RequestMapping("/testEmp")
public class EmployeeController {
    @Autowired
    private EmployeeService employeeService;

    /***
     * 员工列表
     * @param pageNum 当前页的页码
     * @param model
     * @return
     */
    @RequestMapping("/getAllEmps")
    public String getAllEmps(@RequestParam(value = "pageNum",defaultValue = "1") Integer pageNum, Model model){
        //查询前传入页码及每页显示的记录
        //ConstantUtil.PAGESIZE 常量类中的常量，值为10
        PageHelper.startPage(pageNum,ConstantUtil.PAGESIZE);//每页显示的记录数
        //PageHelper.startPage(pageNum,10);后面紧跟的查询就是一个分页查询
        List<Employee> allEmps = employeeService.getAllEmps(null);
        //使用PageInfo对查询结果进行包装,只需将PageInfo交给前台页面进行处理即可;封装了详细的分页信息，传入查询结果集与连续显示的页数
        //ConstantUtil.NAVIGATEPAGES = 5
        PageInfo pageInfo = new PageInfo(allEmps,ConstantUtil.NAVIGATEPAGES);//连续显示5页信息
        model.addAttribute("pageInfo",pageInfo);//将pageInfo放Model中在请区域中进行传递
        return "empList";
    }
}    
```

2. empList.jsp页面代码如下

```html
<%--
  Created by IntelliJ IDEA.
  User: jinshengyuan
  Date: 2018-07-06
  Time: 10:15
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE HTML>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="appContextPath" value="<%=request.getContextPath()%>"/>
<html>
<head>
    <title>员工信息页面</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="keywords" content="" />
    <script type="text/javascript" src="${appContextPath}/jsLib/jquery-easyui-1.5.2/jquery.min.js"></script>
    <link rel="stylesheet" href="${appContextPath}/jsLib/bootstrap-3.3.7-dist/css/bootstrap.css">
    <script type="text/javascript" src="${appContextPath}/jsLib/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

</head>
<body>
<div class="container">
    <!--标题-->
    <div class="row">
        <!--中屏幕,占12列-->
        <div class="col-md-12">
            <h3>SSM_员工信息列表(分页测试Demo)</h3>
        </div>
    </div>
    <!--员工信息列表-->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover">
                <tr>
                    <th>sequence</th>				    			
                    <th>empName</th>
                    <th>empPassword</th>
                    <th>deptId</th>
                    <th>empId</th>
                    <th>operate</th>
                </tr>
                <c:forEach var="emp" items="${pageInfo.list}" varStatus="status">
                    <tr>
						<td>${status.index +1 }</td>
                        <td>${emp.empName}</td>
                        <td>${emp.empPassword}</td>
                        <td>${emp.empId}</td>
                        <td>${emp.deptId}</td>
                        <td>
                            <button type="button" class="btn btn-info btn-sm">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                编辑
                            </button>
                            <button type="button" class="btn btn-danger  btn-sm">
                                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
                                删除
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    <!--操作按钮-->
    <%--<div class="row">
        <!--本身占4列,偏移8列至最右边-->
        <div class="col-md-4 col-md-offset-8">
            <button type="button" class="btn btn-success">新增</button>
            <button type="button" class="btn btn-danger">删除</button>
        </div>
    </div>--%>
    <!--分页-->
    <div class="row">
        <!--分页文字描述-->
        <div class="col-md-4">
            当前第${pageInfo.pageNum}页,共${pageInfo.pages}页,总共${pageInfo.total}条记录
        </div>
        <!--分页导航显示-->
        <div class="col-md-8">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li><a href="${appContextPath}/testEmp/getAllEmps.action?pageNum=1">首页</a></li>

                    <c:if test="${pageInfo.hasPreviousPage}">
                        <li>
                            <a href="${appContextPath}/testEmp/getAllEmps.action?pageNum=${pageInfo.pageNum - 1}"
                               aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>

                    <c:forEach items="${pageInfo.navigatepageNums}" var="navigatePageNum">
                        <c:if test="${navigatePageNum == pageInfo.pageNum}">
                            <li class="active"><a href="#">${navigatePageNum}</a></li>
                        </c:if>
                        <c:if test="${navigatePageNum != pageInfo.pageNum}">
                            <li>
                                <a href="${appContextPath}/testEmp/getAllEmps.action?pageNum=${navigatePageNum}">${navigatePageNum}</a>
                            </li>
                        </c:if>

                    </c:forEach>
                    <c:if test="${pageInfo.hasNextPage}">
                        <li>
                            <a href="${appContextPath}/testEmp/getAllEmps.action?pageNum=${pageInfo.pageNum + 1}"
                               aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <li><a href="${appContextPath}/testEmp/getAllEmps.action?pageNum=${pageInfo.pages}">末页</a></li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
```

