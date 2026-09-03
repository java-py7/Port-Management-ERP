package models;

import java.util.List;
import implementor.CargoImplementor;

public class CargoPojo {

    private int cargoId;
    private int containerId;
    private String description;
    private double weight;
    private String status;

    private String containerType;
    private String shipName;
    private String dockName;

    // GETTERS / SETTERS
    public int getCargoId() { return cargoId; }
    public void setCargoId(int cargoId) { this.cargoId = cargoId; }

    public int getContainerId() { return containerId; }
    public void setContainerId(int containerId) { this.containerId = containerId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getContainerType() { return containerType; }
    public void setContainerType(String containerType) { this.containerType = containerType; }

    public String getShipName() { return shipName; }
    public void setShipName(String shipName) { this.shipName = shipName; }

    public String getDockName() { return dockName; }
    public void setDockName(String dockName) { this.dockName = dockName; }

    // 🔥 MVC2 METHODS

    public void addCargo(CargoPojo c, String role){
        new CargoImplementor().addCargo(c, role);
    }

    public void updateCargo(CargoPojo c, String role){
        new CargoImplementor().updateCargo(c, role);
    }

    public void deleteCargo(int id, String role){
        new CargoImplementor().deleteCargo(id, role);
    }

    public void setStatus(int id, String status, String role, int userId){
        new CargoImplementor().setStatus(id, status, role, userId);
    }

    public static List<CargoPojo> showCargo(String role){
        return new CargoImplementor().showCargo(role);
    }

    public static List<CargoPojo> searchCargo(String role, String keyword){
        return new CargoImplementor().searchCargo(role, keyword);
    }
    
    public List<CargoPojo> getCargoByContainer(int containerId){
        return new CargoImplementor().getCargoByContainer(containerId);
    }
    
    public List<CargoPojo> getAllCargo(){
        return new CargoImplementor().getAllCargo();
    }

}