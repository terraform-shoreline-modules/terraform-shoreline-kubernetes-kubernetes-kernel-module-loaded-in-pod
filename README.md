
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kubernetes - Kernel Module Loaded in Pod.

This incident type is related to detecting the loading of kernel modules within a Kubernetes pod. This alert is usually triggered when kernel modules are loaded within a pod, which could potentially indicate an attack. The presence of a kernel module in a pod can allow attackers to gain privileges, escalate their access, and perform malicious activities. Therefore, this alert is critical in identifying such security threats and taking necessary actions to prevent them.

### Parameters

```shell
export POD_NAME="PLACEHOLDER"
export MODULE_NAME="PLACEHOLDER"
export NAMESPACE="PLACEHOLDER"
```

## Debug

### 1. List all pods in the default namespace

```shell
kubectl get pods
```

### 2. Get the logs for a specific pod

```shell
kubectl logs ${POD_NAME}
```

### 3. List all containers running in a pod

```shell
kubectl describe pods ${POD_NAME} | grep -A 1 "Containers:"
```

### 4. Check if any kernel modules are loaded in the container

```shell
kubectl exec ${POD_NAME} -- cat /proc/modules | grep ${MODULE_NAME}
```

### 5. Check the container's security context

```shell
kubectl describe pod ${POD_NAME} | grep -A 2 "Security Context:"
```

### 6. Check the pod's security policy

```shell
kubectl get podsecuritypolicy
```

## Repair

### Remove the pod from the Kubernetes cluster to prevent further malicious activities.

```shell
#!/bin/bash

# Set the variables
NAMESPACE=${NAMESPACE}
POD_NAME=${POD_NAME}

# Delete the pod
kubectl delete pod $POD_NAME -n $NAMESPACE

# Check if the pod is deleted successfully
if kubectl get pod $POD_NAME -n $NAMESPACE &> /dev/null; then
  echo "Error: $POD_NAME is still running in $NAMESPACE namespace."
  exit 1
else
  echo "Success: $POD_NAME is deleted from $NAMESPACE namespace."
fi
```

### Consider using a security tool such as Falco or Sysdig to continuously monitor the Kubernetes environment for suspicious activities.

```shell
#!/bin/bash

# Install Falco
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y && apt-get install -y falco

# Configure Falco
cat <<EOF | tee /etc/falco/falco.yaml
falco:
  program_output:
    enabled: true
    keep_alive: false
    program: "/usr/bin/logger -t falco -p local3.info"
  rules_file:
    - /etc/falco/falco_rules.yaml
EOF

# Start Falco
systemctl enable falco && systemctl start falco
```