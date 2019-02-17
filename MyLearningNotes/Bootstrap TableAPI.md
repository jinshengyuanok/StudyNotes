# Bootstrap Table Documentation(Eeglish)

## Bootstrap Table 下载及文档地址：

### 1.下载地址：

http://bootstrap-table.wenzhixin.net.cn/home/

### 2.文档地址：

http://bootstrap-table.wenzhixin.net.cn/documentation/

# Table options

The table options are defined in `jQuery.fn.bootstrapTable.defaults`.

`s appear light or dark gray.

| Name         | Attribute          | Type   | Default             | Description                                                  |
| ------------ | ------------------ | ------ | ------------------- | ------------------------------------------------------------ |
| -            | data-toggle        | String | 'table'             | Activate bootstrap table without writing JavaScript.         |
| classes      | data-classes       | String | 'table table-hover' | The class name of table. By default, the table is bordered, you can add 'table-no-bordered' to remove table-bordered style. |
| theadClasses | data-thead-classes | String | ''                  | The class name of table thead. Bootstrap V4, use the modifier classes `.thead-light` or `.thead-dark` to make ` |



# Column options

The column options is defined in `jQuery.fn.bootstrapTable.columnDefaults`.

| Name            | Attribute              | Type                          | Default   | Description                                                  |
| --------------- | ---------------------- | ----------------------------- | --------- | ------------------------------------------------------------ |
| radio           | data-radio             | Boolean                       | false     | True to show a radio. The radio column has fixed width.      |
| checkbox        | data-checkbox          | Boolean                       | false     | True to show a checkbox. The checkbox column has fixed width. |
| field           | data-field             | String                        | undefined | The column field name.                                       |
| title           | data-title             | String                        | undefined | The column title text.                                       |
| titleTooltip    | data-title-tooltip     | String                        | undefined | The column title tooltip text. This option also support the title HTML attribute. |
| class           | class / data-class     | String                        | undefined | The column class name.                                       |
| rowspan         | rowspan / data-rowspan | Number                        | undefined | Indicate how many rows a cell should take up.                |
| colspan         | colspan / data-colspan | Number                        | undefined | Indicate how many columns a cell should take up.             |
| align           | data-align             | String                        | undefined | Indicate how to align the column data. 'left', 'right', 'center' can be used. |
| halign          | data-halign            | String                        | undefined | Indicate how to align the table header. 'left', 'right', 'center' can be used. |
| falign          | data-falign            | String                        | undefined | Indicate how to align the table footer. 'left', 'right', 'center' can be used. |
| valign          | data-valign            | String                        | undefined | Indicate how to align the cell data. 'top', 'middle', 'bottom' can be used. |
| width           | data-width             | Number {Pixels or Percentage} | undefined | The width of column. If not defined, the width will auto expand to fit its contents. Though if the table is left responsive and sized too small this 'width' might be ignored (use min/max-width via class or such then). Also you can add '%' to your number and the bootstrapTable will use the percentage unit, otherwise, leave as number (or add 'px') to make it use pixels. |
| sortable        | data-sortable          | Boolean                       | false     | True to allow the column can be sorted.                      |
| order           | data-order             | String                        | 'asc'     | The default sort order, can only be 'asc' or 'desc'.         |
| visible         | data-visible           | Boolean                       | true      | False to hide the columns item.                              |
| cardVisible     | data-card-visible      | Boolean                       | true      | False to hide the columns item in card view state.           |
| switchable      | data-switchable        | Boolean                       | true      | False to disable the switchable of columns item.             |
| clickToSelect   | data-click-to-select   | Boolean                       | true      | True to select checkbox or radio when the column is clicked. |
| formatter       | data-formatter         | Function                      | undefined | The context (this) is the column Object.  The cell formatter function, take three parameters:  value: the field value.  row: the row record data. index: the row index. field: the row field. Example usage: `function formatter(value, row, index, field) {   if (value === 'foo') {   return '**' + value + '**';   }   return value; } ` |
| footerFormatter | data-footer-formatter  | Function                      | undefined | The context (this) is the column Object.  The function, take one parameter:  data: Array of all the data rows.  the function should return a string with the text to show in the footer cell. |
| events          | data-events            | Object                        | undefined | The cell events listener when you use formatter function, take four parameters:  event: the jQuery event.  value: the field value.  row: the row record data. index: the row index.  Example code: `<th .. data-events="operateEvent">` `var operateEvents = {'click .like': function (e, value, row, index) {}};` |
| sorter          | data-sorter            | Function                      | undefined | The custom field sort function that used to do local sorting, take two parameters:  a: the first field value. b: the second field value. rowA: the first row. rowB: the second row. |
| sortName        | data-sort-name         | String                        | undefined | Provide a customizable sort-name, not the default sort-name in the header, or the field name of the column. For example, a column might display the value of fieldName of "html" such as "<b><span style="color:red">abc</span></b>", but a fieldName to sort is "content" with the value of "abc". |
| cellStyle       | data-cell-style        | Function                      | undefined | The cell style formatter function, take three parameters:  value: the field value. row: the row record data. index: the row index. field: the row field. Support classes or css. Example usage: `function cellStyle(value, row, index, field) {   return {   classes: 'text-nowrap another-class',   css: {"color": "blue", "font-size": "50px"}   }; } ` |
| searchable      | data-searchable        | Boolean                       | true      | True to search data for this column.                         |
| searchFormatter | data-search-formatter  | Boolean                       | true      | True to search use formatted data.                           |
| escape          | data-escape            | Boolean                       | false     | Escapes a string for insertion into HTML, replacing &, <, >, ", \`, and ' characters. |
| showSelectTitle | data-show-select-title | Boolean                       | false     | True to show the title of column with 'radio' or 'singleSelect' 'checkbox' option. |



