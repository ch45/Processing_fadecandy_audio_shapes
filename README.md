
Processing fadecandy audio shapes
---------------------------------

Currently does something but a bit crap...

Cmd Line
--------

rem Windows

    path %PATH%;D:\Apps\processing-3.5.4
    processing-java.exe --sketch=%cd%\Processing_fadecandy_audio_shapes --run exit=60

\# raspi (vnc)

    processing-java --sketch=./Processing_fadecandy_audio_shapes --run exit=60

\# raspi (ssh i.e. headless)

    xvfb-run processing-java --sketch=./Processing_fadecandy_audio_shapes --run exit=60
