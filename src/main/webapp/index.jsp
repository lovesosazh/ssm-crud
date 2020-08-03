<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/js/jquery-3.5.1.js" type="text/javascript"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        var totalRecords,currentPageNo;
        $(function() {

            to_page(1);

            // 打开增加员工的模态框
            $("#emp_add_modal_btn").click(function() {
                // 清除表单数据和样式
                reset_form("#empAddModal form");

                getDepts("#dept_add_input");

                $("#empAddModal").modal({
                    backdrop:"static"
                });


            });



            // 打开修改模态框
            $(document).on("click",".edit_btn",function() {

                // 查询部门信息
                getDepts("#dept_update_input");

                // 查询员工信息
                var empId = $(this).attr("edit-id");
                getEmp(empId);

                $("#emp_update_btn").attr("edit-id",empId);
                $("#empUpdateModal").modal({
                    backdrop:"static"
                });

            });



            // 给删除按钮绑定单击事件
            $(document).on("click", "button.delete_btn", function() {
                var empName = $(this).parent().parent().children().eq(2).text();
                if (confirm("确认删除【" + empName + "】吗?")) {
                    $.ajax({
                       url:"${APP_PATH}/emp/" + $(this).attr("delete-id"),
                       type:"DELETE",
                        success:function (response) {
                            to_page(currentPageNo);
                        }
                    });
                }
            });

            del_emp_all();
            checkAll_fun();
            checkItem_fun();
            // validate_empName();
            saveEmp();
            updateEmp();

        });

        function del_emp_all() {
            // 批量删除
            $("#del_all_btn").click(function () {
                var empNames = "";
                var empIds = "";
                $.each($(".check_item:checked"),function() {
                    empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
                    empIds += $(this).parents("tr").find("td:eq(1)").text() + "-";
                });

                empNames = empNames.substring(0,empNames.length-1);
                empIds = empIds.substring(0,empIds.length-1)
                if (confirm("确认删除【" + empNames+ "】员工吗?")) {
                    $.ajax({
                        url:"${APP_PATH}/emp/" + empIds,
                        type:"DELETE",
                        success:function (response) {
                            to_page(currentPageNo);
                        }
                    });
                }
            });
        }


            // 清除表单数据和样式
            function reset_form(ele) {
                $(ele)[0].reset();
                $(ele).find("*").removeClass("has-error has-success");
                $(ele).find(".help-block").text("");
            }

            // 检验员工姓名是否重复 empName_add_input
            function validate_empName() {
                $("#empName_add_input").change(function() {
                    var empName = $("#empName_add_input").val();
                    var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
                    if (!regName.test(empName)) {
                        show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合");
                        return false;
                    } else {
                        show_validate_msg("#empName_add_input", "success", "");
                        $.ajax({
                            url:"${APP_PATH}/checkEmpName?empName=" + empName,
                            type:"get",
                            success:function(response) {
                                if (response.items.exists) {
                                    show_validate_msg("#empName_add_input", "error", "用户名已存在!");
                                    $("#emp_save_btn").attr("ajax-va", "error");
                                } else {
                                    show_validate_msg("#empName_add_input", "success", "");
                                    $("#emp_save_btn").attr("ajax-va", "success");
                                }
                            }
                        });
                    }


                });
            }

            // 查询部门信息并显示在下拉列表中
            function getDepts(ele) {
                $(ele).empty();
                $.ajax({
                    url: "${APP_PATH}/depts",
                    type:"get",
                    success:function(response) {
                        var deptList = response.items.depts;
                        $.each(deptList, function(index, dept) {
                            var deptOption = $("<option></option>").append(dept.deptName).val(dept.deptId);
                            $(ele).append(deptOption);
                        })
                    },
                    dataType:"json"
                });
            }


            // 保存员工
            function saveEmp() {
                validate_empName();
                $("#emp_save_btn").click(function() {
                    // 校验表单
                    if (!validate_add_form()) {
                        return false;
                    }

                    // 检验用户名是否重复
                    if ($(this).attr("ajax-va") === "error") {
                        return false;
                    }

                    $.ajax({
                        url:"${APP_PATH}/emp",
                        type:"post",
                        data:$("#empAddModal form").serialize(),
                        success:function(response) {
                            // 在保存前需要进行一次后端校验
                            if (response.code === 200) {
                                if (response.items.errorFields.email != undefined) {
                                    show_validate_msg("#email_add_input", "error", response.items.errorFields.email);
                                }

                                if (response.items.errorFields.empName != undefined) {
                                    show_validate_msg("#empName_add_input", "error", response.items.errorFields.empName);
                                }

                            } else {
                                // 关闭模态框
                                $("#empAddModal").modal('hide');
                                // 跳转到员工列表最后一页,显示保存的数据
                                to_page(totalRecords);
                            }
                        }
                    });

                });

            }


            // 校验表单数据
            function validate_add_form() {
                var empName = $("#empName_add_input").val();
                var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
                if (!regName.test(empName)) {
                    // alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
                    show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合");
                    return false;
                } else {
                    show_validate_msg("#empName_add_input", "success", "");
                }

                var email = $("#email_add_input").val();
                var regEmail = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
                if (!regEmail.test(email)) {
                    // alert("邮箱格式不正确");
                    show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
                    return false;
                } else {
                    show_validate_msg("#email_add_input", "success", "");
                }

                return true;
            }


            // 校验提示信息
            function show_validate_msg(ele, status, msg) {
                $(ele).parent().removeClass("has-success has-error");
                $(ele).next("span").text("");
                if ("success" === status) {
                    $(ele).parent().addClass("has-success");
                    $(ele).next("span").text(msg);
                } else {
                    $(ele).parent().addClass("has-error");
                    $(ele).next("span").text(msg);
                }
            }


            function to_page(pageNo) {
                $.ajax({
                    url:"${APP_PATH}/emps?pageNo=" + pageNo,
                    type:"get",
                    success:function(response) {

                        build_emps_table(response);
                        build_page_info(response);
                        build_page_nav(response);
                    },
                    dataType:"json"
                });
            }

            // 构建员工展示表格
            function build_emps_table(result) {
                $("table:eq(0)>tbody").empty();
                var emps = result.items.pageInfo.list;
                $.each(emps,function(index, item) {
                    var checkBoxTd = $("<td></td>").append($("<input type='checkbox' class='check_item'/>"));
                    var empIdTd = $("<td></td>").append(item.empId);
                    var empNameTd = $("<td></td>").append(item.empName);
                    var gender = item.gender == 'M' ? '男' : '女';
                    var empGenderTd = $("<td></td>").append(gender);
                    var empEmailTd = $("<td></td>").append(item.email);
                    var empDeptNameTd = $("<td></td>").append(item.department.deptName);
                    var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                        .append($("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑"));
                    editBtn.attr("edit-id", item.empId);
                    var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                        .append($("<span></span>").addClass("glyphicon glyphicon-trash").append("删除"));
                    delBtn.attr("delete-id", item.empId);
                    var operationTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
                    $("<tr></tr>").append(checkBoxTd).append(empIdTd).append(empNameTd)
                        .append(empGenderTd).append(empEmailTd).append(empDeptNameTd).append(operationTd).appendTo($("table:eq(0)>tbody"));

                });
            }

            // 全选，全不选
            function checkAll_fun() {
                $("#checkAll").click(function() {
                    var isChecked = $(this).prop("checked")
                    $(".check_item").prop("checked",isChecked);

                });
            }

            function checkItem_fun() {
                $(document).on("click",".check_item",function() {
                    var checkItemNums = $(".check_item").length;
                    var checkNums = $(".check_item:checked").length;
                    var flag = checkItemNums === checkNums;
                    $("#checkAll").prop("checked", flag);
                });
            }


            // 构建分页信息
            function build_page_info(result) {
                $("#page_info_area").empty();

                // 当前 页，总 页，共 条记录
                var curNum = result.items.pageInfo.pageNum;
                var totalPages = result.items.pageInfo.pages;
                var totalRecord = result.items.pageInfo.total;
                totalRecords = totalRecord;
                currentPageNo = curNum;
                $("#page_info_area").append("当前第" + curNum + "页,").append("共" + totalPages + "页,").append("共" + totalRecord + "条记录");
            }

            // 构建分页条
            function build_page_nav(result) {
                $("#page_nav_area").empty();

                var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
                var prevPageLi = $("<li></li>").append($("<a></a>").append($("<span></span>").append("&laquo;")).attr("href", "#"));

                if (!result.items.pageInfo.hasPreviousPage) {
                    firstPageLi.addClass("disabled");
                    prevPageLi.addClass("disabled")
                } else {
                    firstPageLi.click(function() {
                        to_page(1);
                    });

                    prevPageLi.click(function() {
                        to_page(result.items.pageInfo.pageNum - 1);
                    });
                }



                var nextPageLi = $("<li></li>").append($("<a></a>").append($("<span></span>").append("&raquo;")).attr("href", "#"));
                var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));

                if (!result.items.pageInfo.hasNextPage) {
                    nextPageLi.addClass("disabled");
                    lastPageLi.addClass("disabled");
                } else {
                    nextPageLi.click(function() {
                        to_page(result.items.pageInfo.pageNum + 1);
                    });

                    lastPageLi.click(function() {
                        to_page(result.items.pageInfo.pages);
                    });
                }



                var ul = $("<ul><ul>").addClass("pagination").append(firstPageLi)
                    .append(prevPageLi);

                $.each(result.items.pageInfo.navigatepageNums, function(index, num) {
                    var numLi = $("<li></li>").append($("<a></a>").append(num).attr("href", "#"));
                    if (result.items.pageInfo.pageNum === num) {
                        numLi = $("<li></li>").addClass("active").append($("<a></a>").append(num).attr("href", "#"));
                    }

                    numLi.click(function() {
                        to_page(num);
                    });
                    ul.append(numLi);
                });

                ul.append(nextPageLi).append(lastPageLi);

                var navEle = $("<nav></nav>").append(ul);

                $("#page_nav_area").append(navEle);
            }



            // 查询员工信息
            function getEmp(empId) {

                $.ajax({
                    url:"${APP_PATH}/emp/" + empId,
                    type:"get",
                    success: function(response) {
                        $("#empName_update_static").text(response.items.emp.empName);
                        $("#email_update_input").val(response.items.emp.email)
                        // if (response.items.emp.gender === 'M') {
                        //     $("#empUpdateModal input[name=gender]:eq(0)").prop("checked","true");
                        // } else {
                        //     $("#empUpdateModal input[name=gender]:eq(1)").prop("checked","true");
                        // }

                        $("#empUpdateModal input[name=gender]").val([response.items.emp.gender])
                        $("#empUpdateModal select").val([response.items.emp.did])
                    },
                    dataType:"json"
                });
            }


            // 点击更新按钮，更新员工信息
            function updateEmp() {
                $("#emp_update_btn").click(function() {
                    // 验证邮箱是否合法
                    var email = $("#email_update_input").val();
                    var regEmail = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
                    if (!regEmail.test(email)) {
                        show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
                        return false;
                    } else {
                        show_validate_msg("#email_update_input", "success", "");
                    }

                    $.ajax({
                        url:"${APP_PATH}/emp/" + $(this).attr("edit-id"),
                        type: "POST",
                        data: $("#empUpdateModal form").serialize() + "&_method=PUT",
                        success: function (response) {
                            // 关闭模态框
                            $("#empUpdateModal").modal('hide');
                            to_page(currentPageNo);
                        }

                    });

                });
            }


    </script>
