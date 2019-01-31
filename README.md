# NodeJS Express Web Service application

## Application components
- Git repository in order to store Webs Service source code
- Container registry where to push Web Service image

## Scenario
1. The application creates a Git repository where to store webservice source code
2. The application creates a Docker registry and pushes there webservice image
3. Application creates kubernetes custom resources for Jenkins operator to create Pipeline and start build of webservice
4. Application users get access to the links to their Web Service, Jenkins Pipeline and Git repository through the Control plane (Stacks > Applications > List)
