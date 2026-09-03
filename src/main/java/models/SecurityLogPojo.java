package models;
import java.util.List;
import implementor.SecurityLogImplementor;

public class SecurityLogPojo {

    private int logId;
    private int userId;
    private String username;
    private String roleName;
    private String entryTime;
    private String exitTime;
    private String duration;

    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    public String getEntryTime() { return entryTime; }
    public void setEntryTime(String entryTime) { this.entryTime = entryTime; }

    public String getExitTime() { return exitTime; }
    public void setExitTime(String exitTime) { this.exitTime = exitTime; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
    

    public List<SecurityLogPojo> getAllLogs() {
        return new SecurityLogImplementor().getAllLogs();
    }

    public List<SecurityLogPojo> searchLogs(String username, String role, String fromDate, String toDate) {
        return new SecurityLogImplementor().searchLogs(username, role, fromDate, toDate);
    }
}