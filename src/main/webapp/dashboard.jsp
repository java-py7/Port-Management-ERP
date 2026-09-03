<%
String role = (String) session.getAttribute("roleName");
%>
<%
models.DashboardPojo d = (models.DashboardPojo) request.getAttribute("dashboard");
%>
<%
int total = d.getTotalShips();

double anchoredP = total == 0 ? 0 : (d.getAnchored() * 100.0 / total);
double dockedP = total == 0 ? 0 : (d.getDocked() * 100.0 / total);
double departedP = total == 0 ? 0 : (d.getDeparted() * 100.0 / total);
%>

<%
int totalDock = d.getDockAvailable() + d.getDockOccupied() + d.getDockMaintenance();

double availP = totalDock == 0 ? 0 : d.getDockAvailable() * 100.0 / totalDock;
double occP = totalDock == 0 ? 0 : d.getDockOccupied() * 100.0 / totalDock;
double mainP = totalDock == 0 ? 0 : d.getDockMaintenance() * 100.0 / totalDock;
%>

<%
int totalContainer = d.getContainerLoaded() + d.getContainerEmpty() + d.getContainerTransit();

double cl = totalContainer == 0 ? 0 : d.getContainerLoaded() * 100.0 / totalContainer;
double ce = totalContainer == 0 ? 0 : d.getContainerEmpty() * 100.0 / totalContainer;
double ct = totalContainer == 0 ? 0 : d.getContainerTransit() * 100.0 / totalContainer;
%>

<%
int totalCargoStatus = d.getCargoLoaded() + d.getCargoUnloaded() + d.getCargoTransit();

double cLoad = totalCargoStatus == 0 ? 0 : d.getCargoLoaded() * 100.0 / totalCargoStatus;
double cUnload = totalCargoStatus == 0 ? 0 : d.getCargoUnloaded() * 100.0 / totalCargoStatus;
double cTransit = totalCargoStatus == 0 ? 0 : d.getCargoTransit() * 100.0 / totalCargoStatus;
%>

<h4 class="mb-4">Dashboard</h4>

<div class="row g-4 mb-4">

<% if("Administrator".equalsIgnoreCase(role) || 
      "Port Manager".equalsIgnoreCase(role) || 
      "Ship Operator".equalsIgnoreCase(role)) { %>
<div class="col-md-3">
<div class="card-custom d-flex justify-content-between align-items-center">
<div>
<div class="metric-title">Total Ships</div>
<div class="metric-value"><%= d.getTotalShips() %></div>
</div>
<i class="fa fa-ship dashboard-icon-ship"></i>
</div>
</div>
<% } %>



<% if("Administrator".equalsIgnoreCase(role) || 
      "Port Manager".equalsIgnoreCase(role) || 
      "Dock Manager".equalsIgnoreCase(role)) { %>

<div class="col-md-3">
<div class="card-custom d-flex justify-content-between align-items-center">
<div>
<div class="metric-title">Total Docks</div>
<div class="metric-value"><%= d.getTotalDocks() %></div>
</div>
<i class="fa fa-anchor dashboard-icon-dock"></i>
</div>
</div>
<% } %>



<% if("Administrator".equalsIgnoreCase(role) || 
      "Port Manager".equalsIgnoreCase(role) || 
      "Ship Operator".equalsIgnoreCase(role)) { %>
<div class="col-md-3">
<div class="card-custom d-flex justify-content-between align-items-center">
<div>
<div class="metric-title">Containers</div>
<div class="metric-value"><%= d.getTotalContainers() %></div>
</div>
<i class="fa fa-box dashboard-icon-container"></i>
</div>
</div>
<% } %>


<% if("Administrator".equalsIgnoreCase(role) || 
      "Port Manager".equalsIgnoreCase(role) || 
      "Cargo Handler".equalsIgnoreCase(role)) { %>
<div class="col-md-3">
<div class="card-custom d-flex justify-content-between align-items-center">
<div>
<div class="metric-title">Cargo</div>
<div class="metric-value"><%= d.getTotalCargo() %></div>
</div>
<i class="fa fa-boxes-stacked dashboard-icon-cargo"></i>
</div>
</div>
<% } %>

