within Modelica_LinearSystems2.Controller.Examples;
model InverseDoublePendulumWithObserver
  "Example of controlled inverse doubel pendulum"
  extends Modelica.Icons.Example;

  extends Templates.SimpleObserverStateSpaceControl(
    redeclare Components.InverseDoublePendulum3 plant(
      additionalMeasurableOutputs=true,
      m_trolley=1,
      n=6,
      phi2_start=0,
      length=1,
      cartDisturbance=true,
      bodyDisturbance=true,
      l=2,
      secondAngle=false,
      m_load=1,
      phi1_start=1.5707963267949),
    preFilter(
      matrixName="M_pa",
      fileName=DataDir + "inverseDoublePendulumController.mat",
      matrixOnFile=true),
    feedbackMatrix(
      matrixOnFile=true,
      matrixName="K_pa",
      fileName=DataDir + "inverseDoublePendulumController.mat"),
    sampleClock(sampleTime=0.002, blockType=Modelica_LinearSystems2.Controller.Types.BlockType.Continuous),
    observer(
      systemName="stateSpace",
      matrixOnFile=true,
      initType=Types.InitWithGlobalDefault.InitialState,
      methodType=Types.MethodWithGlobalDefault.StepExact,
      x_start={0,0,0,0,0,0},
      observerMatrixName="K_ob2",
      blockType=Types.BlockTypeWithGlobalDefault.UseSampleClockOption,
      withDelay=true,
      fileName=DataDir + "inverseDoublePendulumControllerO.mat"));

  Modelica.Blocks.Sources.Pulse pulse(
    offset=0,
    startTime=1,
    width=50,
    period=30,
    amplitude=5)
              annotation (Placement(transformation(extent={{-152,-10},{-132,10}})));
  Components.AccelerationLimiter accelerationLimiter(
    v_limit=20,
    velocityLimitation=false,
    withDelay2=false,
    a_limit=1)
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Noise noise(
    firstSeed={43,123,162},
    blockType=Types.BlockTypeWithGlobalDefault.Discrete,
    y_min=-0.005,
    y_max=0.005,
    sampleFactor=200)
             annotation (Placement(transformation(extent={{14,70},{34,90}})));
  Noise noise1(
    sampleFactor=100,
    blockType=Types.BlockTypeWithGlobalDefault.Discrete,
    y_min=-0.025,
    y_max=0.025)
    annotation (Placement(transformation(extent={{14,40},{34,60}})));

initial equation
//feedback.y = {0.0};
plant.u = {0.0};

equation
  connect(pulse.y, accelerationLimiter.u) annotation (Line(
      points={{-131,0},{-122,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(noise1.y, plant.dist) annotation (Line(
      points={{35,50},{86.8,50},{86.8,5.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(noise.y, plant.dist2) annotation (Line(
      points={{35,80},{93.6,80},{93.6,5.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preFilter.u[1], accelerationLimiter.s) annotation (Line(
      points={{-82,0},{-88,0},{-88,6},{-99,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160,
            100}}),     graphics={Text(
          extent={{-44,78},{8,54}},
          lineColor={0,0,0},
          textString="disturbance"), Rectangle(extent={{-86,28},{108,-60}},
            lineColor={255,0,0})}),
    experiment(
      StopTime=60,
      NumberOfIntervals=2000,
      Tolerance=1e-005),
    experimentSetupOutput,
    Commands,
    Documentation(info="<html>
 
This example shows a control system with constant state feedback.
The system model of a crane trolles system is taken from [1]. The
feedback matrix and the pre filter can be loaded from MATLAB files. By default, this files 
are generated by call of Modelica_LinearSystems2.Examples.StateSpace.craneController.<br>
<p>
 
<A name=\"References\"><B><FONT SIZE=\"+1\">References</FONT></B></A>
<PRE>
  [1] F�llinger, O. \"Regelungstechnik\", H�thig-Verlag
</PRE>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160,
            100}})));
end InverseDoublePendulumWithObserver;
