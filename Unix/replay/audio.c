/* this file is a part of amp software, (C) tomislav uzelac 1996,1997
 */

/* audio.c      main amp source file 

 * Created by: tomislav uzelac  Apr 1996 
 * Karl Anders Oygard added the IRIX code, 10 Mar 1997.
 * Ilkka Karvinen fixed /dev/dsp initialization, 11 Mar 1997.
 * Lutz Vieweg added the HP/UX code, 14 Mar 1997.
 * Dan Nelson added FreeBSD modifications, 23 Mar 1997.
 * Andrew Richards complete reorganisation, new features, 25 Mar 1997
 * Edouard Lafargue added sajber jukebox support, 12 May 1997
 */

#ifdef DEBUG
#define DPRINT(x)  printf(x);
#else
#define DPRINT(x)		/* x */
#endif

#include "amp.h"

#include <sys/types.h>
#include <sys/stat.h>

#ifndef __BEOS__
#include <sys/uio.h>
#endif

/*#include <sys/socket.h> */
#include <errno.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
/*#include <gtk/gtk.h> */
#include <sys/ipc.h>
#include <sys/shm.h>
#include <signal.h>

#define AUDIO
#include "audio.h"
#include "formats.h"
#include "getbits.h"
#include "huffman.h"
#include "layer2.h"
#include "layer3.h"
#include "position.h"
#include "rtbuf.h"
#include "transform.h"
/*#include "controldata.h" */
/*#include "guicontrol.h" */

#define CHILD_STOP 1

#ifndef __BEOS__
typedef int bool;
#endif

int oldvol;
int _play_frame();
struct AUDIO_HEADER header;
int *cnt, g, snd_eof;
extern int pl_current;
extern int parent;

struct sharedata {
	int cnt;
	int pause;
	int diff;
	int sliding;
	int volume;
	int lock;
	int ok;
	int stop;
	struct AUDIO_HEADER header;
} *shared;

void handler2(int sig)
{
	waitpid(0, 0, 0);
}


int decodeMPEG(void)
{
	uid_t my_uid = getuid();
	pid_t pid;

	pid = fork();
	if (pid) {
		return;
		}
	/*  signal(SIGCHLD, handler2); */
	signal(SIGCHLD, SIG_IGN);

	shared->sliding = shared->diff = 0;

#ifdef LINUX_REALTIME
	set_realtime_priority();

	setreuid(my_uid, my_uid);

	prefetch_initial_fill();
#endif				/* LINUX_REALTIME */

	initialise_globals();

#ifndef LINUX_REALTIME
	if (A_FORMAT_WAVE)
		wav_begin();
#endif				/* LINUX_REALTIME */

	if ((g = gethdr(&header)) != 0) {
		report_header_error(g);
		return -1;
	}
	if (header.protection_bit == 0)
		getcrc();

#ifdef LINUX_REALTIME
	if (setup_fancy_audio(&header) != 0) {
		warn("Cannot set up direct-to-DMA audio. Exiting\n");
		return -1;
	}
#else
	if (setup_audio(&header) != 0) {
		warn("Cannot set up audio. Exiting\n");
		return -1;
	}
#endif				/* LINUX_REALTIME */

	DPRINT("\taudio: memcpy\n");
	memcpy(&(shared->header), &header, sizeof(struct AUDIO_HEADER));
	DPRINT("\taudio: release lock\n");
	shared->lock = 0;
	/*  show_header(&header); */

	if (header.layer == 1) {
		if (layer3_frame(&header, shared->cnt)) {
			warn(" error. blip.\n");
			return -1;
		}
	} else if (header.layer == 2)
		if (layer2_frame(&header, shared->cnt)) {
			warn(" error. blip.\n");
			return -1;
		}
#ifdef LINUX_REALTIME
	if (start_fancy_audio(&header) != 0) {
		warn("Cannot start direct-to-DMA audio. Exiting\n");
		return -1;
	}
#endif				/* LINUX_REALTIME */

	/*
	 * decoder loop **********************************
	 */

	snd_eof = 0;
	shared->cnt = 0;
	shared->stop = 0;
	shared->pause = 0;
	oldvol = shared->volume;
	while (!snd_eof) {
		while (!snd_eof && ready_audio()) {
			if (shared->pause) {
				sleep(1);
				continue;
			}
			/*      if (stop) {
			   statusDisplay(&header,0);
			   return 0;
			   } */
			if (shared->stop == CHILD_STOP) {
				close_audio();
				fclose(in_file);
				shmdt(shared);

				if (A_FORMAT_WAVE) {
					wav_end(&header);
				}
				_exit(0);
			}
			_play_frame();
		}
	}
	_exit(0);
}

