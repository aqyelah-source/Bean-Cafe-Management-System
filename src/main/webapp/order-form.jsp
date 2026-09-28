<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.beancafe.model.Menu" %>

<%
    // Make sure user is logged in as Staff
    if (session.getAttribute("role") == null ||
        !"Staff".equalsIgnoreCase((String) session.getAttribute("role"))) {

        response.sendRedirect("login.jsp");
        return;
    }

    List<Menu> menuList =
            (List<Menu>) request.getAttribute("menuList");

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Create Order - Bean Cafe</title>

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

        .message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
            background-color: #f8d7da;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
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

        input[type="number"] {
            width: 70px;
            padding: 7px;
        }

        .available {
            font-weight: bold;
        }

        .unavailable {
            font-weight: bold;
        }

        .total-box {
            margin-top: 25px;
            text-align: right;
            font-size: 20px;
            font-weight: bold;
        }

        .buttons {
            margin-top: 25px;
            display: flex;
            gap: 10px;
        }

        .btn {
            border: none;
            padding: 11px 18px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }

        .btn-submit {
            background-color: #4b2e1e;
            color: white;
        }

        .btn-cancel {
            background-color: #777;
            color: white;
        }

        .btn:hover {
            opacity: 0.9;
        }

    </style>

</head>


<body>


<header>

    <h2>Bean Cafe - Create Order</h2>

    <a href="${pageContext.request.contextPath}/LogoutServlet">
        Logout
    </a>

</header>


<div class="container">

    <h1>Create New Order</h1>

    <p>
        Staff:
        <strong><%= session.getAttribute("name") %></strong>
    </p>


    <!-- ERROR MESSAGES -->

    <% if ("staff".equals(error)) { %>

        <div class="message">
            Staff account could not be found.
        </div>

    <% } else if ("items".equals(error)) { %>

        <div class="message">
            Invalid menu item information.
        </div>

    <% } else if ("noitem".equals(error)) { %>

        <div class="message">
            Please select at least one menu item.
        </div>

    <% } else if ("number".equals(error)) { %>

        <div class="message">
            Please enter a valid quantity.
        </div>

    <% } else if ("insert".equals(error)) { %>

        <div class="message">
            Order could not be created.
        </div>

    <% } %>


    <form action="${pageContext.request.contextPath}/order"
          method="post"
          onsubmit="return validateOrder();">


        <input type="hidden"
               name="action"
               value="insert">


        <table>

            <thead>

                <tr>

                    <th>Menu</th>

                    <th>Category</th>

                    <th>Price (RM)</th>

                    <th>Availability</th>

                    <th>Quantity</th>

                    <th>Subtotal (RM)</th>

                </tr>

            </thead>


            <tbody>

            <%
                if (menuList != null && !menuList.isEmpty()) {

                    for (Menu menu : menuList) {

                        boolean available =
                                "Available".equalsIgnoreCase(
                                        menu.getAvailability()
                                );
            %>

                <tr>

                    <!-- MENU NAME -->
                    <td>
                        <%= menu.getMenuName() %>
                    </td>


                    <!-- CATEGORY -->
                    <td>
                        <%= menu.getCategory() %>
                    </td>


                    <!-- PRICE -->
                    <td>
                        <%= String.format("%.2f", menu.getPrice()) %>
                    </td>


                    <!-- AVAILABILITY -->
                    <td>

                        <% if (available) { %>

                            <span class="available">
                                Available
                            </span>

                        <% } else { %>

                            <span class="unavailable">
                                Unavailable
                            </span>

                        <% } %>

                    </td>


                    <!-- QUANTITY -->
                    <td>

                        <input type="hidden"
                               name="menuId"
                               value="<%= menu.getMenuId() %>">


                        <input type="number"
                               name="quantity"
                               value="0"
                               min="0"
                               class="quantity"
                               data-price="<%= menu.getPrice() %>"
                               onchange="calculateTotal()"
                               oninput="calculateTotal()"
                               <%= available ? "" : "disabled" %>>

                    </td>


                    <!-- SUBTOTAL -->
                    <td>

                        <span class="subtotal">
                            0.00
                        </span>

                    </td>

                </tr>

            <%
                    }

                } else {
            %>

                <tr>

                    <td colspan="6"
                        style="text-align:center;">

                        No menu items found.

                    </td>

                </tr>

            <%
                }
            %>

            </tbody>

        </table>


        <!-- TOTAL -->

        <div class="total-box">

            Total: RM

            <span id="totalPrice">
                0.00
            </span>

        </div>


        <!-- BUTTONS -->

        <div class="buttons">

            <button type="submit"
                    class="btn btn-submit">

                Create Order

            </button>


            <a href="${pageContext.request.contextPath}/order"
               class="btn btn-cancel">

                Cancel

            </a>

        </div>


    </form>

</div>


<script>

    function calculateTotal() {

        const quantityInputs =
                document.querySelectorAll(".quantity");

        const subtotalDisplays =
                document.querySelectorAll(".subtotal");

        let total = 0;


        quantityInputs.forEach(function(input, index) {

            const price =
                    parseFloat(input.dataset.price);

            let quantity =
                    parseInt(input.value);


            if (isNaN(quantity) || quantity < 0) {
                quantity = 0;
            }


            const subtotal =
                    price * quantity;


            subtotalDisplays[index].textContent =
                    subtotal.toFixed(2);


            total += subtotal;

        });


        document.getElementById("totalPrice")
                .textContent =
                total.toFixed(2);
    }


    function validateOrder() {

        const quantityInputs =
                document.querySelectorAll(".quantity");

        let hasItem = false;


        quantityInputs.forEach(function(input) {

            if (!input.disabled) {

                const quantity =
                        parseInt(input.value);

                if (!isNaN(quantity) &&
                    quantity > 0) {

                    hasItem = true;
                }
            }
        });


        if (!hasItem) {

            alert(
                "Please select at least one menu item."
            );

            return false;
        }


        return true;
    }

</script>


</body>

</html>
