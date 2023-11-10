resource "shoreline_notebook" "kubernetes_kernel_module_loaded_in_pod" {
  name       = "kubernetes_kernel_module_loaded_in_pod"
  data       = file("${path.module}/data/kubernetes_kernel_module_loaded_in_pod.json")
  depends_on = [shoreline_action.invoke_delete_pod,shoreline_action.invoke_install_configure_start_falco]
}

resource "shoreline_file" "delete_pod" {
  name             = "delete_pod"
  input_file       = "${path.module}/data/delete_pod.sh"
  md5              = filemd5("${path.module}/data/delete_pod.sh")
  description      = "Remove the pod from the Kubernetes cluster to prevent further malicious activities."
  destination_path = "/tmp/delete_pod.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "install_configure_start_falco" {
  name             = "install_configure_start_falco"
  input_file       = "${path.module}/data/install_configure_start_falco.sh"
  md5              = filemd5("${path.module}/data/install_configure_start_falco.sh")
  description      = "Consider using a security tool such as Falco or Sysdig to continuously monitor the Kubernetes environment for suspicious activities."
  destination_path = "/tmp/install_configure_start_falco.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_delete_pod" {
  name        = "invoke_delete_pod"
  description = "Remove the pod from the Kubernetes cluster to prevent further malicious activities."
  command     = "`chmod +x /tmp/delete_pod.sh && /tmp/delete_pod.sh`"
  params      = ["NAMESPACE","POD_NAME"]
  file_deps   = ["delete_pod"]
  enabled     = true
  depends_on  = [shoreline_file.delete_pod]
}

resource "shoreline_action" "invoke_install_configure_start_falco" {
  name        = "invoke_install_configure_start_falco"
  description = "Consider using a security tool such as Falco or Sysdig to continuously monitor the Kubernetes environment for suspicious activities."
  command     = "`chmod +x /tmp/install_configure_start_falco.sh && /tmp/install_configure_start_falco.sh`"
  params      = []
  file_deps   = ["install_configure_start_falco"]
  enabled     = true
  depends_on  = [shoreline_file.install_configure_start_falco]
}

