var models = function () {

  function JobModel() {
    return {
      jobId:0,
      jobSiteId:0,
      jobSiteName:'',
      jobVendorId:0,
      jobVendorName:'',
      jobStatus:0,
      jobState:0,
      jobDataFileName:'',
      jobDataFilePath:'',
      jobOrder:0,
      jobEmails:'',
      jobIsError:false,
      jobErrorMessage:'',
      jobCreatedOn:'',
      jobStartTime:'',
      jobEndTime:'',
      jobTotalDuration:'',
      jobModifiedTime:'',
      jobIsWarning:false,
      jobWarningMessage:'',
      jobTasks:[]
    };
  }

  function TaskModel() {
    return {
      taskId: 0,
      jobId: 0,
      taskStatus: 0,
      taskType: 0,
      taskStartTime: '',
      taskEndTime: '',
      taskIsError: false,
      taskErrorMessage: '',
      taskInsertedRecords: 0,
      taskUpdatedRecords: 0,
      taskDeletedRecords: 0,
      taskErrorRecords: 0,
      taskUnchangedProductCount:0,
      taskReEnabledProductCount:0,
      taskIgnoredInRapidProductCount:0,
      taskIgnoredSearchOptionProductCount:0,
      taskDuration: ''
    };
  }

  function SiteModel(){
    return {
      siteName: '',
      siteId: 0,
      dropDownList: new DropDownListModel()
    };
  }

  function VendorModel(){
    return {
      vendorName: '',
      vendorId: 0,
      dropDownList: new DropDownListModel()
    };
  }

  function DropDownListModel(){
    return {
      name: '',
      id: 0
    };
  }

  function VendorStatusModel(){
    return {
      vendorMessage: '',
      vendorIsVendorOk: false,
      vendorRuleFileStatus: false
    };
  }

  function PaginationModel(){
    return{
      totalCount: 0,
      startIndex: 1,
      endIndex: _constants.pageLimit
    }
  }

  return {
    JobModel,
    TaskModel,
    SiteModel,
    VendorModel,
    VendorStatusModel,
    PaginationModel,
    DropDownListModel
  };
};