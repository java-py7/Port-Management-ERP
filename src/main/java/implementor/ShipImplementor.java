package implementor;

import java.sql.*;
import java.util.*;

import db_config.GetConnection;
import models.ShipPojo;
import operations.ShipOperations;

public class ShipImplementor implements ShipOperations {

    @Override
    public void addShip(ShipPojo s, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call register_ship(?,?,?,?,?)}");
            cs.setString(1, role);
            cs.setString(2, s.getShipName());
            cs.setString(3, s.getArrivalDate());
            cs.setString(4, s.getDepartureDate());
            cs.setInt(5, s.getOperatorId());

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateShip(ShipPojo s, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call edit_ship_details(?,?,?,?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, s.getShipId());
            cs.setString(3, s.getShipName());
            cs.setString(4, s.getArrivalDate());
            cs.setString(5, s.getDepartureDate());
            cs.setInt(6, s.getOperatorId());

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteShip(int shipId, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call delete_ship(?,?)}");
            cs.setString(1, role);
            cs.setInt(2, shipId);

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setShipStatus(int shipId, String status, String role) {
        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call set_ship_status(?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, shipId);
            cs.setString(3, status);

            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<ShipPojo> getAllShips(String role) {

        List<ShipPojo> list = new ArrayList<>();

        String sql = "SELECT s.*, u.name AS operator_name, r.role_name " +
                     "FROM ship s " +
                     "LEFT JOIN user u ON s.operator_id = u.user_id " +
                     "LEFT JOIN role r ON u.role_id = r.role_id " + 
                     "ORDER BY s.ship_id DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                ShipPojo s = new ShipPojo();

                s.setShipId(rs.getInt("ship_id"));
                s.setShipName(rs.getString("ship_name"));
                s.setArrivalDate(String.valueOf(rs.getTimestamp("arrival_date")));
                s.setDepartureDate(String.valueOf(rs.getTimestamp("departure_date")));
                s.setStatus(rs.getString("status"));
                s.setOperatorId(rs.getInt("operator_id"));
                s.setOperatorName(rs.getString("operator_name"));
                s.setRoleName(rs.getString("role_name"));

                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<ShipPojo> searchShips(String role, String keyword) {

        List<ShipPojo> list = new ArrayList<>();

        String sql = "SELECT s.*, u.name AS operator_name, r.role_name " +
                     "FROM ship s " +
                     "LEFT JOIN user u ON s.operator_id = u.user_id " +
                     "LEFT JOIN role r ON u.role_id = r.role_id " +
                     "WHERE s.ship_name LIKE ? " +
                     "ORDER BY s.ship_id DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                ShipPojo s = new ShipPojo();

                s.setShipId(rs.getInt("ship_id"));
                s.setShipName(rs.getString("ship_name"));
                s.setArrivalDate(String.valueOf(rs.getTimestamp("arrival_date")));
                s.setDepartureDate(String.valueOf(rs.getTimestamp("departure_date")));
                s.setStatus(rs.getString("status"));
                s.setOperatorId(rs.getInt("operator_id"));
                s.setOperatorName(rs.getString("operator_name"));
                s.setRoleName(rs.getString("role_name"));

                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<ShipPojo> getShipsForAllocation() {

        List<ShipPojo> list = new ArrayList<>();

        String sql = "SELECT ship_id, ship_name FROM ship WHERE status IN ('Anchored','Arrived')";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ShipPojo s = new ShipPojo();
                s.setShipId(rs.getInt("ship_id"));
                s.setShipName(rs.getString("ship_name"));
                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<ShipPojo> getDockedShips(){

        List<ShipPojo> list = new ArrayList<>();

        String sql = "SELECT ship_id, ship_name FROM ship WHERE status = 'Docked'";

        try(Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()){

            while(rs.next()){
                ShipPojo s = new ShipPojo();
                s.setShipId(rs.getInt("ship_id"));
                s.setShipName(rs.getString("ship_name"));
                list.add(s);
            }

        } catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
    
    
}