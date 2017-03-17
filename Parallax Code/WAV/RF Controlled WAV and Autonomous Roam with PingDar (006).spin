' Propeller Boe-Bot Receiver.spin  

OBJ

  system : "Propeller Board of Education"        ' System configuration
  time   : "Timing"                              ' Time and delay convenience methods
  xb     : "XBee_Object"                         ' XB wireless communication
  wav    : "jm_wav_player"                       ' Wav player

CON
                                                 ' I/O pin names
  XB_DO = 4,   XB_DI = 3                         ' XBee transmit and receive

  A_LF  = 26,  A_RT  = 27                        ' Audio left, right

  #22,  SD_DO, SD_CLK, SD_DI, SD_CS              ' PropBOE microSD P22...P25

DAT

' List of I/O pin connections required by wav player's start method
wavIO long A_LF, A_RT, SD_DO, SD_CLK, SD_DI, SD_CS   

PUB Go | status, key                             ''Code starts - top object top method
                                                 
  system.Clock(80_000_000)                       ' Set system clock to 80 MHz
  xb.start(XB_DO, XB_DI, 0, 9_600)               ' Start XBee object
  time.pause(100)                                ' 1/10 second delay

  repeat
    status := wav.Start(@wavIO)                  ' Start wav player
    if (status == 0)                             ' If started
      quit                                       ' Quit the loop
    else                                         ' If not started
      time.Pause(250)                            ' Wait 1/4 second & try again                      

  wav.Set_Volume(80, 80)                         ' Set wav player volume
      
  repeat                                         ' Main loop
    if (key := xb.RxCheck) > 0                   ' If incoming character, copy to key
      case key                                   ' & evaluate on case-by-case basis
        "1":                                       
          if (wav.playing == false)              ' If nothing playing
            wav.play(string("crazy.wav"), 1)     ' play crazy.wav one time      
        "2":
          if (wav.playing == false)              ' If nothing playing, 
            wav.play(string("levels.wav"), 1)    ' play levels.wav one time 
        "3":
          if (wav.playing == false)              ' ...etc.
            wav.play(string("somebody.wav"), 1)         
        "4":
          if (wav.playing == false)
            wav.play(string("dontstop.wav"), 1)         
        "5":
          if (wav.playing == false)
            wav.play(string("feeling.wav"), 1)         
        "R", "r":                                ' Start robot navigation
          ifnot navcog                           ' Dont start it twice
            navCog := cognew(RobotNav, @navStack) + 1  ' Remember cog it started in
        "S", "s":                                       
          if navcog
            drive.Stop                           ' Use drive to stop servo signal cog
            cogstop(navCog~ -1)                  ' Stop robot navigation cog
        "X", "x":                                ' Stop current wave
          wav.kill                               

OBJ

  drive         : "PropBOE-Bot Servo Drive"      ' Propeller Boe-Bot servo control
  pingdar       : "Ping)))Dar"                   ' Control turret, measure w. Ping

CON

  PING = 19, TURRET = 17                         ' Ping))) & turret servo I/O labels

DAT

  ' Ping)))Dar object requires number of elements, followed by a list of angles
  ' in ascending order, a list of cm minimum distances, and a list that orders
  ' when the Ping))) should be pointed in each direction.
  elements long    11
  angles   long   -90,  -72,  -54,  -36,  -18,  00,  18,  36,  54,  72,  90
  space    long    22,   22,   27,   27,   37,  37,  37,  27,  27,  22,  22
  order    long     0,   10,    1,    9,    2,   8,   3,   7,   4,   6,   5 
  
VAR

  long navCog, navStack[128]                     'Stack space robot navigation cog 

PUB RobotNav                                     '' Robot navigation method

  drive.Rampstep(8, 8)                           ' Max speed signal change per 20 ms
  drive.Wheels(100, 100)                         ' Wheels full speed forward
  pingdar.Init(PING, TURRET, @elements)          ' Initialize Ping)))Dar object

  ' Main loop sets wheels full to speed forward, then checks distance at the next angle
  ' in the list with pingdar.Advance.  If it's less than the maximum allowed cm space
  ' at that angle, then it just keeps going forward.  If not, then it directs the
  ' Ping))) 0-degrees and then rotates the robot until it sees an opening.

  repeat                                         
    drive.Wheels(100, 100)    
    if pingdar.Advance < (pingdar.Space(pingdar.Angle))
      if pingdar.Angle =< 0
        drive.Wheels(-100, 100)
        repeat until pingdar.Distance(0) > pingdar.Space(0)  
      else 
        drive.Wheels(100, -100)
        repeat until pingdar.Distance(0) > pingdar.Space(0)  
      