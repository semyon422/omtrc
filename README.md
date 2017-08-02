# omtrc
osu!mania timerate changer  

changes PreviewTime, AudioFilename, Version, BeatmapID, Bookmarks, Events, TimingPoints, HitObjects

```
Usage: lua omtrc.lua [OPTIONS]

  -b, --beatmap              set path to .osu file  
  -t, --timerate             set timerate (e.g. 1.1)  
  -i, --interactive          interactive move
  -s, --starRate             enables starrate calculation

This script creates a new map at the same mapset.
```

Script installation:  
1) install lua for windows
2) locate omtrc folder somewhere  
3) locate sox (with lame and mad libraries) folder in omtrc folder  
4) run configure.lua (it creates shell.bat and install.reg)
5) run install.reg
6) complete! Now right click on osu!mania beatmap and select omtrc, then enter time rate and wait, after finishing work press enter to close window and go to the game