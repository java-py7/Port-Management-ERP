package models;

import java.util.List;
import implementor.DockAllocationImplementor;

public class DockAllocationPojo {

    private int allocationId;

    private int shipId;
    private String shipName;
    private String shipStatus;

    private int dockId;
    private String dockName;
    private String dockStatus;

    private String allocationTime;
    private String releaseTime;

    // GETTERS / SETTERS

    public int getAllocationId() { return allocationId; }
    public void setAllocationId(int allocationId) { this.allocationId = allocationId; }

    public int getShipId() { return shipId; }
    public void setShipId(int shipId) { this.shipId = shipId; }

    public String getShipName() { return shipName; }
    public void setShipName(String shipName) { this.shipName = shipName; }

    public String getShipStatus() { return shipStatus; }
    public void setShipStatus(String shipStatus) { this.shipStatus = shipStatus; }

    public int getDockId() { return dockId; }
    public void setDockId(int dockId) { this.dockId = dockId; }

    public String getDockName() { return dockName; }
    public void setDockName(String dockName) { this.dockName = dockName; }

    public String getDockStatus() { return dockStatus; }
    public void setDockStatus(String dockStatus) { this.dockStatus = dockStatus; }

    public String getAllocationTime() { return allocationTime; }
    public void setAllocationTime(String allocationTime) { this.allocationTime = allocationTime; }

    public String getReleaseTime() { return releaseTime; }
    public void setReleaseTime(String releaseTime) { this.releaseTime = releaseTime; }

    // MVC2 CALLS

    public void addAllocation(DockAllocationPojo a, String role) {
        new DockAllocationImplementor().addAllocation(a, role);
    }

    public void releaseAllocation(int allocationId, int dockId, int shipId, String role) {
        new DockAllocationImplementor().releaseAllocation(allocationId, dockId, shipId, role);
    }

    public void updateAllocation(DockAllocationPojo a, String role) {
        new DockAllocationImplementor().updateAllocation(a, role);
    }

    public void deleteAllocation(int allocationId, String role) {
        new DockAllocationImplementor().deleteAllocation(allocationId, role);
    }

    public List<DockAllocationPojo> getAllAllocations(String role) {
        return new DockAllocationImplementor().getAllAllocations(role);
    }

    public List<DockAllocationPojo> searchAllocations(String role, String keyword) {
        return new DockAllocationImplementor().searchAllocations(role, keyword);
    }
    
    public List<DockAllocationPojo> getActiveAllocations(String role){
        return new DockAllocationImplementor().getActiveAllocations(role);
    }

    public List<DockAllocationPojo> getReleasedAllocations(String role){
        return new DockAllocationImplementor().getReleasedAllocations(role);
    }
    
    public List<DockAllocationPojo> searchActiveAllocations(String role, String keyword){
        return new DockAllocationImplementor().searchActiveAllocations(role, keyword);
    }

    public List<DockAllocationPojo> searchReleasedAllocations(String role, String keyword){
        return new DockAllocationImplementor().searchReleasedAllocations(role, keyword);
    }
    
    public void updateReleaseTime(int allocationId, String releaseTime, String role){
        new DockAllocationImplementor().updateReleaseTime(allocationId, releaseTime, role);
    }
}