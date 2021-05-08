Class {
	#name : #HoovesModelSubscriber,
	#superclass : #HoovesModelTransfer,
	#instVars : [
		'caller',
		'model'
	],
	#category : #'Hooves-Model'
}

{ #category : #accessing }
HoovesModelSubscriber class >> description [ 
	^ 'Moose MSE/Json Model subscriber'
]

{ #category : #accessing }
HoovesModelSubscriber class >> isApp [ 
	^ true
]

{ #category : #initialization }
HoovesModelSubscriber >> initializeConnections [

	super initializeConnections.
	caller := self updateService callerFor: self participant.
	connections add: caller.
	connections add: (self modelTopic subscriber
			 forParticipant: self participant
			 onRead: (MessageSend receiver: self selector: #updateModel:)
			 onFailure: (MessageSend receiver: self selector: #manageError:))
]

{ #category : #initialization }
HoovesModelSubscriber >> model [
	^ model ifNil: [ 
		  modelString ifNil: [ ^ self error: 'no model available' ].
		  model := AlcixModel importFromMSEStream: modelString readStream.
		  modelString := nil.
		  model ]
]

{ #category : #initialization }
HoovesModelSubscriber >> updateModel [

	caller call: [ :req | 
		req
			name: modelName;
			version: version ]
]

{ #category : #initialization }
HoovesModelSubscriber >> updateModel: aVersionedModelMessage [
	(version isNil or: [ version < aVersionedModelMessage version ]) 
		ifTrue: [ 
			modelString := aVersionedModelMessage model.
			model := nil.
			version := aVersionedModelMessage version ]
]
