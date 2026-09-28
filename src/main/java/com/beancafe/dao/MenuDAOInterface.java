package com.beancafe.dao;

import com.beancafe.model.Menu;
import java.util.List;

public interface MenuDAOInterface {

    // create the menu
    boolean addMenu(Menu menu);

    // read the menu
    List<Menu> getAllMenu();

    // update the menu
    boolean updateMenu(Menu menu);

    // delete the menu
    boolean deleteMenu(int menuId);
}
