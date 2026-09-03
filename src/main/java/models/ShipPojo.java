package models;

import java.util.List;
import implementor.ShipImplementor;

public class ShipPojo {

    private int shipId;
    private String shipName;
    private String arrivalDate;
    private String departureDate;
    private String status;
    private int operatorId;
    private String operatorName;
    private String roleName;
    private String search;

    // GETTERS & SETTERS

    public int getShipId() { return shipId; }
    public void setShipId(int shipId) { this.shipId = shipId; }

    public String getShipName() { return shipName; }
    public void setShipName(String shipName) { this.shipName = shipName; }

    public String getArrivalDate() { return arrivalDate; }
    public void setArrivalDate(String arrivalDate) { this.arrivalDate = arrivalDate; }

    public String getDepartureDate() { return departureDate; }
    public void setDepartureDate(String departureDate) { this.departureDate = departureDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getOperatorId() { return operatorId; }
    public void setOperatorId(int operatorId) { this.operatorId = operatorId; }

    public String getOperatorName() { return operatorName; }
    public void setOperatorName(String operatorName) { this.operatorName = operatorName; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    public String getSearch() { return search; }
    public void setSearch(String search) { this.search = search; }

    // MVC2 CALLS

    public void addShip(ShipPojo ship, String role) {
        new ShipImplementor().addShip(ship, role);
    }

    public void updateShip(ShipPojo ship, String role) {
        new ShipImplementor().updateShip(ship, role);
    }

    public void deleteShip(int shipId, String role) {
        new ShipImplementor().deleteShip(shipId, role);
    }

    public void setShipStatus(int shipId, String status, String role) {
        new ShipImplementor().setShipStatus(shipId, status, role);
    }

    public List<ShipPojo> getAllShips(String role) {
        return new ShipImplementor().getAllShips(role);
    }

    public List<ShipPojo> searchShips(String role, String keyword) {
        return new ShipImplementor().searchShips(role, keyword);
    }
    
    public static List<ShipPojo> getShipsForAllocation() {
        return new ShipImplementor().getShipsForAllocation();
    }
    
    public List<ShipPojo> getDockedShips(){
        return new ShipImplementor().getDockedShips();
    }
}