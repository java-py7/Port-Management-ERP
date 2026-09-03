package models;

import implementor.DashboardImplementor;

public class DashboardPojo {

    private int totalShips;
    private int totalDocks;
    private int totalContainers;
    private int totalCargo;
    
    // SHIP
    private int anchored;
    private int docked;
    private int atSea;
    private int departed;
    
    // DOCK
    private int dockAvailable;
    private int dockOccupied;
    private int dockMaintenance;

    // CONTAINER
    private int containerLoaded;
    private int containerEmpty;
    private int containerTransit;

    // CARGO
    private int cargoLoaded;
    private int cargoUnloaded;
    private int cargoTransit;

	public int getTotalShips() {
		return totalShips;
	}

	public void setTotalShips(int totalShips) {
		this.totalShips = totalShips;
	}

	public int getTotalDocks() { return totalDocks; }
	public void setTotalDocks(int totalDocks) { this.totalDocks = totalDocks; }

	public int getTotalContainers() {
		return totalContainers;
	}

	public void setTotalContainers(int totalContainers) {
		this.totalContainers = totalContainers;
	}

	public int getTotalCargo() {
		return totalCargo;
	}

	public void setTotalCargo(int totalCargo) {
		this.totalCargo = totalCargo;
	}

	public int getAnchored() {
		return anchored;
	}

	public void setAnchored(int anchored) {
		this.anchored = anchored;
	}

	public int getDocked() {
		return docked;
	}

	public void setDocked(int docked) {
		this.docked = docked;
	}

	public int getAtSea() {
		return atSea;
	}

	public void setAtSea(int atSea) {
		this.atSea = atSea;
	}

	public int getDeparted() {
		return departed;
	}

	public void setDeparted(int departed) {
		this.departed = departed;
	}

    public int getDockAvailable() {
		return dockAvailable;
	}

	public void setDockAvailable(int dockAvailable) {
		this.dockAvailable = dockAvailable;
	}

	public int getDockOccupied() {
		return dockOccupied;
	}

	public void setDockOccupied(int dockOccupied) {
		this.dockOccupied = dockOccupied;
	}

	public int getDockMaintenance() {
		return dockMaintenance;
	}

	public void setDockMaintenance(int dockMaintenance) {
		this.dockMaintenance = dockMaintenance;
	}

	public int getContainerLoaded() {
		return containerLoaded;
	}

	public void setContainerLoaded(int containerLoaded) {
		this.containerLoaded = containerLoaded;
	}

	public int getContainerEmpty() {
		return containerEmpty;
	}

	public void setContainerEmpty(int containerEmpty) {
		this.containerEmpty = containerEmpty;
	}

	public int getContainerTransit() {
		return containerTransit;
	}

	public void setContainerTransit(int containerTransit) {
		this.containerTransit = containerTransit;
	}

	public int getCargoLoaded() {
		return cargoLoaded;
	}

	public void setCargoLoaded(int cargoLoaded) {
		this.cargoLoaded = cargoLoaded;
	}

	public int getCargoUnloaded() {
		return cargoUnloaded;
	}

	public void setCargoUnloaded(int cargoUnloaded) {
		this.cargoUnloaded = cargoUnloaded;
	}

	public int getCargoTransit() {
		return cargoTransit;
	}

	public void setCargoTransit(int cargoTransit) {
		this.cargoTransit = cargoTransit;
	}

	public DashboardPojo getDashboardData(){
        return new DashboardImplementor().getDashboardData();
    }
}