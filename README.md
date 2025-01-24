Repo for GoExperts backend sources without a pipeline. You need to construct a new one.

npm i



npm run build


npm run start



.env


docker build -t your-dockerhub-username/your-app-name:1.0 .








1. The resources for deployment the frontend should be first constructed by IaC tools like Terraform, CloudFormation, Ansible etc. 
2. **DO NOT** operate on the `main` branch directly. Checkout your own branch instead, e.g. feature/new_pipeline
3. Compose your pipeline file and put them into `cicd`
4. Build up a pipeline on cicd platforms like Jenkins, Travis CI, Github Actions and have a test.

BTW:
You may realize the backend service by simply an AWS EC2 instance, or to a complexy architecture based on K8s like GKE/AKS/EKS or ECS as long as you like, but watch your billing. 


**IMPORTANT**:
The `.env` file contains some secrets which are concealed. You need to contact JR Academy to get the information, or the backend service will work improperly.

* [澳洲IT](https:jiangren.com.au/) — 匠人学院，找工作，实习，工作内推，全栈班，DevOps学习
