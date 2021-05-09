Class {
	#name : #HoovesCommandStarter,
	#superclass : #Object,
	#instVars : [
		'command',
		'runningInstance'
	],
	#category : #'Hooves-Model'
}

{ #category : #accessing }
HoovesCommandStarter >> start [
	LibC runCommand: ('{1} &' format: { command })
]
