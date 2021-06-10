To run this demo, you'll need to install:
* [cosign](https://github.com/sigstore/cosign)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)

Start from scratch:

```
./cleanup.sh
```

Create a new keypair for signing, this should save your public key `cosign.pub` to disk
```
./gen-keys.sh
```

Create the Task:
```
kubectl apply -f kaniko.yaml
``` 

Create the TaskRun:
```
kubectl create -f taskrun.yaml
```

Use `tkn taskrun logs <taskrun name>` to track progress -- this is where you should see some cool SPIRE JWT-SVID logs for each container!

Once the TaskRun is complete, you can verify the image was signed by running:

```
kubectl logs -n tekton-chains deploy/tekton-chains-controller
```

You're looking for a recent log that says something like `Successfully uploaded signature`!


Next, verify the image was signed by Chains against your public key!
```
cosign verify -key cosign.pub gcr.io/ref-arch-wg/kaniko-chains-demo

Verification for gcr.io/ref-arch-wg/kaniko-chains-demo --
The following checks were performed on each of these signatures:
  - The cosign claims were validated
  - The signatures were verified against the specified public key
  - Any certificates were verified against the Fulcio roots.
```


Finally, verify the TaskRun was signed as well:

```
TASKRUN=<TaskRun name> ./provenance.sh

Starting validation for TaskRun kaniko-run-m594f
cosign verify-blob -key cosign.pub -signature ./signature ./payload 
Verified OK
```

This should create a `[TASKRUN NAME].yaml` file which you can look through to see the signature and payload as annotations.
