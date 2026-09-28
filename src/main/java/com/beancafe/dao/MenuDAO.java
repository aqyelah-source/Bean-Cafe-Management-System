package com.beancafe.dao;

import com.beancafe.model.Menu;
import com.beancafe.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO implements MenuDAOInterface {

    // CREATE - Add new menu
    @Override
    public boolean addMenu(Menu menu) {

        String sql = "INSERT INTO menu "
                   + "(admin_id, menu_name, category, price, availability) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, menu.getAdminId());
            stmt.setString(2, menu.getMenuName());
            stmt.setString(3, menu.getCategory());
            stmt.setDouble(4, menu.getPrice());
            stmt.setString(5, menu.getAvailability());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // READ - Get all menu
    @Override
    public List<Menu> getAllMenu() {

        List<Menu> menuList = new ArrayList<>();

        String sql = "SELECT * FROM menu";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("menu_id"));
                menu.setAdminId(rs.getInt("admin_id"));
                menu.setMenuName(rs.getString("menu_name"));
                menu.setCategory(rs.getString("category"));
                menu.setPrice(rs.getDouble("price"));
                menu.setAvailability(rs.getString("availability"));

                menuList.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menuList;
    }


    // UPDATE - Update menu
    @Override
    public boolean updateMenu(Menu menu) {

        String sql = "UPDATE menu SET "
                   + "menu_name = ?, category = ?, price = ?, availability = ? "
                   + "WHERE menu_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, menu.getMenuName());
            stmt.setString(2, menu.getCategory());
            stmt.setDouble(3, menu.getPrice());
            stmt.setString(4, menu.getAvailability());
            stmt.setInt(5, menu.getMenuId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // DELETE - Delete menu
    @Override
    public boolean deleteMenu(int menuId) {

        String sql = "DELETE FROM menu WHERE menu_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, menuId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
