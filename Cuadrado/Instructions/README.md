# Take Home Question: Employee Directory Application

## Overview
Build an employee directory app that shows a list of employees parsed from the provided JSON endpoint.

Take care to properly handle errors returned from the endpoint (or other network errors like timeouts), and ensure you do not waste network bandwidth – load expensive resources such as large photos on-demand only. Photos at a given URL will never change. Once one is loaded, you do not need to reload the photo. If an employee’s photo changes, they will be given a new photo URL (eg, you can treat the URL as a globally unique ID).

All screens and views which load from the network should display proper loading, empty, and error states when content is not available. If images fail to load, displaying a placeholder is fine.

The employee list does not need to be persisted to disk – you can reload it from the network on each app launch (but no more often than that). On the contrary, images should be cached on disk as to not waste device bandwidth.

You should structure your code so that it's testable. There is no minimum or maximum amount of test coverage we’re looking for – instead try to provide enough coverage such that regressions would be caught by automated tests. Only worry about unit tests – you can skip view snapshot or integration tests.

Do not worry about building custom controls and UI elements – using system-provided, standard elements is fine.

## Details

### JSON Endpoints

We have provided an endpoint, which when called, returns a dictionary containing a JSON array containing employee information for a fictitious list of employees. Each item in the array represents an employee.

[https://s3.amazonaws.com/sq-mobile-interview/employees.json](https://s3.amazonaws.com/sq-mobile-interview/employees.json)

There are also other endpoints you can call to simulate error states such as malformed employees and an empty employee list:
[https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json](https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json)

If a malformed request is returned (eg, one of the employees is malformed), it’s fine to throw away the entire list of employees. You do not need to worry about only excluding malformed employees. Errors can include missing required fields, incorrect types in fields (expect a string but it’s a number), etc.

[https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json](https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json)

In the case that no employees are returned, the application should present an empty state view.

### JSON Structure
`Key : Type : Required? : Notes`
* uuid : string : YES : The unique identifier for the employee. Represented as a UUID.
* full_name : string: YES : The full name of the employee.
* phone_number : string : NO : The phone number of the employee, sent as an unformatted string (eg, 5556661234).
* email_address : string : YES : The email address of the employee.
* biography : string : NO : A short, tweet-length (~300 chars) string that the employee provided to describe themselves.
* photo_url_small : string : NO : The URL of the employee’s small photo. Useful for list view.
* photo_url_large : string : NO : The URL of the employee’s full-size photo.
* team : string : YES : The team they are on, represented as a human readable string.
* employee_type : enum (FULL_TIME, PART_TIME, CONTRACTOR) : YES : How the employee is classified.

```
{
  "employees" : [
    {
      "uuid" : "some-uuid",
      "full_name" : "Eric Rogers",
      "phone_number" : "5556669870",
      "email_address" : "erogers.demo@squareup.com",
      "biography" : "A short biography describing the employee.",

      "photo_url_small” : "https://some.url/path1.jpg",
      "photo_url_large” : "https://some.url/path2.jpg",

      "team" : “Seller",
      "employee_type" : "FULL_TIME",
    },

    ...

  ]
}
```

## Employee List View

Display a list / table view (or other collection view) which shows all employees returned from the JSON endpoint above. Each row / item in the list should contain a summary of the employee, such as their photo, name, and team. There is no defined way to sort employees – you can sort and group by name, team, etc. You do not need to build any more screens than this list.
