package operations;

import java.util.List;
import models.ContainerPojo;

public interface ContainerOperations {

    void addContainer(ContainerPojo c, String role);

    void assignToShip(int containerId, int shipId, String role);

    void updateContainer(ContainerPojo c, String role);

    void deleteContainer(int id, String role);

    void setStatus(int id, String status, String role);

    List<ContainerPojo> showContainers(String role);

    List<ContainerPojo> searchContainers(String role, String keyword);
}