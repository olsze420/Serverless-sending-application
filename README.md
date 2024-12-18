2. Serverless Sending Application (sandbox usability only) 
a. S3 - static web for access to the app
b. API Gateway - handling PUT request from the website to Lambda
c. Lambda Function - Sending email/sms and passing information from rest API
d. Step Function - based on information from lambda invoking one of the functions
e. SNS & SES - sending email or sms
![enter image description here](https://cloudisfree.com/projects/project-2/part-1/images/infrastructure.png)

## S3 website used for this project is from Project1 - static_web_terraform
