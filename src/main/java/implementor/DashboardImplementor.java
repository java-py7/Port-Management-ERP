package implementor;

import java.sql.*;
import db_config.GetConnection;
import models.DashboardPojo;

public class DashboardImplementor {

    public DashboardPojo getDashboardData(){

        DashboardPojo d = new DashboardPojo();

        try(Connection con = GetConnection.getConnection()){

            // 🔹 TOTAL SHIPS
            ResultSet rs1 = con.prepareStatement(
                "SELECT COUNT(*) FROM ship"
            ).executeQuery();
            if(rs1.next()) d.setTotalShips(rs1.getInt(1));

            // 🔹 ACTIVE DOCKS
            ResultSet rs2 = con.prepareStatement(
        	    "SELECT COUNT(*) FROM dock"
        	).executeQuery();
            if(rs2.next()) d.setTotalDocks(rs2.getInt(1));

            // 🔹 CONTAINERS
            ResultSet rs3 = con.prepareStatement(
                "SELECT COUNT(*) FROM container"
            ).executeQuery();
            if(rs3.next()) d.setTotalContainers(rs3.getInt(1));

            // 🔹 CARGO
            ResultSet rs4 = con.prepareStatement(
                "SELECT COUNT(*) FROM cargo"
            ).executeQuery();
            if(rs4.next()) d.setTotalCargo(rs4.getInt(1));

            // 🔥 SHIP STATUS
            ResultSet rs5 = con.prepareStatement(
                "SELECT status, COUNT(*) as count FROM ship GROUP BY status"
            ).executeQuery();

            while(rs5.next()){
                String status = rs5.getString("status");
                int count = rs5.getInt("count");

                switch(status){
                    case "Anchored": d.setAnchored(count); break;
                    case "Docked": d.setDocked(count); break;
                    case "At Sea": d.setAtSea(count); break;
                    case "Departed": d.setDeparted(count); break;
                }
            }
            
            // 🔥 DOCK STATUS
            ResultSet dockRs = con.prepareStatement(
            	    "SELECT status, COUNT(*) as count FROM dock GROUP BY status"
            	).executeQuery();

            	while(dockRs.next()){
            	    String status = dockRs.getString("status");
            	    int count = dockRs.getInt("count");

            	    switch(status){
            	        case "Available": d.setDockAvailable(count); break;
            	        case "Occupied": d.setDockOccupied(count); break;
            	        case "Under Maintenance": d.setDockMaintenance(count); break;
            	    }
            	}
            	
            // 🔥 CONTAINER STATUS
        	ResultSet conRs = con.prepareStatement(
        		    "SELECT status, COUNT(*) as count FROM container GROUP BY status"
        		).executeQuery();

        		while(conRs.next()){
        		    String status = conRs.getString("status");

        		    switch(status){
        		        case "Loaded": d.setContainerLoaded(conRs.getInt("count")); break;
        		        case "Empty": d.setContainerEmpty(conRs.getInt("count")); break;
        		        case "In Transit": d.setContainerTransit(conRs.getInt("count")); break;
        		    }
        		}
        		
        	// 🔥 CARGO STATUS
        		ResultSet cargoRs = con.prepareStatement(
        		    "SELECT status, COUNT(*) as count FROM cargo WHERE status IS NOT NULL GROUP BY status"
        		).executeQuery();

        		while(cargoRs.next()){
        		    String status = cargoRs.getString("status");
        		    int count = cargoRs.getInt("count");

        		    if(status == null) continue; // safety

        		    status = status.trim();

        		    if ("Loaded".equalsIgnoreCase(status)) {
        		        d.setCargoLoaded(count);
        		    } 
        		    else if ("Unloaded".equalsIgnoreCase(status)) {
        		        d.setCargoUnloaded(count);
        		    } 
        		    else if (status.toLowerCase().contains("transit")) {
        		        d.setCargoTransit(count);
        		    }
        		}
        		
        } catch(Exception e){
            e.printStackTrace();
        }

        return d;
    }
}