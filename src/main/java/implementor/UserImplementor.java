package implementor;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import db_config.GetConnection;
import models.UserPojo;
import operations.UserOperations;

public class UserImplementor implements UserOperations {

	@Override
	public void addUser(UserPojo userPojo) {
		// TODO Auto-generated method stub
		CallableStatement callableStatement;
		try {
			callableStatement = GetConnection.getConnection().prepareCall("{call add_user(?,?,?,?,?)}");
			callableStatement.setString(1, "Administrator");
			callableStatement.setString(2, userPojo.getName());
			callableStatement.setString(3, userPojo.getEmail());
			callableStatement.setString(4, userPojo.getPassword());
			callableStatement.setInt(5, userPojo.getRoleId());
			callableStatement.executeUpdate();
//			System.out.println("Data Inserted...");
			GetConnection.getConnection().close();		
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void updateUser(UserPojo userPojo) {
		// TODO Auto-generated method stub
		CallableStatement callableStatement;
		try {
			callableStatement = GetConnection.getConnection().prepareCall("{call edit_user_details(?,?,?,?,?,?)}");
			callableStatement.setString(1, "Administrator");
			callableStatement.setInt(2, userPojo.getUserId());
			callableStatement.setString(3, userPojo.getName());
			callableStatement.setString(4, userPojo.getEmail());
			callableStatement.setString(5, userPojo.getPassword());
			callableStatement.setInt(6, userPojo.getRoleId());
			callableStatement.executeUpdate();
//			System.out.println("Data Updated...");
			GetConnection.getConnection().close();		
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void setUserStatus(UserPojo userPojo) {
		// TODO Auto-generated method stub
		CallableStatement callableStatement;
		try {
			callableStatement = GetConnection.getConnection().prepareCall("{call set_user_status(?,?,?)}");
			callableStatement.setString(1, "Administrator");
			callableStatement.setInt(2, userPojo.getUserId());
			callableStatement.setString(3, userPojo.getStatus());
			callableStatement.executeUpdate();
//			System.out.println("Data Updated...");
			GetConnection.getConnection().close();		
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public List showUser() {
		// TODO Auto-generated method stub
		List<UserPojo> list = new ArrayList<UserPojo>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = GetConnection.getConnection();
            String sql = "SELECT u.user_id, u.name, u.email, u.role_id, u.status, r.role_name " + "FROM user u JOIN role r ON u.role_id = r.role_id ORDER BY u.user_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                UserPojo u = new UserPojo();
                u.setUserId(rs.getInt("user_id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRoleId(rs.getInt("role_id"));
                u.setRoleName(rs.getString("role_name"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
	}

	@Override
	public List<UserPojo> searchUser(String keyword) {
        List<UserPojo> list = new ArrayList<UserPojo>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = GetConnection.getConnection();
            String sql = "SELECT u.user_id, u.name, u.email, u.role_id, u.status, r.role_name " +
                         "FROM user u JOIN role r ON u.role_id = r.role_id " +
                         "WHERE CAST(u.user_id AS CHAR) LIKE ? OR u.name LIKE ? OR u.email LIKE ? OR r.role_name LIKE ? " +
                         "ORDER BY u.user_id DESC";
            ps = con.prepareStatement(sql);
            String search = "%" + keyword + "%";
            ps.setString(1, search);
            ps.setString(2, search);
            ps.setString(3, search);
            ps.setString(4, search);

            rs = ps.executeQuery();

            while (rs.next()) {
                UserPojo u = new UserPojo();
                u.setUserId(rs.getInt("user_id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRoleId(rs.getInt("role_id"));
                u.setRoleName(rs.getString("role_name"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }
	
	public List<UserPojo> getOperators() {

	    List<UserPojo> list = new ArrayList<>();

	    try (Connection con = GetConnection.getConnection()) {

	    	String sql = "SELECT user_id, name FROM user WHERE role_id IN (1, 2, 3)"; 

	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            UserPojo u = new UserPojo();
	            u.setUserId(rs.getInt("user_id"));
	            u.setName(rs.getString("name"));
	            list.add(u);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

}
