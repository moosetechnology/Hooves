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
HoovesStore class >> instance [ 
	^ instance ifNil: [  instance := self new  ]
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
