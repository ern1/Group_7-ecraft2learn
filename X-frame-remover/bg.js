chrome.webRequest.onHeadersReceived.addListener(
  /* First parameter to addListener() */
  function(details) { 
    for (var i = 0; i < details.responseHeaders.length; i++) {
      if (details.responseHeaders[i].name.toLowerCase() == "x-frame-options") {
        details.responseHeaders.splice(i, 1);
        return { responseHeaders: details.responseHeaders };
      }
    }
  },
  /* Second parameter to addListener() */
  {urls: ["<all_urls>"]},
  /* Third parameter to addListener() */
  ["blocking", "responseHeaders"]);