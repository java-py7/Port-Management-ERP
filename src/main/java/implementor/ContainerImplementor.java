package implementor;

import java.sql.*;
import java.util.*;
import db_config.GetConnection;
import models.ContainerPojo;
import operations.ContainerOperations;

public class ContainerImplementor implements ContainerOperations {

    @Override
    public void addContainer(ContainerPojo c, String role) {
        try(Connection con = GetConnection.getConnection()){
            CallableStatement cs = con.prepareCall("{call add_container(?,?)}");
            cs.setString(1, role);
            cs.setString(2, c.getContainerType());
            cs.execute();
        }catch(Exception e){ e.printStackTrace(); }
    }

    @Override
    public void assignToShip(int containerId, int shipId, String role) {
        try(Connection con = GetConnection.getConnection()){
            CallableStatement cs = con.prepareCall("{call assign_container_to_ship(?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, containerId);
            cs.setInt(3, shipId);
            cs.execute();
        }catch(Exception e){ e.printStackTrace(); }
    }

    @Override
    public void updateContainer(ContainerPojo c, String role) {
        try(Connection con = GetConnection.getConnection()){
            CallableStatement cs = con.prepareCall("{call edit_container_details(?,?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, c.getContainerId());
            cs.setString(3, c.getContainerType());
            cs.setInt(4, c.getShipId());
            cs.execute();
        }catch(Exception e){ e.printStackTrace(); }
    }

    @Override
    public void deleteContainer(int id, String role) {
        try(Connection con = GetConnection.getConnection()){
            CallableStatement cs = con.prepareCall("{call delete_container(?,?)}");
            cs.setString(1, role);
            cs.setInt(2, id);
            cs.execute();
        }catch(Exception e){ e.printStackTrace(); }
    }

    @Override
    public void setStatus(int id, String status, String role) {
        try(Connection con = GetConnection.getConnection()){
            CallableStatement cs = con.prepareCall("{call set_container_status(?,?,?)}");
            cs.setString(1, role);
            cs.setInt(2, id);
            cs.setString(3, status);
            cs.execute();
        }catch(Exception e){ e.printStackTrace(); }
    }

    @Override
    public List<ContainerPojo> showContainers(String role) {

        List<ContainerPojo> list = new ArrayList<>();

        String sql = "SELECT c.container_id, c.container_type, c.status, c.ship_id, s.ship_name " +
                     "FROM container c LEFT JOIN ship s ON c.ship_id = s.ship_id " +
        			 "ORDER BY c.container_id DESC";

        try(Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()){

            while(rs.next()){
                ContainerPojo c = new ContainerPojo();

                c.setContainerId(rs.getInt("container_id"));
                c.setContainerType(rs.getString("container_type"));
                c.setStatus(rs.getString("status"));
                c.setShipId((Integer) rs.getObject("ship_id"));
                c.setShipName(rs.getString("ship_name"));

                list.add(c);
            }

        }catch(Exception e){ e.printStackTrace(); }

        return list;
    }

    @Override
    public List<ContainerPojo> searchContainers(String role, String keyword) {

        List<ContainerPojo> list = new ArrayList<>();

        String sql = "SELECT c.container_id, c.container_type, c.status, s.ship_name " +
                     "FROM container c LEFT JOIN ship s ON c.ship_id = s.ship_id " +
                     "WHERE c.container_type LIKE ? OR c.status LIKE ? OR s.ship_name LIKE ? " +
        			 "ORDER BY c.container_id DESC";

        try(Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)){

            ps.setString(1,"%"+keyword+"%");
            ps.setString(2,"%"+keyword+"%");
            ps.setString(3,"%"+keyword+"%");

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                ContainerPojo c = new ContainerPojo();

                c.setContainerId(rs.getInt("container_id"));
                c.setContainerType(rs.getString("container_type"));
                c.setStatus(rs.getString("status"));
                c.setShipName(rs.getString("ship_name"));

                list.add(c);
            }

        }catch(Exception e){ e.printStackTrace(); }

        return list;
    }
}