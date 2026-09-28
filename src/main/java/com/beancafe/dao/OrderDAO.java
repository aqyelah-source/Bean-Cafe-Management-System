package com.beancafe.dao;

import com.beancafe.model.Order;
import com.beancafe.model.OrderItem;
import com.beancafe.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.List;

public class OrderDAO implements OrderDAOInterface {

    // CREATE - Create new order
    public boolean addOrder(Order order) {

        String orderSql = "INSERT INTO orders "
                + "(staff_id, order_date, total_price, status) "
                + "VALUES (?, ?, ?, ?)";

        String itemSql = "INSERT INTO order_items "
                + "(order_id, menu_id, quantity, subtotal) "
                + "VALUES (?, ?, ?, ?)";

        String historySql = "INSERT INTO order_history "
                + "(order_id, status, updated_at) "
                + "VALUES (?, ?, ?)";

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int orderId;

            // 1. Insert into ORDERS
            try (PreparedStatement orderStmt = conn.prepareStatement(
                    orderSql, PreparedStatement.RETURN_GENERATED_KEYS)) {

                orderStmt.setInt(1, order.getStaffId());
                orderStmt.setTimestamp(
                        2, Timestamp.valueOf(order.getOrderDate()));
                orderStmt.setDouble(3, order.getTotalPrice());
                orderStmt.setString(4, order.getStatus());

                orderStmt.executeUpdate();

                try (ResultSet rs = orderStmt.getGeneratedKeys()) {

                    if (rs.next()) {
                        orderId = rs.getInt(1);
                        order.setOrderId(orderId);
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            // 2. Insert ORDER ITEMS
            for (OrderItem item : order.getItems()) {

                try (PreparedStatement itemStmt =
                        conn.prepareStatement(itemSql)) {

                    itemStmt.setInt(1, orderId);
                    itemStmt.setInt(2, item.getMenuId());
                    itemStmt.setInt(3, item.getQuantity());
                    itemStmt.setDouble(4, item.getSubtotal());

                    itemStmt.executeUpdate();
                }
            }

            // 3. Insert initial ORDER HISTORY
            try (PreparedStatement historyStmt =
                    conn.prepareStatement(historySql)) {

                historyStmt.setInt(1, orderId);
                historyStmt.setString(2, order.getStatus());
                historyStmt.setTimestamp(
                        3, Timestamp.valueOf(order.getOrderDate()));

                historyStmt.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            e.printStackTrace();
            return false;

        } finally {

            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    // READ - Get all orders
    public List<Order> getAllOrders() {

        List<Order> orderList = new ArrayList<>();

        String sql = "SELECT * FROM orders ORDER BY order_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {

                Order order = new Order();

                order.setOrderId(rs.getInt("order_id"));
                order.setStaffId(rs.getInt("staff_id"));

                Timestamp timestamp = rs.getTimestamp("order_date");

                if (timestamp != null) {
                    order.setOrderDate(timestamp.toLocalDateTime());
                }

                order.setTotalPrice(rs.getDouble("total_price"));
                order.setStatus(rs.getString("status"));

                orderList.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderList;
    }


    // READ - Search order by order ID
    public Order getOrderById(int orderId) {

        Order order = null;

        String orderSql = "SELECT * FROM orders WHERE order_id = ?";
        String itemSql =
            "SELECT oi.*, m.menu_name "
            + "FROM order_items oi "
            + "JOIN menu m ON oi.menu_id = m.menu_id "
            + "WHERE oi.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement orderStmt =
                     conn.prepareStatement(orderSql)) {

            orderStmt.setInt(1, orderId);

            try (ResultSet rs = orderStmt.executeQuery()) {

                if (rs.next()) {

                    order = new Order();

                    order.setOrderId(rs.getInt("order_id"));
                    order.setStaffId(rs.getInt("staff_id"));

                    Timestamp timestamp = rs.getTimestamp("order_date");

                    if (timestamp != null) {
                        order.setOrderDate(timestamp.toLocalDateTime());
                    }

                    order.setTotalPrice(rs.getDouble("total_price"));
                    order.setStatus(rs.getString("status"));
                }
            }

            // Get items belonging to the order
            if (order != null) {

                try (PreparedStatement itemStmt =
                        conn.prepareStatement(itemSql)) {

                    itemStmt.setInt(1, orderId);

                    try (ResultSet rs = itemStmt.executeQuery()) {

                        while (rs.next()) {

                            OrderItem item = new OrderItem();

                            item.setOrderItemId(
                                    rs.getInt("order_item_id"));
                            item.setOrderId(rs.getInt("order_id"));
                            item.setMenuId(rs.getInt("menu_id"));
                            item.setMenuName(rs.getString("menu_name"));
                            item.setQuantity(rs.getInt("quantity"));
                            item.setSubtotal(rs.getDouble("subtotal"));

                            order.addItem(item);
                        }
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }


    // UPDATE - Update order status
    public boolean updateOrderStatus(int orderId, String status) {

        String orderSql =
                "UPDATE orders SET status = ? WHERE order_id = ?";

        String historySql = "INSERT INTO order_history "
                + "(order_id, status, updated_at) "
                + "VALUES (?, ?, CURRENT_TIMESTAMP)";

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Update current status
            try (PreparedStatement orderStmt =
                    conn.prepareStatement(orderSql)) {

                orderStmt.setString(1, status);
                orderStmt.setInt(2, orderId);

                int affectedRows = orderStmt.executeUpdate();

                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // Save status change into history
            try (PreparedStatement historyStmt =
                    conn.prepareStatement(historySql)) {

                historyStmt.setInt(1, orderId);
                historyStmt.setString(2, status);

                historyStmt.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }

            e.printStackTrace();
            return false;

        } finally {

            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    // DELETE - Cancel order
    public boolean cancelOrder(int orderId) {

        return updateOrderStatus(orderId, "Cancelled");
    }
}
