<h1>Salesforce Cascade Toggle</h1>

Activates/Deactives an Account/Contact/Opportunity and its related children. 

This is useful for example, in case that we want to create a report containing only on specific records that have the flag enabled, or if we want to perform an operation (or computation) only on those records. The user can easily enable/disable specific records and their children.

It's all done with JavaScript remoting. All the JavaScript code is in the CascadeToggle.resource file.

The buttons to add to the Account/Contact/Opportunity objects have already been created and only need to be added to the layouts.

[ ![Codeship Status for ceiroa/cascade-toggle](https://www.codeship.io/projects/a2bbdfb0-259c-0132-5601-76bec1757a7f/status)](https://www.codeship.io/projects/37228)
