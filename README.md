# wso2-all-in-one
An all in one installation for exercising WSO2 cluster testing.

Uses vagrant + ubuntu + puppet, so it will keep the changes away from your desktop. Just clone this repository to your computer and select one of the deployment options.

WSO2 is a middleware used in development of web services in SOA scenarios. MySQL is the database choice for this exercise. During the startup, the DB is created and provisioned. Finally, the puppet run will deploy the middleware and its configuration to the server. The machine was sized 8GB to host several 256/512MB JVMs. 

From a security perspective, the puppet scripts are sanitizing the VM in the similar way we would sanitize a production environment, making the development/testing machines closer to a production one. 

From a testing perspective, TravisCI runs periodically a test on each commit.

## Instructions
 - Local machine via vagrant (OSX, Windows) (which will run puppet + docker)
 	```
 	vagrant up
 	```

## Problems found (and how they were mitigated)
 - **Vagrant can't mount folders**: See here (https://github.com/slaterx/vagrant-wso2-dev-srv/blob/master/_downloads/vagrant-vboxguestadditions-workaroud.md) for manually fixing this issue.

## Improvements
* **Load Balancing**: This exercise has no in-house load balancing capability. On one hand, it would be better to have it available for earlier testing, although this would also add more complexity to the overall solution. On the other hand, when getting closer to production, it's very likely the load balancing role would be played by a component outside of this solution, either because it would be in a shared tenancy, or because its management may belong to another department for which we couldn't have control.