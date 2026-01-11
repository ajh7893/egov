<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전자정부 프레임워크 프로젝트</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        .menu {
            margin-top: 30px;
        }
        .menu a {
            display: block;
            padding: 15px;
            margin: 10px 0;
            background: #f5f5f5;
            color: #333;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .menu a:hover {
            background: #007bff;
            color: white;
        }
        .info {
            background: #e9ecef;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .info h3 {
            margin-top: 0;
        }
        .info ul {
            list-style: none;
            padding-left: 0;
        }
        .info li {
            padding: 5px 0;
        }
    </style>
</head>
<body>
    <h1>전자정부 프레임워크 프로젝트</h1>

    <div class="info">
        <h3>프로젝트 정보</h3>
        <ul>
            <li><strong>Spring Version:</strong> 5.3.27</li>
            <li><strong>E-Gov Version:</strong> 4.2.0</li>
            <li><strong>Java Version:</strong> 17</li>
            <li><strong>MyBatis Version:</strong> 2.1.2</li>
        </ul>
    </div>

    <div class="menu">
        <h2>메뉴</h2>
        <a href="<c:url value='/lms/chm/chargerManage.do'/>">담당자 관리</a>
        <a href="<c:url value='/lms/emp/employeeManage.do'/>">직원 관리</a>
        <a href="<c:url value='/lms/chm/chargerManageV2.do'/>">담당자 관리 (V2)</a>
        <a href="<c:url value='/lms/emp/employeeManageV2.do'/>">직원 관리 (V2)</a>
        <a href="<c:url value='/sample/w2ui-sample.html'/>">W2UI 샘플 (JS Only)</a>
    </div>

    <div class="info" style="margin-top: 40px;">
        <h3>개발 정보</h3>
        <ul>
            <li><strong>DB:</strong> Oracle (jdbc:oracle:thin:@//localhost:1521/FREEPDB1)</li>
            <li><strong>Grid:</strong> W2UI</li>
            <li><strong>Paging:</strong> Spring Data Pageable</li>
        </ul>
    </div>
</body>
</html>
