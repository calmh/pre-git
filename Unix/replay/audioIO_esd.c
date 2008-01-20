/* -*- linux-c -*- */

/* this file is a part of amp software, (C) tomislav uzelac 1996,1997

  9-2-98: ESounD support for replay, and anything else that wants to use this.
    - Nick Lopez
  
 */

/* Support for Linux and BSD sound devices */

#include "amp.h"
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include "audioIO.h"
#include "esd.h"

/* declare these static to effectively isolate the audio device */

int AUSIZ=0;
static int audio_fd;

/* audioOpen() */
/* should open the audio device, perform any special initialization              */
/* Set the frequency, no of channels and volume. Volume is only set if */
/* it is not -1 */

void audioOpen(int frequency, int stereo, int volume)
{
	int supportedMixers, play_format = ESD_BITS16;

	play_format |= (stereo ? ESD_STEREO : ESD_MONO );
	if ((audio_fd = esd_play_stream_fallback( play_format, frequency, NULL, "Replay" )) < 0)
	  die("Can't connect to ESounD server");
	DB(audio, msg("Audio device opened on %d\n", audio_fd);
	    )

}


/* audioSetVolume - only code this if your system can change the volume while */
/*                                                                      playing. sets the output volume 0-100 */

void audioSetVolume(int volume)
{
  /* no stream volume control, yet */
}


/* audioFlush() */
/* should flush the audio device */

inline void audioFlush()
{
	DB(audio, msg("audio: flush %d\n", audio_fd));

	fsync( audio_fd );
}


/* audioClose() */
/* should close the audio device and perform any special shutdown */

void audioClose()
{
	close(audio_fd);
	DB(audio, msg("audio: closed %d\n", audio_fd));
}


/* audioWrite */
/* writes count bytes from buffer to the audio device */
/* returns the number of bytes actually written */

inline int audioWrite(char *buffer, int count)
{
	DB(audio, msg("audio: Writing %d bytes to audio descriptor %d\n", count, getAudioFd()));

	return (write(audio_fd, buffer, count));
}


/* Let buffer.c have the audio descriptor so it can select on it. This means    */
/* that the program is dependent on a file descriptor to work. Should really */
/* move the select's etc (with inlines of course) in here so that this is the */
/* ONLY file which has hardware dependent audio stuff in it                                                                             */

int getAudioFd()
{
	return (audio_fd);
}
