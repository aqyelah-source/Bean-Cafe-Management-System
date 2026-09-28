<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.beancafe.model.Menu" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Menu Management - Bean Cafe</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 90%;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
        }

        h1 {
            color: #4b2e2e;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .btn {
            padding: 10px 16px;
            text-decoration: none;
            border-radius: 5px;
            color: white;
            display: inline-block;
        }

        .btn-add {
            background-color: #4b2e2e;
        }

        .btn-edit {
            background-color: #2f7d32;
        }

        .btn-delete {
            background-color: #c0392b;
        }

        .btn-back {
            background-color: #555;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }

        th {
            background-color: #4b2e2e;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .available {
            color: green;
            font-weight: bold;
        }

        .unavailable {
            color: red;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="container">

    <div class="top-bar">
        <h1>Menu Management</h1>

        <a class="btn btn-add"
           href="${pageContext.request.contextPath}/menu?action=add">
            + Add Menu
        </a>
    </div>

    <table>

        <thead>
        <tr>
            <th>ID</th>
            <th>Menu Name</th>
            <th>Category</th>
            <th>Price (RM)</th>
            <th>Availability</th>
            <th>Action</th>
        </tr>
        </thead>

        <tbody>

        <%
            List<Menu> menuList =
                    (List<Menu>) request.getAttribute("menuList");

            if (menuList != null && !menuList.isEmpty()) {

                for (Menu menu : menuList) {
        %>

        <tr>

            <td>
                <%= menu.getMenuId() %>
            </td>

            <td>
                <%= menu.getMenuName() %>
            </td>

            <td>
                <%= menu.getCategory() %>
            </td>

            <td>
                <%= String.format("%.2f", menu.getPrice()) %>
            </td>

            <td>
                <%
                    if ("Available".equalsIgnoreCase(
                            menu.getAvailability())) {
                %>

                <span class="available">
                    Available
                </span>

                <%
                    } else {
                %>

                <span class="unavailable">
                    Unavailable
                </span>

                <%
                    }
                %>
            </td>

            <td>

                <a class="btn btn-edit"
                   href="${pageContext.request.contextPath}/menu?action=edit&id=<%= menu.getMenuId() %>">
                    Edit
                </a>

                <a class="btn btn-delete"
                   href="${pageContext.request.contextPath}/menu?action=delete&id=<%= menu.getMenuId() %>"
                   onclick="return confirm('Are you sure you want to delete this menu item?');">
                    Delete
                </a>

            </td>

        </tr>

        <%
                }

            } else {
        %>

        <tr>
            <td colspan="6">
                No menu items found.
            </td>
        </tr>

        <%
            }
        %>

        </tbody>

    </table>

    <br>

    <a class="btn btn-back"
       href="${pageContext.request.contextPath}/admin-dashboard.jsp">
        Back to Dashboard
    </a>

</div>

</body>
</html>
