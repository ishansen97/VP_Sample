var baseAPI = function () {

  var GET = async function (url, authorize, headers) {
    return await execute(url, 'GET', authorize, headers);
  };

  var POST = async function (url, authorize, body, headers) {
    return await execute(url, 'POST', authorize, body, headers);
  };

  var PUT = async function (url, authorize, body, headers) {
    return await execute(url, 'PUT', authorize, body, headers);
  };

  var DELETE = async function (url, authorize, headers) {
    return await execute(url, 'DELETE', authorize, headers);
  };

  var UPLOADSERVER = async function (url, authorize, file) {
    url = CONFIG.apiBaseUrl + url;

    const requestInfo = {
      method: 'PUT'
    };

    var data = new FormData();
    data.append('', file);
    requestInfo.body = data;

    var newHeaders = {};
    setDefaultHeaders(newHeaders, authorize);
    delete newHeaders['Content-Type'];
    requestInfo.headers = newHeaders;

    return await fetch(url, requestInfo);
  };

  var UPLOADS3 = async function (url, file) {
    return new Promise(function (resolve, reject) {
      var xhr = new XMLHttpRequest();

      xhr.open('PUT', url, true);
      xhr.setRequestHeader("Content-Type", "multipart/form-data");

      xhr.onload = () => {
        if (xhr.status === 200) {
          resolve(true);
        }
      };

      xhr.onerror = () => {
        reject(false);
      };
      xhr.send(file);
    });
  };

  var execute = async function (url, method, authorize, body, headers) {
    url = CONFIG.apiBaseUrl + url;

    const requestInfo = {
      method
    };

    if (body) {
      requestInfo.body = JSON.stringify(body);
    }

    const newHeaders = headers? headers : {};
    setDefaultHeaders(newHeaders, authorize);
    requestInfo.headers = newHeaders;
    let retryCount = 0;
    let response;      

    do {
      retryCount++;
      if(retryCount>1){
        await new Promise(res => setTimeout(res, 2500));
      }

      await fetch(url, requestInfo)
        .then((data) => {
          response = data;
          }).catch((error) => {
            response = error;
        });
    } while (!(response?.status == '406' || response?.ok) && retryCount <= 3);

    if(response.ok){
      try{
        return await response.json();
      } catch(e){
        return;
      }
    } else {
      var errorBody = await response.text()
      var ErrorMessage = errorBody.substr(errorBody.indexOf(':')+1)
      $.notify({ message: ErrorMessage, type: 'error' });
      var error = response.status + ": "+response.statusText;
      console.log(error);
      throw error;
    }

  };

  var setDefaultHeaders = function (headers, authorize) {
    if (!('Accept' in headers)) {
      headers.Accept = 'application/json';
    }
    if (!('Content-Type' in headers)) {
      headers['Content-Type'] = 'application/json';
    }
    if (authorize) {
      headers.Authorization = CONFIG.apiToken;
    }
  };


  return {
    GET,
    POST,
    PUT,
    DELETE,
    UPLOADS3,
    UPLOADSERVER
  };
};