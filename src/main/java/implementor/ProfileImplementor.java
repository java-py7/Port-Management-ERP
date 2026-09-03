package implementor;

import java.sql.*;
import db_config.GetConnection;
import models.UserPojo;

public class ProfileImplementor {

    public UserPojo getUserById(int userId) {

        UserPojo user = null;

        try (Connection con = GetConnection.getConnection()) {

            String sql = "SELECT u.user_id, u.name, u.email, u.role_id, u.status, r.role_name " +
                         "FROM user u JOIN role r ON u.role_id = r.role_id " +
                         "WHERE u.user_id = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    public boolean updateProfile(UserPojo user, int roleId, String roleName) {

        try (Connection con = GetConnection.getConnection()) {

            CallableStatement cs = con.prepareCall("{call edit_user_details(?,?,?,?,?,?)}");

            cs.setString(1, roleName);
            cs.setInt(2, user.getUserId());
            cs.setString(3, user.getName());
            cs.setString(4, user.getEmail());
            cs.setString(5, user.getPassword());   // ✅ PASSWORD
            cs.setInt(6, roleId);                  // ✅ ROLE

            int rows = cs.executeUpdate();

            System.out.println("Rows updated: " + rows);

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}