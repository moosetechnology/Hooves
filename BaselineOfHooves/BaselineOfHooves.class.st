Class {
	#name : #BaselineOfHooves,
	#superclass : #BaselineOf,
	#category : #BaselineOfHooves
}

{ #category : #baselines }
BaselineOfHooves >> baseline: spec [

	<baseline>
	spec for: #'pharo8.x' do: [ 
		spec
			baseline: #TaskIt
			with: [ spec repository: 'github://pharo-contributions/taskit/src' ].
		spec
			baseline: #SimpleDDS
			with: [ spec repository: 'github://pharo-robotics/SimpleDDS/src' ].

		spec package: #Hooves with: [ spec requires: #( TaskIt SimpleDDS ) ] ].
	spec for: #'pharo9.x' do: [ 
		spec
			baseline: #SimpleDDS
			with: [ spec repository: 'github://pharo-robotics/SimpleDDS/src' ].

		spec package: #Hooves with: [ spec requires: #( SimpleDDS ) ] ]
]