</head>
<body>

<!-- 员工修改模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">

                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email_update_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input name="email" type="email" class="form-control" id="email_update_input" placeholder="email@lovesosa.com">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender"  value="F"> 女
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="dept_add_input" class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                            <select id="dept_update_input" name="dId" class="form-control"></select>
                        </div>

                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="emp_update_btn" type="button" class="btn btn-primary">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 员工添加模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">

                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <input name="empName" type="text" class="form-control" id="empName_add_input" placeholder="请输入姓名">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input name="email" type="email" class="form-control" id="email_add_input" placeholder="email@lovesosa.com">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="dept_add_input" class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                            <select id="dept_add_input" name="dId" class="form-control"></select>
                        </div>

                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="emp_save_btn" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>


<div class="container">
    <!-- 标题 -->
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <!-- 按钮 -->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button id="emp_add_modal_btn" class="btn btn-primary">新增</button>
            <button class="btn btn-danger" id="del_all_btn">删除</button>
        </div>
    </div>
    <!-- 表格数据 -->
    <div class="row">
        <div class="col-md-12">


            <table class="table table-hover">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="checkAll">
                    </th>
                    <th>#</th>
                    <th>员工姓名</th>
                    <th>性别</th>
                    <th>邮箱</th>
                    <th>部门</th>
                    <th>操作</th>
                </tr>
                </thead>

                <!-- 员工展示列表 -->
                <tbody></tbody>

            </table>
        </div>
    </div>


    <!-- 分页数据 -->
    <div class="row">
        <!-- 分页信息 -->
        <div class="col-md-6" id="page_info_area"></div>

        <!-- 分页条 -->
        <div class="col-md-6" id="page_nav_area"></div>
    </div>
</div>

</body>
</html>