</div>



<div class="row g-4">


<% if("Administrator".equalsIgnoreCase(role) || 
      "Port Manager".equalsIgnoreCase(role) || 
      "Ship Operator".equalsIgnoreCase(role)) { %>
<div class="col-md-6">
<div class="card-custom">
<h6 style="text-align: center;">Ship Status Overview</h6>

<div>
<div>

    <div class="mb-2">
        Anchored (<%= d.getAnchored() %>)
        <div class="progress">
            <div class="progress-bar bg-primary" style="width:<%= anchoredP %>%"></div>
        </div>
    </div>

    <div class="mb-2">
        Docked (<%= d.getDocked() %>)
        <div class="progress">
            <div class="progress-bar bg-success" style="width:<%= dockedP %>%"></div>
        </div>
    </div>

    <div class="mb-2">
        Departed (<%= d.getDeparted() %>)
        <div class="progress">
            <div class="progress-bar bg-info" style="width:<%= departedP %>%"></div>
        </div>
    </div>

</div>
</div>
</div>
</div>
<% } %>


<% if("Administrator".equalsIgnoreCase(role) || 
      "Port Manager".equalsIgnoreCase(role) || 
      "Dock Manager".equalsIgnoreCase(role)) { %>
<div class="col-md-6">
<div class="card-custom">
<h6 style="text-align: center;">Dock Status Overview</h6>

<div>

<div class="mb-2">
Available (<%= d.getDockAvailable() %>)
<div class="progress">
<div class="progress-bar bg-success" style="width:<%= availP %>%"></div>
</div>
</div>

<div class="mb-2">
Occupied (<%= d.getDockOccupied() %>)
<div class="progress">
<div class="progress-bar bg-warning" style="width:<%= occP %>%"></div>
</div>
</div>

<div class="mb-2">
Under Maintenance (<%= d.getDockMaintenance() %>)
<div class="progress">
<div class="progress-bar bg-danger" style="width:<%= mainP %>%"></div>
</div>
</div>

</div>
</div>
</div>
<% } %>



<% if("Administrator".equalsIgnoreCase(role) || 
      "Port Manager".equalsIgnoreCase(role) || 
      "Ship Operator".equalsIgnoreCase(role)) { %>
<div class="col-md-6">
<div class="card-custom">
<h6 style="text-align: center;">Container Status Overview</h6>

<div>

<div class="mb-2">
Loaded (<%= d.getContainerLoaded() %>)
<div class="progress">
<div class="progress-bar bg-primary" style="width:<%= cl %>%"></div>
</div>
</div>

<div class="mb-2">
Empty (<%= d.getContainerEmpty() %>)
<div class="progress">
<div class="progress-bar bg-secondary" style="width:<%= ce %>%"></div>
</div>
</div>

<div class="mb-2">
In Transit (<%= d.getContainerTransit() %>)
<div class="progress">
<div class="progress-bar bg-info" style="width:<%= ct %>%"></div>
</div>
</div>

</div>
</div>
</div>
<% } %>



<% if("Administrator".equalsIgnoreCase(role) || 
      "Port Manager".equalsIgnoreCase(role) || 
      "Cargo Handler".equalsIgnoreCase(role)) { %>
<div class="col-md-6">
<div class="card-custom">
<h6 style="text-align: center;">Cargo Status Overview</h6>

<div>

<div class="mb-2">
Loaded (<%= d.getCargoLoaded() %>)
<div class="progress">
<div class="progress-bar bg-success" style="width:<%= cLoad %>%"></div>
</div>
</div>

<div class="mb-2">
Unloaded (<%= d.getCargoUnloaded() %>)
<div class="progress">
<div class="progress-bar bg-warning" style="width:<%= cUnload %>%"></div>
</div>
</div>

<div class="mb-2">
In Transit (<%= d.getCargoTransit() %>)
<div class="progress">
<div class="progress-bar bg-dark" style="width:<%= cTransit %>%"></div>
</div>
</div>

</div>
</div>
</div>
<% } %>


</div>