var APIDataStore = function () {
  return Vue.observable({
    reportJobs: [],
    productionPushJobs: [],
    cleanUpJobs: [],
    completedJobs: [],
    completedJobsPagination: new _models.PaginationModel(),
    completedJobsFilterData: {}
  });
};
