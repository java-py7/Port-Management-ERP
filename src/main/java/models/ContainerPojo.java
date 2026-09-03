package models;

import java.util.List;
import implementor.ContainerImplementor;

public class ContainerPojo {

    private int containerId;
    private String containerType;
    private String status;
    private Integer shipId;
    private String shipName;

    // GETTERS / SETTERS
    public int getContainerId() { return containerId; }
    public void setContainerId(int containerId) { this.containerId = containerId; }

    public String getContainerType() { return containerType; }
    public void setContainerType(String containerType) { this.containerType = containerType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getShipId() { return shipId; }
    public void setShipId(Integer shipId) { this.shipId = shipId; }

    public String getShipName() { return shipName; }
    public void setShipName(String shipName) { this.shipName = shipName; }

    // 🔥 MVC2 METHODS

    public void addContainer(ContainerPojo c, String role){
        new ContainerImplementor().addContainer(c, role);
    }

    public void assignToShip(int containerId, int shipId, String role){
        new ContainerImplementor().assignToShip(containerId, shipId, role);
    }

    public void updateContainer(ContainerPojo c, String role){
        new ContainerImplementor().updateContainer(c, role);
    }

    public void deleteContainer(int id, String role){
        new ContainerImplementor().deleteContainer(id, role);
    }

    public void setStatus(int id, String status, String role){
        new ContainerImplementor().setStatus(id, status, role);
    }

    public static List<ContainerPojo> showContainers(String role){
        return new ContainerImplementor().showContainers(role);
    }

    public static List<ContainerPojo> searchContainers(String role, String keyword){
        return new ContainerImplementor().searchContainers(role, keyword);
    }
}