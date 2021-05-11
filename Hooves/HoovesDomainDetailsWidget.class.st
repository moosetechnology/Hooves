Class {
	#name : #HoovesDomainDetailsWidget,
	#superclass : #SpPresenter,
	#instVars : [
		'domain',
		'details',
		'applicationsList',
		'topicsList',
		'applicationCatalog'
	],
	#category : #'Hooves-Spec'
}

{ #category : #specs }
HoovesDomainDetailsWidget class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #details;
		  yourself
]

{ #category : #initialization }
HoovesDomainDetailsWidget >> applicationCatalog [

	^ applicationCatalog ifNil: [ 
		  applicationCatalog := self newTable.
		  applicationCatalog addColumn: (SpStringTableColumn new
				   title: 'Name';
				   evaluated: [ :each | each name ];
				   yourself).
		  applicationCatalog addColumn: (SpStringTableColumn new
				   title: 'Description';
				   evaluated: [ :each | each description ];
				   yourself).
		  applicationCatalog items: HoovesApplication applications.
		  applicationCatalog contextMenu: self catalogMenu.
		  applicationCatalog ]
]

{ #category : #initialization }
HoovesDomainDetailsWidget >> applicationMenu [
	^ self newMenu
		title: 'Application options';
		addGroup: [ :aGroup | 
			aGroup
				addItem: [ :anItem | 
					anItem
						name: 'Inspect';
						iconName: #inspect;
						description: 'Inspect Application';
						action: [ self applicationsList selection selectedItem inspect ] ];
				addItem: [ :anItem | 
					anItem
						name: 'Start';
						iconName: #start;
						action: [ self applicationsList selectedItem start.
							self bind ] ];
				addItem: [ :anItem | 
					anItem
						name: 'Stop';
						iconName: #stop;
						action: [ self applicationsList selection selectedItem stop.
							self bind ] ];
				addItem: [ :anItem | 
					anItem
						name: 'Uninstall from Domain';
						iconName: #destroy;
						action: [ domain uninstallApplication: self applicationsList selectedItem.
							self bind ] ] ]
]

{ #category : #initialization }
HoovesDomainDetailsWidget >> applicationsList [

	^ applicationsList ifNil: [ 
		  applicationsList := self newTable.
		
		  applicationsList addColumn: (SpStringTableColumn new
				   title: 'Name';
				   evaluated: [ :each |  each name  ];
				   yourself).
		  applicationsList addColumn: (SpStringTableColumn new
				   title: 'State';
				   evaluated: [ :each | each state ];
				   yourself).
		  applicationsList contextMenu: self applicationMenu.
		  applicationsList ]
]

{ #category : #initialization }
HoovesDomainDetailsWidget >> bind [
	domain isConnected
		ifTrue: [ topicsList items: domain topics , domain services ]
		ifFalse: [ topicsList items: {} ].
	applicationsList items: domain applications
]

{ #category : #initialization }
HoovesDomainDetailsWidget >> catalogMenu [
	^ self newMenu
		title: 'Catalog options';
		addGroup: [ :aGroup | 
			aGroup
				addItem: [ :anItem | 
					anItem
						name: 'Browse';
						description: 'Browse application class';
						action: [ self applicationCatalog selectedItem browse ] ];
				addItem: [ :anItem | 
					anItem
						name: 'Install In Domain';
						iconName: #open;
						action: [ 
							domain installApplication: self applicationCatalog selection selectedItem.
							self bind.
							 ] ] ]
]

{ #category : #initialization }
HoovesDomainDetailsWidget >> domain: aDomain [ 
	aDomain ifNil: [ ^ self ].
	domain := aDomain.
	self bind. 
]

{ #category : #initialization }
HoovesDomainDetailsWidget >> initializeWidgets [
	super initializeWidgets.
	details := self newNotebook.
	self topicsList. 
	self applicationsList.
	self
		newDetailsNotebookPage: 'Topics & Services'
		iconNamed: #list
		provider: [ self topicsList ].
	self
		newDetailsNotebookPage: 'Applications'
		iconNamed: #list
		provider: [ self applicationsList ].
	self
		newDetailsNotebookPage: 'Catalog'
		iconNamed: #list
		provider: [ self applicationCatalog ].
	
	
]

{ #category : #initialization }
HoovesDomainDetailsWidget >> kindNameFor: anObject [

	anObject class = MDDSTopic ifTrue: [ ^ 'Topic' ].
	anObject class = DDSService ifTrue: [ ^ 'Service' ].
	self halt
]

{ #category : #initialization }
HoovesDomainDetailsWidget >> newDetailsNotebookPage: title iconNamed: iconname provider: provider [
	details addPage: (SpNotebookPage
			 title: title
			 icon: (self iconNamed: iconname)
			 provider: provider)
]

{ #category : #initialization }
HoovesDomainDetailsWidget >> topicsList [

	^ topicsList ifNil: [ 
		  topicsList := self newTable.
		  topicsList addColumn: (SpStringTableColumn new
				   title: 'Kind';
				   evaluated: [ :each | self kindNameFor: each ];
				   yourself).
		  topicsList addColumn: (SpStringTableColumn new
				   title: 'Name';
				   evaluated: [ :each | each name ];
				   yourself).
		  topicsList addColumn: (SpStringTableColumn new
				   title: 'Type';
				   evaluated: [ :each | each type name ];
				   yourself).
		  topicsList contextMenu: self topicsMenu.
		  topicsList ]
]

{ #category : #initialization }
HoovesDomainDetailsWidget >> topicsMenu [

	^ self newMenu
		  title: 'Topics & Services options';
		  addGroup: [ :aGroup | 
			  aGroup addItem: [ :anItem | 
					  anItem
						  name: 'Inspect';
						  description: 'Inspect Descriptor';
						  action: [ self applicationsList selectedItem inspect ] ] ]
]
