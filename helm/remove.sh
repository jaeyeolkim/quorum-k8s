helm uninstall validator-1 validator-2 validator-3 validator-4 validator-5 genesis
k delete rs,deploy,po,job,cm,pv,pvc,secret --all
k delete ns quorum