
## End-to-End CI/CD Pipeline Deployment : Full setup guide !

### This project demonstrates a complete Cloud-Native CI/CD pipeline using:
1. **Terraform** Infrastructure provisioning
2. **Docker Hub** Container image registry
3. **Jenkins** CI/CD automation
4. **Kubernetes** Application deployment

The setup is cloud-agnostic and can run on self-managed or cloud Kubernetes clusters.

## Prerequisites

Before you begin, ensure you have:

- AWS Account with administrative access
- AWS CLI installed and configured
- Terraform installed
- kubectl installed
- SSH key pair created in AWS
- Docker Hub account

## Installation & Deployment

#### Step 1: Clone the Repository

```bash
git clone https://github.com/satishpathade/end-to-end-cloud-native-pipeline.git
cd end-to-end-cloud-native-pipeline
```

### Step 2: Configure AWS Credentials
`aws configure`
- Enter your AWS Access Key ID
- Enter your AWS Secret Access Key
- Default region: ap-south-1
- Default output format: json

### Step 3: Deploy Infrastructure
`cd ~/terraform/environments/dev`

- Initialize Terraform
`terraform init`

- Review the deployment plan
`terraform plan`

- Deploy infrastructure 
`terraform apply`

### Step 4: Setup Kubernetes Cluster (Manual)
Configure Kubernetes master node manually using kubeadm.
- SSH k8s master server
- Install and configure a container runtime
- Install Kubernetes components (kubeadm, kubelet, kubectl)
- Initialize the Kubernetes control plane using kubeadm
- Install a Pod Network (Calico) for pod communication across nodes

### Step 5: Join Worker Nodes
- Install Kubernetes node components (kubelet, kubeadm, kubectl)
- Join worker nodes using the master node token
- Verify all nodes are in Ready state in the cluster

### Step 6: Configure Jenkins
-Access Jenkins at 
    `http://<JENKINS_IP>:8080`

- Get initial password:
    SSH jenkin server
    `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

- Install suggested plugins

- Add credentials:
    - Docker Hub (username/password)
    - Kubeconfig (secret file)


### Step 7: Docker Registry Setup (Docker Hub)
Configure Docker Hub as the container registry for storing and distributing Docker images.

- **Login Docker Hub Account**

- **Create Docker Hub Access Token** COPY THE TOKEN IMMEDIATELY (shown only once)
- Access permissions: Read, Write, Delete
- Example token: `dckr_pat_a1B2c3D4e5F6g7H8i9J0k1L2`


- **Configure Docker Hub in Jenkins**  Add Docker Hub Credentials to Jenkins
1. Access Jenkins: http://<JENKINS_IP>:8080
2. Navigate to: Manage Jenkins → Credentials
3. Click: (global) domain
4. Click: Add Credentials
5. Configure:
   - Kind: Username with password
   - Scope: Global
   - Username: `your-dockerhub-username`
   - Password: `dckr_pat_a1B2c3D4e5F6g7H8i9J0k1L2`  (paste token)
   - ID: dockerhub-credentials
   - Description: Docker Hub Registry
6. Click: Create

### Step 8: Configure Kubernetes Access in Jenkins
1. Copy Kubeconfig from Master Node
    [kubeconfig file](kubernetes/configs/kubeconfig)

2. Add Kubeconfig to Jenkins
- Jenkins UI → Manage Jenkins → Credentials
-  Add Credentials
- Configure:
   - Kind: Secret file
   - File: Upload ~/kubeconfig-jenkins
   - ID: kubeconfig
   - Description: Kubernetes Config
- Click: Create


### Step 9: Test Docker from Jenkins Server
1. SSH into Jenkins Server
2. Verify Docker Access
3. Check Docker is running
    `sudo systemctl status docker`

4. Verify jenkins user is in docker group
    `groups jenkins`
-Expected output: `jenkins docker`

5. Give permission denied, add jenkins to docker group
    `sudo usermod -aG docker jenkins`
    `sudo systemctl restart jenkins`

6. Test Docker Login from Jenkins
- Test as jenkins user
    `sudo -u jenkins docker login -u <your-dockerhub-username>`

- Enter token when prompted
- Expected: `Login Succeeded`

**Docker Hub setup complete!**

### Step 10: Create CI/CD Pipeline Creation
**reate automated Jenkins pipeline for building, testing, and deploying applications.**

1. Write Jenkinsfile
    [Jenkins file](jenkinsfile)

2. Commit Changes to GitHub
    ```
    git add .
    git commit -m "Add Jenkins pipeline"
    git push origin main
    ```

3. Create Jenkins Pipeline Job 
    - enkins Dashboard → New Item
    - Enter name: `end-to-end-cloud-native-pipeline`
    - Select: Pipeline
    - click ok

4. Configure Pipeline
- General Section:
    - Check: GitHub project
    - Project url: https://github.com/satishpathade/end-to-end-cloud-native-pipeline

- Build Triggers:
    - Check: Poll SCM

- Pipeline Section:
    - Definition: Pipeline script from SCM
    - SCM: Git
    - Repository URL: https://github.com/satishpathade/end-to-end-cloud-native-pipeline
    - Branches to build: */main
    - Script Path: jenkinsfile

- Click: Save

### Step 11: Test Pipeline
- Manual Build
- Build Now
- Watch: Build History 
- Monitor the build logs

### Step 12: Configure Automatic Builds
- **GitHub Webhook**
1. GitHub repository → Settings → Webhooks
2. Add webhook:
   - Payload URL: http://<JENKINS_IP>:8080/github-webhook/
   - Content type: application/json
   - Events: Just the push event
3. Save


### Step 13: Deploy Application to Kubernetes
**Verify and test the deployed application on Kubernetes cluster.**

1. SSH k8s-master server
2. Check Pods
    `kubectl get pods`

- Expected output
    ```
    NAME                              READY   STATUS    RESTARTS   AGE
    devops-demo-app-abc123-xxxxx      1/1     Running   0          5m
    devops-demo-app-abc123-yyyyy      1/1     Running   0          5m
    devops-demo-app-abc123-zzzzz      1/1     Running   0          5m
    ```

- Check pod details
    `kubectl get pods -o wide`

3. Check Service
    `kubectl get svc `

- Expected output:
    ```
    NAME              TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
    devops-demo-app   NodePort   10.96.xxx.xxx   <none>        80:30080/TCP   10m
    ```

- Get detailed service info
    `kubectl describe svc <svc-name>`


### Step 14:  Access the Application
1. Get Access URL
    - Get worker node IPs
    `kubectl get nodes -o wide`

    - Application URL format:
    `http://<WORKER_NODE_PUBLIC_IP>:30080`

2.  Test Application Updates
    - Edit server.js
    - Commit and Push
    ```
    git add app/server.js
    git commit -m "Update to V2.0"
    git push origin main
    ```

### Step 15:  Rollback (If Needed)
1.  Check Rollout History
    `kubectl rollout history deployment/<name>`
    - Output:
     REVISION  CHANGE-CAUSE
     1         Initial deployment
     2         Update to V2.0
     3         Update to V3.0

2. Rollback to Previous Version
    `kubectl rollout undo deployment/<name>`

3. Rollback to specific revision
    `kubectl rollout undo deployment/<name> --to-revision=2`


### Architecture Overview
Developer → GitHub → Jenkins → Docker Hub → Kubernetes Cluster
