var jobApiMixin = function () {
  return {
    data() {
      return {
        sites: [],
        vendors: [],
        uploadDetails: {}
      };
    },
    methods: {
      async GetReportJobsAndTasks() {
        await _baseApi.GET('jobs/report', true, null)
        .then((jobs)=>{
          _apiDataStore.reportJobs = jobs.map((ele)=>_modelConverter.rapidJobAndTasksToJobAndTasksModel(ele));
        });
      },

      async GetProductionPushJobsAndTasks() {
        await _baseApi.GET('jobs/productionpush', true, null)
        .then((jobs)=>{
          _apiDataStore.productionPushJobs = jobs.map((ele) => _modelConverter.rapidJobAndTasksToJobAndTasksModel(ele));          
        });
      },

      async GetCleanUpJobs() {
        await _baseApi.GET('jobs/cleanup', true, null)
        .then((jobs)=>{
          _apiDataStore.cleanUpJobs = jobs.map((ele)=>_modelConverter.rapidJobAndTasksToJobAndTasksModel(ele));
        });
      },

      async GetCompletedJobs() {
        var filterData = _apiDataStore.completedJobsFilterData;
        var start = _apiDataStore.completedJobsPagination.startIndex;
        var end = _apiDataStore.completedJobsPagination.endIndex;
        var url = `jobs/completed?start=${start}&end=${end}`;

        for(var task in filterData) {
          url = `${url}&${task}=${filterData[task]}`
        }
        
        await _baseApi.GET(url, true, null)
        .then((jobs)=>{
          _apiDataStore.completedJobs = jobs.Data.map((ele)=>_modelConverter.rapidJobToJobModel(ele));
          _apiDataStore.completedJobsPagination.totalCount = jobs.TotalCount; 
        });
      },

      async GetSites() {
        var sites = await _baseApi.GET('jobs/sites', true, null);
        return this.sites = sites.map((ele)=>_modelConverter.rapidSiteToSiteModel(ele));
      },

      async GetVendorsBySite(siteId) {
        var vendors = await _baseApi.GET(`jobs/vendors/${siteId}`, true, null);
        return this.vendors = vendors.map((ele)=>_modelConverter.rapidVendorToVendorModel(ele));        
      },

      async AddJob(job) {
        var converted = _modelConverter.jobModelToRapidJob(job); 
        var addedJob = await _baseApi.POST('jobs', true, converted, null);
        return _modelConverter.rapidJobToJobModel(addedJob);
      },

      async UpdateJob(job) {
        var converted = _modelConverter.jobModelToRapidJob(job); 
        return await _baseApi.PUT('jobs', true, converted, null);
      },

      async UpdateJobOrder(job) {
        var converted = _modelConverter.jobModelToRapidJob(job); 
        return await _baseApi.POST('jobs/reorder', true, converted, null);
      },

      async UpdateJobStatus(job) {
        var converted = _modelConverter.jobModelToRapidJob(job); 
        return await _baseApi.POST('jobs/status', true, converted, null);
      },

      async RunCleanUp(jobId) {
        return await _baseApi.GET(`jobs/cleanup/${jobId}`, true, null);
      },

      async CancelJobAndTasks(jobId) {
        return await _baseApi.GET(`jobs/cancel/${jobId}`, true, null);
      },

      async UnscheduleJobAndTasks(jobId) {
        return await _baseApi.GET(`jobs/unschedule/${jobId}`, true, null);
      },

      async UploadDataFile(job, dataFile) {
        var converted = _modelConverter.jobModelToRapidJob(job); 
        this.uploadDetails = {success: false, message:"Uploading Data File...", retry: false};
        var signedUrlModel = await _baseApi.POST("jobs/upload", true, converted, null);
        _baseApi.UPLOADS3(signedUrlModel.Url, dataFile)
          .then((result) => {
            this.uploadDetails = {
              success: true,
              message: "Upload Successful.",
              filePath: signedUrlModel.FilePath,
              retry: false
            };
          })
          .catch((error) => {
            this.uploadDetails = {
              success: false,
              message: "Upload Failed!",
              filePath: '',
              retry: true
            };
          });
      },

      async DownloadReports(taskId) {
        var downloadUrl = await _baseApi.GET(`jobs/download/${taskId}`, true, null);

        const tempElement = document.createElement("a");
        tempElement.style.display = "none";
        document.body.appendChild(tempElement);
        tempElement.href = downloadUrl;
        tempElement.click();
        window.URL.revokeObjectURL(tempElement.href);
        document.body.removeChild(tempElement);
      },

      async UploadRuleFile(file, vendorId) {
        return await _baseApi.UPLOADSERVER(`jobs/rulefile/${vendorId}/upload`, true, file);
      },

      async VendorStatus(vendorId) {
        var status = await _baseApi.GET(`jobs/status/${vendorId}`, true, null);
        return _modelConverter.rapidVendorStatusToVendorStatusModel(status);
      },

      async ReQueueReports(jobId) {
        return await _baseApi.POST(`jobs/requeuereports/${jobId}`, true, null, null);
      }
    }
  };
};