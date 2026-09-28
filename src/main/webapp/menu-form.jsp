<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.beancafe.model.Menu" %>

<%
    Menu menu = (Menu) request.getAttribute("menu");

    boolean editing = (menu != null);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <title>
        <%= editing ? "Edit Menu" : "Add Menu" %> - Bean Cafe
    </title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
        }

        .container {
            width: 500px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
        }

        h1 {
            color: #4b2e2e;
            text-align: center;
        }

        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input,
        select {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .button-area {
            margin-top: 25px;
        }

        button {
            padding: 10px 20px;
            background-color: #4b2e2e;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .cancel {
            padding: 10px 20px;
            background-color: #555;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-left: 10px;
        }
    </style>

</head>

<body>

<div class="container">

    <h1>
        <%= editing ? "Edit Menu" : "Add New Menu" %>
    </h1>

    <form method="post"
          action="${pageContext.request.contextPath}/menu">

        <%
            if (editing) {
        %>

        <input type="hidden"
               name="action"
               value="update">

        <input type="hidden"
               name="menuId"
               value="<%= menu.getMenuId() %>">

        <%
            } else {
        %>

        <input type="hidden"
               name="action"
               value="insert">

        <%
            }
        %>


        <%-- Temporary Admin ID --%>

        <%
            if (!editing) {
        %>

        <label>Admin ID</label>

        <input type="number"
               name="adminId"
               value="1"
               min="1"
               required>

        <%
            }
        %>


        <label>Menu Name</label>

        <input type="text"
               name="menuName"
               value="<%= editing ? menu.getMenuName() : "" %>"
               required>


        <label>Category</label>

        <select name="category" required>

            <option value="">-- Select Category --</option>

            <option value="Coffee"
                <%= editing &&
                    "Coffee".equals(menu.getCategory())
                    ? "selected" : "" %>>
                Coffee
            </option>

            <option value="Non-Coffee"
                <%= editing &&
                    "Non-Coffee".equals(menu.getCategory())
                    ? "selected" : "" %>>
                Non-Coffee
            </option>

            <option value="Dessert"
                <%= editing &&
                    "Dessert".equals(menu.getCategory())
                    ? "selected" : "" %>>
                Dessert
            </option>

        </select>


        <label>Price (RM)</label>

        <input type="number"
               name="price"
               step="0.01"
               min="0"
               value="<%= editing ? menu.getPrice() : "" %>"
               required>


        <label>Availability</label>

        <select name="availability" required>

            <option value="Available"
                <%= editing &&
                    "Available".equals(menu.getAvailability())
                    ? "selected" : "" %>>
                Available
            </option>

            <option value="Unavailable"
                <%= editing &&
                    "Unavailable".equals(menu.getAvailability())
                    ? "selected" : "" %>>
                Unavailable
            </option>

        </select>


        <div class="button-area">

            <button type="submit">
                <%= editing ? "Update Menu" : "Add Menu" %>
            </button>

            <a class="cancel"
               href="${pageContext.request.contextPath}/menu">
                Cancel
            </a>

        </div>

    </form>

</div>

</body>
</html>
