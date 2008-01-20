/*
  Copyright (c) 2000   Jakob Borg
  
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/
    
/** @author Jakob Borg <jborg@df.lth.se>
 ** @version $Revision: 1.1.1.1 $
 **/

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/mtio.h>
#include <signal.h>

#include <fstream>
#include <iostream>
#include <string>
#include <list>
using namespace std;

#include "stddefs.h"
#include "chunkheader.h"
#include "file.h"
#include "writer.h"
#include "indexer.h"

bool interrupted = false;

void inthandler(int) {
	cout << "[Interrupted, finishing current chunk and exiting] ";
	interrupted = true;
}

Writer::Writer(string vol, string d) {	
	dest = d;
	volume = vol;
	chunk_idx = 1;

	struct mtop op;
	int tapefd;

	// rewind
	tapefd = open(dest.c_str(), O_RDONLY);
	if (tapefd < 0)
		throw InitError();
	op.mt_op = MTREW;
	op.mt_count = 1;
	ioctl(tapefd, MTIOCTOP, (unsigned long) &op);
	close(tapefd);
	
	// set density to uncompressed
	tapefd = open(dest.c_str(), O_RDONLY);
	if (tapefd < 0)
		throw InitError();
	op.mt_op = MTSETDENSITY;
	op.mt_count = 0x15;
	ioctl(tapefd, MTIOCTOP, (unsigned long) &op);
	close(tapefd);
	
	ifstream tape(dest.c_str());
	tape.read(&label, 1024);
	tape.close();
	if (!tape.good())
		throw InitError();

	// step forward
	tapefd = open(dest.c_str(), O_RDONLY);
	if (tapefd < 0)
		throw InitError();
	op.mt_op = MTFSF;
	op.mt_count = 1;
	ioctl(tapefd, MTIOCTOP, (unsigned long) &op);
	close(tapefd);
}

unsigned Writer::get_chunk_size()
{
	return chunk_size;
}

void Writer::wind_to(int n)
{
	struct mtop op;
	int tapefd;

	// rewind
	tapefd = open(dest.c_str(), O_RDONLY);
	if (tapefd < 0)
		throw InitError();
	op.mt_op = MTREW;
	op.mt_count = 1;
	ioctl(tapefd, MTIOCTOP, (unsigned long) &op);
	close(tapefd);

	// step forward
	tapefd = open(dest.c_str(), O_RDONLY);
	if (tapefd < 0)
		throw InitError();
	op.mt_op = MTFSF;
	op.mt_count = n;
	ioctl(tapefd, MTIOCTOP, (unsigned long) &op);
	close(tapefd);

	chunk_idx = n;
}

void Writer::eom()
{
	struct mtop op;
	int tapefd;

	// go to end
	tapefd = open(dest.c_str(), O_RDONLY);
	if (tapefd < 0)
		throw InitError();
	op.mt_op = MTEOM;
	op.mt_count = 1;
	ioctl(tapefd, MTIOCTOP, (unsigned long) &op);
	close(tapefd);

	// find position
	tapefd = open(dest.c_str(), O_RDONLY);
	if (tapefd < 0)
		throw InitError();
	struct mtget inf;
	ioctl(tapefd, MTIOCGET, (unsigned long) &inf);
	close(tapefd);

	chunk_idx = inf.mt_fileno;
}

void Writer::save(list<File>& list)
{
	files.splice(files.end(), list);
}

void Writer::save(File& file)	
{
	files.push_back(file);
}

bool Writer::sync()
{
	File& foo = *(new File()); // woohoo bogus
	int size = 0;
	list<File> chunk;
	static unsigned kbytes = 0;
	static unsigned written = 0;

	if (kbytes == 0)
		kbytes = Indexer::size(files);
	
	int fs = files.size();
	if (fs == 0)
		return true;
	
	while (fs != 0 && size < chunk_size) {
		foo = files.front();
		chunk.push_back(foo);
		files.pop_front();
		size += foo.get_info().st_size / 1024;
		fs--;
	}

	ofstream f((TMP_DIR + "chunk").c_str());
	for (list<File>::iterator i = chunk.begin(); i != chunk.end(); i++) {
		f << i->get_name() << endl;
	}
	f.close();

	ChunkHeader h(volume, label.label, chunk.size(), Indexer::size(chunk), chunk_idx);
	if (chunk_idx == 1) 
		Indexer::create_index(h, INDEX_DIR + string(label.label) + string(".idx"));
	else
		Indexer::append_index(h, INDEX_DIR + string(label.label) + string(".idx"));
		Indexer::append_index(chunk, INDEX_DIR + string(label.label) + string(".idx"));
	
	cout << "Writing chunk " << chunk_idx << ", " << chunk.size() << " files, " << size/1024 << " Mbytes... ";
	cout.flush();
	
	int pid = fork();
	int status;
	interrupted = false;
	void (*oldhandler)(int) = signal(SIGINT, inthandler);
	
	if (pid == 0) {
		freopen((TMP_DIR + "chunk").c_str(), "r", stdin);
		freopen("/dev/null", "w", stdout);
		freopen("/dev/null", "w", stderr);
		execlp("afio", "afio", "-o", "-Z", "-1", "a", dest.c_str(), 0);
	} else {
		while (wait(&status) != pid);
		if (status != 0)
			throw WriteError();
	}

	signal(SIGINT, oldhandler);

	written += size;
	cout << written / double(kbytes) * 100 << "% done" << endl;

	chunk_idx++;
	return (fs == 0 || interrupted);
}

string Writer::get_dest()
{
	return label.label;
}

string Writer::get_volume()
{
	return volume;
}
