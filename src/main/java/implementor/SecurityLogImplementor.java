package implementor;

import java.sql.*;
import java.util.*;

import db_config.GetConnection;
import models.SecurityLogPojo;
import operations.SecurityLogOperations;

public class SecurityLogImplementor implements SecurityLogOperations{

	@Override
    public List<SecurityLogPojo> getAllLogs() {

        List<SecurityLogPojo> list = new ArrayList<>();

        String sql = "SELECT sl.log_id, u.user_id, u.name AS username, r.role_name, "
                   + "sl.entry_time, sl.exit_time, "
                   + "CASE "
                   + " WHEN sl.exit_time IS NULL THEN 'Active Session' "
                   + " ELSE CONCAT(TIMESTAMPDIFF(MINUTE, sl.entry_time, sl.exit_time), ' min') "
                   + "END AS duration "
                   + "FROM security_log sl "
                   + "JOIN user u ON sl.user_id = u.user_id "
                   + "JOIN role r ON u.role_id = r.role_id "
                   + "ORDER BY sl.log_id DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {

            	SecurityLogPojo s = new SecurityLogPojo();

                s.setLogId(rs.getInt("log_id"));
                s.setUserId(rs.getInt("user_id"));
                s.setUsername(rs.getString("username"));
                s.setRoleName(rs.getString("role_name"));
                s.setEntryTime(String.valueOf(rs.getTimestamp("entry_time")));
                s.setExitTime(String.valueOf(rs.getTimestamp("exit_time")));
                s.setDuration(rs.getString("duration"));

                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<SecurityLogPojo> searchLogs(String username, String role, String fromDate, String toDate) {

        List<SecurityLogPojo> list = new ArrayList<>();

        String sql = "SELECT sl.log_id, u.user_id, u.name AS username, r.role_name, "
                   + "sl.entry_time, sl.exit_time, "
                   + "CASE "
                   + " WHEN sl.exit_time IS NULL THEN 'Active Session' "
                   + " ELSE CONCAT(TIMESTAMPDIFF(MINUTE, sl.entry_time, sl.exit_time), ' min') "
                   + "END AS duration "
                   + "FROM security_log sl "
                   + "JOIN user u ON sl.user_id = u.user_id "
                   + "JOIN role r ON u.role_id = r.role_id "
                   + "WHERE 1=1 ";

        if (username != null && !username.isEmpty()) {
            sql += " AND u.name LIKE ? ";
        }

        if (role != null && !role.isEmpty() && !"All Roles".equalsIgnoreCase(role)) {
        	sql += " AND r.role_name LIKE ? ";
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND DATE(sl.entry_time) >= ? ";
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND DATE(sl.entry_time) <= ? ";
        }

        sql += " ORDER BY sl.log_id DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            int i = 1;

            if (username != null && !username.isEmpty()) {
                pst.setString(i++, "%" + username + "%");
            }

            if (role != null && !role.isEmpty() && !"All Roles".equalsIgnoreCase(role)) {
            	pst.setString(i++, role.trim());
            }

            if (fromDate != null && !fromDate.isEmpty()) {
                pst.setString(i++, fromDate);
            }

            if (toDate != null && !toDate.isEmpty()) {
                pst.setString(i++, toDate);
            }

            ResultSet rs = pst.executeQuery();

            while (rs.next()) {

            	SecurityLogPojo s = new SecurityLogPojo();

                s.setLogId(rs.getInt("log_id"));
                s.setUserId(rs.getInt("user_id"));
                s.setUsername(rs.getString("username"));
                s.setRoleName(rs.getString("role_name"));
                s.setEntryTime(String.valueOf(rs.getTimestamp("entry_time")));
                s.setExitTime(String.valueOf(rs.getTimestamp("exit_time")));
                s.setDuration(rs.getString("duration"));

                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}