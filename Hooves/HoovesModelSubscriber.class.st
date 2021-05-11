"
I am a model subscriber. I require a model name and a MooseModel kind class to work. I prompt it by my self.
Once i got my match, you can ask me
#model -> ill give you a moose model.
Or 
#updateModel -> ill request the model publishing to regenerate the model and publish again. 
"
Class {
	#name : #HoovesModelSubscriber,
	#superclass : #HoovesModelTransfer,
	#instVars : [
		'caller',
		'model',
		'modelClass',
		'md5'
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
HoovesModelSubscriber >> initializeApplication [

	super initializeApplication.
	modelClass := UIManager default
		              chooseFrom: MooseModel allSubclasses
		              values: MooseModel allSubclasses
		              title: 'Choose the class for importing the model'.
	modelClass ifNil: [ 
		^ self error: 'Subscriber must have a model class' ]
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
HoovesModelSubscriber >> loadModelFrom: aStream [

	^ modelClass importFromMSEStream: aStream
]

{ #category : #initialization }
HoovesModelSubscriber >> model [
	^ model ifNil: [ 
		  modelString ifNil: [ ^ self error: 'no model available' ].
		  model := self loadModelFrom: modelString readStream .
		  md5 := self md5.
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
	self inform: 'Updating Model!'.
	(version isNil or: [ version < aVersionedModelMessage version ]) 
		ifTrue: [ 
			modelString := aVersionedModelMessage model.
			model := nil.
			version := aVersionedModelMessage version ] ifFalse: [  self inform: 'The received version seems to be too old' ]
]
