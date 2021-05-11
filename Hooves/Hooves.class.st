Class {
	#name : #Hooves,
	#superclass : #SpPresenter,
	#instVars : [
		'store',
		'domains',
		'selectedDomain',
		'details',
		'log'
	],
	#category : #'Hooves-Spec'
}

{ #category : #specs }
Hooves class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: (SpBoxLayout newHorizontal
				   add: #domains width: 400;
				   add: #details;
				   yourself);
		  add: #log;
		  yourself
]

{ #category : #initialization }
Hooves >> bindDomain [

	details domain: selectedDomain
]

{ #category : #initialization }
Hooves >> bindStore [

	domains domains: store domains
]

{ #category : #initialization }
Hooves >> initializeWidgets [

	domains := self instantiate: HoovesDomainsListWidget.
	domains onDomainChanged: [ :dom | self selectDomain: dom ].
	domains onConnectionToggling: [ : isConnecting | self togglingConnection: isConnecting  ].
	details := self instantiate: HoovesDomainDetailsWidget.
	log := self newText.
	
]

{ #category : #initialization }
Hooves >> initializeWindow: aWindow [ 
	aWindow title: 'Hooves'.
	
]

{ #category : #initialization }
Hooves >> logTopic: aContent [ 
	log text: log text, aContent, String crlf
]

{ #category : #initialization }
Hooves >> selectDomain: aDomain [ 
	selectedDomain := aDomain.
	self bindDomain
]

{ #category : #initialization }
Hooves >> store: aStore [ 
	store := aStore. 
	self bindStore. 

]

{ #category : #initialization }
Hooves >> togglingConnection: isConnecting [

	self bindDomain
]
