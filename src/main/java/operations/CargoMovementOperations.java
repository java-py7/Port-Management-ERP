package operations;

import java.util.List;
import models.CargoMovementPojo;
import models.CargoPojo;

public interface CargoMovementOperations {

    void addMovement(CargoMovementPojo m, String role);

    void updateMovement(CargoMovementPojo m, String role);

    List<CargoMovementPojo> getAll(String role);

    List<CargoMovementPojo> search(String role, String keyword);
    
    List<CargoPojo> getAllCargo();
}