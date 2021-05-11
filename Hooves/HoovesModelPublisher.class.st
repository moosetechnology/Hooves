"
This abstract class allows a basic model publishing. It provides the publishing, and the update model service. 
A subclass for a specific model should implement the access to a MSE model, a model regeneration method, and optionally a force code reload in the case that the update of a model is related with changes on the code baseline .
"
Class {
	#name : #HoovesModelPublisher,
	#superclass : #HoovesModelTransfer,
	#instVars : [
		'modelPublication',
		'processingFuture'
	],
	#category : #'Hooves-Model'
}

{ #category : #accessing }
HoovesModelPublisher class >> description [ 
	^ 'Moose MSE/Json Model publisher'
]

{ #category : #initialization }
HoovesModelPublisher >> forceCodeReload [
	" The model publisher is usually related with reloading some model, related with code "
]

{ #category : #initialization }
HoovesModelPublisher >> forceRegenerate [
	" Model must be regenerated. This is the MOTO of the model transfer applications. "
	self subclassResponsibility 
]

{ #category : #initialization }
HoovesModelPublisher >> initializeConnections [

	super initializeConnections.
	modelPublication := (self modelTopic publisher publishing:
			                     self participant)
		                    setLatched: true;
		                    yourself.
	connections add: modelPublication.
	connections add: (self updateService
			 serve:
			 (MessageSend receiver: self selector: #updateRequest:response:)
			 for: self participant)
]

{ #category : #initialization }
HoovesModelPublisher >> loadMSEModel [
	" modelString is meant to be filled up with a MSE version of the model"
	self subclassResponsibility 
]

{ #category : #initialization }
HoovesModelPublisher >> processNewVersion [
	processingFuture
		ifNotNil: [ processingFuture isFinished
				ifFalse: [ ^ self	"Already processing" ] ].
	processingFuture := [ [ modelString
		ifNil: [ version := 0 ]
		ifNotNil: [ self forceCodeReload.
			self forceRegenerate ].
	self loadMSEModel.
	self publishModel ]
		ensure: [  ] ] future
]

{ #category : #initialization }
HoovesModelPublisher >> publishModel [
	modelPublication
		publish: [ :versionedModel | 
			versionedModel version: version.
			versionedModel model: modelString ]
]

{ #category : #initialization }
HoovesModelPublisher >> updateRequest: aRequest response: aResponse [
	aRequest name = modelName
		ifFalse: [ aResponse version: -1.
			aResponse
				errorText: 'This model provider does not provide ' , aRequest name.
			^ aResponse ].
	version ifNil: [ version := aRequest version - 1 ].
	aRequest version < version
		ifTrue: [ aResponse version: version.
			^ aResponse ].
	[ self processNewVersion.
	aResponse nextVersion: version.
	^ aResponse ]
		on: Error
		do: [ :e | 
			aResponse nextVersion: -1.
			aResponse
				errorText: ' Error processing new version! ' , e messageText ]
]
