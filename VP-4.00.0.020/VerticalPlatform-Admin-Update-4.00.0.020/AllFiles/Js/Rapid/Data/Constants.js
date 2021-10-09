var constants = function () {
  const arrayTypes = {
    PENDING: 1,
    QUEUE: 2,
    INPROGRESS: 3,
    ERROR:4
  };

  const status = {
    PENDING: 1,
    QUEUE: 2,
    INPROGRESS: 3,
    FINISHED: 4,
    CANCELED: 5
  };

  GetStatusString = function (val) {
    switch (val) {
      case status.QUEUE:
        return "Queued";
      case status.INPROGRESS:
        return "InProgress";
      case status.PENDING:
        return "Pending";
      case status.FINISHED:
        return "Finished";
      case status.CANCELED:
        return "Canceled";
    }
  };

  const taskType = {
    UPDATE: 1,
    UPDATEPLUS: 2,
    INSERT: 3,
    DELETE: 4,
    REPORTS: 5,
    CLEANUP: 6,
    REPORTING_INSERT_REPORT: 7,
    REPORTING_UPDATE_REPORT: 8,
    REPORTING_DELETE_REPORT: 9,
    REPORTING_ERROR_REPORT: 10,
    PRODUCTIONPUSH_INSERT_REPORT: 11,
    PRODUCTIONPUSH_UPDATE_REPORT: 12,
    PRODUCTIONPUSH_DELETE_REPORT: 13,
    PRODUCTIONPUSH_ERROR_REPORT: 14,
    REPORTING_REENABLED_REPORT: 15,
    REPORTING_IGNOREDSEARCHOPTION_REPORT: 16,
    REPORTING_IGNOREDINRAPID_REPORT: 17,
  };

  GetTaskTypeString = function (val) {
    switch (val) {
      case taskType.UPDATE:
        return "Update";
      case taskType.INSERT:
        return "Insert";
      case taskType.DELETE:
        return "Delete";
      case taskType.REPORTS:
        return "Reports";
      case taskType.CLEANUP:
        return "Cleanup";
      case taskType.REPORTING_INSERT_REPORT:
        return "Insert Report";
      case taskType.REPORTING_UPDATE_REPORT:
        return "Update Report";
      case taskType.REPORTING_DELETE_REPORT:
        return "Delete Report";
      case taskType.REPORTING_ERROR_REPORT:
        return "Error Report";
      case taskType.REPORTING_REENABLED_REPORT:
        return "Re-enables Report";
      case taskType.REPORTING_IGNOREDSEARCHOPTION_REPORT:
        return "Ignored Search Options Report";
      case taskType.REPORTING_IGNOREDINRAPID_REPORT:
        return "Ignored in Rapid Report";
      case taskType.PRODUCTIONPUSH_INSERT_REPORT:
        return "Insert Report";
      case taskType.PRODUCTIONPUSH_UPDATE_REPORT:
        return "Update Report";
      case taskType.PRODUCTIONPUSH_DELETE_REPORT:
        return "Delete Report";
      case taskType.PRODUCTIONPUSH_ERROR_REPORT:
        return "Error Report";
    }
  };

  const state = {
    REPORTS: 1,
    PRODUCTIONPUSH: 2,
    COMPLETED: 3,
    CLEANUP: 4
  };

  const pageLimit = 20;

  const modalClose = {
    addJob:"addJobClose",
    info:"infoClose",
    completed:"completedInfoClose",
    confirm:"confirmClose"
  };

  const permissions = {
    ADD:'adPerm',
    EDIT:'ediPerm',
    DELETE:'delePerm'
  }

  const filterKeys = {
    siteId:'site',
    vendorId:'vendor',
    fromDate:'fromDate',
    toDate:'toDate'
  }

  return {
    status,
    GetStatusString,
    taskType,
    GetTaskTypeString,
    state,
    arrayTypes,
    pageLimit,
    modalClose,
    permissions,
    filterKeys
  };

};


