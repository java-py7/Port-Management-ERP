package implementor;

import java.sql.*;
import java.util.*;

import db_config.GetConnection;
import models.DockPojo;
import operations.DockOperations;

public class DockImplementor implements DockOperations {

    @Override
    public void addDock(DockPojo d, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call add_dock(?,?)}");
            cs.setString(1, role);
            cs.setString(2, d.getDockName());

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateDock(DockPojo d, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call edit_dock_details(?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, d.getDockId());
            cs.setString(3, d.getDockName());

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteDock(int dockId, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call delete_dock(?,?)}");
            cs.setString(1, role);
            cs.setInt(2, dockId);

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setDockStatus(int dockId, String status, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call set_dock_status(?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, dockId);
            cs.setString(3, status);

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<DockPojo> getAllDocks(String role) {

        List<DockPojo> list = new ArrayList<>();

        String sql = "SELECT * FROM dock " +
        			 "ORDER BY dock_id DESC";


        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                DockPojo d = new DockPojo();

                d.setDockId(rs.getInt("dock_id"));
                d.setDockName(rs.getString("dock_name"));
                d.setStatus(rs.getString("status"));

                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<DockPojo> searchDocks(String role, String keyword) {

        List<DockPojo> list = new ArrayList<>();

        String sql = "SELECT * FROM dock WHERE dock_name LIKE ? OR status LIKE ? " +
        			 "ORDER BY dock_id DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                DockPojo d = new DockPojo();

                d.setDockId(rs.getInt("dock_id"));
                d.setDockName(rs.getString("dock_name"));
                d.setStatus(rs.getString("status"));

                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<DockPojo> getAvailableDocks(String role) {

        List<DockPojo> list = new ArrayList<>();

        String sql = "SELECT dock_id, dock_name FROM dock WHERE status = 'Available' " +
        			 "ORDER BY dock_id DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DockPojo d = new DockPojo();
                d.setDockId(rs.getInt("dock_id"));
                d.setDockName(rs.getString("dock_name"));
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}