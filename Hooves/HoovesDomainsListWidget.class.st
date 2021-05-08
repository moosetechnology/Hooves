Class {
	#name : #HoovesDomainsListWidget,
	#superclass : #SpPresenter,
	#instVars : [
		'domains',
		'domainsList',
		'addButton',
		'temporaryDomains',
		'domainViewer',
		'onDomainChanged'
	],
	#category : #'Hooves-Spec'
}

{ #category : #specs }
HoovesDomainsListWidget class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: (SpBoxLayout newHorizontal
				   add: #domainsList;
				   add: #addButton width: 50;
				   yourself) height: 30;
		  add: #domainViewer yourself
]

{ #category : #initialization }
HoovesDomainsListWidget >> add [

	| new |
	new := HoovesDomain new
		       name: 'new domain configuration';
		       url: 'http://ip:11311' asUrl;
		       yourself.

	temporaryDomains add: new.
	self bind.
	domainsList selectItem: new
]

{ #category : #initialization }
HoovesDomainsListWidget >> bind [

	domainsList items: domains , temporaryDomains
]

{ #category : #initialization }
HoovesDomainsListWidget >> delete: domain [

	temporaryDomains remove: domain ifAbsent: [ domains remove: domain ].
	self bind.
	
]

{ #category : #initialization }
HoovesDomainsListWidget >> domainChangeTo: aDomain [

	domainViewer domain: aDomain.
	onDomainChanged ifNotNil: [ onDomainChanged cull: aDomain ]
]

{ #category : #initialization }
HoovesDomainsListWidget >> domains: aSetOfDomains [

	domains := aSetOfDomains .
	temporaryDomains := OrderedCollection new.
	self bind
]

{ #category : #initialization }
HoovesDomainsListWidget >> initialize [

	super initialize.
	temporaryDomains := OrderedCollection new.
	
]

{ #category : #initialization }
HoovesDomainsListWidget >> initializeWidgets [

	super initializeWidgets.
	domainsList := self newDropList
		               display: [ :d | d name ];
		               whenSelectedItemChangedDo: [ :item | 
			               self domainChangeTo: item ];
		               yourself.
	addButton := self newButton
		             icon: (self iconNamed: #add);
		             action: [ self add ].

	domainViewer := HoovesDomainWidget new.
	domainViewer onSave: [ :domain | self save: domain ].
	domainViewer onDelete: [ :domain | self delete: domain ]
]

{ #category : #initialization }
HoovesDomainsListWidget >> onDomainChanged: aBlock [ 
	onDomainChanged := aBlock
]

{ #category : #initialization }
HoovesDomainsListWidget >> save: domain [
	temporaryDomains remove: domain ifAbsent: [ ^ self ].
	domains add: domain
]
