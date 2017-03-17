' Propeller Boe-Bot Receiver.spin
OBJ

  system : "Propeller Board of Education"        ' System configuration
  time   : "Timing"                              ' Time and delay convenience methods
  wav    : "jm_wav_player"                       ' Wav player
  pst    : "Parallax Serial Terminal Plus"
  pin    : "Input Output Pins"

CON
                                                 ' I/O pin names

  A_LF  = 26,  A_RT  = 27                        ' Audio left, right

  #22,  SD_DO, SD_CLK, SD_DI, SD_CS              ' PropBOE microSD P22...P25


DAT

' List of I/O pin connections required by wav player's start method
wavIO long A_LF, A_RT, SD_DO, SD_CLK, SD_DI, SD_CS
file1 byte "Years.wav" , 0

file2 byte "Audio.wav" , 0



PUB Go | status, key                             ''Code starts - top object top method
                                                 
  system.Clock(80_000_000)                       ' Set system clock to 80 MHz
  
  repeat
    status := wav.Start(@wavIO)                  ' Start wav player
    if (status == 0)                             ' If started
      pst.Str(string("WAV STARTED"))             ' Display "WAV STARTED" 
      pin.High(4)                                ' Set pin 4 to always output logic 1
      quit                                       ' Quit the loop
    else                                         ' If not started
      time.Pause(250)                            ' Wait 1/4 second & try again                      

wav.Set_Volume(80, 80)                           ' Set wav player volume 
time.Pause(4000)                         
                                                                                                           
repeat

  if (pin.In(5))==1                               ' If pin in 5 is logic 1                                   
                                                                  '            
      if (wav.playing == false)                    'And, If nothing playing,             
              pst.Str(string("STARTING VOICE"))   ' Display "Starting Voice"
              wav.play(string("Audio.wav"), 1)    ' Starts Audio 
              quit                                ' play Audio.wav one time  

              