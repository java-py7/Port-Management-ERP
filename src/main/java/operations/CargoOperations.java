package operations;

import java.util.List;
import models.CargoPojo;

public interface CargoOperations {

    void addCargo(CargoPojo c, String role);

    void updateCargo(CargoPojo c, String role);

    void deleteCargo(int id, String role);

    void setStatus(int id, String status, String role, int userId);

    List<CargoPojo> showCargo(String role);

    List<CargoPojo> searchCargo(String role, String keyword);
    
    List<CargoPojo> getAllCargo();
}