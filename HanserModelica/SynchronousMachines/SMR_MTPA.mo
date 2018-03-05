within HanserModelica.SynchronousMachines;
model SMR_MTPA "Synchronous reluctance machine, investigating maximum torque per Amps"
  extends Modelica.Icons.Example;
  import Modelica.Constants.pi;
  parameter Integer m = 3 "Number of phases";
  parameter Modelica.SIunits.Voltage VNominal = 100 "Nominal RMS voltage per phase";
  parameter Modelica.SIunits.Frequency fNominal = 50 "Nominal frequency";
  parameter Modelica.SIunits.Frequency f = 50 "Actual frequency";
  parameter Modelica.SIunits.Time tRamp = 1 "Frequency ramp";
  parameter Modelica.SIunits.Torque TLoad = 88.67 "Nominal load torque";
  parameter Modelica.SIunits.Time tStep = 1.2 "Time of load torque step";
  parameter Modelica.SIunits.Inertia JLoad = 0.29 "Load's moment of inertia";
  parameter Modelica.SIunits.AngularVelocity wNominal = 2 * pi * fNominal / smrData.p "Nominal angular velocity";
  Modelica.SIunits.Angle theta = rotorAngle.rotorDisplacementAngle "Rotor displacement angle, quasi stastic";
  parameter Boolean positiveRange = false "Use positive range of angles, if true";
  Modelica.SIunits.Angle phii = MoveTo_Modelica.Math.wrapAngle(smr.arg_is[1], positiveRange) "Angle of current";
  Modelica.SIunits.Angle phiv = MoveTo_Modelica.Math.wrapAngle(smr.arg_vs[1], positiveRange) "Angle of voltage";
  Modelica.SIunits.Angle phis = MoveTo_Modelica.Math.wrapAngle(phiv - phii, positiveRange) "Angle between voltage and current";
  Modelica.SIunits.Angle epsilon = MoveTo_Modelica.Math.wrapAngle(phis - theta, positiveRange) "Current angle";
  Modelica.Magnetic.QuasiStatic.FundamentalWave.BasicMachines.SynchronousMachines.SM_ReluctanceRotor smr(p = smrData.p, fsNominal = smrData.fsNominal, TsRef = smrData.TsRef, Jr = smrData.Jr, Js = smrData.Js, frictionParameters = smrData.frictionParameters, statorCoreParameters = smrData.statorCoreParameters, strayLoadParameters = smrData.strayLoadParameters,                                        Lrsigmad = smrData.Lrsigmad, Lrsigmaq = smrData.Lrsigmaq, Rrd = smrData.Rrd, Rrq = smrData.Rrq, TrRef = smrData.TrRef, phiMechanical(fixed = true, start = 0), m = m, effectiveStatorTurns = smrData.effectiveStatorTurns, Rs = smrData.Rs * m / 3, Lssigma = smrData.Lssigma * m / 3, Lmd = smrData.Lmd * m / 3, Lmq = smrData.Lmq * m / 3,
    TsOperational=373.15,
    alpha20s=smrData.alpha20s,
    TrOperational=373.15,
    useDamperCage=false,
    alpha20r=smrData.alpha20r)                                                                                                                                                                                                         annotation (
    Placement(transformation(extent = {{0, 0}, {20, 20}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed quadraticSpeedDependentTorque(w_fixed = wNominal) annotation (
    Placement(transformation(extent = {{80, 0}, {60, 20}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.Star starMachine(m = Modelica.Electrical.MultiPhase.Functions.numberOfSymmetricBaseSystems(m)) annotation (
    Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = 180, origin = {-20, 10})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground groundM annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-50, 0})));
  Modelica.Magnetic.QuasiStatic.FundamentalWave.Utilities.MultiTerminalBox terminalBox(terminalConnection = "Y", m = m) annotation (
    Placement(transformation(extent = {{0, 16}, {20, 36}})));
  Modelica.Magnetic.QuasiStatic.FundamentalWave.Utilities.CurrentController currentController(m = m, p = smr.p) annotation (
    Placement(transformation(extent = {{-40, 70}, {-20, 90}})));
  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {40, 50})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Sources.ReferenceCurrentSource referenceCurrentSource(m = m) annotation (
    Placement(transformation(extent = {{10, -10}, {-10, 10}}, rotation = 90, origin = {10, 80})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.Star star(m = m) annotation (
    Placement(transformation(origin = {60, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground grounde annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, origin = {60, 60})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.Resistor resistor(m = m, R_ref = fill(1e5, m)) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {30, 80})));
  MoveTo_Modelica.Magnetic.QuasiStatic.FundamentalWave.Sensors.RotorDisplacementAngle rotorAngle(
    m=m,
    p=smrData.p,
    positiveRange=positiveRange) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,10})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Sensors.CurrentQuasiRMSSensor currentRMSSensor(m = m) annotation (
    Placement(transformation(extent = {{10, 10}, {-10, -10}}, rotation = 90, origin = {10, 50})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Sensors.VoltageQuasiRMSSensor voltageRMSSensor(m = m) annotation (
    Placement(transformation(extent = {{-30, 50}, {-10, 30}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.Star starM(m = m) annotation (
    Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = 270, origin = {-40, 30})));
  Modelica.ComplexBlocks.Sources.ComplexRotatingPhasor rotSource(magnitude = 100, w = 2 * pi) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-70, 20})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal toReal annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-70, 50})));
  parameter ParameterRecords.SMR smrData annotation (Placement(transformation(extent={{60,30},{80,50}})));
equation
  connect(starMachine.plug_p, terminalBox.starpoint) annotation (
    Line(points={{-10,10},{-10,22},{1,22}},        color = {85, 170, 255}));
  connect(groundM.pin, starMachine.pin_n) annotation (
    Line(points = {{-50, 10}, {-30, 10}}, color = {85, 170, 255}));
  connect(terminalBox.plug_sn, smr.plug_sn) annotation (
    Line(points = {{4, 20}, {4, 20}}, color = {85, 170, 255}));
  connect(terminalBox.plug_sp, smr.plug_sp) annotation (
    Line(points = {{16, 20}, {16, 20}}, color = {85, 170, 255}));
  connect(currentController.I, referenceCurrentSource.I) annotation (
    Line(points={{-19,84},{-10,84},{-10,84},{0,84}},           color = {85, 170, 255}));
  connect(referenceCurrentSource.plug_p, star.plug_p) annotation (
    Line(points = {{10, 90}, {60, 90}}, color = {85, 170, 255}));
  connect(star.pin_n, grounde.pin) annotation (
    Line(points = {{60, 70}, {60, 70}}, color = {85, 170, 255}));
  connect(angleSensor.flange, smr.flange) annotation (
    Line(points = {{40, 40}, {40, 30}, {30, 30}, {30, 10}, {20, 10}}));
  connect(referenceCurrentSource.plug_p, resistor.plug_p) annotation (
    Line(points = {{10, 90}, {30, 90}}, color = {85, 170, 255}));
  connect(resistor.plug_n, referenceCurrentSource.plug_n) annotation (
    Line(points = {{30, 70}, {10, 70}}, color = {85, 170, 255}));
  connect(currentController.gamma, referenceCurrentSource.gamma) annotation (
    Line(points={{-19,76},{-10,76},{-10,76},{0,76}},           color = {0, 0, 127}));
  connect(angleSensor.phi, currentController.phi) annotation (
    Line(points = {{40, 61}, {40, 64}, {-30, 64}, {-30, 68}}, color = {0, 0, 127}));
  connect(smr.flange, rotorAngle.flange) annotation (
    Line(points = {{20, 10}, {30, 10}}, color = {0, 0, 0}));
  connect(terminalBox.plug_sp, rotorAngle.plug_p) annotation (
    Line(points = {{16, 20}, {34, 20}}, color = {85, 170, 255}));
  connect(terminalBox.plugSupply, currentRMSSensor.plug_n) annotation (
    Line(points = {{10, 22}, {10, 40}}, color = {85, 170, 255}));
  connect(currentRMSSensor.plug_p, referenceCurrentSource.plug_n) annotation (
    Line(points = {{10, 60}, {10, 70}}, color = {85, 170, 255}));
  connect(rotorAngle.plug_n, terminalBox.plug_sn) annotation (
    Line(points = {{46, 20}, {46, 26}, {4, 26}, {4, 20}}, color = {85, 170, 255}));
  connect(voltageRMSSensor.plug_n, currentRMSSensor.plug_n) annotation (
    Line(points = {{-10, 40}, {10, 40}}, color = {85, 170, 255}));
  connect(starM.pin_n, starMachine.pin_n) annotation (
    Line(points = {{-40, 20}, {-40, 10}, {-30, 10}}, color = {85, 170, 255}));
  connect(starM.plug_p, voltageRMSSensor.plug_p) annotation (
    Line(points = {{-40, 40}, {-30, 40}}, color = {85, 170, 255}));
  connect(quadraticSpeedDependentTorque.flange, rotorAngle.flange) annotation (
    Line(points = {{60, 10}, {30, 10}}, color = {0, 0, 0}));
  connect(toReal.u, rotSource.y) annotation (
    Line(points = {{-70, 38}, {-70, 31}}, color = {85, 170, 255}));
  connect(toReal.re, currentController.id_rms) annotation (
    Line(points = {{-76, 62}, {-76, 86}, {-42, 86}}, color = {0, 0, 127}));
  connect(currentController.iq_rms, toReal.im) annotation (
    Line(points = {{-42, 74}, {-64, 74}, {-64, 62}}, color = {0, 0, 127}));
  annotation (
    experiment(StopTime = 1, Interval = 1E-3, Tolerance = 1E-6),
    Documentation(info = "<html>
<p>
This example investigates the maximum torque per amps (MTPA) of a quasi static permanent magnet synchronous machine. 
The machines is operated at constant speed. The current magnitude is kept constant and the current angle is
rotated from 0 to 360 degrees with the simulation period of one second.</p>

<p>
In this simulation the angle is the following angles are calculated:</p> 

<ul>
<li><code>phi_v<code> = angle of voltage phasor</li>
<li><code>phi_i<code> = angle of current phasor</li>
<li><code>phiphi_v - phi_i</code> = angle between voltage and current phasor</li>
<li><code>theta</code> = rotor displacement angle</li>
<li><code>epsilon = phi - theta</code> = current angle</li>
</ul>

<p>
Simulate for 1 second and plot (versus angle epsilon):
</p>

<ul>
<li><code>smpm.tauElectrical</code>: machine torque</li>
<li><code>smpm.abs_vs[1]</code>: machine phase voltage magnitude</li>
<li><code>phi</code>: phase angle between voltage and current phasor</li>
</ul>

<h5>Note</h5>
<p>The resistors connected to the terminals of the windings of the quasi static machine model are necessary 
to numerically stabilize the simulation.</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Text(extent = {{0, -10}, {80, -18}}, textStyle={TextStyle.Bold},                            lineColor={0,0,0},
          textString="%m phase quasi static")}));
end SMR_MTPA;
