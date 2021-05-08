Class {
	#name : #HoovesStartWidget,
	#superclass : #SpPresenter,
	#instVars : [
		'command',
		'commandText',
		'status'
	],
	#category : #'Hooves-Spec'
}

{ #category : #specs }
HoovesStartWidget class >> defaultSpec [

	^ SpBoxLayout newHorizontal
		  add: #commandText;
		  add: #status
]

{ #category : #accessing }
HoovesStartWidget >> bind [
	commandText text: command command.
	
]

{ #category : #accessing }
HoovesStartWidget >> command: aCommand [
	command := aCommand .
	self bind.
]

{ #category : #initialization }
HoovesStartWidget >> initializeWidgets [

	super initializeWidgets.
	status := self newImage
		          image: (self iconNamed: #glamorousGreenCircle);
		          yourself.
	commandText := self newTextInput
		               text: '$HOME/execute';
		               yourself
]
