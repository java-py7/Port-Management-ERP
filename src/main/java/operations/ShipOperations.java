package operations;

import java.util.List;
import models.ShipPojo;

public interface ShipOperations {

    void addShip(ShipPojo ship, String role);
    void updateShip(ShipPojo ship, String role);
    void deleteShip(int shipId, String role);
    void setShipStatus(int shipId, String status, String role);

    List<ShipPojo> getAllShips(String role);
    List<ShipPojo> searchShips(String role, String keyword);
}