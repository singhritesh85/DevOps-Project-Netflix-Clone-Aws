# DevOps-Project-Netflix-Clone-Aws
![image](https://github.com/user-attachments/assets/8f077d3b-350e-4d22-8743-21bc877ccbfa)

For Monitoring Jenkins using Prometheus and Grafana the plugin prometheus metrics has been installed as shown in the screenshot attached below.
![image](https://github.com/user-attachments/assets/8a29aedd-bd9a-4c72-96fe-ad0fbe99f983)
After installation of prometheus metrics plugin restart the Jenkins as shown in the screen attached below.
![image](https://github.com/user-attachments/assets/c5085d9d-5f01-4f00-9013-1d79ba39b6ff)
![image](https://github.com/user-attachments/assets/cecc4d03-0210-4602-96dd-efc0cba3e57b)
Now prometheus metrics plugin will be shown in the list of installed plugins as shown in the screenshot attached below.
![image](https://github.com/user-attachments/assets/2080d903-7f18-4761-97c0-1d76010897a3)

Configuration file for prometheus **/etc/prometheus/prometheus.yml** is as shown in the screenshot attached below.
![image](https://github.com/user-attachments/assets/95a77272-f676-4298-9fa2-b6a0c8f80608)

Targets of Prometheus is as shown in the screenshot attached below.
![image](https://github.com/user-attachments/assets/fb629d93-3534-4d53-9272-80a3d5e8bd4c)
![image](https://github.com/user-attachments/assets/1f2b0480-a2e8-47b4-a083-45eb98e2f966)

Prometheus is used as a Data Source for Grafana is as shown in the screenshot attached below.
![image](https://github.com/user-attachments/assets/37bae130-b1a0-488e-8780-be456f24f36a)
![image](https://github.com/user-attachments/assets/176ac352-8378-4372-b39b-fc37d9062e49)

Dashboard has been imported using the Code 1860(for Node Exporter) and 9964(for Jenkins and Jenkins Job) is as shown in the screenshot attached below.
![image](https://github.com/user-attachments/assets/a85260b5-f231-487b-9eeb-732589742bfb)
![image](https://github.com/user-attachments/assets/cd4d6d8b-c145-47b8-9f64-ef3cd0386218)

Install SonarQube Scanner plugin and do its configuration as shown in the screenshot attached below.
![image](https://github.com/user-attachments/assets/2a3e6d91-9e8f-49f0-a5b8-067e1eb1f7cb)
![image](https://github.com/user-attachments/assets/37475b4e-a5fe-45a2-a622-9554ce9bc65a)

Do the Email configuration in Jenkins as shown below.
![image](https://github.com/user-attachments/assets/ef3894fd-f9bc-4692-a6b1-24bef7fd9694)
![image](https://github.com/user-attachments/assets/53a2994a-6cb8-4cb0-bb06-bcb37fe463d0)

After Running the Jenkins Job Successfully, the screenshot of SonarQube, ArgoCD is as shown below.
![image](https://github.com/user-attachments/assets/4ab7c2a7-25f1-4635-b255-0c152498936a)
![image](https://github.com/user-attachments/assets/0764612a-6cef-444a-9319-38d193a12d50)

The entry for Route53 is as shwon below.
![image](https://github.com/user-attachments/assets/67f29bb3-acf7-4b3d-9ae9-cfa1d67e1676)

Finally you can access the Application as shown in the screenshot attached below.
![image](https://github.com/user-attachments/assets/711d0420-4b98-4807-9a60-3474578fff9b)

After execution of Jenkins Job, email will be triggered to group email id for notification of Jenkins Job Completion Status.
![image](https://github.com/user-attachments/assets/ba76aebd-931f-418b-ab66-861d3734844e)
![image](https://github.com/user-attachments/assets/d190b2a4-20a9-4f80-8492-ce73de26a818)


<br><br/>
<br><br/>
<br><br/>
<br><br/>
<br><br/>
```
source Code:- https://github.com/singhritesh85/DevSecOps-Project.git

Helm Chart:-   https://github.com/singhritesh85/helm-repo-for-netflix-clone.git
```
<br><br/>
<br><br/>
<br><br/>
```
Reference:-  https://muditmathur121.medium.com/devsecops-netflix-clone-ci-cd-with-monitoring-email-990fbd115102
```
