<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.beancafe.model.Order" %>

<%
    // Make sure user is logged in
    if (session.getAttribute("role") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Order> orderList =
            (List<Order>) request.getAttribute("orderList");

    Order searchedOrder =
            (Order) request.getAttribute("searchedOrder");

    Boolean searchPerformed =
            (Boolean) request.getAttribute("searchPerformed");

    String success =
            request.getParameter("success");

    String error =
            request.getParameter("error");

    String role =
            (String) session.getAttribute("role");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Order Management - Bean Cafe</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background-color: #f5f0eb;
            margin: 0;
        }

        header {
            background-color: #4b2e1e;
            color: white;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h2 {
            margin: 0;
        }

        header a {
            color: white;
            text-decoration: none;
            background-color: #6f4e37;
            padding: 8px 14px;
            border-radius: 4px;
        }

        .container {
            width: 90%;
            margin: 30px auto;
            background-color: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        h1 {
            color: #4b2e1e;
            margin-top: 0;
        }

        .top-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .search-form {
            display: flex;
            gap: 8px;
        }

        .search-form input {
            padding: 9px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .btn {
            display: inline-block;
            padding: 9px 14px;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-add {
            background-color: #4b2e1e;
            color: white;
        }

        .btn-search {
            background-color: #6f4e37;
            color: white;
        }

        .btn-view {
            background-color: #4b2e1e;
            color: white;
        }

        .btn-cancel {
            background-color: #b04a4a;
            color: white;
        }

        .btn-back {
            background-color: #777;
            color: white;
            margin-top: 20px;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .message-success {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .message-error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th {
            background-color: #4b2e1e;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background-color: #f8f5f2;
        }

        .status {
            font-weight: bold;
        }

        .action-buttons {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .no-orders {
            text-align: center;
            padding: 20px;
        }

        .search-title {
            color: #4b2e1e;
            margin-top: 25px;
        }

    </style>

</head>


<body>


<!-- ============================= -->
<!-- HEADER                        -->
<!-- ============================= -->

<header>

    <h2>Bean Cafe - Order Management</h2>

    <a href="${pageContext.request.contextPath}/LogoutServlet">
        Logout
    </a>

</header>


<div class="container">

    <h1>Order Management</h1>

    <p>
        Welcome,
        <strong><%= session.getAttribute("name") %></strong>
        (<%= role %>)
    </p>


    <!-- ============================= -->
    <!-- SUCCESS / ERROR MESSAGES      -->
    <!-- ============================= -->

    <% if ("created".equals(success)) { %>

        <div class="message-success">
            Order created successfully.
        </div>

    <% } %>


    <% if ("notfound".equals(error)) { %>

        <div class="message-error">
            Order could not be found.
        </div>

    <% } %>


    <!-- ============================= -->
    <!-- TOP BUTTONS + SEARCH          -->
    <!-- ============================= -->

    <div class="top-section">


        <!-- Only Staff can create order -->

        <% if ("Staff".equalsIgnoreCase(role)) { %>

            <a href="${pageContext.request.contextPath}/order?action=add"
               class="btn btn-add">

                + Create New Order

            </a>

        <% } %>


        <!-- SEARCH -->

        <form action="${pageContext.request.contextPath}/order"
              method="get"
              class="search-form">

            <input type="hidden"
                   name="action"
                   value="search">

            <input type="number"
                   name="orderId"
                   placeholder="Enter Order ID"
                   min="1"
                   required>

            <button type="submit"
                    class="btn btn-search">

                Search

            </button>

            <a href="${pageContext.request.contextPath}/order"
               class="btn btn-search">

                Show All

            </a>

        </form>

    </div>


    <!-- ============================= -->
    <!-- SEARCH RESULT                 -->
    <!-- ============================= -->

    <%
        if (Boolean.TRUE.equals(searchPerformed)) {
    %>

        <h2 class="search-title">
            Search Result
        </h2>


        <% if (searchedOrder != null) { %>

            <table>

                <thead>

                    <tr>

                        <th>Order ID</th>
                        <th>Staff ID</th>
                        <th>Order Date</th>
                        <th>Total Price (RM)</th>
                        <th>Status</th>
                        <th>Action</th>

                    </tr>

                </thead>


                <tbody>

                    <tr>

                        <td>
                            <%= searchedOrder.getOrderId() %>
                        </td>

                        <td>
                            <%= searchedOrder.getStaffId() %>
                        </td>

                        <td>
                            <%= searchedOrder.getOrderDate() %>
                        </td>

                        <td>
                            <%= String.format(
                                    "%.2f",
                                    searchedOrder.getTotalPrice()
                                )
                            %>
                        </td>

                        <td class="status">
                            <%= searchedOrder.getStatus() %>
                        </td>

                        <td>

                            <div class="action-buttons">

                                <a href="${pageContext.request.contextPath}/order?action=view&id=<%= searchedOrder.getOrderId() %>"
                                   class="btn btn-view">

                                    View

                                </a>


                                <% if (!"Cancelled".equalsIgnoreCase(
                                        searchedOrder.getStatus())) { %>

                                    <a href="${pageContext.request.contextPath}/order?action=cancel&id=<%= searchedOrder.getOrderId() %>"
                                       class="btn btn-cancel"
                                       onclick="return confirm('Are you sure you want to cancel this order?');">

                                        Cancel

                                    </a>

                                <% } %>

                            </div>

                        </td>

                    </tr>

                </tbody>

            </table>


        <% } else { %>


            <div class="message-error">
                No order found with that Order ID.
            </div>


        <% } %>


    <%
        } else {
    %>


    <!-- ============================= -->
    <!-- ALL ORDERS                    -->
    <!-- ============================= -->

        <table>

            <thead>

                <tr>

                    <th>Order ID</th>

                    <th>Staff ID</th>

                    <th>Order Date</th>

                    <th>Total Price (RM)</th>

                    <th>Status</th>

                    <th>Action</th>

                </tr>

            </thead>


            <tbody>


            <%
                if (orderList != null &&
                    !orderList.isEmpty()) {

                    for (Order order : orderList) {
            %>


                <tr>

                    <!-- ORDER ID -->

                    <td>
                        <%= order.getOrderId() %>
                    </td>


                    <!-- STAFF ID -->

                    <td>
                        <%= order.getStaffId() %>
                    </td>


                    <!-- ORDER DATE -->

                    <td>
                        <%= order.getOrderDate() %>
                    </td>


                    <!-- TOTAL PRICE -->

                    <td>

                        <%= String.format(
                                "%.2f",
                                order.getTotalPrice()
                            )
                        %>

                    </td>


                    <!-- STATUS -->

                    <td class="status">

                        <%= order.getStatus() %>

                    </td>


                    <!-- ACTION -->

                    <td>

                        <div class="action-buttons">


                            <!-- VIEW -->

                            <a href="${pageContext.request.contextPath}/order?action=view&id=<%= order.getOrderId() %>"
                               class="btn btn-view">

                                View

                            </a>


                            <!-- CANCEL -->

                            <% if (!"Cancelled".equalsIgnoreCase(
                                    order.getStatus())) { %>

                                <a href="${pageContext.request.contextPath}/order?action=cancel&id=<%= order.getOrderId() %>"
                                   class="btn btn-cancel"
                                   onclick="return confirm('Are you sure you want to cancel this order?');">

                                    Cancel

                                </a>

                            <% } %>


                        </div>

                    </td>

                </tr>


            <%
                    }

                } else {
            %>


                <tr>

                    <td colspan="6"
                        class="no-orders">

                        No orders found.

                    </td>

                </tr>


            <%
                }
            %>


            </tbody>

        </table>


    <%
        }
    %>


    <!-- ============================= -->
    <!-- BACK TO DASHBOARD             -->
    <!-- ============================= -->

    <% if ("Admin".equalsIgnoreCase(role)) { %>

        <a href="${pageContext.request.contextPath}/admin-dashboard.jsp"
           class="btn btn-back">

            Back to Dashboard

        </a>

    <% } else { %>

        <a href="${pageContext.request.contextPath}/staff-dashboard.jsp"
           class="btn btn-back">

            Back to Dashboard

        </a>

    <% } %>


</div>


</body>

</html>
