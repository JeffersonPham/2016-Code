#pragma config(Sensor, in1,    leftSensor,     sensorPotentiometer)
#pragma config(Sensor, in2,    rightSensor,    sensorPotentiometer)
#pragma config(Sensor, dgtl1,  touch,          sensorTouch)
#pragma config(Motor,  port2,           leftMotor,     tmotorVex269_MC29, openLoop)
#pragma config(Motor,  port3,           rightMotor,    tmotorVex269_MC29, openLoop, reversed)
//*!!Code automatically generated by 'ROBOTC' configuration wizard               !!*//

task main()
{
	while(1==1)
	{
if(SensorValue(touch)==1)
{
setMotor(port2,50);
setMotor(port3,50);
}
else
setMotor(port2,-50);
setMotor(port3,-50);

}}