int _play_frame()
{
	uid_t my_uid = getuid();
	if ((g = gethdr(&header)) != 0) {
		report_header_error(g);
#ifdef LINUX_REALTIME
		cleanup_fancy_audio();
#else
		if (g == GETHDR_EOF && A_FORMAT_WAVE)
			wav_end(&header);
#endif				/* LINUX_REALTIME */
		snd_eof = 1;
		return 0;
	}
	if (header.protection_bit == 0)
		getcrc();

	if (shared->diff != 0) {
		shared->sliding = 1;

		if (shared->diff > 0)
			shared->cnt += ffwd(&header, shared->diff);
		else if (shared->diff < 0)
			shared->cnt -= rew(&header, -shared->diff);

		shared->diff = shared->sliding = 0;
	}
	if (oldvol != shared->volume) {
/*		printf("setting volume: %d\n", *volume);*/
		audioSetVolume(shared->volume);
		oldvol = shared->volume;
	}
	if (header.layer == 1) {
		if (layer3_frame(&header, shared->cnt)) {
			warn(" error. blip.\n");
			return 0;
		}
	} else if (header.layer == 2)
		if (layer2_frame(&header, shared->cnt)) {
			warn(" error. blip.\n");
			return 0;
		}
	/*  while (gtk_events_pending())
	   gtk_main_iteration(); */
	shared->cnt++;
	memcpy(&(shared->header), &header, sizeof(struct AUDIO_HEADER));
	/*  statusDisplay(&header,cnt);        */

#ifdef LINUX_REALTIME
	if (block_fancy_audio(snd_eof) != 0) {
		warn("Problems with direct-to-DMA audio\n");
		return 0;
	}
#endif
#ifdef LINUX_REALTIME
	if (stop_fancy_audio() != 0) {
		warn("Cannot stop direct-to-DMA audio. Exiting\n");
		return 0;
	}
#endif
	return 1;
}


/* call this once at the beginning
 */
void initialise_decoder(void)
{
	premultiply();
	imdct_init();
	calculate_t43();
}

/* call this before each file is played
 */
void initialise_globals(void)
{
	append = data = nch = 0;
	f_bdirty = TRUE;
	bclean_bytes = 0;

	memset(s, 0, sizeof s);
	memset(res, 0, sizeof res);
}

void report_header_error(int err)
{
	switch (err) {
	case GETHDR_ERR:
		die("error reading mpeg bitstream. exiting.\n");
		break;
	case GETHDR_NS:
		warn("this is a file in MPEG 2.5 format, which is not defined\n");
		warn("by ISO/MPEG. It is \"a special Fraunhofer format\".\n");
		warn("amp does not support this format. sorry.\n");
		break;
	case GETHDR_FL1:
		warn("ISO/MPEG layer 1 is not supported by amp (yet).\n");
		break;
	case GETHDR_FF:
		warn("free format bitstreams are not supported. sorry.\n");
		break;
	case GETHDR_SYN:
		warn("oops, we're out of sync.\n");
		break;
	case GETHDR_EOF:
	default:;		/* some stupid compilers need the semicolon */
	}
}

/* TODO: there must be a check here to see if the audio device has been opened
 * successfuly. This is a bitch because it requires all 6 or 7 OS-specific functions
 * to be changed. Is anyone willing to do this at all???
 */
int setup_audio(struct AUDIO_HEADER *header)
{
	if (A_AUDIO_PLAY)
		if (AUDIO_BUFFER_SIZE == 0) {
			audioOpen(t_sampling_frequency[header->ID][header->sampling_frequency], (header->mode != 3 && !A_DOWNMIX), A_SET_VOLUME);
		} else {
			audioBufferOpen(t_sampling_frequency[header->ID][header->sampling_frequency], (header->mode != 3 && !A_DOWNMIX), A_SET_VOLUME);
		}
	return 0;
}

void close_audio(void)
{
	if (A_AUDIO_PLAY)
		if (AUDIO_BUFFER_SIZE != 0)
			audioBufferClose();
		else
			audioClose();
}

int ready_audio(void)
{
#ifdef LINUX_REALTIME
	return ready_fancy_audio();
#else
	return 1;
#endif
}

/* TODO: add some kind of error reporting here
 */
void play(char *inFileStr, char *outFileStr)
{
	if ((in_file = fopen(inFileStr, "r")) == NULL) {
		warn("Could not open file: %s\n", inFileStr);
		return;
	}
	if (A_WRITE_TO_FILE)
		if ((out_file = fopen(outFileStr, "w")) == NULL) {
			warn("Could not open file: %s\n", outFileStr);
			return;
		}
	decodeMPEG();
	fclose(in_file);
	if (A_WRITE_TO_FILE)
		fclose(out_file);
}
