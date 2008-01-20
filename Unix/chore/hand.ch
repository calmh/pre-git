# keywords:
# joint limit1 limit2
# bone length
# spacer x y

def j2finger l1 l2:
	joint -10 110
	bone l1
	joint 0 120
	bone l2

def j3finger l1 l2 l3:
	joint -10 110
	bone l1
	joint 0 120
	bone l2
	joint 0 120
	bone l3

def hand:
	array:
		j2finger 10 6
		spacer 5 20
		j3finger 10 7 3
		j3finger 10 10 4
		j3finger 8 6 4
		j3finger 5 5 3

