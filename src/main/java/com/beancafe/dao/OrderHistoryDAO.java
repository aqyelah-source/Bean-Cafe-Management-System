package com.beancafe.dao;

import com.beancafe.model.OrderHistory;
import com.beancafe.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OrderHistoryDAO {

    // READ - Get all order history
    public List<OrderHistory> getAllHistory() {

        List<OrderHistory> historyList
                = new ArrayList<>();

        String sql
                = "SELECT * FROM order_history "
                + "ORDER BY updated_at DESC";

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql); ResultSet rs
                = stmt.executeQuery()) {

            while (rs.next()) {

                OrderHistory history
                        = new OrderHistory();

                history.setHistoryId(
                        rs.getInt("history_id")
                );

                history.setOrderId(
                        rs.getInt("order_id")
                );

                history.setStatus(
                        rs.getString("status")
                );

                Timestamp timestamp
                        = rs.getTimestamp("updated_at");

                if (timestamp != null) {

                    history.setUpdatedAt(
                            timestamp.toLocalDateTime()
                    );
                }

                historyList.add(history);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return historyList;
    }

    // READ - Get history for a specific order
    public List<OrderHistory> getHistoryByOrderId(int orderId) {

        List<OrderHistory> historyList = new ArrayList<>();

        String sql = "SELECT * FROM order_history "
                + "WHERE order_id = ? ORDER BY updated_at";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    OrderHistory history = new OrderHistory();

                    history.setHistoryId(rs.getInt("history_id"));
                    history.setOrderId(rs.getInt("order_id"));
                    history.setStatus(rs.getString("status"));

                    Timestamp timestamp = rs.getTimestamp("updated_at");

                    if (timestamp != null) {
                        history.setUpdatedAt(
                                timestamp.toLocalDateTime());
                    }

                    historyList.add(history);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return historyList;
    }
}
