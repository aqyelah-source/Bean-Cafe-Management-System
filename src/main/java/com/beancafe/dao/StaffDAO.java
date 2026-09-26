package com.beancafe.dao;

import com.beancafe.model.Staff;
import com.beancafe.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO {

    // Get all staff
    public List<Staff> getAllStaff() {

        List<Staff> staffList = new ArrayList<>();

        String sql = "SELECT s.staff_id, s.admin_id, s.position, s.shift, "
                   + "u.user_id, u.name, u.username, u.password, u.role "
                   + "FROM staff s "
                   + "JOIN user u ON s.user_id = u.user_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {

                Staff staff = new Staff();

                staff.setStaffId(rs.getInt("staff_id"));
                staff.setAdminId(rs.getInt("admin_id"));
                staff.setUserId(rs.getInt("user_id"));
                staff.setName(rs.getString("name"));
                staff.setUsername(rs.getString("username"));
                staff.setPassword(rs.getString("password"));
                staff.setRole(rs.getString("role"));
                staff.setPosition(rs.getString("position"));
                staff.setShift(rs.getString("shift"));

                staffList.add(staff);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return staffList;
    }

    // Add new staff
    public boolean addStaff(Staff staff) {

        String userSql = "INSERT INTO user "
                + "(name, username, password, role) "
                + "VALUES (?, ?, ?, ?)";

        String staffSql = "INSERT INTO staff "
                + "(user_id, admin_id, position, shift) "
                + "VALUES (?, ?, ?, ?)";

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int userId;

            try (PreparedStatement userStmt = conn.prepareStatement(
                    userSql, PreparedStatement.RETURN_GENERATED_KEYS)) {

                userStmt.setString(1, staff.getName());
                userStmt.setString(2, staff.getUsername());
                userStmt.setString(3, staff.getPassword());
                userStmt.setString(4, staff.getRole());

                userStmt.executeUpdate();

                try (ResultSet rs = userStmt.getGeneratedKeys()) {

                    if (rs.next()) {
                        userId = rs.getInt(1);
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement staffStmt =
                    conn.prepareStatement(staffSql)) {

                staffStmt.setInt(1, userId);
                staffStmt.setInt(2, staff.getAdminId());
                staffStmt.setString(3, staff.getPosition());
                staffStmt.setString(4, staff.getShift());

                staffStmt.executeUpdate();
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

    // Update staff
    public boolean updateStaff(Staff staff) {

        String userSql = "UPDATE user SET name = ?, username = ? "
                       + "WHERE user_id = ?";

        String staffSql = "UPDATE staff SET position = ?, shift = ? "
                        + "WHERE staff_id = ?";

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement userStmt =
                    conn.prepareStatement(userSql)) {

                userStmt.setString(1, staff.getName());
                userStmt.setString(2, staff.getUsername());
                userStmt.setInt(3, staff.getUserId());

                userStmt.executeUpdate();
            }

            try (PreparedStatement staffStmt =
                    conn.prepareStatement(staffSql)) {

                staffStmt.setString(1, staff.getPosition());
                staffStmt.setString(2, staff.getShift());
                staffStmt.setInt(3, staff.getStaffId());

                staffStmt.executeUpdate();
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
    
    // Delete staff
public boolean deleteStaff(int staffId, int userId) {

    String staffSql = "DELETE FROM staff WHERE staff_id = ?";
    String userSql = "DELETE FROM user WHERE user_id = ?";

    Connection conn = null;

    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false);

        // Delete from STAFF table first
        try (PreparedStatement staffStmt =
                conn.prepareStatement(staffSql)) {

            staffStmt.setInt(1, staffId);
            staffStmt.executeUpdate();
        }

        // Delete from USER table
        try (PreparedStatement userStmt =
                conn.prepareStatement(userSql)) {

                userStmt.setInt(1, userId);
                userStmt.executeUpdate();
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
}