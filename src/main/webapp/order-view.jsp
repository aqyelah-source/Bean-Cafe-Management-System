<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.beancafe.model.Order" %>
<%@ page import="com.beancafe.model.OrderItem" %>

<%
    // Make sure user is logged in
    if (session.getAttribute("role") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get order sent by OrderServlet
    Order order = (Order) request.getAttribute("order");

    // If no order was found
    if (order == null) {
        response.sendRedirect(
                request.getContextPath() + "/order"
        );
        return;
    }

    String role = (String) session.getAttribute("role");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Order Details - Bean Cafe</title>

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
            width: 85%;
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

        h2 {
            color: #4b2e1e;
        }

        .order-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-top: 20px;
            margin-bottom: 30px;
        }

        .info-box {
            background-color: #f8f5f2;
            padding: 15px;
            border-radius: 5px;
        }

        .info-label {
            font-weight: bold;
            color: #4b2e1e;
            margin-bottom: 5px;
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

        .total-box {
            margin-top: 20px;
            text-align: right;
            font-size: 20px;
            font-weight: bold;
            color: #4b2e1e;
        }

        .status-section {
            margin-top: 30px;
            padding: 20px;
            background-color: #f8f5f2;
            border-radius: 5px;
        }

        .status-section select {
            padding: 9px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-right: 8px;
        }

        .btn {
            display: inline-block;
            padding: 10px 16px;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-update {
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
        }

        .btn:hover {
            opacity: 0.9;
        }

        .buttons {
            margin-top: 25px;
            display: flex;
            gap: 10px;
        }

        .cancelled-message {
            margin-top: 20px;
            padding: 12px;
            background-color: #f8d7da;
            color: #721c24;
            border-radius: 5px;
        }

        .no-items {
            text-align: center;
            padding: 20px;
        }

    </style>

</head>


<body>


<!-- ============================== -->
<!-- HEADER                         -->
<!-- ============================== -->

<header>

    <h2>Bean Cafe - Order Details</h2>

    <a href="${pageContext.request.contextPath}/LogoutServlet">
        Logout
    </a>

</header>


<div class="container">


    <h1>
        Order #<%= order.getOrderId() %>
    </h1>


    <!-- ============================== -->
    <!-- ORDER INFORMATION              -->
    <!-- ============================== -->

    <div class="order-info">


        <div class="info-box">

            <div class="info-label">
                Order ID
            </div>

            <%= order.getOrderId() %>

        </div>


        <div class="info-box">

            <div class="info-label">
                Staff ID
            </div>

            <%= order.getStaffId() %>

        </div>


        <div class="info-box">

            <div class="info-label">
                Order Date
            </div>

            <%= order.getOrderDate() %>

        </div>


        <div class="info-box">

            <div class="info-label">
                Status
            </div>

            <%= order.getStatus() %>

        </div>


    </div>


    <!-- ============================== -->
    <!-- ORDER ITEMS                    -->
    <!-- ============================== -->

    <h2>Order Items</h2>


    <table>

        <thead>

            <tr>

                <th>Order Item ID</th>

                <th>Menu ID</th>

                <th>Quantity</th>

                <th>Subtotal (RM)</th>

            </tr>

        </thead>


        <tbody>


        <%
            if (order.getItems() != null &&
                !order.getItems().isEmpty()) {

                for (OrderItem item : order.getItems()) {
        %>


            <tr>


                <!-- ORDER ITEM ID -->

                <td>
                    <%= item.getOrderItemId() %>
                </td>


                <!-- MENU ID -->

                <td>
                    <%= item.getMenuId() %>
                </td>


                <!-- QUANTITY -->

                <td>
                    <%= item.getQuantity() %>
                </td>


                <!-- SUBTOTAL -->

                <td>

                    <%= String.format(
                            "%.2f",
                            item.getSubtotal()
                        )
                    %>

                </td>


            </tr>


        <%
                }

            } else {
        %>


            <tr>

                <td colspan="4"
                    class="no-items">

                    No order items found.

                </td>

            </tr>


        <%
            }
        %>


        </tbody>

    </table>


    <!-- ============================== -->
    <!-- TOTAL PRICE                    -->
    <!-- ============================== -->

    <div class="total-box">

        Total Price:
        RM <%= String.format(
                    "%.2f",
                    order.getTotalPrice()
                )
           %>

    </div>



    <!-- ============================== -->
    <!-- UPDATE STATUS                  -->
    <!-- ============================== -->

    <% if (!"Cancelled".equalsIgnoreCase(
            order.getStatus())) { %>


        <div class="status-section">

            <h2>Update Order Status</h2>


            <form action="${pageContext.request.contextPath}/order"
                  method="post">


                <input type="hidden"
                       name="action"
                       value="updateStatus">


                <input type="hidden"
                       name="orderId"
                       value="<%= order.getOrderId() %>">


                <label for="status">
                    Status:
                </label>


                <select name="status"
                        id="status"
                        required>


                    <option value="Pending"
                        <%= "Pending".equalsIgnoreCase(
                                order.getStatus())
                                ? "selected" : "" %>>

                        Pending

                    </option>


                    <option value="Preparing"
                        <%= "Preparing".equalsIgnoreCase(
                                order.getStatus())
                                ? "selected" : "" %>>

                        Preparing

                    </option>


                    <option value="Ready"
                        <%= "Ready".equalsIgnoreCase(
                                order.getStatus())
                                ? "selected" : "" %>>

                        Ready

                    </option>


                    <option value="Completed"
                        <%= "Completed".equalsIgnoreCase(
                                order.getStatus())
                                ? "selected" : "" %>>

                        Completed

                    </option>


                </select>


                <button type="submit"
                        class="btn btn-update">

                    Update Status

                </button>


            </form>

        </div>


    <% } else { %>


        <div class="cancelled-message">

            This order has been cancelled.

        </div>


    <% } %>



    <!-- ============================== -->
    <!-- BUTTONS                        -->
    <!-- ============================== -->

    <div class="buttons">


        <!-- BACK TO ORDER LIST -->

        <a href="${pageContext.request.contextPath}/order"
           class="btn btn-back">

            Back to Orders

        </a>


        <!-- CANCEL ORDER -->

        <% if (!"Cancelled".equalsIgnoreCase(
                order.getStatus()) &&
              !"Completed".equalsIgnoreCase(
                order.getStatus())) { %>


            <form action="${pageContext.request.contextPath}/order"
                  method="post"
                  style="display:inline;"
                  onsubmit="return confirm(
                      'Are you sure you want to cancel this order?'
                  );">


                <input type="hidden"
                       name="action"
                       value="cancel">


                <input type="hidden"
                       name="id"
                       value="<%= order.getOrderId() %>">


                <button type="submit"
                        class="btn btn-cancel">

                    Cancel Order

                </button>


            </form>


        <% } %>


    </div>


</div>


</body>

</html>
