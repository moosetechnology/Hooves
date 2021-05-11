"
Some times models must be transferred and updated. and then transfer to a network .
This duple of applications (pub and sub) are the building bricks for this feature.

"
Class {
	#name : #HoovesModelTransfer,
	#superclass : #HoovesApplication,
	#instVars : [
		'modelName',
		'modelString',
		'version'
	],
	#category : #'Hooves-Model'
}

{ #category : #initialization }
HoovesModelTransfer >> initializeApplication [
	super initializeApplication.
	modelName := UIManager default
		request: 'Please insert the model name'
		initialAnswer: 'moose-model'.
	modelName
		ifNil: [ ^ self error: 'Subscriber must have a model name' ]
]

{ #category : #accessing }
HoovesModelTransfer >> modelName: aModelName [

	modelName := aModelName
]

{ #category : #accessing }
HoovesModelTransfer >> modelTopic [
	^ domain domain
		  findOrRegisterTopicByName: ('/models/{1}' format: { modelName })
		  type: 'Hooves/VersionedModel'
]

{ #category : #accessing }
HoovesModelTransfer >> serviceUpdateType [
	^ DDSServiceTypeDefinition
		named: 'Hooves/UpdateService'
		request:
			{(MDDSFieldDefinition
				name: #name
				type: (MDDSBasicTypeDefinition for: MDDSStringType new)).
			(MDDSFieldDefinition
				name: #version
				type: (MDDSBasicTypeDefinition for: MDDSInt16Type new))}
		response:
			{(MDDSFieldDefinition
				name: #errorText
				type: (MDDSBasicTypeDefinition for: MDDSStringType new)).
			(MDDSFieldDefinition
				name: #nextVersion
				type: (MDDSBasicTypeDefinition for: MDDSInt16Type new))}
]

{ #category : #accessing }
HoovesModelTransfer >> types [

	^ { 
		  self serviceUpdateType.
		  self versionedModelType }
]

{ #category : #accessing }
HoovesModelTransfer >> updateService [

	^ domain domain
		  findOrRegisterServiceByName:
		  ('/models/{1}/update' format: { modelName })
		  type: 'Hooves/UpdateService'
]

{ #category : #accessing }
HoovesModelTransfer >> versionedModelType [
	^ MDDSTypeDefinition
		named: 'Hooves/VersionedModel'
		defined:
			{(MDDSFieldDefinition
				name: #version
				type: (MDDSBasicTypeDefinition for: MDDSInt16Type new)).
			(MDDSFieldDefinition
				name: #exportType
				type: (MDDSBasicTypeDefinition for: MDDSUInt8Type new)).
			(MDDSFieldDefinition
				name: #modelName
				type: (MDDSBasicTypeDefinition for: MDDSStringType new)).
			(MDDSFieldDefinition
				name: #model
				type: (MDDSBasicTypeDefinition for: MDDSStringType new))}
]
