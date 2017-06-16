# Errors

<aside class="notice">In use, each error comes with a meesage that should explain what went wrong.</aside>

The Kittn API uses the following error codes:


Error Code | Meaning
---------- | -------
400 | Bad Request -- Your request was not phrased properly
401 | Unauthorized -- No or invalid access token was provided for route requiring authorization
403 | Forbidden -- You are not permitted to perform the requested action
404 | Not Found -- The requested resource could not be found
409 | Conflict -- Your request conflicts with the existing state of the application
418 | I'm a teapot :)
500 | Internal Server Error -- Something went wrong on our end.
