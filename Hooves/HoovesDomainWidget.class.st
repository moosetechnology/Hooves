Class {
	#name : #HoovesDomainWidget,
	#superclass : #SpPresenter,
	#instVars : [
		'domain',
		'name',
		'ip',
		'port',
		'start',
		'save',
		'delete',
		'connect',
		'setDefaultPort',
		'setDefaultIp',
		'nameLabel',
		'ipLabel',
		'portLabel',
		'onDelete',
		'onSave',
		'interfaceLabel',
		'interface'
	],
	#category : #'Hooves-Spec'
}

{ #category : #specs }
HoovesDomainWidget class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #nameLabel height: 25;
		  add: #name height: 25;
		  add: #interfaceLabel height: 25;
		  add: #interface height: 25;
		  add: #ipLabel height: 25;
		  add: (SpBoxLayout newHorizontal
				   add: #ip;
				   add: #setDefaultIp width: 25;
				   yourself)
		  height: 22;
		  add: #portLabel height: 25;
		  add: (SpBoxLayout newHorizontal
				   add: #port;
				   add: #setDefaultPort width: 25;
				   yourself)
		  height: 22;
		  add: (SpBoxLayout newHorizontal
				   add: #save;
				   add: #delete;
				   add: #connect;
				   yourself)
		  height: 50;
		  yourself
]

{ #category : #accessing }
HoovesDomainWidget >> bind [

	ip text: domain url host.
	port number: domain url port.
	name text: domain name.
	connect state: domain isConnected.
	connect label: (domain isConnected
			 ifTrue: [ 'Disconnect' ]
			 ifFalse: [ 'Connect' ]).
	domain interface
		ifNil: [ interface selectIndex: 1 ]
		ifNotNil: [ :i | interface selectItem: i ]
]

{ #category : #accessing }
HoovesDomainWidget >> deleteDomain [

	onDelete cull: domain
]

{ #category : #accessing }
HoovesDomainWidget >> domain: aDomain [
	aDomain ifNil: [ ^ self ].
	domain := aDomain.
	self bind.
]

{ #category : #accessing }
HoovesDomainWidget >> initializeWidgets [ 
	save := self newButton label:'Save'; icon: (self iconNamed:#smallSave); help: 'Save modifications'; action: [ self saveDomain ]; yourself.
	delete := self newButton label:'Delete'; icon: (self iconNamed:#changeRemove);help: 'Delete connection';action: [ self deleteDomain ];  yourself.
	connect := self newToggleButton icon: (self iconNamed: #remote); help: '(Dis)Connect to DDS Server';whenChangedDo: [  : bool | self toogleConnection: bool ]; yourself.
	name := self newTextInput text:'Domain name'; yourself. 
	interfaceLabel := self newLabel label: 'Outgoing Interface'; yourself .
	interface := self newDropList items: DDSNetworkInterface interfacesIpV4;  display: [ :i | i name, ' (', i ipV4 , ')' ];yourself.
	ip := self newTextInput text:'xxx.xxx.xxx.xxx'; yourself.
	port := self newNumberInput number: 11311; yourself.
	setDefaultPort := self newButton icon: (self iconNamed: #image); help: 'Set defaul port';  action: [ self setPort].
	setDefaultIp := self newButton icon: (self iconNamed: #image); help: 'Pick a host IP';  action: [ self setIp ].
	nameLabel := self newLabel label:'DDSDomain Server name:'; yourself .
	ipLabel := self newLabel label:'DDSDomain Server IP Address:'; yourself .
	portLabel := self newLabel label:'DDSDomain Server Port Number'; yourself .
]

{ #category : #accessing }
HoovesDomainWidget >> onDelete: aBlock [
	onDelete :=  aBlock.
]

{ #category : #accessing }
HoovesDomainWidget >> onSave: aBlock [
	onSave := aBlock.
]

{ #category : #accessing }
HoovesDomainWidget >> saveDomain [
	domain url: ('http://{1}:{2}' format: { 
				 ip text.
				 port number asString }) asUrl.
	domain interface: interface selectedItem. 
	onSave cull: domain
]

{ #category : #accessing }
HoovesDomainWidget >> setIp [

	ip text: HoovesInterfacePicker new pickInterface ipV4
]

{ #category : #accessing }
HoovesDomainWidget >> setPort [
	port number: 11311.
]

{ #category : #'as yet unclassified' }
HoovesDomainWidget >> toogleConnection: aBoolean [ 
	aBoolean ifTrue: [ "Save & Connect" self saveDomain. domain connect. ] ifFalse: [ "Disconnect" domain disconnect ].
	self bind. 
]
