within HanserModelica.SynchronousMachines;
model SMEE_DOL "Test example: ElectricalExcitedSynchronousInductionMachine starting direct on line"
  extends Modelica.Icons.Example;
  parameter Integer m=3 "Number of phases";
  parameter Modelica.SIunits.Voltage VNominal=100 "Nominal RMS voltage per phase";
  parameter Modelica.SIunits.Frequency fNominal=50 "Nominal frequency";
  parameter Modelica.SIunits.Voltage Ve=smeeData.Re*smeeData.IeOpenCircuit "Excitation current";
  parameter Modelica.SIunits.Angle gamma0(displayUnit="deg") = 0 "Initial rotor displacement angle";
  Modelica.Magnetic.FundamentalWave.BasicMachines.SynchronousInductionMachines.SM_ElectricalExcited smee(
    phiMechanical(start=-(Modelica.Constants.pi + gamma0)/smee.p, fixed=true),
    fsNominal=smeeData.fsNominal,
    TsRef=smeeData.TsRef,
    Lrsigmad=smeeData.Lrsigmad,
    Lrsigmaq=smeeData.Lrsigmaq,
    Rrd=smeeData.Rrd,
    Rrq=smeeData.Rrq,
    TrRef=smeeData.TrRef,
    VsNominal=smeeData.VsNominal,
    IeOpenCircuit=smeeData.IeOpenCircuit,
    Re=smeeData.Re,
    TeRef=smeeData.TeRef,
    p=2,
    Jr=0.29,
    Js=0.29,
    useDamperCage=true,
    statorCoreParameters(VRef=100),
    strayLoadParameters(IRef=100),
    brushParameters(ILinear=0.01),
    ir(fixed=true),
    wMechanical(fixed=true),
    m=m,
    Rs=smeeData.Rs*m/3,
    Lssigma=smeeData.Lssigma*m/3,
    Lmd=smeeData.Lmd*m/3,
    Lmq=smeeData.Lmq*m/3,
    TsOperational=293.15,
    alpha20s=smeeData.alpha20s,
    alpha20r=smeeData.alpha20r,
    TrOperational=293.15,
    TeOperational=293.15,
    alpha20e=smeeData.alpha20e,
    sigmae=smeeData.sigmae*m/3)
                          annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Modelica.Electrical.Machines.Sensors.RotorDisplacementAngle rotorDisplacementAngle(p=smee.p, m=m) annotation (Placement(transformation(
        origin={20,-40},
        extent={{-10,10},{10,-10}},
        rotation=270)));
  Modelica.Electrical.Analog.Basic.Ground groundExcitation annotation (
      Placement(transformation(
        origin={-40,-70},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Mechanics.Rotational.Sensors.MultiSensor mSensor annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Electrical.MultiPhase.Sensors.MultiSensor sensor(m=m) annotation (Placement(transformation(
        origin={40,30},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Electrical.MultiPhase.Sensors.CurrentQuasiRMSSensor iSensor(m=m) annotation (Placement(transformation(
        origin={40,0},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Electrical.MultiPhase.Sources.SineVoltage sineVoltage(
    final m=m,
    final V=fill(VNominal*sqrt(2), m),
    final freqHz=fill(fNominal, m)) annotation (Placement(transformation(
          extent={{-10,40},{-30,60}})));
  Modelica.Electrical.MultiPhase.Basic.Star star(final m=m) annotation (
      Placement(transformation(extent={{-40,40},{-60,60}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (Placement(
        transformation(
        origin={-60,30},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.Analog.Sources.RampVoltage rampVoltage(
    duration=0.1,
    V=Ve,
    offset=0,
    startTime=0.5) annotation (Placement(transformation(
        origin={-40,-40},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  Modelica.Electrical.Machines.Utilities.TerminalBox terminalBox(terminalConnection="Y", m=m) annotation (Placement(transformation(extent={{-20,-34},{0,-14}})));
  parameter Modelica.Electrical.Machines.Utilities.SynchronousMachineData smeeData(
    SNominal=30e3,
    VsNominal=100,
    fsNominal=50,
    IeOpenCircuit=10,
    x0=0.1,
    xd=1.6,
    xq=1.6,
    xdTransient=0.1375,
    xdSubtransient=0.121428571,
    xqSubtransient=0.148387097,
    Ta=0.014171268,
    Td0Transient=0.261177343,
    Td0Subtransient=0.006963029,
    Tq0Subtransient=0.123345081,
    alpha20s(displayUnit="1/K") = Modelica.Electrical.Machines.Thermal.Constants.alpha20Zero,
    alpha20r(displayUnit="1/K") = Modelica.Electrical.Machines.Thermal.Constants.alpha20Zero,
    alpha20e(displayUnit="1/K") = Modelica.Electrical.Machines.Thermal.Constants.alpha20Zero,
    TsSpecification=293.15,
    TsRef=293.15,
    TrSpecification=293.15,
    TrRef=293.15,
    TeSpecification=293.15,
    TeRef=293.15) annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  Modelica.Electrical.MultiPhase.Ideal.IdealClosingSwitch idealCloser(
    final m=m,
    Ron=fill(1e-5*m/3, m),
    Goff=fill(1e-5*m/3, m)) annotation (Placement(transformation(
        origin={10,50},
        extent={{-10,10},{10,-10}},
        rotation=0)));
  Modelica.Blocks.Sources.BooleanStep booleanStep(startTime=0) annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Modelica.Blocks.Routing.BooleanReplicator booleanReplicator(nout=m) annotation (Placement(transformation(extent={{-20,20},{0,0}})));
  Modelica.Mechanics.Rotational.Sources.TorqueStep torqueStep(
    offsetTorque=0,
    stepTorque=50,
    startTime=2) annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
initial equation
  // sum(smee.is) = 0;
  smee.is[1:2] = zeros(2);
  smee.ie = 0;
  //conditional damper cage currents are defined as fixed start values
equation
  connect(rotorDisplacementAngle.plug_n, smee.plug_sn) annotation (Line(
        points={{26,-30},{26,-20},{-16,-20},{-16,-30}}, color={0,0,255}));
  connect(rotorDisplacementAngle.plug_p, smee.plug_sp)
    annotation (Line(points={{14,-30},{-4,-30}}, color={0,0,255}));
  connect(star.pin_n, ground.p)
    annotation (Line(points={{-60,50},{-60,40}}, color={0,0,255}));
  connect(star.plug_p, sineVoltage.plug_n)
    annotation (Line(points={{-40,50},{-30,50}}, color={0,0,255}));
  connect(terminalBox.plugSupply, iSensor.plug_n) annotation (Line(points={{-10,-28},{-10,-10},{40,-10}}, color={0,0,255}));
  connect(terminalBox.plug_sn, smee.plug_sn) annotation (Line(
      points={{-16,-30},{-16,-30}},
      color={0,0,255}));
  connect(terminalBox.plug_sp, smee.plug_sp) annotation (Line(
      points={{-4,-30},{-4,-30}},
      color={0,0,255}));
  connect(smee.flange, rotorDisplacementAngle.flange) annotation (Line(
      points={{0,-40},{10,-40}}));
  connect(smee.flange, mSensor.flange_a) annotation (Line(points={{0,-40},{40,-40}}));
  connect(sineVoltage.plug_p, idealCloser.plug_p)
    annotation (Line(points={{-10,50},{0,50}},        color={0,0,255}));
  connect(booleanReplicator.y, idealCloser.control)
    annotation (Line(points={{1,10},{10,10},{10,38}},
                                                 color={255,0,255}));
  connect(booleanStep.y, booleanReplicator.u)
    annotation (Line(points={{-29,10},{-22,10}}, color={255,0,255}));
  connect(groundExcitation.p, rampVoltage.n)
    annotation (Line(points={{-40,-60},{-40,-60},{-40,-56},{-40,-56},{-40,-50},{-40,-50}},
                                                   color={0,0,255}));
  connect(rampVoltage.n, smee.pin_en) annotation (Line(points={{-40,-50},{-30,-50},{-30,-46},{-20,-46}},
                                          color={0,0,255}));
  connect(rampVoltage.p, smee.pin_ep) annotation (Line(points={{-40,-30},{-30,-30},{-30,-34},{-20,-34}},
                                          color={0,0,255}));
  connect(mSensor.flange_b, torqueStep.flange) annotation (Line(points={{60,-40},{70,-40}}, color={0,0,0}));
  connect(idealCloser.plug_n, sensor.pc) annotation (Line(points={{20,50},{40,50},{40,40}}, color={0,0,255}));
  connect(sensor.nv, terminalBox.plug_sn) annotation (Line(points={{30,30},{20,30},{20,-20},{-16,-20},{-16,-30}}, color={0,0,255}));
  connect(sensor.nc, iSensor.plug_p) annotation (Line(points={{40,20},{40,10}}, color={0,0,255}));
  connect(sensor.pv, sensor.pc) annotation (Line(points={{50,30},{50,40},{40,40}}, color={0,0,255}));
  annotation (experiment(
      StopTime=3,
      Interval=0.0001,
      Tolerance=1e-006),                                                Documentation(info="<html>
<p>An electrically excited synchronous generator is started direct on line utilizing the damper cage (and the shorted excitation winding) at 0.1 seconds.<br>
At t = 0.5 seconds, the excitation voltage is raised to achieve no-load excitation current. Note, that reactive power of the stator goes to zero.<br>
At t = 1 second, a driving torque step is applied to the shaft (i.e. the turbine is activated). Note, that active and reactive power of the stator changes. 
To drive at higher torque, i.e., produce more electric power, excitation has to be adapted.
</p>

<p>Simulate for 2 seconds and plot:</p>

<ul>
<li><code>smee.tauElectrical</code></li>
<li><code>smee.wMechanical</code></li>
<li><code>smee.ie</code></li>
<li><code>rotorDisplacementAngle.rotorDisplacementAngle</code></li>
<li><code>iSensor.I</code></li>
<li><code>sensor.powerTotal</code></li>
<li><code>mSensor.power</code></li>
</ul>

<p>Default machine parameters are used.</p>

<h5>Note</h5>
<p>The mains switch is closed at time = 0 in order to avoid non physical noise calculated by the <code>rotorDisplacementAngle</code>. 
This noise is caused by the interaction of the high resistance of the switch and the machine, see 
<a href=\"https://github.com/modelica/Modelica/issues/2388\">#2388</a>. 
</p>
</html>"),
    Diagram(graphics={                      Text(
                  extent={{10,-72},{90,-80}},
                  lineColor={0,0,0},
                  fillColor={255,255,170},
                  fillPattern=FillPattern.Solid,
                  textStyle={TextStyle.Bold},
          textString="%m phase quasi static")}));
end SMEE_DOL;
