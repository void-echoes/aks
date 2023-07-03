<h3>Spark on AKS</h3>
<h5>Steps Followed in AKS:</h5>

	1. Create the Spark Docker file 
	2. Build the image in your local (docker build image_name:tag_name)
	3. Push the image to your ACR (az login -> az acr login -> docker tag with the context of acr_url -> docker push to the URL  (tagging helps docker to set the ACR) 
	4. Install aks cli (az aks install-cli)
	5. Set the path to your env variables for K8s context (it starts pointing to the kube config) 
	6. Retrieve the credentials of the present AKS cluster and set them in the kube config (az aks get-credentials --resource-group AKS-DEV --name sparkdevtest ) 
	7. Create a Service Principal from the portal, and add it to the AKS cluster. (to create an SP, -> aad->app registration-> new registration | copy the client id and the tenant id after creation ) 
	8. Add a role for the SP to the ACR( In the portal, ACR-> IAM -> Add Role Assignments -> Service Principal -> Contributor Access -> Apply
	9. Connecting AKS Cluster to ACR via SP ( az aks update -n sparkdevtest -g AKS-DEV --attach-acr acrdevd )
	10. Create a Deployment with the deployment.yaml ( kubectl apply -f spark-deployment.yaml)
	11. Check if the pods are up (kubectl get pods) 
	12. Expose the port of spark to access the UI (kubectl port-forward <pod_name> 4040:4040)

<h5> Read more about :</h5>

	1. Pools
	2. Namespace
	3. System Node Pool 

<h5> Bits :</h5>
	
 	1. There is usually an infrastructure RG created along the cluster RG which holds the infra details of the cluster

<h5>Essential commands in Kubeclt:</h5>(to be updated) 
	
 	1. kubectl describe pod spark-job-858dd98915d1d7f0-driver
	2. kubectl auth can-i create pod
	3. kubectl get rolebinding default-pods-rolebinding -n default
