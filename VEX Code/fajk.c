#pragma config(Motor,  port2,           bleh,          tmotorVex269_MC29, openLoop)
#pragma config(Motor,  port3,           bleh2,         tmotorVex269_MC29, openLoop)
#pragma config(Motor,  port4,           bleh3,         tmotorVex269_MC29, openLoop)
//*!!Code automatically generated by 'ROBOTC' configuration wizard               !!*//

task main()
{
//	wait(5);
	//open
//setMotor(port2, -27);
//setMotor(port3, 30);
//wait(1);
//stopAllMotors();
	//close
//setMotor(port2, 27);
//setMotor(port3, -30);
//wait(.2);
//stopAllMotors();

//up
setMotor(port2, 127);
wait(3);
stopAllMotors();
//down
//setMotor(port2, 40);
//wait(1);
//stopAllMotors();

}
