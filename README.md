# PSHuntressAPI
PowerSell API for Huntress (Source reference: https://api.huntress.io/docs)

To use these scripts do the following steps:
1) Copy the .PS1 files to a location where you want to run the scripts from, for example: ```D:\Huntress```
2) Copy the ```Huntress.txt``` file to a different location, this contains your API credentials so it needs to be kept safe!
3) Edit the ```Huntress.txt``` file and replace the "h1=" line with your API Key. It should look something like: ```h1=hk_11aa22bb33cc```
4) Edit the ```Huntress.txt``` file and replace the "h2=" line with your API Secret. It should look something like: ```h2=hs_4a5b6c7d8e```
5) Save the text file.

Open PowerShell and navigate to the directory with the .PS1 files, example: ```cd D:\Huntress```
Run the command: ```Huntress-ListAgents```
If everything has worked correctly you should see a list of all agents appear in the output.

Working functions you can use are:
```
Huntress-ListAccounts                  # List all Accounts
Huntress-ListOrgs                      # List all Orgs
Huntress-GetOrg -orgId 123456          # Get data for Organization ID: 123456
Huntress-ListAgents                    # List all Agents
Huntress-GetAgent -agentId 123456      # Get data for Agent ID: 123456
Huntress-ListSignals                   # List All Signals (This needs more params to allow filtering!)
Huntress-GetSignal -signalId 123456    # Get data for Signal ID: 123456
Huntress-BillingReports                # List all Billing Reports for the account
Huntress-SummaryReports                # List all Summary Reports for the account
```