# Events

To use event syntax:

```js
$('#table').bootstrapTable({
  onEventName: function (arg1, arg2, ...) {
    // ...
  }
})

$('#table').on('event-name.bs.table', function (e, arg1, arg2, ...) {
  // ...
})
```

 



| Option Event     | jQuery Event             | Parameter                   | Description                                                  |
| ---------------- | ------------------------ | --------------------------- | ------------------------------------------------------------ |
| onAll            | all.bs.table             | name, args                  | Fires when all events trigger, the parameters contain:  name: the event name,  args: the event data. |
| onClickRow       | click-row.bs.table       | row, $element, field        | Fires when user click a row, the parameters contain:  row: the record corresponding to the clicked row,  $element: the tr element,  field: the field name corresponding to the clicked cell. |
| onDblClickRow    | dbl-click-row.bs.table   | row, $element, field        | Fires when user double click a row, the parameters contain:  row: the record corresponding to the clicked row,  $element: the tr element,  field: the field name corresponding to the clicked cell. |
| onClickCell      | click-cell.bs.table      | field, value, row, $element | Fires when user click a cell, the parameters contain:  field: the field name corresponding to the clicked cell,  value: the data value corresponding to the clicked cell,  row: the record corresponding to the clicked row,  $element: the td element. |
| onDblClickCell   | dbl-click-cell.bs.table  | field, value, row, $element | Fires when user double click a cell, the parameters contain:  field: the field name corresponding to the clicked cell,  value: the data value corresponding to the clicked cell,  row: the record corresponding to the clicked row,  $element: the td element. |
| onSort           | sort.bs.table            | name, order                 | Fires when user sort a column, the parameters contain:  name: the sort column field name order: the sort column order. |
| onCheck          | check.bs.table           | row, $element               | Fires when user check a row, the parameters contain:  row: the record corresponding to the clicked row. $element: the DOM element checked. |
| onUncheck        | uncheck.bs.table         | row, $element               | Fires when user uncheck a row, the parameters contain:  row: the record corresponding to the clicked row. $element: the DOM element unchecked. |
| onCheckAll       | check-all.bs.table       | rows                        | Fires when user check all rows, the parameters contain:  rows: array of records corresponding to newly checked rows. |
| onUncheckAll     | uncheck-all.bs.table     | rows                        | Fires when user uncheck all rows, the parameters contain:  rows: array of records corresponding to previously checked rows. |
| onCheckSome      | check-some.bs.table      | rows                        | Fires when user check some rows, the parameters contain:  rows: array of records corresponding to newly checked rows. |
| onUncheckSome    | uncheck-some.bs.table    | rows                        | Fires when user uncheck some rows, the parameters contain:  rows: array of records corresponding to previously checked rows. |
| onLoadSuccess    | load-success.bs.table    | data                        | Fires when remote data is loaded successfully.               |
| onLoadError      | load-error.bs.table      | status, res                 | Fires when some errors occur to load remote data.            |
| onColumnSwitch   | column-switch.bs.table   | field, checked              | Fires when switch the column visible.                        |
| onColumnSearch   | column-search.bs.table   | field, text                 | Fires when search by column.                                 |
| onPageChange     | page-change.bs.table     | number, size                | Fires when change the page number or page size.              |
| onSearch         | search.bs.table          | text                        | Fires when search the table.                                 |
| onToggle         | toggle.bs.table          | cardView                    | Fires when toggle the view of table.                         |
| onPreBody        | pre-body.bs.table        | data                        | Fires before the table body is rendered                      |
| onPostBody       | post-body.bs.table       | data                        | Fires after the table body is rendered and available in the DOM |
| onPostHeader     | post-header.bs.table     | none                        | Fires after the table header is rendered and availble in the DOM |
| onExpandRow      | expand-row.bs.table      | index, row, $detail         | Fires when click the detail icon to expand the detail view.  |
| onCollapseRow    | collapse-row.bs.table    | index, row                  | Fires when click the detail icon to collapse the detail view. |
| onRefreshOptions | refresh-options.bs.table | options                     | Fires after refresh the options and before destroy and init the table |
| onResetView      | reset-view.bs.table      |                             | Fires when reset view of the table.                          |
| onRefresh        | refresh.bs.table         | params                      | Fires after the click the refresh button.                    |
| onScrollBody     | scroll-body.bs.table     |                             | Fires when table body scroll.                                |



