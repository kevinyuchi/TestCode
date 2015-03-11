global without sharing class PostInstallClass implements InstallHandler {
    
    public Integer testAvailJobs;
    public Integer maxJobsAllowed;
    
    global void onInstall(InstallContext context) {
        
        //Create Mapping Object data
        List<Everstring_Lead_Field_Mapping__c> mappingList = new List<Everstring_Lead_Field_Mapping__c>();
        mappingList = [SELECT Id, Name, everstring__Everstring_Lead_API_Name__c, everstring__SFDC_Lead_API_Name__c, everstring__Active__c
                        FROM Everstring_Lead_Field_Mapping__c
                        WHERE Id != null];
        
        if(mappingList.size() == 0){
            
            List<Everstring_Lead_Field_Mapping__c> insertMappingList = new List<Everstring_Lead_Field_Mapping__c>
            {
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'Name', everstring__Everstring_Lead_API_Name__c = 'name', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'Company', everstring__Everstring_Lead_API_Name__c = 'company', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'MobilePhone', everstring__Everstring_Lead_API_Name__c = 'mobile', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'Title', everstring__Everstring_Lead_API_Name__c = 'title', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'Phone', everstring__Everstring_Lead_API_Name__c = 'phone', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'Website', everstring__Everstring_Lead_API_Name__c = 'website', everstring__Active__c = true),             
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'Industry', everstring__Everstring_Lead_API_Name__c = 'industry', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'NumberOfEmployees', everstring__Everstring_Lead_API_Name__c = 'employees', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'everstring__Owner_Name__c', everstring__Everstring_Lead_API_Name__c = 'leadowner', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'LeadSource', everstring__Everstring_Lead_API_Name__c = 'leadsource', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'Status', everstring__Everstring_Lead_API_Name__c = 'leadstatus', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'LastTransferDate', everstring__Everstring_Lead_API_Name__c = 'transferdate', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'LastModifiedById', everstring__Everstring_Lead_API_Name__c = 'modifiedby', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'Id', everstring__Everstring_Lead_API_Name__c = 'salesforceID', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'FirstName', everstring__Everstring_Lead_API_Name__c = 'firstname', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'LastName', everstring__Everstring_Lead_API_Name__c = 'lastname', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'CreatedById', everstring__Everstring_Lead_API_Name__c = 'createdby', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'CreatedDate', everstring__Everstring_Lead_API_Name__c = 'createdate', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'Country', everstring__Everstring_Lead_API_Name__c = 'country', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'City', everstring__Everstring_Lead_API_Name__c = 'city', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'State', everstring__Everstring_Lead_API_Name__c = 'state', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'Street', everstring__Everstring_Lead_API_Name__c = 'street', everstring__Active__c = true),
                new Everstring_Lead_Field_Mapping__c(everstring__SFDC_Lead_API_Name__c = 'PostalCode', everstring__Everstring_Lead_API_Name__c = 'zip', everstring__Active__c = true)
            };

            try{
                insert insertMappingList;
            }catch(Exception e){
                system.debug('Exception occured::'+e.getMessage());
            }
        }
        
        //Create "Everstring_Settings__c" Custom Setting data
        List<Everstring_Settings__c> customSettingList = new List<Everstring_Settings__c>();
        customSettingList = [SELECT EverString_EndPoint_BaseURL__c, EverString_Last_Sync_Date__c
                                FROM Everstring_Settings__c
                                WHERE Name = 'EverStringAPIValues'];
        
        List<Organization> orgList = [SELECT Id, IsSandbox, OrganizationType FROM Organization WHERE Id = :context.organizationId() LIMIT 1];

        if(customSettingList.size() == 0) {
            
            Everstring_Settings__c evrs = new Everstring_Settings__c();
            
            /*if(orgList != NULL && orgList.size() > 0 && (orgList[0].IsSandbox || orgList[0].OrganizationType == 'Developer Edition')) {
                evrs.EverString_EndPoint_BaseURL__c = 'https://api-uat.everstring.com/api/service';
            } else {
                evrs.EverString_EndPoint_BaseURL__c = 'https://client.everstring.com/api/service';
            }*/
            evrs.EverString_EndPoint_BaseURL__c = 'https://client.everstring.com/api/service';    
            evrs.EverString_Last_Sync_Date__c = System.now();
            evrs.Name = 'EverStringAPIValues';

            try {
                insert evrs;
            } catch(Exception e) {
                system.debug('Exception occured::'+e.getMessage());
            }
        }
        
        //Create "Rating_Configuration__c" Custom Setting data
        List<Rating_Configuration__c> ratingCustomSettingList = new List<Rating_Configuration__c>();
        ratingCustomSettingList = [SELECT Id FROM Rating_Configuration__c
                                WHERE SetupOwnerId = :context.organizationId()];
        
        if(ratingCustomSettingList.size() == 0) {
            
            Rating_Configuration__c rating = new Rating_Configuration__c();
            rating.ES_Comp_Fit_Rating_Cutoff_1__c = 75;
            rating.ES_Comp_Fit_Rating_Cutoff_2__c = 50;
            rating.ES_Comp_Fit_Rating_Cutoff_3__c = 25;
            rating.ES_Person_Fit_Rating_Cutoff_1__c = 75;
            rating.ES_Person_Fit_Rating_Cutoff_2__c = 50;
            rating.ES_Person_Fit_Rating_Cutoff_3__c = 25;
            rating.ES_Person_Engagement_Rating_Cutoff_1__c = 75;
            rating.ES_Person_Engagement_Rating_Cutoff_2__c = 50;
            rating.ES_Person_Engagement_Rating_Cutoff_3__c = 25;
            rating.SetupOwnerId = context.organizationId();            
            try {
                insert rating;
            } catch(Exception e) {
                system.debug('Exception occured::'+e.getMessage());
            }
        }        
        
        //Initiate scheudlers based on the available count in the org
        Integer jobsRunning = 0;
        Integer availableJobs;
        //jobsRunning = [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.JobType = '7'];
        jobsRunning = [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.JobType = '7' AND NextFireTime != NULL];
        jobsRunning = (jobsRunning==null) ? 0 : jobsRunning;

        if(orgList != NULL && orgList.size() > 0) {
            if(orgList[0].OrganizationType == 'Developer Edition') {
                maxJobsAllowed = 5;
            } else {
                maxJobsAllowed = 100;
            }
        } else {
            maxJobsAllowed = 0;
        }

        if(!Test.isRunningTest()){
            availableJobs = maxJobsAllowed-jobsRunning;
        }else{
            availableJobs = maxJobsAllowed-testAvailJobs;
        }

        List<CronJobDetail> cronJobList = new List<CronJobDetail>();
        cronJobList = [Select Name, JobType From CronJobDetail WHERE Name LIKE 'EverString Lead Push Job%'];
        
        if(cronJobList.size() == 0) {
        
            if(availableJobs >= 12){
                
                System.schedule('EverString Lead Push Job1', '0 05 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job2', '0 10 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job3', '0 15 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job4', '0 20 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job5', '0 25 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job6', '0 30 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job7', '0 35 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job8', '0 40 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job9', '0 45 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job10', '0 50 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job11', '0 55 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job12', '0 00 0-23 * * ?', new ScheduleEverStringAPIIntegration());
            }
            else if(availableJobs >= 6){
                
                System.schedule('EverString Lead Push Job1', '0 00 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job2', '0 10 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job3', '0 20 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job4', '0 30 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job5', '0 40 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job6', '0 50 0-23 * * ?', new ScheduleEverStringAPIIntegration());
            }
            else if(availableJobs >= 4){
                
                System.schedule('EverString Lead Push Job1', '0 00 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job2', '0 15 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job3', '0 30 0-23 * * ?', new ScheduleEverStringAPIIntegration());
                System.schedule('EverString Lead Push Job4', '0 45 0-23 * * ?', new ScheduleEverStringAPIIntegration());
            }
            else if(availableJobs >= 1){
                
                System.schedule('EverString Lead Push Job1', '0 00 0-23 * * ?', new ScheduleEverStringAPIIntegration());
            }
        }
    }
}