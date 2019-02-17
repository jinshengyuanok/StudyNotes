# Easyui 使用笔记

## Datagrid相关操作

   datagrid选中行的默认背景颜色

``` css
.datagrid-row-selected {
    background: #FBEC88;
}
```



1. 让datagrid每次加载完成后，标题列中的CheckBox不被选中

``` js
1.datagrid标题列的chekcbox代码：
<div class="datagrid-header-check"><input type="checkbox"></div>
2.在onLoadSuccess事件中添加下面代码即可解决每次加载后标题列的复选框不被选中:
$(".datagrid-header-check").children("input[type=\"checkbox\"]").attr("checked", false);
------------------------
3.当某个条件未达到是，每一行的复选框不被选中
onCheck: function (index, row) {
    var n = $('#cc').combotree('getValue');// 获取选择的节点值
    if (n == null || n == "") {
        //让当前行的复选框不被选中(只是当前记录前的复选框不被选中)
        //$("input[type='checkbox']")[index + 1].checked = false;
        //当前记录不被选中(复选框及数据行都不被选中)
        $('#dg').datagrid('unselectRow',i);        
        //与之相反的有：
         //$("input[type='checkbox']")[i + 1].checked = true;
         //$('#dg').datagrid('selectRow',i);
        $.messager.alert('系统提示', '请选机构', "info");
        return;
    }
4.当某个条件未选择时，点击全选复选框时让其自己及其当前页的所有行都不选中
onCheckAll: function (rows) {
 var n = $('#cc').combotree('getValue');// 获取选择的节点值
 if (n == null || n == "") {
 //避免datagrid标题列的CheckBox在数据重新加载后还处于选中状态
 $(".datagrid-header-heck").children("input[type=\"checkbox\"]").attr("checked",false);
     //当前页每一行中的复选框不被选中
     for (var i = 0; i < rows.length; i++) {
         //每一行记录前的复选框不被选中
         //$("input[type='checkbox']")[i + 1].checked = false;
         //每一行记录不被选中(包括复选框及选择背景)
         $('#dg').datagrid('unselectRow',i);
         //与之相反的有：
         //$("input[type='checkbox']")[i + 1].checked = true;
         //$('#dg').datagrid('selectRow',i);
     }
     $.messager.alert('系统提示', '请选择核查范围', "info");
     return;
 }
```

2. 动态改datagrid中某一列的值时，可以使用updaterow方法来改变，

``` js
//如更新每一行中empId与empName字段的值，可以这样做
var dgRows = $("#auditDg").datagrid("getRows");//获取所有行
        //遍历datagrid每一行的数据，然后根据index更新行数据
        $.each(dgRows, function (i, d) {           
            //更新每一行的empId与empName字段
            $('#auditDg').datagrid('updateRow',{
				index: i,
				row: {
					empId: empId,
					empName:empName
				}
			});		
            
        });
```

3. datagrid的单元格中显示按钮linkbutton按钮的方法

``` js
$('#dg').datagrid({
        method: 'post',
        fit: true,
        url: url,
        pageSize: 15,
        singleSelect: true,
        scrollbarSize: 0,
        fitColumns: true,
        rownumbers: true,
        pageList: [15, 20, 30, 50],
        pagination: true,
        nowrap: false,
        columns: [[
            {field: 'id', hidden:true},
            {field: 'modifyPerson', title: '人员变更', align: 'center', width: 70, 
                formatter: function (value, row, index) {    
                    //这里指定class名称，如 buttonClass
                    return '<a class="buttonClass" onclick="see(\'' + row.id + 						'\',\'' + row.modifyPerson + '\')" href="javascript:void(0)">变更</a>';
                }
            }
        ]], onBeforeLoad: function (p) {
            //分页数据参数传递
            p.startRow = p.page ? ((p.page - 1) * p.rows) : 0;//当前第几页
            p.pageRows = p.rows;//每页行数
            return true;
        }, onLoadSuccess: function (row) {
            //变更按钮css设置，在加载完成后设置linkbutton
         	$('.buttonClass').linkbutton({plain: true, iconCls: 'icon-role'});
        }
    });
```

4. datagrid中调用了 updateRow()方法更新完行数据后，行号出现010,110等bug的修复

``` js
找到easyui文件夹中的 jquery.easyui.min.js 文件，然后搜索下面代码，并按有注释部分的源码修改下即可【每个版本变量名都有差异，根据自己使用的版本仔细查看，一定要看清楚是datagrid的】：
renderRow:function(_5be,_5bf,_5c0,_5c1,_5c2){
var opts=$.data(_5be,"datagrid").options;
var cc=[];
if(_5c0&&opts.rownumbers){
//var _5c3=_5c1+1;
var _5c3=parseInt(_5c1)+1;//修复datagrid中调用了updateRow方法后，行号异常的问题，直接使用parseInt(x)解析下就行
if(opts.pagination){
_5c3+=(opts.pageNumber-1)*opts.pageSize;
}
//其实就是使用parseInt解析了下参数
```

5. datagrid中根据index获取行数据

``` js
var row = $("#dg").datagrid("getRows")[dgIndex];//dgIndex为索引
```

## 消息提示框相关

1. $.messager修改“确定”与“取消”按钮的默认值

``` js
//使用$.messager.defaults重写默认值对象。
$.messager.defaults = {ok : '是', cancel : '否'};//这里将
$.messager.confirm("系统提示","您确定要干点什么吗",function(yes){
    if(yes){
       //干点儿啥
    }else{
       //不干点儿啥
    }
})
```

## Datagrid实现本地数据分页

### 1. 本地数据分页Demo

