package implementor;

import java.sql.*;
import java.util.*;

import db_config.GetConnection;
import models.DockAllocationPojo;
import models.ShipPojo;
import operations.DockAllocationOperations;

public class DockAllocationImplementor implements DockAllocationOperations {

    @Override
    public void addAllocation(DockAllocationPojo a, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call add_dock_allocation(?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, a.getShipId());
            cs.setInt(3, a.getDockId());

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void releaseAllocation(int allocationId, int dockId, int shipId, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call update_dock_allocation_release_time(?,?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, allocationId);
            cs.setInt(3, dockId);
            cs.setInt(4, shipId);

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateAllocation(DockAllocationPojo a, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call update_dock_allocation_details(?,?,?,?,?)}");

            cs.setString(1, role);
            cs.setInt(2, a.getAllocationId());
            cs.setInt(3, a.getShipId());
            cs.setInt(4, a.getDockId());
            cs.setString(5, a.getAllocationTime());

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteAllocation(int allocationId, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call delete_dock_allocation(?,?)}");
            cs.setString(1, role);
            cs.setInt(2, allocationId);

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<DockAllocationPojo> getAllAllocations(String role) {

        List<DockAllocationPojo> list = new ArrayList<>();

        String sql = "SELECT da.allocation_id, s.ship_name, s.status AS ship_status, " +
                     "d.dock_name, d.status AS dock_status, " +
                     "da.allocation_time, da.release_time " +
                     "FROM dock_allocation da " +
                     "JOIN ship s ON da.ship_id = s.ship_id " +
                     "JOIN dock d ON da.dock_id = d.dock_id " +
                     "ORDER BY da.allocation_id DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                DockAllocationPojo a = new DockAllocationPojo();

                a.setAllocationId(rs.getInt("allocation_id"));
                a.setShipName(rs.getString("ship_name"));
                a.setShipStatus(rs.getString("ship_status"));
                a.setDockName(rs.getString("dock_name"));
                a.setDockStatus(rs.getString("dock_status"));
                a.setAllocationTime(String.valueOf(rs.getTimestamp("allocation_time")));
                a.setReleaseTime(String.valueOf(rs.getTimestamp("release_time")));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<DockAllocationPojo> searchAllocations(String role, String keyword) {

        List<DockAllocationPojo> list = new ArrayList<>();

        String sql = "SELECT da.allocation_id, s.ship_name, d.dock_name, " +
                     "da.allocation_time, da.release_time " +
                     "FROM dock_allocation da " +
                     "JOIN ship s ON da.ship_id = s.ship_id " +
                     "JOIN dock d ON da.dock_id = d.dock_id " +
                     "WHERE s.ship_name LIKE ? OR d.dock_name LIKE ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                DockAllocationPojo a = new DockAllocationPojo();

                a.setAllocationId(rs.getInt("allocation_id"));
                a.setShipName(rs.getString("ship_name"));
                a.setDockName(rs.getString("dock_name"));
                a.setAllocationTime(String.valueOf(rs.getTimestamp("allocation_time")));
                a.setReleaseTime(String.valueOf(rs.getTimestamp("release_time")));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<ShipPojo> getShipsForAllocation() {

        List<ShipPojo> list = new ArrayList<>();

        String sql = "SELECT ship_id, ship_name, status FROM ship WHERE status IN ('Anchored','Arrived')";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ShipPojo s = new ShipPojo();
                s.setShipId(rs.getInt("ship_id"));
                s.setShipName(rs.getString("ship_name"));
                s.setStatus(rs.getString("status"));
                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<DockAllocationPojo> getActiveAllocations(String role){

        List<DockAllocationPojo> list = new ArrayList<>();

        String sql = "SELECT da.allocation_id, da.ship_id, da.dock_id, " +
                     "s.ship_name, s.status AS ship_status, " +
                     "d.dock_name, d.status AS dock_status, " +
                     "da.allocation_time, da.release_time " +
                     "FROM dock_allocation da " +
                     "JOIN ship s ON da.ship_id = s.ship_id " +
                     "JOIN dock d ON da.dock_id = d.dock_id " +
                     "WHERE da.release_time IS NULL " +
                     "ORDER BY da.allocation_id DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                DockAllocationPojo a = new DockAllocationPojo();

                a.setAllocationId(rs.getInt("allocation_id"));
                a.setShipId(rs.getInt("ship_id"));
                a.setShipName(rs.getString("ship_name"));
                a.setShipStatus(rs.getString("ship_status"));

                a.setDockId(rs.getInt("dock_id"));
                a.setDockName(rs.getString("dock_name"));
                a.setDockStatus(rs.getString("dock_status"));

                a.setAllocationTime(String.valueOf(rs.getTimestamp("allocation_time")));
                a.setReleaseTime(String.valueOf(rs.getTimestamp("release_time")));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<DockAllocationPojo> getReleasedAllocations(String role){

        List<DockAllocationPojo> list = new ArrayList<>();

        String sql = "SELECT da.allocation_id, da.ship_id, da.dock_id, " +
                     "s.ship_name, s.status AS ship_status, " +
                     "d.dock_name, d.status AS dock_status, " +
                     "da.allocation_time, da.release_time " +
                     "FROM dock_allocation da " +
                     "JOIN ship s ON da.ship_id = s.ship_id " +
                     "JOIN dock d ON da.dock_id = d.dock_id " +
                     "WHERE da.release_time IS NOT NULL " +
                     "ORDER BY da.allocation_id DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                DockAllocationPojo a = new DockAllocationPojo();

                a.setAllocationId(rs.getInt("allocation_id"));
                a.setShipId(rs.getInt("ship_id"));
                a.setShipName(rs.getString("ship_name"));
                a.setShipStatus(rs.getString("ship_status"));

                a.setDockId(rs.getInt("dock_id"));
                a.setDockName(rs.getString("dock_name"));
                a.setDockStatus(rs.getString("dock_status"));

                a.setAllocationTime(String.valueOf(rs.getTimestamp("allocation_time")));
                a.setReleaseTime(String.valueOf(rs.getTimestamp("release_time")));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<DockAllocationPojo> searchActiveAllocations(String role, String keyword){

        List<DockAllocationPojo> list = new ArrayList<>();

        String sql = "SELECT da.*, s.ship_name, d.dock_name " +
                     "FROM dock_allocation da " +
                     "JOIN ship s ON da.ship_id = s.ship_id " +
                     "JOIN dock d ON da.dock_id = d.dock_id " +
                     "WHERE da.release_time IS NULL AND (s.ship_name LIKE ? OR d.dock_name LIKE ?)";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DockAllocationPojo a = new DockAllocationPojo();

                a.setAllocationId(rs.getInt("allocation_id"));
                a.setShipId(rs.getInt("ship_id"));
                a.setShipName(rs.getString("ship_name"));
                a.setDockId(rs.getInt("dock_id"));
                a.setDockName(rs.getString("dock_name"));

                a.setAllocationTime(String.valueOf(rs.getTimestamp("allocation_time")));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<DockAllocationPojo> searchReleasedAllocations(String role, String keyword){

        List<DockAllocationPojo> list = new ArrayList<>();

        String sql = "SELECT da.*, s.ship_name, d.dock_name " +
                     "FROM dock_allocation da " +
                     "JOIN ship s ON da.ship_id = s.ship_id " +
                     "JOIN dock d ON da.dock_id = d.dock_id " +
                     "WHERE da.release_time IS NOT NULL AND (s.ship_name LIKE ? OR d.dock_name LIKE ?)";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DockAllocationPojo a = new DockAllocationPojo();

                a.setAllocationId(rs.getInt("allocation_id"));
                a.setShipId(rs.getInt("ship_id"));
                a.setShipName(rs.getString("ship_name"));
                a.setDockId(rs.getInt("dock_id"));
                a.setDockName(rs.getString("dock_name"));

                a.setReleaseTime(String.valueOf(rs.getTimestamp("release_time")));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public void updateReleaseTime(int allocationId, String releaseTime, String role){

        try(Connection con = GetConnection.getConnection()){

            CallableStatement cs = con.prepareCall("{call update_allocated_release_time(?,?,?)}");

            cs.setString(1, role);
            cs.setInt(2, allocationId);
            cs.setString(3, releaseTime);

            cs.execute();

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}