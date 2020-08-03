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
        $(function() {



        })
    </script>
</head>
<body>

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
                <button class="btn btn-primary">新增</button>
                <button class="btn btn-danger">删除</button>
            </div>
        </div>
        <!-- 表格数据 -->
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>员工姓名</th>
                            <th>性别</th>
                            <th>邮箱</th>
                            <th>部门</th>
                            <th>操作</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach items="${requestScope.pageInfo.list}" var="emp">
                            <tr>
                                <td>${emp.empId}</td>
                                <td>${emp.empName}</td>
                                <td>${emp.gender=='M' ? '男' : '女'}</td>
                                <td>${emp.email}</td>
                                <td>${emp.department.deptName}</td>
                                <td>
                                    <button class="btn btn-primary btn-sm">
                                        <span class="glyphicon glyphicon-pencil"> 编辑 </span>
                                    </button>
                                    <button class="btn btn-danger btn-sm">
                                        <span class="glyphicon glyphicon-trash"> 删除 </span>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- 分页信息 -->
        <div class="row">
            <div class="col-md-6">
                当前${requestScope.pageInfo.pageNum}页，总${requestScope.pageInfo.pages}页，共${requestScope.pageInfo.total}条记录
            </div>
            <div class="col-md-6">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li>
                            <a href="${APP_PATH}/emps?pageNo=1">首页</a>
                        </li>

                        <c:if test="${requestScope.pageInfo.hasPreviousPage}">
                            <li>
                                <a href="${APP_PATH}/emps?pageNo=${requestScope.pageInfo.pageNum - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach items="${requestScope.pageInfo.navigatepageNums}" var="page_num">
                            <c:if test="${page_num == pageInfo.pageNum}">
                                <li class="active"><a href="#">${page_num}</a></li>
                            </c:if>
                            <c:if test="${page_num != pageInfo.pageNum}">
                                <li><a href="${APP_PATH}/emps?pageNo=${page_num}">${page_num}</a></li>
                            </c:if>
                        </c:forEach>

                        <c:if test="${requestScope.pageInfo.hasNextPage}">
                        <li>
                            <a href="${APP_PATH}/emps?pageNo=${requestScope.pageInfo.pageNum + 1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                        </c:if>
                        <li>
                            <a href="${APP_PATH}/emps?pageNo=${requestScope.pageInfo.pages}">末页</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

</body>
</html>
