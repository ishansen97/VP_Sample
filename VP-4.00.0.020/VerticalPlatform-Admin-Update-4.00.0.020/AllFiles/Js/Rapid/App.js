var _constants = new constants();
var _models = new models();
var _modelConverter = new modelConverter();
var _baseApi = new baseAPI();
var _apiDataStore = new APIDataStore();
var _jobApiMixin = new jobApiMixin();
var _taskApiMixin = new taskApiMixin();
var _sharedModalMixin = new sharedModalMixin();
var _componentsDataStore = new ComponentsDataStore();

var root = new root();
var dropDownList = new dropDownList(); 
var informationModal = new informationModal(); 
var confirmationModal = new confirmationModal(); 
var pageList = new pageList();
var tabView = new tabView();
var addJobModal = new addJobModal();
var reportsTileComponent = new reportsTileComponent();
var reportsTabComponent = new reportsTabComponent();
var productionPushReportingData = new productionPushReportingData();
var productionPushProductionData = new productionPushProductionData();
var productionPushTile = new productionPushTile();
var productionPushTabComponent = new productionPushTabComponent();
var completedJobReportingData = new completedJobReportingData();
var cleanUpTileComponent = new cleanUpTileComponent();
var cleanUpTabComponent = new cleanUpTabComponent();
var completedJobDetailModal = new completedJobDetailModal();
var completedTabComponent = new completedTabComponent();
var completedTaskTimeData = new completedTaskTimeData();
var spinner = new spinner();

new Vue({
  el: '#startup'
});
