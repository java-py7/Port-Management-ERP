package operations;

import java.util.List;
import models.DockPojo;

public interface DockOperations {

    void addDock(DockPojo d, String role);
    void updateDock(DockPojo d, String role);
    void deleteDock(int dockId, String role);
    void setDockStatus(int dockId, String status, String role);

    List<DockPojo> getAllDocks(String role);
    List<DockPojo> searchDocks(String role, String keyword);
}