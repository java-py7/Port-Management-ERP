package operations;

import java.util.List;
import models.DockAllocationPojo;

public interface DockAllocationOperations {

    void addAllocation(DockAllocationPojo a, String role);

    void releaseAllocation(int allocationId, int dockId, int shipId, String role);

    void updateAllocation(DockAllocationPojo a, String role);

    void deleteAllocation(int allocationId, String role);

    List<DockAllocationPojo> getAllAllocations(String role);

    List<DockAllocationPojo> searchAllocations(String role, String keyword);
    
    void updateReleaseTime(int allocationId, String releaseTime, String role);
}