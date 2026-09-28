<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null ||
        !"Admin".equalsIgnoreCase((String) session.getAttribute("role"))) {

        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">
    <title>Admin Dashboard - Bean Cafe</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background: #f5f0eb;
            margin: 0;
        }

        header {
            background: #4b2e1e;
            color: #fff;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header a {
            color: #fff;
            text-decoration: none;
            background: #6f4e37;
            padding: 8px 14px;
            border-radius: 4px;
        }

        .content {
            padding: 24px;
        }

        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-top: 20px;
        }

        .card {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            text-align: center;
        }

        .card-link {
            text-decoration: none;
            color: #4b2e1e;
            font-weight: bold;
        }

        .card:hover {
            background: #f1e5dc;
            cursor: pointer;
            transform: translateY(-2px);
            transition: 0.2s;
        }

    </style>

</head>

<body>

<header>

    <h2>
        Welcome,
        <%= session.getAttribute("name") %>
        (Admin)
    </h2>

    <a href="${pageContext.request.contextPath}/LogoutServlet">
        Logout
    </a>

</header>


<div class="content">

    <h2>Admin Dashboard</h2>

    <p>Select a function below.</p>


    <div class="card-grid">


        <!-- Staff Management -->

        <div class="card">
            Staff Management
        </div>


        <!-- Menu Management -->

        <a class="card-link"
           href="${pageContext.request.contextPath}/menu">

            <div class="card">
                Menu Management
            </div>

        </a>


        <!-- Order Management -->

        <div class="card">
            Order Management
        </div>


        <!-- Search -->

        <div class="card">
            Search
        </div>


        <!-- Order Summary -->

        <div class="card">
            Order Summary
        </div>


        <!-- Generate Report -->

        <div class="card">
            Generate Report
        </div>


    </div>

</div>

</body>

</html>
