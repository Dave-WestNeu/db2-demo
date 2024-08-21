# DB2 Demo

This repo
- Stands up a super small AKS cluster
- Deploys a pod on the k8s cluser with a demo `DB2` instance and a sample database
- Returns connection info so you can connect to what you deployed with a `DB2` client or program calls

## prereqs
Azure Developer CLI (`azd`)

## Stand up infra
$ azd auth login
$ azd init # (select use existing code and make an env called `sbx` or whatever you choose)
$ azd up