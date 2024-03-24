resource "terraform_data" "istio" {
  provisioner "local-exec" {
    when = create
    command = "istioctl install -y --set profile=${var.profile} --set values.cni.cniConfDir=/var/snap/microk8s/current/args/cni-network --set values.cni.cniBinDir=/var/snap/microk8s/current/opt/cni/bin -f ./templates/meshconfig.yaml"

  }

  provisioner "local-exec" {
    when = destroy
    command = "istioctl uninstall -y --purge"
  }
}
