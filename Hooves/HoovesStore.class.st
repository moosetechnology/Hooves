"
I am here only to store configurations 
"
Class {
	#name : #HoovesStore,
	#superclass : #Object,
	#instVars : [
		'domains',
		'starter'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'Hooves-Model'
}

{ #category : #accessing }
HoovesStore class >> initialize [

	SessionManager default
		registerSystemClassNamed: self name
		atPriority: 60
]

{ #category : #accessing }
HoovesStore class >> instance [ 
	^ instance ifNil: [  instance := self new  ]
]

{ #category : #accessing }
HoovesStore class >> shutDown: quitting [

	(quitting and: [ instance isNotNil ]) ifTrue: [ 
		instance domains do: [ :d | d quittingImage ] ]
]

{ #category : #accessing }
HoovesStore class >> startUp: isImageStarting [

	isImageStarting ifTrue: [ 
		instance domains do: [ :d | d startingImage ] ]
]

{ #category : #accessing }
HoovesStore >> applications [
	^ domains flatCollect: [ :d | d applications ]
]

{ #category : #initialization }
HoovesStore >> domains [ 
	 ^ domains
]

{ #category : #initialization }
HoovesStore >> initialize [
	super initialize.
	starter := OrderedCollection new.
	domains := OrderedCollection new
]

{ #category : #initialization }
HoovesStore >> removeDomain: aDomain [

	domains remove: aDomain
]

{ #category : #initialization }
HoovesStore >> saveDomain: aDomain [

	domains add: aDomain
]
