//Creating empty object to use as namespace
var Toggle = {};

Toggle.activateObject = function(obj) {
	//console.log('Activating object: ' + obj);
	if ('Toggle__Active__c' in obj) {
		obj.Toggle__Active__c = 'Yes';
	} else if ('Active__c' in obj) {
		obj.Active__c = 'Yes';
	}
	var result = sforce.connection.update( [ obj ]);
	//console.log("Activation Result: " + result);
	return result;
}

Toggle.deactivateObject = function(obj) {
	//console.log('Deactivating object: ' + obj);
	if ('Toggle__Active__c' in obj) {
		obj.Toggle__Active__c = 'No';
	} else if ('Active__c' in obj) {
		obj.Active__c = 'No';
	}
	var result = sforce.connection.update( [ obj ]);
	//console.log("Deactivation Result: " + result);
	return result;
}

Toggle.activateObjectArray = function(objectArray) {
	//console.log("*Activating object array*");
	for ( var i = 0; i < objectArray.length; i++) {
		//console.log("Activating Element in Object Array: " + objectArray[i]);
		Toggle.activateObject(objectArray[i]);
	}
}

Toggle.deactivateObjectArray = function(objectArray) {
	//console.log("*Deactivating object array*");
	for ( var i = 0; i < objectArray.length; i++) {
		//console.log("Deactivating Element in Object Array: " + objectArray[i]);
		Toggle.deactivateObject(objectArray[i]);
	}
}

Toggle.toggleAccount = function(accId) {
	var acc = Toggle.getObjectByObjectId(accId, 'Account');
	
	var active;
	if ('Toggle__Active__c' in acc) {
		active = acc.Toggle__Active__c;
	} else if ('Active__c' in acc) {
		active = acc.Active__c;
	}
	//console.log("Account Active: " + active);

	var opps = Toggle.getOppsByAccId(accId);
	//console.log(opps.length + ' child opportunities found.');
	var contacts = Toggle.getContactsByAccId(accId);
	//console.log(contacts.length + ' child contacts found.');
	var cases = Toggle.getCasesByAccId(accId);
	//console.log(cases.length + ' child cases found.');
	
	// If the account is active, warn user that the toggle will make all
	// related contacts, cases and opportunities inactive too
	if (active == "Yes") {
		// Deactivate account
		Toggle.deactivateObject(acc);
		
		var deactivateChildren = confirm("Done. Would you like to inactivate all related Contacts, non-closed Opportunities, "  
				+ "and non-closed Cases as well?");

		// Deactivate children 
		if (deactivateChildren == true) {	
			Toggle.deactivateObjectArray(opps);
			Toggle.deactivateObjectArray(contacts);
			Toggle.deactivateObjectArray(cases);
		}
	// If the account is not active, ask the user if he'd like to activate all of its children too
	} else {
		// Activate account
		Toggle.activateObject(acc);

		var activateChildren = confirm("Done. Would you like to activate all related Contacts, non-closed Opportunities, " +
				"and non-closed Cases as well?");

		// Activate children
		if (activateChildren == true) {
			// Activate children
			Toggle.activateObjectArray(opps);
			Toggle.activateObjectArray(contacts);			
			Toggle.activateObjectArray(cases);
		}
	}
}

// The activation toggle only cascades for the children of an account. We can use
// a shared method for the other objects.
Toggle.toggleObject = function(objectId, table) {
	var object = Toggle.getObjectByObjectId(objectId, table);
	var active;
	if ('Toggle__Active__c' in object) {
		active = object.Toggle__Active__c;
	} else if ('Active__c' in acc) {
		active = object.Active__c;
	}
	//console.log("Object Active: " + active);
	
	if (active == "Yes") {
		// Deactivate object
		Toggle.deactivateObject(object);
	} else {
		// Activate object
		Toggle.activateObject(object);
	}
}

Toggle.getObjectByObjectId = function(objectId, table) {
	var object;
	try {
		object = sforce.connection.query(
				"SELECT Id, Toggle__Active__c from " + table + " WHERE Id='" + objectId
						+ "'").getArray("records")[0];
	} catch (e) {
		object = sforce.connection.query(
				"SELECT Id, Active__c from " + table + " WHERE Id='" + objectId + "'")
				.getArray("records")[0];
	}
	return object;
}

Toggle.getOppsByAccId = function(accId) {
	var opps;
	try {
		opps = sforce.connection
				.query(
						"SELECT Id, Toggle__Active__c from Opportunity WHERE IsClosed!=true AND AccountId='"
								+ accId + "'").getArray("records");
	} catch (e) {
		opps = sforce.connection.query(
				"SELECT Id, Active__c from Opportunity WHERE IsClosed!=true AND AccountId='"
						+ accId + "'").getArray("records");
	}
	return opps;
}

Toggle.getContactsByAccId = function(accId) {
	var contacts;
	try {
		contacts = sforce.connection.query(
				"SELECT Id, Toggle__Active__c from Contact WHERE AccountId='"
						+ accId + "'").getArray("records");
	} catch (e) {
		contacts = sforce.connection.query(
				"SELECT Id, Active__c from Contact WHERE AccountId='" + accId
						+ "'").getArray("records");
	}
	return contacts;
}

Toggle.getCasesByAccId = function(accId) {
	var cases;
	try {
		cases = sforce.connection.query(
				"SELECT Id, Toggle__Active__c from Case WHERE Status!='Closed' AND AccountId='"
						+ accId + "'").getArray("records");
	} catch (e) {
		cases = sforce.connection.query(
				"SELECT Id, Active__c from Case WHERE Status!='Closed' AND AccountId='"
						+ accId + "'").getArray("records");
	}
	return cases;
}