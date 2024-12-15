Make the Script Executable
chmod +x setup_debian_server.sh
./setup_debian_server.sh

###  Take ThreadDumps
Take thread dump from kubernetes 
kubectl exec -n default <pod-name> -- ps aux | grep java
kubectl exec -n  default "$POD_NAME" -- jstack "$PID" > threadump1.txt

### Connect the GKE from VM

gcloud auth login --no-launch-browser

1.This will print a URL in the terminal.
2.Copy and paste the URL into a browser on a machine with GUI access.
3.Follow the authentication flow and copy the generated authentication code.

---Set the Project---
gcloud config set project artful-talon-443506-d1
----Connect the GKE----
gcloud container clusters get-credentials cluster-1 --zone us-central1-c --project artful-talon-443506-d1
