# CanyonCreekLidar

hello

Normal GitHub setup

- Make a zip just in case things go wrong
  - git init
  - git remote add origin https://github.com/gearsmotion789/robot.git
  - git fetch
  - git checkout master
  - git pull origin master
  - git add .
  - git commit -m "stuff"
  - git push origin master

Github info

- Prereq
  - You have to been in the same folder that was "Cloned" from this repo
  - OR you can do
    - git init
  - If you see "double folder icon" instead of "single folder" icon, do below, then [git init]
    - rm -rf .git
- Add Repo
  - git remote add LeapRobot https://github.com/gearsmotion789/Leap-Motion-Robot-Arm.git
- Remove Repo
  - git remove rm LeapRobot
- Push
  - (Prereq)
    - must do below to get updated repo before pushing your own folder (so save a zip backup!)
      - git pull origin master
  - git add .
  - git commit -m "Update"
  - git push LeapRobot master
    - if you cloned from this repo, then run
      - git push origin master (if you didn't follow "Add Repo")
    - if you get error "Changes not staged for commit:"
      - git add [files you want to track]
- Pull
  - git fetch
  - git checkout master
  - git pull LeapRobot master
