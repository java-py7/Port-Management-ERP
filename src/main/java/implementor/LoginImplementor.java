package implementor;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import db_config.GetConnection;
import models.UserPojo;
import operations.LoginOperations;

public class LoginImplementor implements LoginOperations {

	@Override
	public UserPojo loginUser(UserPojo userPojo) {

	    UserPojo user = null;

	    try (Connection con = GetConnection.getConnection()) {

	        // 1) Validate via procedure (will throw if invalid)
	        CallableStatement cs = con.prepareCall("{call user_login(?,?)}");
	        cs.setString(1, userPojo.getEmail());
	        cs.setString(2, userPojo.getPassword());
	        cs.execute();
	        cs.close();

	        // 2) Fetch user data
	        String sql = "SELECT u.user_id, u.name, u.email, u.role_id, u.status, r.role_name " +
	                     "FROM user u JOIN role r ON u.role_id = r.role_id " +
	                     "WHERE u.email = ?";

	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, userPojo.getEmail());

	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            user = new UserPojo();
	            user.setUserId(rs.getInt("user_id"));
	            user.setName(rs.getString("name"));
	            user.setEmail(rs.getString("email"));
	            user.setRoleId(rs.getInt("role_id"));
	            user.setRoleName(rs.getString("role_name"));
	            user.setStatus(rs.getString("status"));
	        }

	        rs.close();
	        ps.close();

	    } catch (Exception e) {
	        // invalid login → return null
	        user = null;
	    }

	    return user;
	}

    @Override
    public String logoutUser(int userId) {

        String message = "Logout Failed";

        try {
            Connection con = GetConnection.getConnection();

            CallableStatement cs = con.prepareCall("{call user_logout(?)}");
            cs.setInt(1, userId);

            boolean hasResult = cs.execute();

            if (hasResult) {
                ResultSet rs = cs.getResultSet();
                if (rs.next()) {
                    message = rs.getString(1); // "Successfully Logged Out..."
                }
                rs.close();
            }

            cs.close();
            con.close();

        } catch (Exception e) {
            message = "Logout Error";
        }

        return message;
    }
}