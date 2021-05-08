Class {
	#name : #HoovesInterfacePicker,
	#superclass : #SpPresenter,
	#instVars : [
		'interface',
		'ok',
		'cancel',
		'interfaces',
		'accepted'
	],
	#category : #'Hooves-Spec'
}

{ #category : #specs }
HoovesInterfacePicker class >> defaultSpec [

	^ SpBoxLayout newVertical add: #interfaces height: 100
]

{ #category : #visiting }
HoovesInterfacePicker >> accept [ 
	accepted :=true.
]

{ #category : #visiting }
HoovesInterfacePicker >> cancel [ 
	accepted :=false.
]

{ #category : #visiting }
HoovesInterfacePicker >> initializeWidgets [
	accepted := true. 
	super initializeWidgets.
	interfaces := self newDropList
		              items:
			              (DDSNetworkInterface interfaces select: [ :i | 
					               i hasIpV4 ]);
		              display: [ :i | i name, ' (', i ipV4 , ')' ];
		              yourself
]

{ #category : #visiting }
HoovesInterfacePicker >> pickInterface [

	self openModalWithSpec.
	^ accepted
		  ifTrue: [ interfaces selectedItem ]
		  ifFalse: [ nil ]
]
