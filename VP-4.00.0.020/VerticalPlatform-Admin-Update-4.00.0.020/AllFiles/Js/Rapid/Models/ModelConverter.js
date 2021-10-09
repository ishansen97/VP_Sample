var modelConverter = function () {

  function rapidJobToJobModel(rapidJob) {
    return {
      jobId: rapidJob.Id,
      jobSiteId: rapidJob.SiteId,
      jobSiteName: rapidJob.SiteName,
      jobVendorId: rapidJob.VendorId,
      jobVendorName: rapidJob.VendorName,
      jobStatus: rapidJob.Status,
      jobState: rapidJob.State,
      jobDataFileName: rapidJob.DataFileName,
      jobDataFilePath: rapidJob.DataFilePath,
      jobOrder: rapidJob.Order,
      jobEmails: rapidJob.Emails,
      jobIsError: rapidJob.IsError,
      jobErrorMessage: rapidJob.ErrorMessage,
      jobCreatedOn: rapidJob.CreatedOn,
      jobStartTime: rapidJob.StartTime,
      jobEndTime: rapidJob.EndTime,
      jobTotalDuration: rapidJob.TotalDuration,
      jobModifiedTime: getDateObject(rapidJob.ModifiedTime),
      jobIsWarning: rapidJob.IsWarning,
      jobWarningMessage: rapidJob.WarningMessage,
      jobTasks: []
    };
  }

  function getDateObject(dateString){
    var v = dateString? new Date(dateString.replace(/-/g, '/')): dateString;
    return v;
  }

  function jobModelToRapidJob(jobModel) {
    return {
      Id: jobModel.jobId,
      SiteId: jobModel.jobSiteId,
      SiteName: jobModel.jobSiteName,
      VendorId: jobModel.jobVendorId,
      VendorName: jobModel.jobVendorName,
      Status: jobModel.jobStatus,
      State: jobModel.jobState,
      DataFileName: jobModel.jobDataFileName,
      DataFilePath: jobModel.jobDataFilePath,
      Order: jobModel.jobOrder,
      Emails: jobModel.jobEmails,
      IsError: jobModel.jobIsError,
      ErrorMessage: jobModel.jobErrorMessage,
      CreatedOn: jobModel.jobCreatedOn,
      StartTime: jobModel.jobStartTime,
      EndTime: jobModel.jobEndTime,
      TotalDuration: jobModel.jobTotalDuration,
      IsWarning: jobModel.jobIsWarning,
      WarningMessage: jobModel.jobWarningMessage,
      Tasks: []
    };
  }

  function rapidJobAndTasksToJobAndTasksModel(rapidJobAndTasks) {
    var jobModel = rapidJobToJobModel(rapidJobAndTasks);
    jobModel.jobTasks = rapidJobAndTasks.Tasks.map(rapidTaskToTaskModel);
    return jobModel;
  }

  function rapidTaskToTaskModel(rapidTask) {
    return {
      taskId: rapidTask.Id,
      jobId: rapidTask.JobId,
      taskStatus: rapidTask.Status,
      taskType: rapidTask.TaskType,
      taskStartTime: rapidTask.StartTime,
      taskEndTime: rapidTask.EndTime,
      taskIsError: rapidTask.IsError,
      taskErrorMessage: rapidTask.ErrorMessage,
      taskInsertedRecords: rapidTask.InsertedRecords,
      taskUpdatedRecords: rapidTask.UpdatedRecords,
      taskDeletedRecords: rapidTask.DeletedRecords,
      taskErrorRecords: rapidTask.ErrorRecords,
      taskUnchangedProductCount: rapidTask.UnchangedProductCount,
      taskReEnabledProductCount: rapidTask.ReEnabledProductCount,
      taskIgnoredInRapidProductCount: rapidTask.IgnoredInRapidProductCount,
      taskIgnoredSearchOptionProductCount: rapidTask.IgnoredSearchOptionProductCount,
      taskDuration: rapidTask.TaskDuration
    };
  }

  function taskModelToRapidTask(taskModel) {
    return {
      Id: taskModel.taskId,
      JobId: taskModel.jobId,
      Status: taskModel.taskStatus,
      TaskType: taskModel.taskType,
      StartTime: taskModel.taskStartTime,
      EndTime: taskModel.taskEndTime,
      IsError: taskModel.taskIsError,
      ErrorMessage: taskModel.taskErrorMessage,
      InsertedRecords: taskModel.taskInsertedRecords,
      UpdatedRecords: taskModel.taskUpdatedRecords,
      DeletedRecords: taskModel.taskDeletedRecords,
      ErrorRecords: taskModel.taskErrorRecords,
      UnchangedProductCount: taskModel.taskUnchangedProductCount,
      ReEnabledProductCount: taskModel.taskReEnabledProductCount,
      IgnoredInRapidProductCount: taskModel.taskIgnoredInRapidProductCount,
      IgnoredSearchOptionProductCount: taskModel.taskIgnoredSearchOptionProductCount,
      TaskDuration: taskModel.taskDuration
    };
  }

  function rapidSiteToSiteModel(rapidSite) {
    return {
      siteName: rapidSite.Name,
      siteId: rapidSite.Id,
      dropDownList: {
        name:rapidSite.Name,
        id: rapidSite.Id
      }
    };
  }

  function rapidVendorToVendorModel(rapidSite) {
    return {
      vendorName: rapidSite.Name,
      vendorId: rapidSite.Id,
      dropDownList: {
        name:rapidSite.Name,
        id: rapidSite.Id
      }
    };
  }

  function rapidVendorStatusToVendorStatusModel(rapidFile) {
    return {
      vendorMessage: rapidFile.Message,
      vendorRuleFileStatus: rapidFile.ruleFileStatus,
      vendorIsVendorOk: rapidFile.isVendorOk
    };
  }

  return {
    rapidJobToJobModel,
    jobModelToRapidJob,
    rapidJobAndTasksToJobAndTasksModel,
    rapidTaskToTaskModel,
    taskModelToRapidTask,
    rapidSiteToSiteModel,
    rapidVendorToVendorModel,
    rapidVendorStatusToVendorStatusModel
  };
};