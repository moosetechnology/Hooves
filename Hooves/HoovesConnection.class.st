Class {
	#name : #HoovesConnection,
	#superclass : #Object,
	#instVars : [
		'interface',
		'participant',
		'ip'
	],
	#category : #'Hooves-Model'
}

{ #category : #testing }
HoovesConnection >> connectTo: domain with: name andIp: ipV4 [
	participant ifNotNil: [ ^ self error: 'Participant stll connected' ].
	ip := ipV4.
	participant := DDSDomainParticipant
		               domain: domain
		               name: name
		               ip: ipV4
]

{ #category : #'connection open/close' }
HoovesConnection >> disconnect [
	participant destroy.
	participant := nil. 
]

{ #category : #testing }
HoovesConnection >> isConnected [

	^ participant isNotNil
]

{ #category : #testing }
HoovesConnection >> participant [
	^ participant
]
