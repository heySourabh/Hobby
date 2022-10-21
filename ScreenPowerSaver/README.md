# Description
This program overlays all idle display screens with black window to save power.
This tool saves power by blacking out idle screens when you are using only few of the multiple displays.

# Why?
I love using multiple displays (generally three) when working. However, I just use one or two most of the time. 
It is therefore a waste of power to keep all the screens on.

# How it works
1. After every short while, the code checks the mouse location and updates idle screen status.
2. If the mouse is not in a display area for considerable time (more than a minute)
    - an overlay black background screen fills the idle screen.
3. If the mouse moves into an idle display, the overlay screen is removed.

The CPU usage of running this program is negligible. It uses about 0.02% of CPU on my machine (using Java 18). 
I believe it largely offsets the power cost of keeping multiple screens running all the time.
Use this code if you love using multiple screens but want to save power!

Developer: Sourabh Bhat (heySourabh@gmail.com)