``` js
1.html代码：
<table id="dg"></table>
2.js代码：
<script>
    // datagrid数据源
    var data = new Array();//或data = [];
    //造50条数据
    for (var i = 1; i <= 50; ++i) {
        data.push(new jsonObj("编号" + i, "姓名" + i))
    }
    $(function () {
        $("#dg").datagrid({
            title: "本地数据分页Demo",
            rownumbers: true,
            fit: false,
            fitColumns: true,
            singleSelect: true,
            //scrollbarSize: 0,//显示横向滚动条
            pagination: true,
            pageSize: 15,
            pageList: [15, 20, 30, 50],
            data: data.slice(0, 10),
            columns: [
                [
                    {field: 'id', align: "center", title: "编号", width: 100},
                    {field: 'name', align: "center", title: "姓名", width: 100}
                ]
            ]
        });
        var pager = $("#dg").datagrid("getPager");//得到分页信息
        pager.pagination({
            total: data.length,
            onSelectPage: function (pageNo, pageSize) {
                var start = (pageNo - 1) * pageSize;
                var end = start + pageSize;
                $("#dg").datagrid("loadData", data.slice(start, end));
                pager.pagination('refresh', {
                    total: data.length,
                    pageNumber: pageNo
                });
            }
        });
    })

    /***
     * 分装json数据的对象
     * @param id
     * @param name
     */
    function jsonObj(id, name) {
        this.id = id;
        this.name = name;
    }
</script>

小技巧：
A.需求：如果在datagrid分页数据的第二页的某一行中修改了行数据，数据刷新后需停留在第二页，则可以使用下面的方式实现：
1.获取分页对象及当前页页码与当前页的行数
//获取分页xun
var pageOptions = $('#dg').datagrid('getPager').data("pagination").options;
var pageNumber= pageOptions.pageNumber;//获取当前页码
var pageSize = pageOptions.pageSize;//获取当前页数据行数  

2.计算显示的开始记录到结束记录数
var startRow = (pageNumber -1) * pageSize ;//开始记录数
var endRow = startRow + pageSize ;//结束记录数

3.重新加载datagrid数据,并设置分页相关参数
//加载datagrid信息，这一步的传参很关键
$("#dg").datagrid("loadData", data.slice(startRow,endRow));//最主要是这一步，传入2计算的参数
var pager = $("#dg").datagrid("getPager");//得到分页信息
    pager.pagination({
        total: data.length,
        onSelectPage: function (pageNo, pageSize) {
           var start = (pageNo - 1) * pageSize;
           var end = start + pageSize;
           $("#dg").datagrid("loadData", data.slice(start, end));
           pager.pagination('refresh', {
                total: data.length,
                pageNumber: pageNo
           });
    }
});

B.需求：例如选中第一页的所有行，点击分页按钮时跳转至第二页，然后再点击分页按钮跳转到第一页后让第一页已选择过的数据默认选中.

实现方法：在datagrid中的onLoadSuccess方法中处理，代码如下：
onLoadSuccess: function (row) {
    $(".datagrid-header-check").children("input[type=\"checkbox\"]").attr("checked", false);//避免datagrid标题列的CheckBox在数据重新加载后还处于选中状态
    //doCellTip 就是鼠标放到单元格上有个提示的功能
    $('#dg').datagrid('doCellTip', {'max-width': '300px', 'delay': 500});
    //加载完成后,获取当前页所有行数据,并根据每一行的id与已经选择后的数据id比对,分页后对已经选择的数据默认选中
    var dgRows = $('#dg').datagrid('getRows');//获取当前页行数据
    if (data.length > 0) {
        //遍历当前页行数据
        for (var i = 0; i < dgRows.length; i++) {
            //遍历已选择记录数组
            for (var j = 0; j < data.length; j++) {
                //判断当前行的id与已选择记录数组中的id是否相同,如果相同则将当前行设置为选中状态
                if (dgRows[i].id == data[j].id) {
                    $("input[type='checkbox']")[i + 1].checked = true;
                }
            }
        }

    }
}
```



### 2.分页相关参数获取

``` js
//获取当前页页码
var pageNumber=$('#dg').datagrid('getPager').data("pagination").options.pageNumber;
//获取当前页数据记录数
var pageSize=$('#dg').datagrid('getPager').data("pagination").options.pageSize;
var startRow = (pageNumber -1) * pageSize + 1;//开始记录数
var endRow = startRow + pageSize -1;//结束记录数


```

### 3.数组相关

#### 1.数组去重

``` js
//定义一个数组
var myArray = [];
myArray.push(new jsonDataObj(1,'张三'))；
myArray.push(new jsonDataObj(2,'李四'))；
myArray.push(new jsonDataObj(1,'张三'))；
myArray.push(new jsonDataObj(21,'王五'))；
myArray.push(new jsonDataObj(10,'马六'))；
/**
 * 封装json数据对象
 * @param id
 * @param empName
 */
function jsonDataObj(id, empName) {
    this.id = id;
    this.empName = empName;
}
/**
 * 数组去重
 * @param arr
 * @returns {*}
 */
function uniqueArray(arr) {
    for (var i = 0; i < arr.length; i++) {
        for (var j = i + 1; j < arr.length;j++) {
            if (arr[i].id == arr[j].id) {//根据id比对
                arr.splice(j, 1);//删除重复的对象；
            }
        }
    }
    return arr;
}
//对myArray去重
uniqueArray(myArray);
```

#### 2.数组排序

``` js
//定义排序规则
/**
 * 数组排序规则
 * @param a
 * @param b
 * @returns {number}
 */
function sortById(a, b) {
    return a.id - b.id;
}
//对myArray按id排序
myArray.sort(sortById);

```

