package implementor;

import java.sql.*;
import java.util.*;

import db_config.GetConnection;
import models.CargoPojo;
import operations.CargoOperations;

public class CargoImplementor implements CargoOperations {

    @Override
    public void addCargo(CargoPojo c, String role) {
        try(Connection con = GetConnection.getConnection()){
            CallableStatement cs = con.prepareCall("{call add_cargo(?,?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, c.getContainerId());
            cs.setString(3, c.getDescription());
            cs.setDouble(4, c.getWeight());
            cs.execute();
        } catch(Exception e){ e.printStackTrace(); }
    }

    @Override
    public void updateCargo(CargoPojo c, String role) {
        try(Connection con = GetConnection.getConnection()){
            CallableStatement cs = con.prepareCall("{call edit_cargo_details(?,?,?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, c.getCargoId());
            cs.setInt(3, c.getContainerId());
            cs.setDouble(4, c.getWeight());
            cs.setString(5, c.getDescription());
            cs.execute();
        } catch(Exception e){ e.printStackTrace(); }
    }

    @Override
    public void deleteCargo(int id, String role) {
        try(Connection con = GetConnection.getConnection()){
            CallableStatement cs = con.prepareCall("{call delete_cargo(?,?)}");
            cs.setString(1, role);
            cs.setInt(2, id);
            cs.execute();
        } catch(Exception e){ e.printStackTrace(); }
    }

    @Override
    public void setStatus(int id, String status, String role, int userId) {
        try(Connection con = GetConnection.getConnection()){
            CallableStatement cs = con.prepareCall("{call set_cargo_status(?,?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, id);
            cs.setString(3, status);
            cs.setInt(4, userId);
            cs.execute();
        } catch(Exception e){ e.printStackTrace(); }
    }

    @Override
    public List<CargoPojo> showCargo(String role) {

        List<CargoPojo> list = new ArrayList<>();

        String sql = "SELECT c.cargo_id, c.container_id, c.description, c.weight, c.status, " +
                     "ct.container_type, s.ship_name, d.dock_name " +
                     "FROM cargo c " +
                     "LEFT JOIN container ct ON c.container_id = ct.container_id " +
                     "LEFT JOIN ship s ON ct.ship_id = s.ship_id " +
                     "LEFT JOIN dock_allocation da ON s.ship_id = da.ship_id " +
                     "LEFT JOIN dock d ON da.dock_id = d.dock_id " + 
                     "GROUP BY c.cargo_id " +
                     "ORDER BY c.cargo_id DESC";

        try(Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()){

            while(rs.next()){
                CargoPojo c = new CargoPojo();

                c.setCargoId(rs.getInt("cargo_id"));
                c.setContainerId(rs.getInt("container_id"));
                c.setDescription(rs.getString("description"));
                c.setWeight(rs.getDouble("weight"));
                c.setStatus(rs.getString("status"));
                c.setContainerType(rs.getString("container_type"));
                c.setShipName(rs.getString("ship_name"));
                c.setDockName(rs.getString("dock_name"));

                list.add(c);
            }

        } catch(Exception e){ e.printStackTrace(); }

        return list;
    }

    @Override
    public List<CargoPojo> searchCargo(String role, String keyword) {

        List<CargoPojo> list = new ArrayList<>();

        String sql = "SELECT c.cargo_id, c.container_id, c.description, c.weight, c.status, " +
                     "ct.container_type, s.ship_name " +
                     "FROM cargo c " +
                     "LEFT JOIN container ct ON c.container_id = ct.container_id " +
                     "LEFT JOIN ship s ON ct.ship_id = s.ship_id " +
                     "WHERE c.description LIKE ? OR c.status LIKE ? OR s.ship_name LIKE ? " +
                     "GROUP BY c.cargo_id " +
                     "ORDER BY c.cargo_id DESC";
                     

        try(Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)){

            ps.setString(1,"%"+keyword+"%");
            ps.setString(2,"%"+keyword+"%");
            ps.setString(3,"%"+keyword+"%");

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                CargoPojo c = new CargoPojo();

                c.setCargoId(rs.getInt("cargo_id"));
                c.setContainerId(rs.getInt("container_id"));
                c.setDescription(rs.getString("description"));
                c.setWeight(rs.getDouble("weight"));
                c.setStatus(rs.getString("status"));
                c.setContainerType(rs.getString("container_type"));
                c.setShipName(rs.getString("ship_name"));

                list.add(c);
            }

        } catch(Exception e){ e.printStackTrace(); }

        return list;
    }
    
    public List<CargoPojo> getCargoByContainer(int containerId){

        List<CargoPojo> list = new ArrayList<>();

        String sql = "SELECT cargo_id, c.container_id, description, weight, status " +
                     "FROM cargo WHERE container_id = ?";

        try(Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)){

            ps.setInt(1, containerId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                CargoPojo c = new CargoPojo();

                c.setCargoId(rs.getInt("cargo_id"));
                c.setContainerId(rs.getInt("container_id"));
                c.setDescription(rs.getString("description"));
                c.setWeight(rs.getDouble("weight"));
                c.setStatus(rs.getString("status"));

                list.add(c);
            }

        } catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
    
    @Override
    public List<CargoPojo> getAllCargo() {

        List<CargoPojo> list = new ArrayList<>();

        String sql = "SELECT cargo_id, description FROM cargo";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                CargoPojo c = new CargoPojo();

                c.setCargoId(rs.getInt("cargo_id"));
                c.setDescription(rs.getString("description"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}