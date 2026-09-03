package models;

import java.util.List;
import implementor.DockImplementor;

public class DockPojo {

    private int dockId;
    private String dockName;
    private String status;
    private String search;

    public int getDockId() { return dockId; }
    public void setDockId(int dockId) { this.dockId = dockId; }

    public String getDockName() { return dockName; }
    public void setDockName(String dockName) { this.dockName = dockName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSearch() { return search; }
    public void setSearch(String search) { this.search = search; }

    // MVC2 CALLS

    public void addDock(DockPojo d, String role) {
        new DockImplementor().addDock(d, role);
    }

    public void updateDock(DockPojo d, String role) {
        new DockImplementor().updateDock(d, role);
    }

    public void deleteDock(int dockId, String role) {
        new DockImplementor().deleteDock(dockId, role);
    }

    public void setDockStatus(int dockId, String status, String role) {
        new DockImplementor().setDockStatus(dockId, status, role);
    }

    public List<DockPojo> getAllDocks(String role) {
        return new DockImplementor().getAllDocks(role);
    }

    public List<DockPojo> searchDocks(String role, String keyword) {
        return new DockImplementor().searchDocks(role, keyword);
    }
    
    public List<DockPojo> getAvailableDocks(String role) {
        return new DockImplementor().getAvailableDocks(role);
    }
}