# Methods

The calling method syntax: `$('#table').bootstrapTable('method', parameter)`.

| Name              | Parameter      | Description                                                  | Example |
| ----------------- | -------------- | ------------------------------------------------------------ | ------- |
| getOptions        | none           | Return the options object.                                   |         |
| getSelections     | none           | Return selected rows, when no record selected, an empty array will return. |         |
| getAllSelections  | none           | Return all selected rows contain search or filter, when no record selected, an empty array will return. |         |
| showAllColumns    | none           | Show All the columns.                                        |         |
| hideAllColumns    | none           | Hide All the columns.                                        |         |
| getData           | useCurrentPage | Get the loaded data of table at the moment that this method is called. If you set the useCurrentPage to true the method will return the data in the current page. |         |
| getRowByUniqueId  | id             | Get data from table, the row that contains the id passed by parameter. |         |
| load              | data           | Load the data to table, the old rows will be removed.        |         |
| append            | data           | Append the data to table.                                    |         |
| prepend           | data           | Prepend the data to table.                                   |         |
| remove            | params         | Remove data from table, the params contains two properties:  field: the field name of remove rows.  values: the array of values for rows which should be removed. |         |
| removeAll         | -              | Remove all data from table.                                  |         |
| removeByUniqueId  | id             | Remove data from table, the row that contains the id passed by parameter. |         |
| insertRow         | params         | Insert a new row, the param contains following properties: index: the row index to insert into. row: the row data. |         |
| updateRow         | params         | Update the specified row(s), each param contains following properties:  index: the row index to be updated.  row: the new row data. |         |
| updateByUniqueId  | params         | Update the specified row(s), each param contains following properties:  id: a row id where the id should be the uniqueid field assigned to the table.  row: the new row data. |         |
| showRow           | params         | Show the specified row. The param must contain at least one of the following properties: index: the row index. uniqueId: the value of the uniqueId for that row. |         |
| hideRow           | params         | Hide the specified row. The param must contain at least one of the following properties: index: the row index. uniqueId: the value of the uniqueId for that row. |         |
| getHiddenRows     | boolean        | Get all rows hidden and if you pass the show parameter true the rows will be shown again, otherwise, the method only will return the rows hidden. |         |
| mergeCells        | options        | Merge some cells to one cell, the options contains following properties:  index: the row index.  field: the field name. rowspan: the rowspan count to be merged.  colspan: the colspan count to be merged. |         |
| updateCell        | params         | Update one cell, the params contains following properties:  index: the row index.  field: the field name. value: the new field value.  To disable table re-initialization you can set `{reinit: false}` |         |
| refresh           | params         | Refresh the remote server data, you can set `{silent: true}` to refresh the data silently, and set `{url: newUrl, pageNumber: pageNumber, pageSize: pageSize}` to change the url (optional), page number (optional) and page size (optional). To supply query params specific to this request, set `{query: {foo: 'bar'}}`. |         |
| refreshOptions    | options        | Refresh the options                                          |         |
| resetSearch       | text           | Set the search text                                          |         |
| showLoading       | none           | Show loading status.                                         |         |
| hideLoading       | none           | Hide loading status.                                         |         |
| checkAll          | none           | Check all current page rows.                                 |         |
| uncheckAll        | none           | Uncheck all current page rows.                               |         |
| checkInvert       | none           | Invert check of current page rows. Triggers onCheckSome and onUncheckSome events. |         |
| check             | index          | Check a row, the row index start with 0.                     |         |
| uncheck           | index          | Uncheck a row, the row index start with 0.                   |         |
| checkBy           | params         | Check a row by array of values, the params contains: field: name of the field used to find records values: array of values for rows to check Example:  $("#table").bootstrapTable("checkBy", {field:"field_name", values:["value1","value2","value3"]}) |         |
| uncheckBy         | params         | Uncheck a row by array of values, the params contains: field: name of the field used to find records values: array of values for rows to uncheck Example:  $("#table").bootstrapTable("uncheckBy", {field:"field_name", values:["value1","value2","value3"]}) |         |
| resetView         | params         | Reset the bootstrap table view, for example reset the table height. |         |
| resetWidth        | none           | Resizes header and footer to fit current columns width       |         |
| destroy           | none           | Destroy the bootstrap table.                                 |         |
| showColumn        | field          | Show the specified column.                                   |         |
| hideColumn        | field          | Hide the specified column.                                   |         |
| getHiddenColumns  | -              | Get hidden columns.                                          |         |
| getVisibleColumns | -              | Get visible columns.                                         |         |
| scrollTo          | value          | Scroll to the number value position, the unit is 'px', set 'bottom' means scroll to the bottom. |         |
| getScrollPosition | none           | Get the current scroll position, the unit is 'px'.           |         |
| filterBy          | params         | (Can use only in client-side) Filter data in table, e.g. you can filter `{age: 10}` to show the data only age is equal to 10. You can also filter with an array of values, as in: `{age: 10, hairColor: ["blue", "red", "green"]} to find data where age is equal to 10 and hairColor is either blue, red, or green.` |         |
| selectPage        | page           | Go to the a specified page.                                  |         |
| prevPage          | none           | Go to previous page.                                         |         |
| nextPage          | none           | Go to next page.                                             |         |
| togglePagination  | none           | Toggle the pagination option.                                |         |
| toggleView        | none           | Toggle the card/table view.                                  |         |
| expandRow         | index          | Expand the row that has the index passed by parameter if the detail view option is set to True. |         |
| collapseRow       | index          | Collapse the row that has the index passed by parameter if the detail view option is set to True. |         |
| expandAllRows     | is subtable    | Expand all rows if the detail view option is set to True.    |         |
| collapseAllRows   | is subtable    | Collapse all rows if the detail view option is set to True.  |         |
| updateCellById    | params         | update the cell specified by the id, each param contains following properties:  id: row id where the id should be the uniqueid field assigned to the table.  field: field name of the cell to be updated. value: new value of the cell. |         |



