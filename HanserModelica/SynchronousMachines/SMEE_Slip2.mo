within HanserModelica.SynchronousMachines;
model SMEE_Slip2 "Electrical excited synchronous machine operating at small slip and ie = 2A"
  extends SMEE_Slip1(ie=2);
  annotation (experiment(StopTime=30,Interval=1E-3,Tolerance=1e-06), Documentation(info="<html>
<p>Compare the simulation results of this simulation model with results calculated by 
<a href=\"modelica://HanserModelica.SynchronousMachines.SMEE_Slip1\">SMEE_Slip1</a>.</p>
</html>"));
end SMEE_Slip2;
