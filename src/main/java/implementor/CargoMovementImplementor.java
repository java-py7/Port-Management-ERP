package implementor;

import java.sql.*;
import java.util.*;

import db_config.GetConnection;
import models.CargoMovementPojo;
import models.CargoPojo;
import operations.CargoMovementOperations;

public class CargoMovementImplementor implements CargoMovementOperations {

    @Override
    public void addMovement(CargoMovementPojo m, String role) {
        try(Connection con = GetConnection.getConnection()){
            CallableStatement cs = con.prepareCall("{call add_cargo_movement(?,?,?,?)}");

            cs.setString(1, role);
            cs.setInt(2, m.getCargoId());
            cs.setString(3, m.getMovementType());
            cs.setInt(4, Integer.parseInt(m.getHandledBy())); // userId

            cs.execute();

        } catch(Exception e){ e.printStackTrace(); }
    }

    @Override
    public void updateMovement(CargoMovementPojo m, String role) {
        try(Connection con = GetConnection.getConnection()){
            CallableStatement cs = con.prepareCall("{call update_cargo_movement_details(?,?,?,?,?)}");

            cs.setString(1, role);
            cs.setInt(2, m.getMovementId());
            cs.setInt(3, m.getCargoId());
            cs.setString(4, m.getMovementDate());
            cs.setString(5, m.getHandledBy());

            cs.execute();

        } catch(Exception e){ e.printStackTrace(); }
    }

    @Override
    public List<CargoMovementPojo> getAll(String role) {

        List<CargoMovementPojo> list = new ArrayList<>();

        String sql = "SELECT m.movement_id, m.movement_type, m.movement_date, " +
                     "u.name AS handled_by, c.description, c.status " +
                     "FROM cargo_movement m " +
                     "JOIN cargo c ON m.cargo_id = c.cargo_id " +
                     "LEFT JOIN user u ON m.handled_by = u.user_id " +
                     "ORDER BY m.movement_id DESC";

        try(Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()){

            while(rs.next()){
                CargoMovementPojo m = new CargoMovementPojo();

                m.setMovementId(rs.getInt("movement_id"));
                m.setMovementType(rs.getString("movement_type"));
                m.setMovementDate(String.valueOf(rs.getTimestamp("movement_date")));
                m.setHandledBy(rs.getString("handled_by"));
                m.setCargoDescription(rs.getString("description"));
                m.setCargoStatus(rs.getString("status"));

                list.add(m);
            }

        } catch(Exception e){ e.printStackTrace(); }

        return list;
    }

    @Override
    public List<CargoMovementPojo> search(String role, String keyword) {

        List<CargoMovementPojo> list = new ArrayList<>();

        String sql = "SELECT m.movement_id, m.movement_type, m.movement_date, " +
                     "u.name AS handled_by, c.description, c.status " +
                     "FROM cargo_movement m " +
                     "JOIN cargo c ON m.cargo_id = c.cargo_id " +
                     "LEFT JOIN user u ON m.handled_by = u.user_id " +
                     "WHERE m.movement_type LIKE ? OR c.description LIKE ? OR c.status LIKE ? OR u.name LIKE ? " +
                     "ORDER BY m.movement_id DESC";

        try(Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)){

            for(int i=1;i<=4;i++) ps.setString(i,"%"+keyword+"%");

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                CargoMovementPojo m = new CargoMovementPojo();

                m.setMovementId(rs.getInt("movement_id"));
                m.setMovementType(rs.getString("movement_type"));
                m.setMovementDate(String.valueOf(rs.getTimestamp("movement_date")));
                m.setHandledBy(rs.getString("handled_by"));
                m.setCargoDescription(rs.getString("description"));
                m.setCargoStatus(rs.getString("status"));

                list.add(m);
            }

        } catch(Exception e){ e.printStackTrace(); }

        return list;
    }

	@Override
	public List<CargoPojo> getAllCargo() {

	    List<CargoPojo> list = new ArrayList<>();

	    String sql = "SELECT c.cargo_id, c.description " +
	                 "FROM cargo c " +
	                 "ORDER BY c.cargo_id DESC";

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