# Localizations

| Name                   | Parameter                   | Default                       |
| ---------------------- | --------------------------- | ----------------------------- |
| formatLoadingMessage   | -                           | 'Loading, please wait…'       |
| formatRecordsPerPage   | pageNumber                  | '%s records per page'         |
| formatShowingRows      | pageFrom, pageTo, totalRows | 'Showing %s to %s of %s rows' |
| formatDetailPagination | totalRows                   | 'Showing %s rows'             |
| formatSearch           | -                           | 'Search'                      |
| formatNoMatches        | -                           | 'No matching records found'   |
| formatRefresh          | -                           | 'Refresh'                     |
| formatToggle           | -                           | 'Toggle'                      |
| formatColumns          | -                           | 'Columns'                     |
| formatAllRows          | -                           | 'All'                         |
| formatFullscreen       | -                           | 'Fullscreen'                  |



------



**PS:**

We can import [all locale files](https://github.com/wenzhixin/bootstrap-table/tree/master/src/locale) what you need:

```html
<script src="bootstrap-table-en-US.js"></script>
<script src="bootstrap-table-zh-CN.js"></script>
...
```

And then use JavaScript to switch locale:

```js
$.extend($.fn.bootstrapTable.defaults, $.fn.bootstrapTable.locales['en-US']);
// $.extend($.fn.bootstrapTable.defaults, $.fn.bootstrapTable.locales['zh-CN']);
// ...
```

Or use data attributes to set locale for table:

```html
<table data-toggle="table" data-locale="en-US">
</table>
```

Or use JavaScript to set locale for table:

```js
$('table').bootstrapTable({locale:'en-US'});
```

- 

# Bootstrap Table 文档(中文)

# 表格参数

表格的参数定义在 `jQuery.fn.bootstrapTable.defaults`。

` 的样式。       

| 名称         | 标签               | 类型   | 默认                | 描述                                                         |
| ------------ | ------------------ | ------ | ------------------- | ------------------------------------------------------------ |
| -            | data-toggle        | String | 'table'             | 不用写 JavaScript 直接启用表格。                             |
| classes      | data-classes       | String | 'table table-hover' | 表格的类名称。默认情况下，表格是有边框的，你可以添加 'table-no-bordered' 来删除表格的边框样式。 |
| theadClasses | data-thead-classes | String | ''                  | 表格 thead 的类名称。Bootstrap V4，使用 `.thead-light` 或者 `.thead-dark` 可以设置 ` |



# 列参数

The column options is defined in `jQuery.fn.bootstrapTable.columnDefaults`.

| Name            | Attribute              | Type                          | Default   | Description                                                  |
| --------------- | ---------------------- | ----------------------------- | --------- | ------------------------------------------------------------ |
| radio           | data-radio             | Boolean                       | false     | True to show a radio. The radio column has fixed width.      |
| checkbox        | data-checkbox          | Boolean                       | false     | True to show a checkbox. The checkbox column has fixed width. |
| field           | data-field             | String                        | undefined | The column field name.                                       |
| title           | data-title             | String                        | undefined | The column title text.                                       |
| titleTooltip    | data-title-tooltip     | String                        | undefined | The column title tooltip text. This option also support the title HTML attribute |
| class           | class / data-class     | String                        | undefined | The column class name.                                       |
| rowspan         | rowspan / data-rowspan | Number                        | undefined | Indicate how many rows a cell should take up.                |
| colspan         | colspan / data-colspan | Number                        | undefined | Indicate how many columns a cell should take up.             |
| align           | data-align             | String                        | undefined | Indicate how to align the column data. 'left', 'right', 'center' can be used. |
| halign          | data-halign            | String                        | undefined | Indicate how to align the table header. 'left', 'right', 'center' can be used. |
| falign          | data-falign            | String                        | undefined | Indicate how to align the table footer. 'left', 'right', 'center' can be used. |
| valign          | data-valign            | String                        | undefined | Indicate how to align the cell data. 'top', 'middle', 'bottom' can be used. |
| width           | data-width             | Number {Pixels or Percentage} | undefined | The width of column. If not defined, the width will auto expand to fit its contents. Also you can add '%' to your number and the bootstrapTable will use the percentage unit, otherwise, you can add or no the 'px' to your number and then the bootstrapTable will use the pixels |
| sortable        | data-sortable          | Boolean                       | false     | True to allow the column can be sorted.                      |
| order           | data-order             | String                        | 'asc'     | The default sort order, can only be 'asc' or 'desc'.         |
| visible         | data-visible           | Boolean                       | true      | False to hide the columns item.                              |
| cardVisible     | data-card-visible      | Boolean                       | true      | False to hide the columns item in card view state.           |
| switchable      | data-switchable        | Boolean                       | true      | False to disable the switchable of columns item.             |
| clickToSelect   | data-click-to-select   | Boolean                       | true      | True to select checkbox or radiobox when the column is clicked. |
| formatter       | data-formatter         | Function                      | undefined | The context (this) is the column Object.  The cell formatter function, take three parameters:  value: the field value.  row: the row record data. index: the row index. |
| footerFormatter | data-footer-formatter  | Function                      | undefined | The context (this) is the column Object.  The function, take one parameter:  data: Array of all the data rows.  the function should return a string with the text to show in the footer cell. |
| events          | data-events            | Object                        | undefined | The cell events listener when you use formatter function, take three parameters:  event: the jQuery event.  value: the field value.  row: the row record data. index: the row index. |
| sorter          | data-sorter            | Function                      | undefined | The custom field sort function that used to do local sorting, take two parameters:  a: the first field value. b: the second field value. rowA: the first row. rowB: the second row. |
| sortName        | data-sort-name         | String                        | undefined | Provide a customizable sort-name, not the default sort-name in the header, or the field name of the column. For example, a column might display the value of fieldName of "html" such as "<b><span style="color:red">abc</span></b>", but a fieldName to sort is "content" with the value of "abc". |
| cellStyle       | data-cell-style        | Function                      | undefined | The cell style formatter function, take three parameters:  value: the field value. row: the row record data. index: the row index. field: the row field. Support classes or css. |
| searchable      | data-searchable        | Boolean                       | true      | True to search data for this column.                         |
| searchFormatter | data-search-formatter  | Boolean                       | true      | True to search use formated data.                            |
| escape          | data-escape            | Boolean                       | false     | Escapes a string for insertion into HTML, replacing &, <, >, ", \`, and ' characters. |
| showSelectTitle | data-show-select-title | Boolean                       | false     | True to show the title of column with 'radio' or 'singleSelect' 'checkbox' option. |



# 事件

| Option 事件      | jQuery 事件              | 参数                        | 描述                                                         |
| ---------------- | ------------------------ | --------------------------- | ------------------------------------------------------------ |
| onAll            | all.bs.table             | name, args                  | 所有的事件都会触发该事件，参数包括： name：事件名， args：事件的参数。 |
| onClickRow       | click-row.bs.table       | row, $element               | 当用户点击某一行的时候触发，参数包括： row：点击行的数据， $element：tr 元素， field：点击列的 field 名称。 |
| onDblClickRow    | dbl-click-row.bs.table   | row, $element               | 当用户双击某一行的时候触发，参数包括： row：点击行的数据， $element：tr 元素， field：点击列的 field 名称。 |
| onClickCell      | click-cell.bs.table      | field, value, row, $element | 当用户点击某一列的时候触发，参数包括： field：点击列的 field 名称， value：点击列的 value 值， row：点击列的整行数据， $element：td 元素。 |
| onDblClickCell   | dbl-click-cell.bs.table  | field, value, row, $element | 当用户双击某一列的时候触发，参数包括： field：点击列的 field 名称， value：点击列的 value 值， row：点击列的整行数据， $element：td 元素。 |
| onSort           | sort.bs.table            | name, order                 | 当用户对某列进行排序时触发，参数包括： name：排序列的 filed 名称， order：排序顺序。 |
| onCheck          | check.bs.table           | row                         | 当用户选择某一行时触发，参数包含：         row：与点击行对应的记录，         $element：选择的DOM元素。 |
| onUncheck        | uncheck.bs.table         | row                         | 当用户反选某一行时触发，参数包含： row：与点击行对应的记录，         $element：选择的DOM元素。 |
| onCheckAll       | check-all.bs.table       | rows                        | 当用户全选所有的行时触发，参数包含： rows：最新选择的所有行的数组。 |
| onUncheckAll     | uncheck-all.bs.table     | rows                        | 当用户反选所有的行时触发，参数包含： rows：最新选择的所有行的数组。 |
| onCheckSome      | check-some.bs.table      | rows                        | 当用户选择某些行时触发，参数包含： rows：相对于之前选择的行的数组。 |
| onUncheckSome    | uncheck-some.bs.table    | rows                        | 当用户反选某些行时触发，参数包含： rows：相对于之前选择的行的数组。 |
| onLoadSuccess    | load-success.bs.table    | data                        | 远程数据加载成功时触发成功。                                 |
| onLoadError      | load-error.bs.table      | status                      | 远程数据加载失败时触发成功。                                 |
| onColumnSwitch   | column-switch.bs.table   | field, checked              | 当切换列的时候触发。                                         |
| onColumnSearch   | column-search.bs.table   | field, text                 | 当搜索列时触发。                                             |
| onPageChange     | page-change.bs.table     | number, size                | 当页面更改页码或页面大小时触发。                             |
| onSearch         | search.bs.table          | text                        | 当搜索表格时触发。                                           |
| onToggle         | toggle.bs.table          | cardView                    | 切换表格视图时触发。                                         |
| onPreBody        | pre-body.bs.table        | data                        | 在表格 body 渲染之前触发。                                   |
| onPostBody       | post-body.bs.table       | data                        | 在表格 body 渲染完成后触发。                                 |
| onPostHeader     | post-header.bs.table     | none                        | 在表格 header 渲染完成后触发。                               |
| onExpandRow      | expand-row.bs.table      | index, row, $detail         | 当点击详细图标展开详细页面的时候触发。                       |
| onCollapseRow    | collapse-row.bs.table    | index, row                  | 当点击详细图片收起详细页面的时候触发。                       |
| onRefreshOptions | refresh-options.bs.table | options                     | 刷新选项之后并在销毁和初始化表之前触发。                     |
| onRefresh        | refresh.bs.table         | params                      | 点击刷新按钮后触发。                                         |
| onScrollBody     | scroll-body.bs.table     |                             | 表格 body 滚动时触发。                                       |



# 方法

使用方法的语法：`$('#table').bootstrapTable('method', parameter)`。

| 名称              | 参数           | 描述                                                         | 例子 |
| ----------------- | -------------- | ------------------------------------------------------------ | ---- |
| getOptions        | none           | 返回表格的 Options。                                         |      |
| getSelections     | none           | 返回所选的行，当没有选择任何行的时候返回一个空数组。         |      |
| getAllSelections  | none           | 返回所有选择的行，包括搜索过滤前的，当没有选择任何行的时候返回一个空数组。 |      |
| getData           | useCurrentPage | 或者当前加载的数据。假如设置 useCurrentPage 为 true，则返回当前页的数据。 |      |
| getRowByUniqueId  | id             | 根据 uniqueId 获取行数据。                                   |      |
| load              | data           | 加载数据到表格中，旧数据会被替换。                           |      |
| showAllColumns    | none           | 显示所有列。                                                 |      |
| hideAllColumns    | none           | 隐藏所有列。                                                 |      |
| append            | data           | 添加数据到表格在现有数据之后。                               |      |
| prepend           | data           | 插入数据到表格在现有数据之前。                               |      |
| remove            | params         | 从表格中删除数据，包括两个参数： field: 需要删除的行的 field 名称， values: 需要删除的行的值，类型为数组。 |      |
| removeAll         | -              | 删除表格所有数据。                                           |      |
| removeByUniqueId  | id             | 根据 uniqueId 删除指定的行。                                 |      |
| insertRow         | params         | 插入新行，参数包括： index: 要插入的行的 index， row: 行的数据，Object 对象。 |      |
| updateRow         | params         | 更新指定的行，参数包括： index: 要更新的行的 index， row: 行的数据，Object 对象。 |      |
| showRow           | params         | 显示指定的行，参数包括： index: 要更新的行的 index 或者 uniqueId， isIdField: 指定 index 是否为 uniqueid。 |      |
| hideRow           | params         | 显示指定的行，参数包括： index: 要更新的行的 index， uniqueId: 或者要更新的行的 uniqueid。 |      |
| getHiddenRows     | show           | 获取所有隐藏的行，如果show参数为true，行将再次显示，否则，只返回隐藏的行。 |      |
| mergeCells        | options        | 将某些单元格合并到一个单元格，选项包含以下属性：  index: 行索引， field: 字段名称， rowspan: 要合并的rowspan数量， colspan: 要合并的colspan数量。 |      |
| updateCell        | params         | 更新一个单元格，params包含以下属性： index: 行索引。 field: 字段名称。 value: 新字段值。 |      |
| refresh           | params         | 刷新远程服务器数据，可以设置`{silent: true}`以静默方式刷新数据，并设置`{url: newUrl}`更改URL。 要提供特定于此请求的查询参数，请设置`{query: {foo: 'bar'}}`。 |      |
| refreshOptions    | options        | 刷新选项。                                                   |      |
| resetSearch       | text           | 设置搜索文本。                                               |      |
| showLoading       | none           | 显示加载状态。                                               |      |
| hideLoading       | none           | 隐藏加载状态。                                               |      |
| checkAll          | none           | 选中当前页面所有行。                                         |      |
| uncheckAll        | none           | 取消选中当前页面所有行。                                     |      |
| check             | index          | 选中某一行，行索引从0开始。                                  |      |
| uncheck           | index          | 取消选中某一行，行索引从0开始。                              |      |
| checkBy           | params         | 按值或数组选中某行，参数包含： field: 用于查找记录的字段的名称， values: 要检查的行的值数组。 例子:  $("#table").bootstrapTable("checkBy", {field:"field_name", values:["value1","value2","value3"]}) |      |
| uncheckBy         | params         | 按值数组取消选中某行，参数包含： field: 用于查找记录的字段的名称， values: 要检查的行的值数组。 例子:  $("#table").bootstrapTable("uncheckBy", {field:"field_name", values:["value1","value2","value3"]}) |      |
| resetView         | params         | 重置引导表视图，例如重置表高度。                             |      |
| resetWidth        | none           | 调整页眉和页脚的大小以适合当前列宽度。                       |      |
| destroy           | none           | 销毁表。                                                     |      |
| showColumn        | field          | 显示指定的列。                                               |      |
| hideColumn        | field          | 隐藏指定的列。                                               |      |
| getHiddenColumns  | -              | 获取隐藏的列。                                               |      |
| getVisibleColumns | -              | 获取可见列。                                                 |      |
| scrollTo          | value          | 滚动到指定位置，单位为 px，设置 'bottom' 表示跳到最后。      |      |
| getScrollPosition | none           | 获取当前滚动条的位置，单位为 px。                            |      |
| filterBy          | params         | （只能用于 client 端）过滤表格数据， 你可以通过过滤`{age: 10}`来显示 age 等于 10 的数据。 |      |
| selectPage        | page           | 跳到指定的页。                                               |      |
| prevPage          | none           | 跳到上一页。                                                 |      |
| nextPage          | none           | 跳到下一页。                                                 |      |
| togglePagination  | none           | 切换分页选项。                                               |      |
| toggleView        | none           | 切换 card/table 视图                                         |      |
| expandRow         | index          | 如果详细视图选项设置为True，可展开索引为 index 的行。        |      |
| collapseRow       | index          | 如果详细视图选项设置为True，可收起索引为 index 的行。.       |      |
| expandAllRows     | none           | 如果详细视图选项设置为True，可展开所有行。                   |      |
| collapseAllRows   | none           | 如果详细视图选项设置为True，可收起开所有行。                 |      |



# 多语言

| Name                   | Parameter                   | Default                       |
| ---------------------- | --------------------------- | ----------------------------- |
| formatLoadingMessage   | -                           | 'Loading, please wait…'       |
| formatRecordsPerPage   | pageNumber                  | '%s records per page'         |
| formatShowingRows      | pageFrom, pageTo, totalRows | 'Showing %s to %s of %s rows' |
| formatDetailPagination | totalRows                   | 'Showing %s rows'             |
| formatSearch           | -                           | 'Search'                      |
| formatNoMatches        | -                           | 'No matching records found'   |
| formatRefresh          | -                           | 'Refresh'                     |
| formatToggle           | -                           | 'Toggle'                      |
| formatColumns          | -                           | 'Columns'                     |
| formatAllRows          | -                           | 'All'                         |
| formatFullscreen       | -                           | 'Fullscreen'                  |

------



**PS:**

We can import [all locale files](https://github.com/wenzhixin/bootstrap-table/tree/master/src/locale) what you need:

```html
<script src="bootstrap-table-en-US.js"></script>
<script src="bootstrap-table-zh-CN.js"></script>
...
```

And then use JavaScript to switch locale:

```js
$.extend($.fn.bootstrapTable.defaults, $.fn.bootstrapTable.locales['en-US']);
// $.extend($.fn.bootstrapTable.defaults, $.fn.bootstrapTable.locales['zh-CN']);
// ...
```