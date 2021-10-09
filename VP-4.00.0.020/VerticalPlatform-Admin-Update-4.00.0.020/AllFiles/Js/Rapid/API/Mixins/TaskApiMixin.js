var taskApiMixin = function() {
  return {
    methods: {
      async GetTasksByJobId(jobId) {
        var tasks = await _baseApi.GET(`tasks/job/${jobId}`, true, null);
        return tasks.map((ele)=>_modelConverter.rapidTaskToTaskModel(ele));
      },

      async UpdateTaskStatus(task) {
        var converted = _modelConverter.taskModelToRapidTask(task); 
        return await _baseApi.POST('tasks/status', true, converted, null);
      },
      
      async AddTask(jobId, taskType){
        var task = {
          jobId: jobId,
          taskType: taskType
        };
        return await _baseApi.POST('tasks', true, task, null);
      }
    }
  };
  
}