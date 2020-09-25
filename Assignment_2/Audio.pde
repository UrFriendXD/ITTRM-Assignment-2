class Audio {
  //declare everything we need to play our file and control the playback rate
  TickRate speedControl;
  FilePlayer musicPlayer;
  AudioOutput out1;
  
  //Change the value of music here with a sound file in same folder
  String music = "Happy.mp3";

  Audio()
  {
                               
    // Opens the file and puts it in the "play" state.                           
    musicPlayer = new FilePlayer( minim.loadFileStream(music) );
  
    // loop forever
    musicPlayer.loop();
  
    // playback speed of 1
    speedControl = new TickRate(1.f);
  
    // fetch a line out of minim
    out1 = minim.getLineOut();
  
    // feed the file player through the TickRate to the output.
    musicPlayer.patch(speedControl).patch(out1);

  }
   
  void draw()
  {
    // change the speed and pitch control value based on mouse position
    speed = map(mouseX, 0, width, 0.8f, 1.5f);
  
    speedControl.value.setLastValue(speed);
  }
  
}
