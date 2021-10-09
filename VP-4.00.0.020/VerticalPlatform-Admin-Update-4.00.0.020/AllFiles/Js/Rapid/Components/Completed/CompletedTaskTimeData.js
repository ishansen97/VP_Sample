var completedTaskTimeData = function () {
  let TimeDataTemplate = `
  <div class="vp-custom-table-row">
      <div class="vp-custom-table-cell align-vertical" style="width: 30%;">{{task.taskName}}</div>
      <div class="vp-custom-table-cell align-vertical" style="width: 25%;">{{task.taskStartTime}}</div>
      <div class="vp-custom-table-cell align-vertical" style="width: 25%;">{{task.taskEndTime}}</div>
      <div class="vp-custom-table-cell align-vertical" style="width: 20%;">{{task.taskDuration}}</div>
  </div>
`;

  Vue.component('completed-task-time-data', {
    template: TimeDataTemplate,
    props: {
      taskProp: {
        required: true,
        type: Object
      }
    },
    data() {
      return {
        task: this.taskProp
      };
    }
  });
};