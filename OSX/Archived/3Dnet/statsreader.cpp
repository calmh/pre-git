/*
 *  statsreader.cpp
 *  3Dnet
 *
 *  Created by Jakob Borg on 2005-10-29.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#include "stdafx.h"

#include "statsreader.h"

#ifdef WIN32
#include <winsock2.h>
#else
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h> 
#endif

#include <iostream>
#include <sstream>
using namespace std;

StatsReader* StatsReader::instance() {
	static StatsReader* inst = 0;
	if (inst == 0)
		inst = new StatsReader();
	return inst;
}

StatsReader::StatsReader() {
	struct sockaddr_in serv_addr;
	struct hostent *server;

#ifdef WIN32
	WSAData data;
	WSAStartup(2, &data);
#endif

	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	server = gethostbyname("pim.perspektivbredband.se");
	if (server == NULL) {
		fprintf(stderr,"ERROR, no such host\n");
		exit(0);
	}
	serv_addr.sin_port = htons(12345);
	serv_addr.sin_family = AF_INET;
#ifdef WIN32
	serv_addr.sin_addr.S_un.S_addr = inet_addr("81.186.254.2");
#else
	serv_addr.sin_addr.s_addr = inet_addr("81.186.254.2");
#endif
	cout << "[StatsReader::StatsReader()] Connecting... " << flush;
	connect(sockfd, (const sockaddr*) &serv_addr, sizeof(serv_addr));
	cout << "done." << endl;
}

double* StatsReader::usage(string target) {
	string tline = target + "\n";
	int n = send(sockfd, tline.c_str(), (int) tline.length(), 0);

	char buffer[255];
	int i;
	for (i = 0; i < 255; i++) {
		n = recv(sockfd,buffer + i, 1, 0);
		if (n == -1) {
			double* foo = new double[2];
			foo[0] = foo[1] = 0.0;
			return foo;
		}
		if (buffer[i] == '\n')
			break;
	}
	buffer[i] = 0;
	string tmp(buffer);
	cout << "[StatsReader::usage(\"" << target << "\")] Read: " << tmp << endl;
	istringstream is(tmp);
	double* usage = new double[2];
	is >> usage[0] >> usage[1];
	return usage;
}

StatsReader::~StatsReader() {
#ifdef WIN32
	// close?
#else
	cout << "[StatsReader::~StatsReader()] Closed" << endl;
	close(sockfd);
#endif
}

