within Modelica_LinearSystems2.Examples.StateSpace;
function plotBodeMIMO
  "Constructs zeros-and-poles-transfers from state space representation and plots the Bode diagrams with automatic determination of the frequency range to plot "

  import Modelica;
  import Modelica_LinearSystems2.StateSpace;
  import Modelica_LinearSystems2.TransferFunction;

  input Boolean systemOnFile=false
    "true, if state space system is defined on file"
    annotation(Dialog(group="system data definition"),choices(checkBox=true));

  input String fileName="NoName" "file where matrix [A, B; C, D] is stored" annotation(Dialog(group="system data definition",loadSelector(filter="MAT files (*.mat);; All files (*.*)",
                      caption="state space system data file"),enable = systemOnFile));

  input Real A[:,size(A, 1)]=[-1.0,0.0,0.0; 0.0,-2.0,0.0; 0.0,0.0,-3.0]  annotation(Dialog(group="system matrices",enable = not systemOnFile));
  input Real B[size(A, 2),:]=[0.0,1.0; 1.0,1.0; -1.0,0.0]  annotation(Dialog(group="system matrices",enable = not systemOnFile));
  input Real C[:,size(A, 1)]=[0.0,1.0,1.0; 1.0,1.0,1.0]  annotation(Dialog(group="system matrices",enable = not systemOnFile));
  input Real D[size(C, 1),size(B, 2)]=[1.0,0.0; 0.0,1.0]  annotation(Dialog(group="system matrices",enable = not systemOnFile));

  output Boolean ok;

protected
  StateSpace ss=if systemOnFile then
      Modelica_LinearSystems2.StateSpace.Import.fromFile( fileName) else StateSpace(
      A=A,
      B=B,
      C=C,
      D=D);

algorithm
  Modelica_LinearSystems2.StateSpace.Plot.bodeMIMO(    ss);
  ok := true;

  annotation (interactive=true, Documentation(info="<html>
This example demonstrates the construnction of a zeros-and-poles-transfer-function-matrix from a MIMO state space representation and �plots the Bode diagrams with automatic determination of the frequency range to plot
</html>"));
end plotBodeMIMO;
