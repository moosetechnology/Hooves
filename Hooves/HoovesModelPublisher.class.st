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

{ #category : #accessing }
HoovesModelPublisher class >> isApp [ 
	^ true
]

{ #category : #initialization }
HoovesModelPublisher >> forceCodeReload [

	Metacello new
		baseline: 'Alce';
		repository: 'github://impetuosa/Alce';
		onConflictUseIncoming;
		load
]

{ #category : #initialization }
HoovesModelPublisher >> forceRegenerate [

	AlceNorthwindCachedModelAbstractTest resetNorwindCachedModel.
	AlceNorthwindCachedModelAbstractTest regenerateCacheModel.
	version := version + 1
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
	modelString := AlceNorthwindCachedModelAbstractTest cachedModelMSE.
]

{ #category : #initialization }
HoovesModelPublisher >> processNewVersion [
	self assert: modelName = 'norwind'.
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
HoovesModelPublisher >> updateRequest: aRequest response: aResponse [
	aRequest name = modelName ifFalse: [ 
		aResponse version: -1.
		aResponse errorText: 'This model provider does not provide ' , aRequest name.
		^ aResponse 
	].
	aRequest version < version ifTrue: [ 
		aResponse version: version.
			^ aResponse 
	].
	[ 
	   self processNewVersion.
   	   aResponse nextVersion: version.
	   ^ aResponse 
	]
		on: Error
		do: [ :e | 
			aResponse nextVersion: -1.
			aResponse errorText: ' Error processing new version! ' , e messageText 
		]
]
