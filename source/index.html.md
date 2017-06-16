---
title: LibreDMS API Reference

toc_footers:
  - © 2017 Princess-Jewel Essien
  - Built for Andela Simulations
  - <a href='https://github.com/andela-pessien/libre-dms'>Code on Github</a>
  - <a href='https://github.com/lord/slate'>Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the LibreDMS API! This reference will guide you in using the API to access various document management system functions, such as creating, listing, retrieving, editing and deleting documents.

The API is hosted at https://libre-dms.herokuapp.com

# API Summary

### Authorization Key:

Type | Meaning
---- | -------
None | Anyone can access this route
Any | Any user with a valid access token can access this route
Self | The owner of the requested resource can access this route
Limited | Special rules exist for authorizing access (e.g. if a user's profile is public or not)
Admin | Administrators and the superadministrator can access this route
Superadmin | The superadministrator can access this route

### Authentication

EndPoint | Functionality | Authorization required
-------- | ------------- | ---------------
POST /api/users | Sign up a user | None
POST /api/auth/login | Sign in a user | None
POST /api/auth/logout | Sign out a user | Any

### Users

EndPoint | Functionality | Authorization required
-------- | ------------- | ---------------
GET /api/users | List users (paginated) | Any
GET /api/users/:id | Retrieve a user | Limited
PUT /api/users/:id | Update a user | Self
PUT /api/users/set-role/:id | Promote/Demote a user | Admin
DELETE /api/users/:id | Delete a user | Self, Superadmin
GET /api/search/users/?q={name} | Search for a user (paginated) | Any

### Documents

EndPoint | Functionality | Authorization required
-------- | ------------- | ---------------
POST /api/documents | Creates a document | Any
GET /api/documents | Lists documents (paginated) | Any
GET /api/documents/:id | Retrieves a document | Limited
PUT /api/documents/:id | Updates a document | Self
DELETE /api/documents/:id | Deletes a document | Self, Superadmin
GET /api/users/:id/documents | Lists documents belonging to a user (paginated) | Any
GET /api/search/documents | Search for a document (paginated) | Any

### Roles

EndPoint | Functionality | Authorization required
-------- | ------------- | ---------------
GET /api/roles | Lists roles | None
GET /api/roles/:id | Retrieve a role | None

# Authentication

## Sign Up (Create a user)

> Request:

```json
{
  "name": "Jane Doe",
  "email": "jane@doe.com",
  "password": "janedoe1"
}
```

> Response:

```json
status: 201

headers: {
  "x-access-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjdjYmM1ZWQ3LTJhMjgtNDExMy05ZWI2LTZlYmFmMDk1NjI0YyIsInJvbGVJZCI6NCwiaWF0IjoxNDk3NjIzMjA2LCJleHAiOjE0OTc3MDk2MDZ9.vcvKgIWamrzfqO9bU10WK6FkutU1cf6aWj5qrqNZzkg"
}

body: {
  "id": "7782b69c-8260-4c00-9a9e-d2485d8125a5",
  "name": "Jane Doe",
  "email": "jane@doe.com",
  "isPrivate": true,
  "roleId": 4,
  "createdAt": "2017-06-16T14:23:38.838Z",
}
```

### HTTP Request

`POST /api/users`

This endpoint signs up a user. Name, email and password fields are mandatory: name must be a first and last name combination, emails must be valid and passwords must be at least 8 characters long (and cannot consist of only whitespaces). The created user's profile visibility is set to private by default, and a JSON web token is returned which should be used to authenticate future requests.

Note: You cannot set your own role!

## Sign In

> Request:

```json
{
  "email": "jane@doe.com",
  "password": "janedoe1"
}
```

> Response:

```json
status: 200

headers: {
  "x-access-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjdjYmM1ZWQ3LTJhMjgtNDExMy05ZWI2LTZlYmFmMDk1NjI0YyIsInJvbGVJZCI6NCwiaWF0IjoxNDk3NjIzOTI1LCJleHAiOjE0OTc3MTAzMjV9.lqxfsp9ULK_aialQC6f-YxtJQLNmgp6aRzpTtY1ajNk"
}

body: {
  "id": "7782b69c-8260-4c00-9a9e-d2485d8125a5",
  "name": "Jane Doe",
  "email": "jane@doe.com",
  "isPrivate": true,
  "roleId": 4,
  "createdAt": "2017-06-16T14:23:38.838Z",
}
```

### HTTP Request

`POST /api/auth/login`

This endpoint signs in a user. Email and password fields are mandatory. A JSON web token is returned which should be used to authenticate future requests.

## Sign Out

> Response:

```json
status: 200

headers: {
  "x-access-token": ""
}

body: {
  "message": "Logout successful!"
}
```

### HTTP Request

`POST /api/auth/logout`

This endpoint signs out a user.
An empty access token header is returned.

## Access tokens

Signing up and signing in return JSON web tokens in the response header (as `x-access-token`) which should be set as the `x-access-token` header on requests to endpoints requiring authorization.

# Users

## List users

> Response:

```json
status: 200

body: {
  "list": [
    {
      "id": "7782b69c-8260-4c00-9a9e-d2485d8125a5",
      "name": "Jane Doe"
    },
    {
      "id": "d71635c8-8587-4da9-9233-8abb3c4bdbcb",
      "name": "John Doe"
    }
  ],
  "metadata": {
    "total": 2,
    "pages": 1,
    "currentPage": 1,
    "pageSize": 10
  }
}
```

This endpoint retrieves all users whose profile the requester has access to.

### HTTP Request

`GET /api/users`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
limit | 10 | The (maximum) number of users to return
offset | 0 | The number of users to offset list by

## Retrieve a user

> Response:

```json
status: 200

body: {
  "id": "7782b69c-8260-4c00-9a9e-d2485d8125a5",
  "name": "Jane Doe",
  "email": "jane@doe.com",
  "isPrivate": true,
  "roleId": 4,
  "createdAt": "2017-06-16T14:23:38.838Z",
}
```

This endpoint retrieves a user by ID.

You can always retrieve your own details. Administrators and the superadministrator can retrieve any user's details. Other users can only retrieve a user's details if their `isPrivate` attribute is set to `true`.

### HTTP Request

`GET /api/users/:id`

## Update a user

> Request

```json
{
  "email": "janedoe@gmail.com"
}
```

> Response:

```json
status: 200

body: {
  "id": "7782b69c-8260-4c00-9a9e-d2485d8125a5",
  "name": "Josephine Doe",
  "email": "janedoe@gmail.com",
  "isPrivate": true,
  "roleId": 4,
  "createdAt": "2017-06-16T14:23:38.838Z",
}
```

This endpoint updates a user's details.

Users can update only their own details regardless of privilege level.

Again, you cannot set your own role.

### HTTP Request

`PUT /api/users/:id`

## Promote/Demote a user

> Request

```json
{
  "roleId": "2"
}
```

> Response:

```json
status: 200

body: {
  "id": "7782b69c-8260-4c00-9a9e-d2485d8125a5",
  "name": "Josephine Doe",
  "email": "janedoe@gmail.com",
  "isPrivate": true,
  "roleId": 2,
  "createdAt": "2017-06-16T14:23:38.838Z",
}
```

This endpoint promotes or demotes a user from one privilege level to another.

Administrators and the superadministrator can promote a user to reviewer or administrator, or demote a user from reviewer to regular user. Only the superadministrator can demote an administrator.

### HTTP Request

`PUT /api/users/set-role/:id`

## Delete a user

> Response:

```json
status: 200

body: {
  "message": "User deleted successfully"
}
```

This endpoint deletes a user.

Users can delete only themselves, and the superadministrator can delete any user. Deleting a user makes their documents visible only to the superadministrator.

### HTTP Request

`DELETE /api/users/:id`

## Search for a user

> Request: `GET /api/search/users?q=doe`

> Response:

```json
status: 200

body: {
  "list": [
    {
      "id": "7782b69c-8260-4c00-9a9e-d2485d8125a5",
      "name": "Jane Doe"
    },
    {
      "id": "d71635c8-8587-4da9-9233-8abb3c4bdbcb",
      "name": "John Doe"
    }
  ],
  "metadata": {
    "total": 2,
    "pages": 1,
    "currentPage": 1,
    "pageSize": 10
  }
}
```

This endpoint searches for a user by name.

Providing keyword(s) to search for is mandatory.

### HTTP Request

`GET /api/search/users`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
`q` or `query` | - | The keyword(s) to match
limit | 10 | The (maximum) number of users to return
offset | 0 | The number of users to offset list by

# Documents

## Create a document

> Request:

```json
{
  "title": "Test Document",
  "content": "Test content"
}
```

> Response:

```json
status: 201

body: {
  "id": "4617f1df-7395-4c2c-b9c8-703ae98fdc88",
  "title": "Test Document",
  "content": "Test content",
  "access": "private",
  "accesslevel": "view",
  "type": "text",
  "userId": "7cbc5ed7-2a28-4113-9eb6-6ebaf095624c",
  "userRole": 4,
  "createdAt": "2017-06-16T18:01:08.951Z",
  "updatedAt": "2017-06-16T18:01:08.951Z"
}
```

### HTTP Request

`POST /api/documents`

This endpoint creates a document.

Title field is mandatory. The created document's access is set to private by default, and the owner and role level of the document are automatically set based on the claims in the `x-access-token` header.

## List documents

> Response:

```json
status: 200

body: {
  "list": [
    {
        "id": "9d68d265-2441-4423-9cd8-b9e4738b085b",
        "title": "Another Test Document",
        "type": "text",
        "access": "private",
        "createdAt": "2017-06-16T18:04:14.045Z",
        "updatedAt": "2017-06-16T18:04:14.045Z"
    },
    {
        "id": "4617f1df-7395-4c2c-b9c8-703ae98fdc88",
        "title": "Test Document",
        "type": "text",
        "access": "private",
        "createdAt": "2017-06-16T18:01:08.951Z",
        "updatedAt": "2017-06-16T18:01:08.951Z"
    }
  ],
  "metadata": {
    "total": 2,
    "pages": 1,
    "currentPage": 1,
    "pageSize": 10
  }
}
```

This endpoint retrieves all documents the requester has access to.

### HTTP Request

`GET /api/documents`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
limit | 10 | The (maximum) number of documents to return
offset | 0 | The number of documents to offset list by

## List a user's documents

> Response:

```json
status: 200

body: {
  "list": [
    {
        "id": "9d68d265-2441-4423-9cd8-b9e4738b085b",
        "title": "Another Test Document",
        "type": "text",
        "access": "private",
        "createdAt": "2017-06-16T18:04:14.045Z",
        "updatedAt": "2017-06-16T18:04:14.045Z"
    },
    {
        "id": "4617f1df-7395-4c2c-b9c8-703ae98fdc88",
        "title": "Test Document",
        "type": "text",
        "access": "private",
        "createdAt": "2017-06-16T18:01:08.951Z",
        "updatedAt": "2017-06-16T18:01:08.951Z"
    }
  ],
  "metadata": {
    "total": 2,
    "pages": 1,
    "currentPage": 1,
    "pageSize": 10
  }
}
```

This endpoint retrieves all of a user's documents that the requester has access to.

### HTTP Request

`GET /api/users/:id/documents`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
limit | 10 | The (maximum) number of documents to return
offset | 0 | The number of documents to offset list by

## Search for a document

> Request: `GET /api/search/documents?q=Another`

> Response:

```json
status: 200

body: {
  "list": [
    {
      "id": "9d68d265-2441-4423-9cd8-b9e4738b085b",
      "title": "Another Test Document",
      "type": "text",
      "access": "private",
      "userId": "7cbc5ed7-2a28-4113-9eb6-6ebaf095624c",
      "createdAt": "2017-06-16T18:04:14.045Z",
      "updatedAt": "2017-06-16T18:04:14.045Z",
      "User": {
        "id": "7cbc5ed7-2a28-4113-9eb6-6ebaf095624c",
        "name": "Jane  Doe",
        "roleId": 4
      }
    }
  ],
  "metadata": {
    "total": 1,
    "pages": 1,
    "currentPage": 1,
    "pageSize": 10
  }
}
```

This endpoint searches for a document by title.

Providing keyword(s) to search for is mandatory.

### HTTP Request

`GET /api/search/documents`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
`q` or `query` | - | The keyword(s) to match
limit | 10 | The (maximum) number of documents to return
offset | 0 | The number of documents to offset list by

## Retrieve a document

> Response:

```json
status: 200

body: {
  "id": "4617f1df-7395-4c2c-b9c8-703ae98fdc88",
  "title": "Test Document",
  "content": "Test content",
  "access": "private",
  "accesslevel": "view",
  "type": "text",
  "userId": "7cbc5ed7-2a28-4113-9eb6-6ebaf095624c",
  "userRole": 4,
  "createdAt": "2017-06-16T18:01:08.951Z",
  "updatedAt": "2017-06-16T18:01:08.951Z"
}
```

This endpoint retrieves a document by ID.

You can always retrieve your own documents. Administrators and the superadministrator can retrieve any document. Other users can only retrieve a document if it is public or it is set to role access (and the requester is on the same or greater privilege level as the owner).

### HTTP Request

`GET /api/documents/:id`

## Update a document

> Request

```json
{
  "title": "Updated Test Document"
}
```

> Response:

```json
status: 200

body: {
  "id": "4617f1df-7395-4c2c-b9c8-703ae98fdc88",
  "title": "Updated Test Document",
  "content": "Test content",
  "access": "private",
  "accesslevel": "view",
  "type": "text",
  "userId": "7cbc5ed7-2a28-4113-9eb6-6ebaf095624c",
  "userRole": 4,
  "createdAt": "2017-06-16T18:01:08.951Z",
  "updatedAt": "2017-06-16T18:08:09.772Z"
}
```

This endpoint updates a document.

Users can update only their own documents regardless of privilege level.

### HTTP Request

`PUT /api/documents/:id`

## Delete a document

> Response:

```json
status: 200

body: {
  "message": "Document deleted successfully"
}
```

This endpoint deletes a document.

Users can delete only their own documents, and the superadministrator can delete any document.

### HTTP Request

`DELETE /api/documents/:id`

# Roles

## List roles

> Response:

```json
status: 200

body: [
  {
    "id": 1,
    "label": "Superadministrator"
  },
  {
    "id": 2,
    "label": "Administrator"
  },
  {
    "id": 3,
    "label": "Reviewer"
  },
  {
    "id": 4,
    "label": "Regular"
  }
]
```

This endpoint retrieves all roles.

### HTTP Request

`GET /api/roles`

## Retrieve a role

> Response:

```json
status: 200

body: {
  "id": 2,
  "label": "Administrator"
}
```

This endpoint retrieves a role by ID.

### HTTP Request

`GET /api/roles/:id`