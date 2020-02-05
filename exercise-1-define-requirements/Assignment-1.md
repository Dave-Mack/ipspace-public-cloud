# Networking in Public Cloud Deployments Exercise 1
***

## Assignment 
Define requirements for a deployment of a new solution in a public clould

## Responses

*   What services should the public cloud deployment offer to the customers?
    * The deployment will provide a Web Application that will be hosted completely in the cloud.
    * It will be as classic three-tier web app with web servers, application servers and a database.
    
*   How will the users consume those services? Will they use Internet access or will you have to provide a more dedicated connectivity solution?
    * Users will consume the service via Internet access.
    
*   Identify the data needed by the solution you're deploying. What data is shared with other applications? Where will the data reside?
    
    * The solution will use the following data:
    	* Dynamic Data retrieved from a relational database and processed by application servers in the cloud. 
        * Static Content will be pulled from object storage in the cloud.
    
*    What are the security requirements of your application?
		* Any Internet user should be able to view web pages. They will not be able to directly access the application servers or data base.
    	* Developers should be able to access internal servers via VPN or dedicated circuit.
    	* Access will be controlled by Role and Organization.
    	* All data must be encrypted at rest and in flight.
    
*   What are the high availability requirements?
	* The application should be able to survive the failure of one physical location (AZ).
    * If the Application or Database fails, static content should still available during the failure.
    * Block storage should survive instance failure.
    
*    Do you have to provide connectivity to your on-premises data center? If so, how will you implement it?
    	* Connectivity for developers will be via VPN to our VPCs
    
*    Do you have to implement connectivity to other (customer) sites? If so, how will you implement it?
     	* Not currently but we can add additional VPN endpoints or a Direct Connect connection if needed.
