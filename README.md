Setup:
* Run ./update-dockerconfig.sh on gLinux machine

Demo:
1. Run gen-key.sh
1a. REDEPLOY CHAINS, or just delete the pod so the secret is mounted in.
2. Mention I already have auth set up
3. Start the TaskRun
4. Check controller logs for TaskRun to show up
5. Verify with the public key we have