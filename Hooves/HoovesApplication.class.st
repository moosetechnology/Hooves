Class {
	#name : #HoovesApplication,
	#superclass : #Object,
	#instVars : [
		'domain',
		'connections',
		'running'
	],
	#category : #'Hooves-Model'
}

{ #category : #accessing }
HoovesApplication class >> applications [

	^ self allSubclasses select: #isApp
]

{ #category : #accessing }
HoovesApplication class >> description [ 
	^ self subclassResponsibility 
]

{ #category : #accessing }
HoovesApplication class >> isApp [
	^ false
]

{ #category : #accessing }
HoovesApplication >> domain: aHoovesDomain [ 
	domain := aHoovesDomain
]

{ #category : #initialization }
HoovesApplication >> initializeApplication [
	" Called only once after creation, during the installation process "
]

{ #category : #initialization }
HoovesApplication >> initializeConnections [
	" Called by start. Each time an application starts it is prompted to init connections. ".
	connections := OrderedCollection new.
]

{ #category : #accessing }
HoovesApplication >> name [

	^ self class name , '(' , self class description , ')'
]

{ #category : #initialization }
HoovesApplication >> participant [

	^ domain participant
]

{ #category : #initialization }
HoovesApplication >> registerTypes [

	self types do: [ :t | domain domain registerTypeDefinition: t ]
]

{ #category : #initialization }
HoovesApplication >> start [ 
	self registerTypes. 
 	self initializeConnections. 
	running := true. 
]

{ #category : #accessing }
HoovesApplication >> state [

	^ running
		  ifTrue: [ 'Running' ]
		  ifFalse: [ 'Stopped' ]
]

{ #category : #initialization }
HoovesApplication >> stop [
	running := false.
	connections
		select: [ :i | i class = DDSPublication ]
		thenDo: [ :i | i stopPublishing ].
	connections
		select: [ :i | i class = MDDSSubscription ]
		thenDo: [ :i | i stopSubscription ].
	connections
		select: [ :i | i class = DDSService ]
		thenDo: [ :i | i stopServing ].
	
]

{ #category : #initialization }
HoovesApplication >> types [
	^{}
]
