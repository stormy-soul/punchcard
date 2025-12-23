<div align="center">
<pre>                                                      
                             █                               █ 
 ▄▄▄▄   ▄   ▄  ▄ ▄▄    ▄▄▄   █ ▄▄    ▄▄▄    ▄▄▄    ▄ ▄▄   ▄▄▄█ 
 █▀ ▀█  █   █  █▀  █  █▀  ▀  █▀  █  █▀  ▀  ▀   █   █▀  ▀ █▀ ▀█ 
 █   █  █   █  █   █  █      █   █  █      ▄▀▀▀█   █     █   █ 
 ██▄█▀  ▀▄▄▀█  █   █  ▀█▄▄▀  █   █  ▀█▄▄▀  ▀▄▄▀█   █     ▀█▄██ 
 █                                                             
 ▀                                                             
Thing that copies my End-4/illogical-impulse tweaks to yours..
https://github.com/stormy-soul/punchcard                  v1.0
</pre>
</div>

`punchcard` is a script that copies over my end4 tweaks onto your device. it's not something magical, it literally just overwrites necessary files with what I provide. So if you want the dots themselves, dig around the `configs/` directory and copy over what you want!

## What it is
A thingamajig that just cp -a my_stuff your_stuff. But it does keep a backup over at `~/card-backup`, so if you ever wanna restore stuff, you can.It will also overwrite some hyprland configs, namely `general.conf` and `rules.conf` so your setup can look as shown in the screenshots, blur and all!

## Requirements
The script assumes you have illogical-impulse shell installed, plus:
- `hyprland` (obviously)
- `quickshell` (duh)
- Any [Nerd Font](https://nerdfonts.com) (for some icons)

_Note: I only ever tested this on arch with hyprland 0.52.2, so it aint guaranteed to work. You can just copy what you need manually too y'know!_

## Installation
It's quite easy
- You just clone this repo by running `git clone https://github.com/stormy-soul/punchcard`
- Go into that cloned directory and run `./patcher.sh help`

## Screenshots
<img width="1918" height="1078" alt="home" src="https://github.com/user-attachments/assets/e38cc73d-b601-4efb-801b-2ec8416c3a19" />
<img width="1918" height="1078" alt="sidebar" src="https://github.com/user-attachments/assets/b062bcb2-c97b-4507-a795-acb9447faff3" />


## Usage
```bash
Usage: ./patcher.sh <command>

Commands:
  apply     Backup and apply configs
  restore   Restore last backup
  help      Show this help message
```