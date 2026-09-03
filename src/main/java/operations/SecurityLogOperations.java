package operations;

import java.util.List;
import models.SecurityLogPojo;

public interface SecurityLogOperations {

    List<SecurityLogPojo> getAllLogs();

    List<SecurityLogPojo> searchLogs(String username, String role, String fromDate, String toDate);
}