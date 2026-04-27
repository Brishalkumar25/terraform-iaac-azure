# terraform-iaac-azure# azure-terraform-nginx

Below are the resources created for the project:

1. Virtual machine : 2 Linux virtual machines are created with high availability zone. It takes the password from the keyvault secret which is created manually in KV. It can be replaced with VM scale set as well. Traffic will be distributed between both VMs.

2. Key Vault : It store the secret for the DB & VMs and certificate (self signed or digicert) for app GW. 

3. Virtual network and Subnet : Vnet with range /16 cidr is created along with 3 subnets for hosting VM (web), DB and application gateway. 

4. Azure SQL : SQL server and dedicated databse is deployed so that VM can get the data from DB. however, for this project DB is required to store the application logs and session.

5. Application Gateway: It is used for the inbound traffic handling, virtual machine is used as a backend pool. User can hit the public url of application gateway to reach the application hosted in VM.

6. Resource group: A single RG with lock has been created to accumulate all the resources.

7. Location: All resources are deployed in sweden central region

8. NSG: Network security group associated with web subnet (hosting VMs) with default deny rule and a inbound rule for traffic from application gateway to VM

9. User identity: Its created to use in a) SQL server as Microsoft suggest to use MS entra auth with user identity b) with application gateway. however, we can use 2 seperate managed identity if required.

10. Private endpoint: Private traffic flow is managed via pep, and associated with Keyvault & SQL. Private dns zone is created privatelink.database.windows.net for SQL, and privatelink.vaultcore.azure.net for the key vault. The vnet is linked with both the private dns zone and pep is created as A record from terraform.

11. Script: nginx installation script is created and deployed in both VM.

12. Route and route table : All the outbound traffic to anywhere 0.0.0.0/0 should be travel via azure firewall as next hop.

Security

1. Internal traffic is secured via private endpoint, secrets and certificated cannot be accessed unless from private endpoint. 
2. NSG is created so that inbound and outbound traffic is restricted
3. WAF is used for the internet inbound traffic and suspicious threat.
4. Route table and route is associated so that traffic from DB and web subnet is flow from the firewall (NVA), based on no trust policy.


RBAC 
Service principal need owner role on subscriotion, key vault administrator on KV

