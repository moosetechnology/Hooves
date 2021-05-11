"
Our version of the standard uses a master node for a network. 
In the DDS standar i represent the domain. This information comes directly from the network's master.
Domain is required to be connected to a master to be able to see what is going on and to be able to produce connections.
In the hooves side i do also manage applications.
Applications are installed the context of a domain. 
Applications can be as well: uninstalled, started and stopped.
"
Class {
	#name : #HoovesDomain,
	#superclass : #Object,
	#instVars : [
		'url',
		'interface',
		'domain',
		'connection',
		'name',
		'applications',
		'wasConnectedWhileShuttingDown'
	],
	#category : #'Hooves-Model'
}

{ #category : #accessing }
HoovesDomain >> applications [

	^ applications
]

{ #category : #accessing }
HoovesDomain >> connect [
	self isConnected ifTrue: [ 
		^ self error: 'Already connected to domain' ].
	
	connection := HoovesConnection new.
	connection connectTo: self domain with: name andIp: interface ipV4.
	self startApplications.
]

{ #category : #'connection open/close' }
HoovesDomain >> disconnect [
	self isConnected ifFalse: [ ^ self  ].
	self stopApplications.
	connection disconnect. 
	domain destroy. 
	domain := nil. 
	connection := nil.
]

{ #category : #accessing }
HoovesDomain >> domain [

	^ domain ifNil: [ 
		  domain := DDSExternallyDefinedDomain onSimpleDDS: url. " Add the protocol support "
		  domain isConnected ifFalse: [ 
			  domain := nil.
			  ^ self error: 'The master is not currently online.' ].
		  domain addProtocol:
			  (DDSTCPProtocol encoding: MDDSEncoder decoding: MDDSDecoder) ]
]

{ #category : #accessing }
HoovesDomain >> initialize [ 
	super initialize. 
	applications := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
HoovesDomain >> installApplication: aClass [ 
	| newApp |
	newApp := aClass new.
	newApp domain: self. 
	newApp initializeApplication. 
	applications add: newApp. 
	
]

{ #category : #accessing }
HoovesDomain >> interface [
	^ interface
]

{ #category : #accessing }
HoovesDomain >> interface: aDDSNetworkInterface [ 
	interface := aDDSNetworkInterface
]

{ #category : #testing }
HoovesDomain >> isConnected [
	^ connection isNotNil and: [ connection isConnected ]
]

{ #category : #accessing }
HoovesDomain >> name [ 
	^ name
]

{ #category : #accessing }
HoovesDomain >> name: aName [
 	name := aName
]

{ #category : #accessing }
HoovesDomain >> participant [

	^ connection participant
]

{ #category : #'connection open/close' }
HoovesDomain >> quittingImage [

	wasConnectedWhileShuttingDown := self isConnected.
	self disconnect. 
]

{ #category : #accessing }
HoovesDomain >> services [

	^ domain
		  ifNil: [ OrderedCollection new ]
		  ifNotNil: [ self domain services asOrderedCollection ]
]

{ #category : #'as yet unclassified' }
HoovesDomain >> startApplications [

	applications do: [ :a | a start ]
]

{ #category : #'connection open/close' }
HoovesDomain >> startingImage [

	wasConnectedWhileShuttingDown ifTrue: [ self connect ]
]

{ #category : #'connection open/close' }
HoovesDomain >> stopApplications [

	applications do: [ :a | a stop ]
]

{ #category : #accessing }
HoovesDomain >> topics [

	^ domain
		  ifNil: [ OrderedCollection new]
		  ifNotNil: [ self domain topics asOrderedCollection ]
]

{ #category : #'as yet unclassified' }
HoovesDomain >> uninstallApplication: aHoovesModelApp [
	aHoovesModelApp stop. 
	applications remove: aHoovesModelApp
]

{ #category : #accessing }
HoovesDomain >> url [
	^ url
]

{ #category : #accessing }
HoovesDomain >> url: aZnUrl [ 
	url := aZnUrl.
]
