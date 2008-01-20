#!/bin/sh

TOADDR=jakob@lsn.se

if uuidgen | egrep -q \^a ; then
	p4 sync >/dev/null 2>&1
	mail -s "To do!" $TOADDR < ~/p4/personal/dokument/todo.txt
fi

