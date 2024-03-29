# Robocorp Developer Training - Certificate level II: Build a robot

The tasker for this course can be found here: https://robocorp.com/docs/courses/build-a-robot

All the Robocorp courses available here: https://robocorp.com/docs/courses

(Styling the code will be done later as a separate exercise >.>)

![image](https://user-images.githubusercontent.com/52319409/146160902-b1c5a55c-c7e0-4e00-9477-9ad826d7ef2e.png)

# Notes to consider while running

This repository - for demonstration purposes - includes a vault.json file at root folder to allow for secrets being used in a local run. Stashed as a secret is the address to the robot ordering website.

When the robot is run, assistant asks for the location for a list of orders to be used as source material. The given location for the material in this course is:

https://robotsparebinindustries.com/orders.csv

# Template: Standard Robot Framework

Want to get started using [Robot Framework](https://robocorp.com/docs/languages-and-frameworks/robot-framework/basics) this is the simplest template to start from.

This template robot:

- Uses [Robot Framework](https://robocorp.com/docs/languages-and-frameworks/robot-framework/basics) syntax.
- Includes all the necessary dependencies and initialization commands (`conda.yaml`).
- Provides a simple task template to start from (`tasks.robot`).

## Learning materials

- [All docs related to Robot Framework](https://robocorp.com/docs/languages-and-frameworks/robot-framework)
