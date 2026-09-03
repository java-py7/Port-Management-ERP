package models;

import java.util.List;
import implementor.CargoMovementImplementor;

public class CargoMovementPojo {

    private int movementId;
    private int cargoId;
    private String movementType;
    private String movementDate;
    private String handledBy;

    private String cargoDescription;
    private String cargoStatus;

    // GETTERS / SETTERS
    public int getMovementId() { return movementId; }
    public void setMovementId(int movementId) { this.movementId = movementId; }

    public int getCargoId() { return cargoId; }
    public void setCargoId(int cargoId) { this.cargoId = cargoId; }

    public String getMovementType() { return movementType; }
    public void setMovementType(String movementType) { this.movementType = movementType; }

    public String getMovementDate() { return movementDate; }
    public void setMovementDate(String movementDate) { this.movementDate = movementDate; }

    public String getHandledBy() { return handledBy; }
    public void setHandledBy(String handledBy) { this.handledBy = handledBy; }

    public String getCargoDescription() { return cargoDescription; }
    public void setCargoDescription(String cargoDescription) { this.cargoDescription = cargoDescription; }

    public String getCargoStatus() { return cargoStatus; }
    public void setCargoStatus(String cargoStatus) { this.cargoStatus = cargoStatus; }

    // 🔥 MVC2 METHODS

    public void addMovement(CargoMovementPojo m, String role){
        new CargoMovementImplementor().addMovement(m, role);
    }

    public void updateMovement(CargoMovementPojo m, String role){
        new CargoMovementImplementor().updateMovement(m, role);
    }

    public static List<CargoMovementPojo> getAll(String role){
        return new CargoMovementImplementor().getAll(role);
    }

    public static List<CargoMovementPojo> search(String role, String keyword){
        return new CargoMovementImplementor().search(role, keyword);
    }
}