# martaneta-iot

kubectl --kubeconfig kubeconfig patch storageclass openebs-hostpath -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'