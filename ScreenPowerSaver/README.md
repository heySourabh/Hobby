# Description
This program overlays all idle displays with black screen to save power.
This tool saves power by blacking out idle screens when you are using only few of the multiple displays.

# Why?
I love using multiple displays (generally three) when working. However, I just use one or two most of the time. 
It is therefore a waste of power to keep all the screens on.

# How it works
1. After every short while, the code checks the mouse location and updates idle screen status.
2. If the mouse is not in a display area for a considerable amount of time (more than a minute)
    - an overlay black background screen fills the idle screen.
3. If the mouse is moved into an idle display, the overlay screen is removed and the screen's idle timer is reset.

The CPU usage of running this program is negligible. It uses about 0.02% of CPU on my machine (using Java 18). 
I believe it largely offsets the power cost of keeping multiple screens running all the time.
Use this code if you love using multiple screens but don't want to waste energy!

## Developer:
**Sourabh Bhat**  
Email: heySourabh@gmail.com  
website: https://spbhat.in  
