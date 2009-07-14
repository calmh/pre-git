 /* -*- linux-c -*- */

/*  $Id: replay.c,v 1.1.1.1 2003/03/01 12:55:12 jb Exp $
 *
 *  L3Play GTK MP3 Player
 * 
 *  Copyright (c) 1998 Jakob Borg
 * 
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, 
 *  USA.
 */

#ifdef DEBUG
#define DPRINT(x)  printf(x);
#else
#define DPRINT(x)		/* x */
#endif

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <signal.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <glob.h>
#include <time.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <gtk/gtk.h>

#undef MIN
#undef MAX
#undef TRUE
#undef FALSE

#include "amp.h"
#include "audio.h"
#include "formats.h"
#include "getbits.h"
#include "huffman.h"
#include "layer2.h"
#include "layer3.h"
#include "position.h"
#include "rtbuf.h"
#include "transform.h"
#include "controldata.h"
#include "guicontrol.h"

#include "pixmaps.h"

/* Internationarization & Code Convertion */

#define CODECONV(x) x
#ifdef I18N
#       include <locale.h>
#       ifdef	JAPANESE
#	include <jlib.h>
#       undef CODECONV
#	define CODECONV(x) toStringEUC(x)
#	endif
#endif

/* Get id3tag information from mp3file */
#include "id3tag.h"

#define PROGRAM_NAME "Replay"
#define VERSION_MAJ 0
#define VERSION_MIN 58
#define CONFDIR ".replay"
#define RCFILE ".replayrc"
#define OPTFILE ".options"
#define DEFAULTPL "default"

#define CLEAR 0
#define SET 1
#define TOGGLE 2
#define CHECK 3

#define D_BUT_PREV 0
#define D_BUT_PLAY 1
#define D_BUT_PAUSE 2
#define D_BUT_STOP 3
#define D_BUT_NEXT 4
#define D_BUT_LIST 5

#define D_BUT_PL_UP 7
#define D_BUT_PL_DOWN 8
#define D_BUT_PL_REMOVE 9
#define D_BUT_PL_ADD 6
#define D_BUT_PL_CLEAR 10
#define D_BUT_PL_SAVE 11
#define D_BUT_PL_LOAD 12
#define D_BUT_PL_SORT 13
#define D_BUT_SAVE_WAV 14
#define D_BUT_OPTIONS 17

#define D_TOG_REPEAT 0
#define D_TOG_RANDOM 1
#define D_TOG_DOWNMIX 2
#define D_TOG_REMAINING 12
#define D_TOG_SILENT 13
#define D_TOG_SAVEALL 14

#define D_MENU_LOAD_PL 3
#define D_MENU_SAVE_PL 4
#define D_MENU_LOAD_MP3 5
#define D_MENU_EXIT 6

#define D_MENU_HELP_ABOUT 7
#define D_MENU_HELP_REPLAY 8
#define D_MENU_HELP_PLED 9
#define D_MENU_HELP_MAIN 10
#define D_MENU_HELP_SAVE 15
#define D_MENU_SAVE_OPTS 16

#define CHILD_STOP 1

#define OPT_RANDOM 0
#define OPT_REMAINING 1
#define OPT_REPEAT 2
#define OPT_SAVEALL 4
#define OPT_NUMBER_OF 5

gint BUT_PREV = D_BUT_PREV;
gint BUT_PLAY = D_BUT_PLAY;
gint BUT_PAUSE = D_BUT_PAUSE;
gint BUT_STOP = D_BUT_STOP;
gint BUT_NEXT = D_BUT_NEXT;
gint BUT_LIST = D_BUT_LIST;

gint BUT_PL_UP = D_BUT_PL_UP;
gint BUT_PL_DOWN = D_BUT_PL_DOWN;
gint BUT_PL_REMOVE = D_BUT_PL_REMOVE;
gint BUT_PL_ADD = D_BUT_PL_ADD;
gint BUT_PL_CLEAR = D_BUT_PL_CLEAR;
gint BUT_PL_SAVE = D_BUT_PL_SAVE;
gint BUT_PL_LOAD = D_BUT_PL_LOAD;
gint BUT_PL_SORT = D_BUT_PL_SORT;
gint BUT_SAVE_WAV = D_BUT_SAVE_WAV;
gint BUT_OPTIONS = D_BUT_OPTIONS;

gint TOG_REPEAT = D_TOG_REPEAT;
gint TOG_RANDOM = D_TOG_RANDOM;
gint TOG_DOWNMIX = D_TOG_DOWNMIX;
gint TOG_REMAINING = D_TOG_REMAINING;
gint TOG_SILENT = D_TOG_SILENT;
gint TOG_SAVEALL = D_TOG_SAVEALL;

gint MENU_LOAD_PL = D_MENU_LOAD_PL;
gint MENU_SAVE_PL = D_MENU_SAVE_PL;
gint MENU_LOAD_MP3 = D_MENU_LOAD_MP3;
gint MENU_EXIT = D_MENU_EXIT;

gint MENU_HELP_ABOUT = D_MENU_HELP_ABOUT;
gint MENU_HELP_REPLAY = D_MENU_HELP_REPLAY;
gint MENU_HELP_PLED = D_MENU_HELP_PLED;
gint MENU_HELP_MAIN = D_MENU_HELP_MAIN;
gint MENU_HELP_SAVE = D_MENU_HELP_SAVE;
gint MENU_SAVE_OPTS = D_MENU_SAVE_OPTS;

GtkWidget *w_main;
GtkWidget *w_pl;
GtkWidget *w_prefs;
GtkWidget *w_selector;
GtkWidget *pl_selector;
GtkWidget *status;
GtkWidget *total;
GtkWidget *playtime;
GtkWidget *bar;
GtkWidget *volume_b;
GtkWidget *pl_playtime;
GtkWidget *opt_remaining_menu_item;
GtkAdjustment *adj;
GtkAdjustment *v_adj;
GtkStyle *style ;
GdkPixmap *p_tickmark;
GdkBitmap *tm_mask;
GtkWidget *button[6];
int leds[6] = {0, 0, 0, 0, 0, 0};
GtkWidget *pixmapwid[6];
GdkPixmap *pixmap[6][2];
GdkBitmap *mask[6][2];

GtkWidget *pll;
gint current = -1;
gint selected = 0;

gchar *save_as = NULL;
gint pl_index = 0;
gint songs_left = 0;

gint playing = 0;
gint auto_range = 1;
gint loading = 1;
gint no_auto_load = 0;
gint timeout;
unsigned long total_secs = 0;
unsigned long total_bytes = 0;
struct AUDIO_HEADER header;

/*extern int *sliding;
extern int *diff;
extern int *volume;*/
extern FILE *in_file;
time_t click;

gint options[OPT_NUMBER_OF] = {0, 0, 0, 0, 0};

gint filesize;
gchar *fdata;
gchar *ftotal;
gchar *confdir;
gchar *rcfile;
gchar *defaultpl;
gchar *initial_playlist;

/* id3 tag information */
MP3_TAG *id3;

char *copyright_message = "\n\
Copyright (c) 1998 Jakob Borg <jakob@debian.org>\n\
This program is based on amp which is _not_ GPL'd, see README.amp\n\
Portions by Jakob Borg _are_ GPL'd, see the source code.\n\
Latest version and source code can be found at http://replay.linuxpower.org\n\n\
ESD Extension by Nick Lopez\n\
ID3TAG & I18N Extensions by Daisuke Taruki\n\
Patches by various people\n\
";

gchar *help_message = "\n\
Usage: replay [options], where options are:\n\
-h, --help      Show this help text.\n\
-m, --mono      Downmix to mono.\n\
-r, --repeat    Play selected tracks endlessly.\n\
-R, --random    Play selected tracks in random order.\n\
-p, --playlist  Should be followed by the name of a playlist to load.\n\
If it is not, Replay will instead avoid loading the default\n\
playlist. This playlist should be called default and placed\n\
in the default playlist directory, usually ~/.replay.\n\
-b, --buffer    Should be followed by buffer size in kb (64-10000).\n\
-a, --remaining Show remaining time for tracks.\n\
-s, --save      Save all played tracks as WAV's in the current dir.\n\
-S, --silent    No audio, high speed.\n\
-N, --noauto    Don't automatically start playing\n\
filename        Name of a track to load.\n\
Just suffix any option with - to reverse meaning\n\
\n\
It also accepts the standard GTK options:\n\
--display, --debug-level, --no-xshm, --sync, --show-events, --no-show-events\n\
--name, --class\n\
\n\
The following signals may be used (apart from the obvious):\n\
SIGUSR1: Previous\n\
SIGUSR2: Next\n\
\n\
Options may be given any number of times.\n";

gchar *help_main_message = "\n\
The top row of widgets contains two time counters and one slider. The left\n\
time counter shows the time elapsed so far, the right one shows the estimated\n\
length of the track. The slider in between gives you an opportunity to seek in\n\
the track\n\
\n\
The buttons should be self explanatory.\n\
\n\
The next row is just an informative label, also self explanatory.\n";

gchar *help_pled_message = "\n\
The Playlist Editor contains on the left the current playlist, and on the\n\
right a colun of buttons. 'Load...' and 'Save...' operates on the entire\n\
playlist, while 'Add...' adds a single track file to the list without\n\
disturbing the other files already there.\n";

gchar *help_save_message = "\n\
You can save to .wav in two different ways. The first is to select 'File|Save WAV...'\n\
which will bring up  dialog asking where to save the next file played. After that\n\
file, the player will revert to normal playing.\n\
\n\
The other way is to check 'Options|Save to WAV' which will cause the player to save all\n\
subsequent tracks as trackname.wav in the current directory.\n\
\n\
In both of these cases you can also check Options|Silent to turn off audio and speed up\n\
playback (to system-limited speed).\n\
\n\
Note that you cn still seek and use all the normal player functions when recording.\n";

void init_main(int, char *[]);
void do_play();
void do_stop();
void do_next();
void do_prev();

void add_to_playlist(gchar *);
void delete_event(GtkWidget *, GdkEvent *, gpointer *);

void button_callack(GtkWidget *, gint *);
void menu_callback(GtkWidget *, gint *);
void selection_callback(GtkCList *, gint, gint, GdkEventButton *);
void slider_callback(GtkAdjustment * adj, struct AUDIO_HEADER *);
void volume_callback(GtkAdjustment * adj, struct AUDIO_HEADER *);

void selected_mp3(GtkWidget * w, GtkFileSelection * fs);
void recurse(gchar *filename);
void selected_pl_load(GtkWidget *, GtkFileSelection *);
void selected_pl_save(GtkWidget *, GtkFileSelection *);
void selected_wav_save(GtkWidget * w, GtkFileSelection * fs);
int statusDisplay(struct AUDIO_HEADER *header);
void load_playlist(gchar * filename);
void update_pl_playtime();

void show_header(struct AUDIO_HEADER *);
void init_selector();
void init_prefs();
void init_pl();
void show_help_window(gchar *, gchar *);

void popup_callback(GtkWidget * widget, GdkEvent * event);

void load_options();
void callback_func( GtkWidget *widget, GdkEvent  *event, gpointer callback_data );

gchar *basename2(gchar * path);
GtkWidget *xpm_label_box(gchar * xpm_data[], gint, gint);
int tickmark(int set, int num);

void sigchld_handler(int);
void sigusr1_handler(int);
void sigusr2_handler(int);
void clear_marks();
void set_marks();

void column_callback(GtkCList * clist, gint column);
void select_row_callback(GtkWidget *widget, gint row, gint column, GdkEventButton *event, gpointer data);
void on_led(int i);

int parent;
/*extern int *cnt;*/

extern struct sharedata {
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


/* main() */

int main(int argc, char *argv[])
{
	gchar *home;
	struct stat a;
	int i;
	int ident;
	int dont_play = 0;

	/*	FILE *pidfile;*/
	pid_t pid;

	id3=(MP3_TAG*)malloc(sizeof(MP3_TAG));

	pid = getpid();
	printf("My PID is %i\n", pid);       
	/*	pidfile = fopen("/tmp/replay.pid", "w");
		fprintf(pidfile, "%i", pid);
		fclose(pidfile); */

	DPRINT("main()\n");

	srandom(time(NULL));
	parent = 1;

	AUDIO_BUFFER_SIZE = 0;
	A_DUMP_BINARY = FALSE;
	A_QUIET = FALSE;
	A_FORMAT_WAVE = FALSE;
	A_SHOW_CNT = FALSE;
	A_SET_VOLUME = -1;
	A_SHOW_TIME = 0;
	A_AUDIO_PLAY = TRUE;
	A_WRITE_TO_FILE = FALSE;
	A_MSG_STDOUT = FALSE;
	A_DOWNMIX = FALSE;

	ident = shmget(IPC_PRIVATE, sizeof(struct sharedata), IPC_CREAT | 0600);
	if (ident == -1) {
		printf("Aieeh! Failed to get shared memory segment!\n");
		abort();
	}
	(char *) shared = shmat(ident, NULL, 0);
	if (!shared) {
		printf("Aieeh! Failed to attach to shared memory segment!\n");
		abort();
	}

	shared->lock = 0;
	shared->diff = shared->sliding = 0;

	signal(SIGCHLD, sigchld_handler);
	signal(SIGUSR1, sigusr1_handler);
	signal(SIGUSR2, sigusr2_handler);

	/* check directory */

	home = getenv("HOME");
	confdir = malloc(strlen(home) + strlen(CONFDIR) + 3);
	sprintf(confdir, "%s/%s/", home, CONFDIR);
	defaultpl = malloc(strlen(confdir) + strlen(DEFAULTPL) + 1);
	sprintf(defaultpl, "%s%s", confdir, DEFAULTPL);
	rcfile = malloc(strlen(home) + strlen(RCFILE) + 2);
	sprintf(rcfile, "%s/%s", home, RCFILE);
	if (stat(confdir, &a))
		if (mkdir(confdir, 0755))
			fprintf(stderr, "Couldn't create '%s'.\n", confdir);
		else
			fprintf(stderr, "Created '%s'.\n", confdir);

	load_options();

	DPRINT("init_decoder\n");
	initialise_decoder();

	if (argc > 1) {
		for (i = 1; argv[i] != NULL; i++) {
			if (!strcmp(argv[i], "-h") || !strcmp(argv[i], "--help")) {
				printf("%s %d.%d [build %s]\n", PROGRAM_NAME, VERSION_MAJ, VERSION_MIN, DATE);
				printf(copyright_message);
				printf(help_message);
				exit(1);
			} else if (!strcmp(argv[i], "-m") || !strcmp(argv[i], "--mono")) {
				A_DOWNMIX = TRUE;
			} else if (!strcmp(argv[i], "-m-") || !strcmp(argv[i], "--mono-")) {
				A_DOWNMIX = FALSE;
 			} else if (!strcmp(argv[i], "-r") || !strcmp(argv[i], "--repeat")) {
				options[OPT_REPEAT] = TRUE;
 			} else if (!strcmp(argv[i], "-r-") || !strcmp(argv[i], "--repeat-")) {
				options[OPT_REPEAT] = FALSE;
			} else if (!strcmp(argv[i], "-a") || !strcmp(argv[i], "--remaining")) {
				options[OPT_REMAINING] = TRUE;
			} else if (!strcmp(argv[i], "-a-") || !strcmp(argv[i], "--remaining-")) {
				options[OPT_REMAINING] = FALSE;
			} else if (!strcmp(argv[i], "-s") || !strcmp(argv[i], "--save")) {
				options[OPT_SAVEALL] = TRUE;
			} else if (!strcmp(argv[i], "-s-") || !strcmp(argv[i], "--save-")) {
				options[OPT_SAVEALL] = FALSE;
			} else if (!strcmp(argv[i], "-R") || !strcmp(argv[i], "--random")) {
				options[OPT_RANDOM] = TRUE;
			} else if (!strcmp(argv[i], "-R-") || !strcmp(argv[i], "--random-")) {
				options[OPT_RANDOM] = FALSE;
			} else if (!strcmp(argv[i], "-b") || !strcmp(argv[i], "--buffer")) {
				AUDIO_BUFFER_SIZE = atoi(argv[++i]) * 1024;
			} else if (!strcmp(argv[i], "-S") || !strcmp(argv[i], "--silent")) {
				A_AUDIO_PLAY = 0;
			} else if (!strcmp(argv[i], "-S-") || !strcmp(argv[i], "--silent-")) {
				A_AUDIO_PLAY = 0;
			} else if (!strcmp(argv[i], "-N") || !strcmp(argv[i], "--noauto")) {
				dont_play = 1;
			} else if (!strcmp(argv[i], "-N-") || !strcmp(argv[i], "--noauto-")) {
				dont_play = 0;
			}
		}
	}
	init_main(argc, argv);
	init_pl();
/*	init_prefs();*/
	init_selector();

	if (argc > 1) {
		for (i = 1; argv[i] != NULL; i++) {
			if (!strcmp(argv[i], "-p") || !strcmp(argv[i], "--playlist")) {
				no_auto_load = 1;
				if (!argv[i+1]) {
					break;
				}
				if (!stat(argv[i+1], &a)) {
					initial_playlist = argv[i+1];
					i++;
				}
			} else {
				if (!stat(argv[i], &a) && (S_ISLNK(a.st_mode) || S_ISREG(a.st_mode))) {
					loading = 1;
					add_to_playlist(argv[i]);
					loading = 0;
				}
			}
		}
	}
	DPRINT("\twidget_show(main)\n");
	gtk_widget_show(w_main);

	if (initial_playlist != NULL) {
		load_playlist(initial_playlist);
	} else if (!no_auto_load && !stat(defaultpl, &a)) {
		load_playlist(defaultpl);
	}
	if (options[OPT_RANDOM] && (current != -1))
		current = random() % pl_index;

	if (current != -1 && !dont_play)
		do_play();
	gtk_main();


	free(id3);
	return 0;
}

/* begin playing mp3 #current||selected */

void do_play()
{
	gchar *filename;
	struct stat temp;
	gint i = 0;
	time_t a, b;

	filename = gtk_clist_get_row_data(GTK_CLIST(pll), current);

	read_tag(filename,id3);

	DPRINT("do_play()\n");

	if (shared->pause || playing) {
		do_stop();
	}
	loading = 1;
	gtk_clist_select_row(GTK_CLIST(pll), current, 0);
	tickmark(CLEAR, current);

	loading = 0;
	stat(filename, &temp);
	filesize = temp.st_size;
	playing = 1;
	shared->stop = 0;
	shared->lock = 1;
	DPRINT("\tplay\n");
	on_led(1);
	if (options[OPT_SAVEALL]) {
		save_as = malloc(strlen(basename2(filename)) + 5);
		sprintf(save_as, "%s.wav", basename2(filename));
		A_WRITE_TO_FILE = A_FORMAT_WAVE = 1;
	}
	DPRINT(filename);
	DPRINT("\n");
	DPRINT(save_as);
	DPRINT("\n");
	play(filename, save_as);
	a = b = 0;
	while (shared->lock && playing) {
		DPRINT("\tWaiting for lock to be released...\n");
		a = time(NULL);
		if (a != b) {
			i++;
			b = a;
		}
		if (i > 3) {
			printf("\nGiving while waiting for sound. There is obviously a problem.\n");
			break;
		}
	}
	if (!playing)
		return;
	DPRINT("\n\tshow_header\n");
	show_header(&(shared->header));
	if (!playing)
		return;
	timeout = gtk_timeout_add(900, (GtkFunction) statusDisplay, &(shared->header));
}

/* stop playing mp3 */

void do_stop()
{
	gchar *title;
	gchar *buffer;
	gchar *data2;
	gint i;

	DPRINT("do_stop()\n");

	signal(SIGCHLD, SIG_IGN);

	shared->pause = 0;
	shared->stop = CHILD_STOP;
	playing = 0;
	shared->stop = 1;
	sigchld_handler(SIGCHLD);

	signal(SIGCHLD, sigchld_handler);
}

/* play next in playlist */

void do_next()
{
	DPRINT("do_next()\n");

	if (!pl_index)
		return;

	if (!songs_left)
		if (options[OPT_REPEAT]) {
			clear_marks();
			current = 0;
		}
		else {
			DPRINT("No more songs to play\n");
			return;
		}
	do {
#ifdef DEBUG
		printf("songs_left: %d\n", songs_left);
#endif
		if (options[OPT_RANDOM]) {
			current = random() % pl_index;
			
			if (!gtk_clist_row_is_visible(GTK_CLIST(pll), current))
				gtk_clist_moveto(GTK_CLIST(pll), current, 0, 0.0, 0.0);
		} else {
			if (current < (pl_index - 1)) {
				current++;

				if (!gtk_clist_row_is_visible(GTK_CLIST(pll), current))
					gtk_clist_moveto(GTK_CLIST(pll), current, 0, 0.5, 0.0);
			} else 
				current = 0;
		}
	} while (tickmark(CHECK, current));
	do_play();
}

/* play previous in playlist */

void do_prev()
{
	DPRINT("do_prev()\n");

	if (!pl_index)
		return;

	if (!songs_left)
		if (options[OPT_REPEAT]) {
			clear_marks();
			current = 0;
		}
		else
			return;

	if (options[OPT_RANDOM]) {
		current = random() % pl_index;
		if (!gtk_clist_row_is_visible(GTK_CLIST(pll), current))
			gtk_clist_moveto(GTK_CLIST(pll), current, 0, 0.5, 0.0);
	} else {
		if (current > 0) {
			current--;
			if (!gtk_clist_row_is_visible(GTK_CLIST(pll), current))
				gtk_clist_moveto(GTK_CLIST(pll), current, 0, 0.5, 0.0);
		} else
			current = pl_index - 1;
	}
	do_play();
}

/* add a song to the playlist */

void add_to_playlist(gchar * filename)
{
	gint i;

	DPRINT("add_to_playlist()\n");
	DPRINT(filename);
	DPRINT("\n");

	recurse(filename);
	update_pl_playtime();
}

/* the main window got a delete event */

void delete_event(GtkWidget * widget, GdkEvent * event, gpointer * data)
{
	DPRINT("delete_event()\n");

	if (playing)
		do_stop();

	DPRINT("\tloop\n");
	while (playing)
		time(NULL);

	/*  DPRINT("\texit\n");
	    exit(0); */
	DPRINT("\tdetach\n");
	shmdt((char *) shared);
	gtk_main_quit();
}

/* callback for buttons */

void button_callback(GtkWidget * widget, gint * data)
{
	gchar *title;
	gchar *buffer;
	gchar *entry[6];
	gchar *data2;
	gint i;
	struct stat a;
	gint bitrate;

	DPRINT("button_callback()\n");

	switch (*data) {
	case D_BUT_OPTIONS:
		gtk_widget_show(w_prefs);
		break;
	case D_BUT_PREV:
		if (current == -1)
			break;
		on_led(0);
		if (playing)
			do_stop();
		do_prev();
		break;

	case D_BUT_PLAY:
		if (current == -1)
			break;
/*		on_led(1); */
		current = selected;
		if (!gtk_clist_row_is_visible(GTK_CLIST(pll), current))
			gtk_clist_moveto(GTK_CLIST(pll), current, 0, 0.5, 0.0);
		do_play();
		break;

	case D_BUT_PAUSE:
		if (current == -1 || !playing)
			break;
		shared->pause = !shared->pause;
		if (shared->pause)
			on_led(2);
		else
			on_led(1);
		break;

	case D_BUT_STOP:
		on_led(3);
		if (playing)
			do_stop();
		break;

	case D_BUT_NEXT:
		if (current == -1)
			break;
		on_led(4);
		if (playing)
			do_stop();
		do_next();
		break;

	case D_BUT_LIST:
		gtk_widget_show(w_pl);
		break;

	case D_BUT_PL_SORT:

		break;

	case D_BUT_PL_ADD:
		gtk_widget_show(w_selector);
		break;

	case D_BUT_PL_UP:
		if (selected == 0)
			return;
		if (pl_index == 0)
			return;

		loading = 1;
		gtk_clist_freeze(GTK_CLIST(pll));

		title = gtk_clist_get_row_data(GTK_CLIST(pll), selected);
		entry[0] = strdup(" ");
		gtk_clist_get_text(GTK_CLIST(pll), selected, 1, &buffer);
		entry[1] = strdup(buffer);
		gtk_clist_get_text(GTK_CLIST(pll), selected, 2, &buffer);
		entry[2] = strdup(buffer);
		gtk_clist_get_text(GTK_CLIST(pll), selected, 3, &buffer);
		entry[3] = strdup(buffer);
		gtk_clist_get_text(GTK_CLIST(pll), selected, 4, &buffer);
		entry[4] = strdup(buffer);
		gtk_clist_get_text(GTK_CLIST(pll), selected, 5, &buffer);
		entry[5] = strdup(buffer);
		gtk_clist_remove(GTK_CLIST(pll), selected);
		gtk_clist_insert(GTK_CLIST(pll), selected - 1, entry);

		data2 = strdup(title);
		gtk_clist_set_row_data(GTK_CLIST(pll), selected - 1, data2);
		gtk_clist_select_row(GTK_CLIST(pll), selected - 1, 0);

		selected--;

		for (i = 0; i < pl_index; i++) {
			title = gtk_clist_get_row_data(GTK_CLIST(pll), i);

			entry[1] = malloc(4);
			sprintf(entry[1], "%02d", i + 1);
			entry[0] = strdup(" ");
			gtk_clist_get_text(GTK_CLIST(pll), i, 2, &buffer);
			entry[2] = strdup(buffer);
			gtk_clist_get_text(GTK_CLIST(pll), i, 3, &buffer);
			entry[3] = strdup(buffer);
			gtk_clist_get_text(GTK_CLIST(pll), i, 4, &buffer);
			entry[4] = strdup(buffer);
			gtk_clist_get_text(GTK_CLIST(pll), i, 5, &buffer);
			entry[5] = strdup(buffer);

			gtk_clist_remove(GTK_CLIST(pll), i);
			gtk_clist_insert(GTK_CLIST(pll), i, entry);

			data2 = strdup(title);
			gtk_clist_set_row_data(GTK_CLIST(pll), i, data2);
		}

		gtk_clist_thaw(GTK_CLIST(pll));
		gtk_clist_select_row(GTK_CLIST(pll), selected, 0);
		loading = 0;

		break;

	case D_BUT_PL_DOWN:
		if (selected == pl_index - 1)
			return;
		if (pl_index == 0)
			return;

		loading = 1;
		gtk_clist_freeze(GTK_CLIST(pll));

		title = gtk_clist_get_row_data(GTK_CLIST(pll), selected);
		entry[0] = strdup(" ");
		gtk_clist_get_text(GTK_CLIST(pll), selected, 1, &buffer);
		entry[1] = strdup(buffer);
		gtk_clist_get_text(GTK_CLIST(pll), selected, 2, &buffer);
		entry[2] = strdup(buffer);
		gtk_clist_get_text(GTK_CLIST(pll), selected, 3, &buffer);
		entry[3] = strdup(buffer);
		gtk_clist_get_text(GTK_CLIST(pll), selected, 4, &buffer);
		entry[4] = strdup(buffer);
		gtk_clist_get_text(GTK_CLIST(pll), selected, 5, &buffer);
		entry[5] = strdup(buffer);
		gtk_clist_remove(GTK_CLIST(pll), selected);
		gtk_clist_insert(GTK_CLIST(pll), selected + 1, entry);

		data2 = strdup(title);
		gtk_clist_set_row_data(GTK_CLIST(pll), selected + 1, data2);
		gtk_clist_select_row(GTK_CLIST(pll), selected + 1, 0);

		selected++;
	
		for (i = 0; i < pl_index; i++) {
			title = gtk_clist_get_row_data(GTK_CLIST(pll), i);
			entry[0] = strdup(" ");
			entry[1] = malloc(4);
			sprintf(entry[1], "%02d", i + 1);
			gtk_clist_get_text(GTK_CLIST(pll), i, 2, &buffer);
			entry[2] = strdup(buffer);
			gtk_clist_get_text(GTK_CLIST(pll), i, 3, &buffer);
			entry[3] = strdup(buffer);
			gtk_clist_get_text(GTK_CLIST(pll), i, 4, &buffer);
			entry[4] = strdup(buffer);
			gtk_clist_get_text(GTK_CLIST(pll), i, 5, &buffer);
			entry[5] = strdup(buffer);

			gtk_clist_remove(GTK_CLIST(pll), i);
			gtk_clist_insert(GTK_CLIST(pll), i, entry);

			data2 = strdup(title);
			gtk_clist_set_row_data(GTK_CLIST(pll), i, data2);
		}

		gtk_clist_thaw(GTK_CLIST(pll));
		gtk_clist_select_row(GTK_CLIST(pll), selected, 0);
		loading = 0;
	
		break;

	case D_BUT_PL_REMOVE:
		if (playing && current == selected)
			do_next();

		if (pl_index == 0)
			return;

		DPRINT("Removing: ");
		DPRINT(gtk_clist_get_row_data(GTK_CLIST(pll), selected));
		DPRINT("\n");

		in_file = fopen(gtk_clist_get_row_data(GTK_CLIST(pll), selected), "r");
		gethdr(&header);
		fclose(in_file);
		stat(gtk_clist_get_row_data(GTK_CLIST(pll), selected), &a);
		bitrate  = t_bitrate[header.ID][3 - header.layer][header.bitrate_index];
		total_bytes -= a.st_size;
		total_secs -= a.st_size / 419 * 128 / bitrate * 1152 / 44100;

		loading = 1;
		gtk_clist_freeze(GTK_CLIST(pll));
		gtk_clist_remove(GTK_CLIST(pll), selected);
		pl_index--;

		update_pl_playtime();

		if (pl_index)
			for (i = 0; i < pl_index; i++) {
				title = gtk_clist_get_row_data(GTK_CLIST(pll), i);
				entry[0] = strdup(" ");
				entry[1] = malloc(4);
				sprintf(entry[1], "%02d", i + 1);
				gtk_clist_get_text(GTK_CLIST(pll), i, 2, &buffer);
				entry[2] = strdup(buffer);
				gtk_clist_get_text(GTK_CLIST(pll), i, 3, &buffer);
				entry[3] = strdup(buffer);
				gtk_clist_get_text(GTK_CLIST(pll), i, 4, &buffer);
				entry[4] = strdup(buffer);
				gtk_clist_get_text(GTK_CLIST(pll), i, 5, &buffer);
				entry[5] = strdup(buffer);

				gtk_clist_remove(GTK_CLIST(pll), i);
				gtk_clist_insert(GTK_CLIST(pll), i, entry);

				data2 = strdup(title);
				gtk_clist_set_row_data(GTK_CLIST(pll), i, data2);
			}
		
		gtk_clist_thaw(GTK_CLIST(pll));
		if (pl_index)
			gtk_clist_select_row(GTK_CLIST(pll), selected, 0);
		loading = 0;
		break;

	case D_BUT_PL_CLEAR:

		current = -1;
		selected = 0;
		pl_index = 0;
		total_secs = total_bytes = 0;
		update_pl_playtime();

		gtk_clist_clear(GTK_CLIST(pll));
		if (playing)
			do_stop();
		pl_index = 0;
		break;
	case D_BUT_PL_LOAD:
		title = malloc(strlen(PROGRAM_NAME) + strlen(" - Load Playlist ")); 
		sprintf(title, "%s - Load Playlist", PROGRAM_NAME);
		pl_selector = gtk_file_selection_new(title);
		free(title);
		gtk_file_selection_set_filename(GTK_FILE_SELECTION(pl_selector), confdir);

		gtk_signal_connect(GTK_OBJECT(w_selector), "delete_event", (GtkSignalFunc) gtk_widget_destroy, GTK_OBJECT(pl_selector));

		gtk_signal_connect(GTK_OBJECT(GTK_FILE_SELECTION(pl_selector)->ok_button), "clicked", (GtkSignalFunc) selected_pl_load, GTK_OBJECT(pl_selector));

		gtk_signal_connect_object(GTK_OBJECT(GTK_FILE_SELECTION(pl_selector)->cancel_button), "clicked", (GtkSignalFunc) gtk_widget_destroy, GTK_OBJECT(pl_selector));
		gtk_widget_show(pl_selector);
		break;
	case D_BUT_PL_SAVE:
		title = malloc(strlen(PROGRAM_NAME) + strlen(" - Save Playlist ")); 
		sprintf(title, "%s - Save Playlist", PROGRAM_NAME);
		pl_selector = gtk_file_selection_new(title);
		free(title);
		gtk_file_selection_set_filename(GTK_FILE_SELECTION(pl_selector), confdir);

		gtk_signal_connect(GTK_OBJECT(w_selector), "delete_event", (GtkSignalFunc) gtk_widget_destroy, GTK_OBJECT(pl_selector));

		gtk_signal_connect(GTK_OBJECT(GTK_FILE_SELECTION(pl_selector)->ok_button), "clicked", (GtkSignalFunc) selected_pl_save, GTK_OBJECT(pl_selector));

		gtk_signal_connect_object(GTK_OBJECT(GTK_FILE_SELECTION(pl_selector)->cancel_button), "clicked", (GtkSignalFunc) gtk_widget_destroy, GTK_OBJECT(pl_selector));
		gtk_widget_show(pl_selector);
		break;
	case D_BUT_SAVE_WAV:
		title = malloc(strlen(PROGRAM_NAME) + strlen(" - Save as WAV ")); 
		sprintf(title, "%s - Save as WAV", PROGRAM_NAME);
		pl_selector = gtk_file_selection_new(title);
		free(title);
		/*    gtk_file_selection_set_filename(GTK_FILE_SELECTION(pl_selector), confdir);  */

		gtk_signal_connect(GTK_OBJECT(w_selector), "delete_event", (GtkSignalFunc) gtk_widget_destroy, GTK_OBJECT(pl_selector));

		gtk_signal_connect(GTK_OBJECT(GTK_FILE_SELECTION(pl_selector)->ok_button), "clicked", (GtkSignalFunc) selected_wav_save, GTK_OBJECT(pl_selector));

		gtk_signal_connect_object(GTK_OBJECT(GTK_FILE_SELECTION(pl_selector)->cancel_button), "clicked", (GtkSignalFunc) gtk_widget_destroy, GTK_OBJECT(pl_selector));
		gtk_widget_show(pl_selector);
		break;
	};
}

/* callback for menus */

void menu_callback(GtkWidget * widget, gint * data)
{
	gchar *buffer;
	FILE *file;

	DPRINT("menu_callback()\n");
	switch (*data) {
	case D_TOG_RANDOM:
		options[OPT_RANDOM] = ((GtkCheckMenuItem *) widget)->active;
		break;
	case D_TOG_REPEAT:
		options[OPT_REPEAT] = ((GtkCheckMenuItem *) widget)->active;
		break;
	case D_TOG_DOWNMIX:
		A_DOWNMIX = ((GtkCheckMenuItem *) widget)->active;
		break;
	case D_TOG_SILENT:
		A_AUDIO_PLAY = !((GtkCheckMenuItem *) widget)->active;
		break;
	case D_TOG_SAVEALL:
		options[OPT_SAVEALL] = ((GtkCheckMenuItem *) widget)->active;
		break;
	case D_TOG_REMAINING:
		options[OPT_REMAINING] = ((GtkCheckMenuItem *) widget)->active;
		break;
	case D_MENU_HELP_REPLAY:
		show_help_window("Help: Usage", help_message);
		break;
	case D_MENU_HELP_MAIN:
		show_help_window("Help: Main Window", help_main_message);
		break;
	case D_MENU_HELP_PLED:
		show_help_window("Help: Playlist Editor", help_pled_message);
		break;
	case D_MENU_HELP_SAVE:
		show_help_window("Help: Saving to WAV", help_save_message);
		break;
	case D_MENU_HELP_ABOUT:
		buffer = malloc(4096);
		sprintf(buffer, "\n%s %d.%d [build %s]\n%s", PROGRAM_NAME, VERSION_MAJ, VERSION_MIN, DATE, copyright_message);
		show_help_window("Help: About", buffer);
		free(buffer);
		break;
	case D_MENU_SAVE_OPTS:
		buffer = malloc(4096);
		sprintf(buffer, "%s/%s", confdir, OPTFILE);
		file = fopen(buffer, "w");
		free(buffer);
		fwrite(options, sizeof(gint), OPT_NUMBER_OF, file);
		fwrite(&A_DOWNMIX, sizeof(int), 1, file);
		fwrite(&A_AUDIO_PLAY, sizeof(int), 1, file);
		fclose(file);
	}
}

/* callback for playlist selection */

void selection_callback(GtkCList * clist, gint row, gint column, GdkEventButton * event)
{
	if (loading)
		return;

	if (time(NULL) == click && selected == row) {
		click = 0;
		if (playing)
			do_stop();
		current = selected;
		do_play();
	} else {
		selected = row;
		time(&click);
	}
}

/* callback for slider */

void slider_callback(GtkAdjustment *gadj, struct AUDIO_HEADER *header)
{
	int nframe;

	DPRINT("slider_callback()\n");

	if (auto_range) {
		auto_range = 0;
		return;
	}
	if (shared->sliding)
		return;

	nframe = gadj->value / (419.0 * t_bitrate[header->ID][3 - header->layer][header->bitrate_index] / 128.0 / filesize * 100.0);
	shared->diff = nframe - shared->cnt;
}

/* callback for volume */

void volume_callback(GtkAdjustment *gadj, struct AUDIO_HEADER *header)
{
	DPRINT("volume_callback()\n");

	shared->volume = 100 - gadj->value;
/*	printf("volume: %i\n", *volume);*/
}

/* callback for mp3 loading */

void selected_mp3(GtkWidget * w, GtkFileSelection * fs)
{
	struct stat a;
	glob_t match;
	gint i = 1;
	char *tmp_filenames[65536];
	GList *tmp;

/*	tmp = g_list_nth(GTK_CLIST(fs->file_list)->selection, 1);

	while (i < 10)
	{
		printf("%d\n", i);
		tmp_filenames[i++] = strdup(tmp->data);
		printf("%s\n", tmp->data);
		tmp = g_list_nth(GTK_CLIST(fs->file_list)->selection, i);
		}*/
	gchar *filename = gtk_file_selection_get_filename(fs); 

	DPRINT("selected_mp3()\n");

	loading = 1;

	if (!stat(filename, &a))
		add_to_playlist(filename);
	else {
		glob(filename, GLOB_ERR, NULL, &match);
		for (i = 0; i < match.gl_pathc; i++)
			add_to_playlist(match.gl_pathv[i]);
	}
	loading = 0;

//	gtk_widget_hide(GTK_WIDGET(w_selector));
}

void recurse(gchar *filename)
{
	gchar *string;
	gchar *entry[6];
	gchar *data;
	struct stat a;
	gint bitrate;
	gint i;
	glob_t match;
	gchar *buffer = malloc(4096);
	gchar *buffer2 = malloc(4096);
	gint secs;
	gint minutes;

	MP3_TAG *rec_id3;
	int id3_ok = 0;

	DPRINT("recurse()\n\tentering: ");
	DPRINT(filename);
	DPRINT("\n");

	for (i = 0; i < 256 && filename[i] != 0; i++)
		if (filename[i] == '\n')
			filename[i] = 0;

	stat(filename, &a);
	if (S_ISDIR(a.st_mode)) {
		sprintf(buffer2, "%s/*", filename);
		DPRINT("\tglobbing: ");
		DPRINT(buffer2);
		DPRINT("\n");
		if (glob(buffer2, GLOB_ERR, NULL, &match) == GLOB_NOMATCH) {
			DPRINT("\tmatched nothing\n");
			return;
		}
/*		free(buffer2);*/
		for (i = 0; i < match.gl_pathc; i++) {
			stat(match.gl_pathv[i], &a);
			DPRINT("\tmatched: ");
			DPRINT(match.gl_pathv[i]);
			DPRINT("\n");
			if (S_ISDIR(a.st_mode ))
				recurse(match.gl_pathv[i]);
			else {
				if (!stat(match.gl_pathv[i], &a) && (S_ISLNK(a.st_mode) || S_ISREG(a.st_mode))) {
					in_file = fopen(match.gl_pathv[i], "r");
					DPRINT(".\n");
					if (gethdr(&header))
						continue;
					DPRINT(".\n");
					fclose(in_file);
					bitrate  = t_bitrate[header.ID][3 - header.layer][header.bitrate_index];
					DPRINT(".\n");

					total_bytes += a.st_size;
					secs = a.st_size / 419 * 128 / bitrate * 1152 / 44100;
					total_secs += secs;
					DPRINT(".\n");

					rec_id3 = (MP3_TAG *) malloc(sizeof(MP3_TAG));
					id3_ok = read_tag(match.gl_pathv[i], rec_id3);

					if (id3_ok != 1)
						sprintf(buffer, "%s", CODECONV(basename2(match.gl_pathv[i])));
					else
						sprintf(buffer, "%s - %s", CODECONV(rec_id3->Artist), CODECONV(rec_id3->Title));

					DPRINT("\tgtk_list_item_new_with_label\n");

					minutes = secs / 60;
					secs = secs % 60;
					
					DPRINT(".\n");
					entry[0] = strdup(" ");
					entry[1] = malloc(4);
					sprintf(entry[1], "%02d", pl_index+1);
					entry[2] = strdup(buffer);
					entry[3] = malloc(8);
					sprintf(entry[3], "%d:%02d", minutes, secs);
					entry[4] = malloc(8);
					sprintf(entry[4], "%d", bitrate);
					entry[5] = malloc(32);
					sprintf(entry[5], "%s", CODECONV(((!id3_ok || rec_id3->Junle < 0) ? "-" : junle_table[rec_id3->Junle])));

					free(rec_id3);
					id3_ok = 0;
					DPRINT(".\n");
					gtk_clist_append(GTK_CLIST(pll), entry);
					DPRINT(".\n");
/*					free(buffer);
					DPRINT(".\n");*/
					data = strdup(match.gl_pathv[i]);
					DPRINT(".\n");
					gtk_clist_set_row_data(GTK_CLIST(pll), pl_index, data);
					DPRINT(".\n");
					pl_index++;
					DPRINT(".\n");
					songs_left++;

					DPRINT(".\n");
					if (current == -1)
						current = 0;
					DPRINT("\tdone\n");
				}
			}
		}
	}  else {
		if (!stat(filename, &a) && (S_ISLNK(a.st_mode) || S_ISREG(a.st_mode))) {
			in_file = fopen(filename, "r");
			DPRINT(".\n");
			if (gethdr(&header))
				return;
			DPRINT(".\n");
			fclose(in_file);
			bitrate  = t_bitrate[header.ID][3 - header.layer][header.bitrate_index];
			DPRINT(".\n");
			
			total_bytes += a.st_size;
			secs = a.st_size / 419 * 128 / bitrate * 1152 / 44100;
			total_secs += secs;
			DPRINT(".\n");
			
			/*
			sprintf(buffer, "%s", basename2(filename));
			*/			
			rec_id3 = (MP3_TAG *) malloc(sizeof(MP3_TAG));
			id3_ok = read_tag(filename, rec_id3);

			if (id3_ok != 1)
				sprintf(buffer, "%s", CODECONV(basename2(filename)));
			else
				sprintf(buffer, "%s - %s", CODECONV(rec_id3->Artist), CODECONV(rec_id3->Title));

			DPRINT("\tgtk_list_item_new_with_label\n");
			
			minutes = secs / 60;
			secs = secs % 60;
			
			DPRINT(".\n");
			entry[0] = strdup(" ");
			entry[1] = malloc(4);
			sprintf(entry[1], "%02d", pl_index+1);
			entry[2] = strdup(buffer);
			entry[3] = malloc(8);
			sprintf(entry[3], "%d:%02d", minutes, secs);
			entry[4] = malloc(8);
			sprintf(entry[4], "%d", bitrate);
			entry[5] = malloc(32);
			sprintf(entry[5], "%s", CODECONV(((!id3_ok || rec_id3->Junle < 0) ? "-" : junle_table[rec_id3->Junle])));
			
			free(rec_id3);
			id3_ok = 0;

			DPRINT(".\n");
			gtk_clist_append(GTK_CLIST(pll), entry);
			DPRINT(".\n");
/*			free(buffer);
			DPRINT(".\n");*/
			data = strdup(filename);
			DPRINT(".\n");
			gtk_clist_set_row_data(GTK_CLIST(pll), pl_index, data);
			DPRINT(".\n");
			pl_index++;
			songs_left++;
			
			if (current == -1)
				current = 0;
			DPRINT("\tdone\n");
		}
	}
	free(buffer);
	free(buffer2);
}

/* callback for playlist loading */

void selected_pl_load(GtkWidget * w, GtkFileSelection * fs)
{
	struct stat a;

	gchar *filename = gtk_file_selection_get_filename(fs);

	DPRINT("selected_pl()\n");

	if (!stat(filename, &a))
		load_playlist(filename);

	gtk_widget_destroy(pl_selector);
}

void load_playlist(gchar *filename)
{
	struct stat a;
	int i;
	FILE *plist;
	char buffer[256];
	char *buffer2;
	char *path;
	int len;
	int is_m3u = 0;
	plist = fopen(filename, "r");

	len = strlen(filename) - 1;
	if (filename[len] == 'u' && filename[len - 1] == '3' && filename[len - 2] == 'm' && filename[len - 3] == '.')
		is_m3u = 1;

	loading = 1;
	gtk_clist_freeze(GTK_CLIST(pll));

	while (fgets(buffer, 255, plist) != NULL) {
		for (i = 0; i < 256 && buffer[i] != 0; i++)
			if (buffer[i] == '\n')
				buffer[i] = 0;
		if (is_m3u) {
			path = strdup(filename);
			for (i = strlen(filename); i > 0; i--)
				if (path[i] == '/') {
					path[i] = 0;
					break;
				}
			buffer2 = strdup(buffer);
			sprintf(buffer, "%s/%s", path, buffer2);
		}
		if (!stat(buffer, &a))
			add_to_playlist(buffer);
	}

	gtk_clist_thaw(GTK_CLIST(pll));

	fclose(plist);
	loading = 0;
}

/* callback for playlist saving */

void selected_pl_save(GtkWidget * w, GtkFileSelection * fs)
{
	int i;
	FILE *plist;
	gchar *filename = gtk_file_selection_get_filename(fs);

	DPRINT("selected_pl()\n");

	plist = fopen(filename, "w");

	for (i = 0; i < pl_index; i++)
		fprintf(plist, "%s\n", gtk_clist_get_row_data(GTK_CLIST(pll), i));

	fclose(plist);
	gtk_widget_destroy(pl_selector);
}

/* callback for .wav saving */

void selected_wav_save(GtkWidget * w, GtkFileSelection * fs)
{
	int i;
	FILE *plist;
	gchar *filename = gtk_file_selection_get_filename(fs);

	DPRINT("selected_pl()\n");

	save_as = strdup(filename);
	A_WRITE_TO_FILE = 1;
	A_FORMAT_WAVE = 1;

	gtk_widget_destroy(pl_selector);
}

/* update statuslabel */

int statusDisplay(struct AUDIO_HEADER *header)
{
	static int minutes, seconds, tseconds;
	char *buffer;
	static float p, op;
	int frameNo;

	DPRINT("status_display()\n");

	/*  header = (struct AUDIO_HEADER *) shared + 16; */
	frameNo = shared->cnt;

	seconds = frameNo * 1152 / 44100;	/*t_sampling_frequency[header->ID][header->sampling_frequency]; */
	tseconds = filesize / 419 * 128 / t_bitrate[header->ID][3 - header->layer][header->bitrate_index] * 1152 / 44100;

	buffer = malloc(16);
	if (options[OPT_REMAINING]) {
		minutes = (tseconds - seconds) / 60;
		seconds = (tseconds - seconds) % 60;
		sprintf(buffer, "-%d:%02d", minutes, seconds);
	} else {
		minutes = seconds / 60;
		seconds = seconds % 60;
		sprintf(buffer, "%d:%02d", minutes, seconds);
	}

	if (shared->sliding) {
		DPRINT("\tsliding, returning\n");
		return TRUE;
	}
	gtk_label_set(GTK_LABEL(playtime), buffer);
	free(buffer);

	p = (gfloat) frameNo *419 * t_bitrate[header->ID][3 - header->layer][header->bitrate_index] / 128 / filesize * 100;
	gtk_adjustment_set_value(GTK_ADJUSTMENT(adj), p);
	auto_range = 1;
	gtk_range_set_adjustment(GTK_RANGE(bar), adj);

	return TRUE;
}

/* get information about current mp3 */

void show_header(struct AUDIO_HEADER *header)
{
	int bitrate = t_bitrate[header->ID][3 - header->layer][header->bitrate_index];
	int fs = t_sampling_frequency[header->ID][header->sampling_frequency];
	int mpg, layer;
	char stm[8];
	int minutes, seconds;
	char *tempdata;

	seconds = filesize / 419 * 128 / bitrate * 1152 / 44100;	/*fs; */
	minutes = seconds / 60;
	seconds = seconds % 60;

	DPRINT("show_header()\n");

	layer = 4 - header->layer;
	if (header->ID == 1)
		mpg = 1;
	else
		mpg = 2;
	if (header->mode == 3)
		strcpy(stm, "mono");
	else
		strcpy(stm, "stereo");

	if (fdata)
		free(fdata);
	DPRINT("\tsprintf\n");
	fdata = malloc(4096);
	/*
	sprintf(fdata, "[%02i] - %s: %dkbit, %s", current + 1, basename2(gtk_clist_get_row_data(GTK_CLIST(pll), current)), bitrate, stm);
	*/
	
	tempdata = malloc(1024);
	if (strlen(id3->Artist) > 0)
		sprintf(tempdata, "%s - %s (%s)", CODECONV(id3->Artist), CODECONV(id3->Title), CODECONV(id3->Album));
	else
		sprintf(tempdata, "%s", CODECONV(basename2(gtk_clist_get_row_data(GTK_CLIST(pll), current))));
	sprintf(fdata, "[%02i] - %s: %dkbit, %s", current + 1, tempdata, bitrate, stm);
	free(tempdata);

	DPRINT("\tsetlabel\n");
	gtk_label_set(GTK_LABEL(status), fdata);
	if (ftotal)
		free(ftotal);
	DPRINT("\tsprintf\n");
	ftotal = malloc(4096);
	sprintf(ftotal, "%d:%02d", minutes, seconds);
	DPRINT("\tsetlabel\n");
	gtk_label_set(GTK_LABEL(total), ftotal);
}

/* initialize mp3 file selector */

void init_selector()
{
	gchar *title = malloc(32);

	DPRINT("init_selector()\n");

	sprintf(title, "%s - Add to Playlist", PROGRAM_NAME);
	w_selector = gtk_file_selection_new(title);
/*	gtk_clist_set_selection_mode(GTK_CLIST(GTK_FILE_SELECTION(w_selector)->file_list), GTK_SELECTION_MULTIPLE);	*/
	
	gtk_signal_connect(GTK_OBJECT(w_selector), "destroy", (GtkSignalFunc) gtk_widget_hide, GTK_OBJECT(w_selector));
	gtk_signal_connect(GTK_OBJECT(w_selector), "delete_event", (GtkSignalFunc) gtk_widget_hide, GTK_OBJECT(w_selector));

	gtk_signal_connect(GTK_OBJECT(GTK_FILE_SELECTION(w_selector)->ok_button), "clicked", (GtkSignalFunc) selected_mp3, GTK_OBJECT(w_selector));

	gtk_signal_connect_object(GTK_OBJECT(GTK_FILE_SELECTION(w_selector)->cancel_button), "clicked", (GtkSignalFunc) gtk_widget_hide, GTK_OBJECT(w_selector));
}

/* initialize playlit window */

void init_pl()
{
	GtkWidget *scrolled_window;
	GtkWidget *table;
	GtkWidget *button;
	GtkTooltips *tooltips = gtk_tooltips_new();
	gchar *title;
	gchar *titles[] = {"P", "Nr", "Title - Artist or File Name", "Length", "Bitrate", "Genre"};

	DPRINT("init_pl()\n");

	style = gtk_widget_get_style(w_main);
	p_tickmark = gdk_pixmap_create_from_xpm_d(w_main->window, &tm_mask, &style->bg[GTK_STATE_NORMAL], tickmark_xpm);

	w_pl = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_container_border_width(GTK_CONTAINER(w_pl), 5);

	title = malloc(strlen(PROGRAM_NAME) + strlen(" - Playlist Editor "));
	sprintf(title, "%s - Playlist Editor", PROGRAM_NAME);
	gtk_window_set_title(GTK_WINDOW(w_pl), title);
	gtk_signal_connect(GTK_OBJECT(w_pl), "delete_event", (GtkSignalFunc) gtk_widget_hide, GTK_OBJECT(w_pl));
	gtk_signal_connect(GTK_OBJECT(w_pl), "destroy", (GtkSignalFunc) gtk_widget_hide, GTK_OBJECT(w_pl));

	table = gtk_table_new(11, 2, 0);
	gtk_table_set_row_spacings(GTK_TABLE(table), 5);
	gtk_table_set_col_spacings(GTK_TABLE(table), 0);
	gtk_container_add(GTK_CONTAINER(w_pl), table);

	pll = gtk_clist_new_with_titles(6, titles);
	gtk_clist_set_column_width(GTK_CLIST(pll), 0, 20);
	gtk_clist_set_column_width(GTK_CLIST(pll), 1, 20);
	gtk_clist_set_column_width(GTK_CLIST(pll), 2, 300);
	gtk_clist_set_column_width(GTK_CLIST(pll), 3, 50);
	gtk_clist_set_column_width(GTK_CLIST(pll), 4, 50);
	gtk_clist_set_column_width(GTK_CLIST(pll), 5, 100);

	gtk_signal_connect(GTK_OBJECT(pll), "click_column", GTK_SIGNAL_FUNC(column_callback), NULL);
	gtk_signal_connect(GTK_OBJECT(pll), "select_row", GTK_SIGNAL_FUNC(select_row_callback), NULL);
	gtk_widget_set_usize(pll, 600, 250);
	gtk_clist_set_selection_mode(GTK_CLIST(pll), GTK_SELECTION_BROWSE);
	gtk_clist_column_titles_show(GTK_CLIST(pll));
	gtk_clist_column_titles_active(GTK_CLIST(pll));
	gtk_signal_connect(GTK_OBJECT(pll), "select_row", GTK_SIGNAL_FUNC(selection_callback), NULL);
	gtk_table_attach_defaults(GTK_TABLE(table), pll, 0, 1, 0, 10);

	button = gtk_button_new_with_label(" Move Up ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Move track one step higher in the list", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PL_UP);
	gtk_table_attach(GTK_TABLE(table), button, 1, 2, 0, 1, GTK_FILL, 0, 5, 0);
	gtk_widget_show(button);

	button = gtk_button_new_with_label(" Move Down ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Move track one step lower in the list", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PL_DOWN);
	gtk_table_attach(GTK_TABLE(table), button, 1, 2, 1, 2, GTK_FILL, 0, 5, 0);
	gtk_widget_show(button);

	button = gtk_button_new_with_label(" Remove ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Remove track from the list", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PL_REMOVE);
	gtk_table_attach(GTK_TABLE(table), button, 1, 2, 2, 3, GTK_FILL, 0, 5, 0);
	gtk_widget_show(button);

	button = gtk_button_new_with_label(" Load... ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Load an entire playlist", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PL_LOAD);
	gtk_table_attach(GTK_TABLE(table), button, 1, 2, 3, 4, GTK_FILL, 0, 5, 0);
	gtk_widget_show(button);

	button = gtk_button_new_with_label(" Save... ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Save the current playlist", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PL_SAVE);
	gtk_table_attach(GTK_TABLE(table), button, 1, 2, 4, 5, GTK_FILL, 0, 5, 0);
	gtk_widget_show(button);

	button = gtk_button_new_with_label(" Add... ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Add an MP3 to the playlist", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PL_ADD);
	gtk_table_attach(GTK_TABLE(table), button, 1, 2, 5, 6, GTK_FILL, 0, 5, 0);
	gtk_widget_show(button);

	button = gtk_button_new_with_label(" Clear ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Remove all tracks from the playlist", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PL_CLEAR);
	gtk_table_attach(GTK_TABLE(table), button, 1, 2, 6, 7, GTK_FILL, 0, 5, 0);
	gtk_widget_show(button);

/*	button = gtk_button_new_with_label(" Sort ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Unimplemented", NULL);
	gtk_widget_set_sensitive(button, 0);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(popup_callback), (gpointer) NULL);
	gtk_table_attach(GTK_TABLE(table), button, 1, 2, 7, 8, GTK_FILL, 0, 5, 0);
	gtk_widget_show(button);*/

	button = gtk_button_new_with_label(" Dismiss ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Close window", NULL);
	gtk_signal_connect_object(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(gtk_widget_hide), GTK_OBJECT(w_pl));

	gtk_table_attach(GTK_TABLE(table), button, 1, 2, 8, 9, GTK_FILL, 0, 5, 0);
	gtk_widget_show(button);

	button = gtk_label_new(" ");
	gtk_table_attach(GTK_TABLE(table), button, 1, 2, 9, 10, 0, GTK_FILL | GTK_EXPAND, 5, 0);
	gtk_widget_show(button);

	/* playtime */

	pl_playtime = gtk_label_new("0 files, 0h 00m 00s, 0.0 Mb total size");
	gtk_table_attach(GTK_TABLE(table), pl_playtime, 0, 2, 10, 11, 0, GTK_FILL, 5, 0);
	gtk_widget_show(pl_playtime);

	gtk_widget_show(pll);
	gtk_widget_show(table);
}

/* initialize preferences window */

void init_prefs()
{
	GtkWidget *button;
	GtkWidget *table;
	GtkTooltips *tooltips = gtk_tooltips_new();
	gchar *title;

	DPRINT("init_prefs()\n");

	style = gtk_widget_get_style(w_main);

	w_prefs = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_container_border_width(GTK_CONTAINER(w_pl), 10);

	title = malloc(strlen(PROGRAM_NAME) + strlen(" - Preferences "));
	sprintf(title, "%s - Preferences", PROGRAM_NAME);
	gtk_window_set_title(GTK_WINDOW(w_prefs), title);
	gtk_signal_connect(GTK_OBJECT(w_prefs), "delete_event", (GtkSignalFunc) gtk_widget_hide, GTK_OBJECT(w_pl));
	gtk_signal_connect(GTK_OBJECT(w_prefs), "destroy", (GtkSignalFunc) gtk_widget_hide, GTK_OBJECT(w_pl));

	table = gtk_table_new(8, 2, 0);
	gtk_table_set_row_spacings(GTK_TABLE(table), 0);
	gtk_table_set_col_spacings(GTK_TABLE(table), 5);
	gtk_container_add(GTK_CONTAINER(w_prefs), table);

	/* options column */

	button = gtk_check_button_new_with_label(" Silent ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Move track one step higher in the list", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_SILENT);
	gtk_table_attach_defaults(GTK_TABLE(table), button, 0, 2, 0, 1);
	gtk_widget_show(button);

	button = gtk_check_button_new_with_label(" Save to WAV ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Move track one step higher in the list", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_SAVEALL);
	gtk_table_attach_defaults(GTK_TABLE(table), button, 0, 2, 1, 2);
	gtk_widget_show(button);

	button = gtk_check_button_new_with_label(" Repeat Playlist ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Move track one step higher in the list", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_REPEAT);
	gtk_table_attach_defaults(GTK_TABLE(table), button, 0, 2, 2, 3);
	gtk_widget_show(button);

	button = gtk_check_button_new_with_label(" Random Order ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Move track one step higher in the list", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_RANDOM);
	gtk_table_attach_defaults(GTK_TABLE(table), button, 0, 2, 3, 4);
	gtk_widget_show(button);

	button = gtk_check_button_new_with_label(" Mono ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Move track one step higher in the list", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_DOWNMIX);
	gtk_table_attach_defaults(GTK_TABLE(table), button, 0, 2, 4, 5);
	gtk_widget_show(button);

	button = gtk_check_button_new_with_label(" Show Remaining Time ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Move track one step higher in the list", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_REMAINING);
	gtk_table_attach_defaults(GTK_TABLE(table), button, 0, 2, 5, 6);
	gtk_widget_show(button);

	/* lower row */

	button = gtk_button_new_with_label(" OK ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Move track one step higher in the list", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & BUT_PL_UP);
	gtk_table_attach_defaults(GTK_TABLE(table), button, 0, 1, 6, 7);
	gtk_widget_show(button);

	button = gtk_button_new_with_label(" Cancel ");
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button, "Move track one step higher in the list", NULL);
	gtk_signal_connect(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & BUT_PL_UP);
	gtk_table_attach_defaults(GTK_TABLE(table), button, 1, 2, 6, 7);
	gtk_widget_show(button);

	gtk_widget_show(table);
}

/* update pl_playtime label */

void update_pl_playtime()
{
	gchar *buffer;
	float mb;
	gint hours, minutes, seconds;

	DPRINT("update_pl_playtime()\n");

	hours = total_secs / 3600;
	minutes = (total_secs - 3600 * hours) / 60;
	seconds = total_secs - 3600 * hours - 60 * minutes;
	mb = total_bytes / (1024.0 * 1024.0);

	buffer = malloc(4096);
	sprintf(buffer, "%i files, %dh %02dm %02ds, %0.01f Mb total size", pl_index, hours, minutes, seconds, mb);
	gtk_label_set(GTK_LABEL(pl_playtime), buffer);
	free(buffer);
}

/* initialize main window */

void init_main(int argc, char *argv[])
{
/*	GtkWidget *button;*/
	GtkWidget *table;
	GtkWidget *box; 
	GtkWidget *vbox;
	GtkWidget *hbox;
	GtkWidget *hbox2;
	GtkWidget *menu;
	GtkWidget *frame;
	GtkWidget *menu_item;
	GtkWidget *menu_bar;
	GtkWidget *viewport;
	GtkWidget *eventbox;
	GtkTooltips *tooltips = gtk_tooltips_new();

	GtkStyle *style;
	gchar *buffer;

	/* locale set  */
	#ifdef I18N
        gtk_set_locale();
	setlocale(LC_ALL,getenv("LANG"));
	#endif

	DPRINT("init_main()\n");
	gtk_init(&argc, &argv);
	gtk_rc_parse("/usr/local/share/gtkrc");
	gtk_rc_parse(rcfile);

	/* window */
	DPRINT("\twindow\n");

	w_main = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_widget_set_name(w_main, "w_main");

	buffer = malloc(4096);
	sprintf(buffer, "%s %d.%d [%s]", PROGRAM_NAME, VERSION_MAJ, VERSION_MIN, DATE);
	gtk_window_set_title(GTK_WINDOW(w_main), buffer);
	free(buffer);

	gtk_signal_connect(GTK_OBJECT(w_main), "delete_event", GTK_SIGNAL_FUNC(delete_event), NULL);

	gtk_container_border_width(GTK_CONTAINER(w_main), 0);

	gtk_widget_realize(w_main);

	/* containers */
	DPRINT("\tcontainers\n");

	vbox = gtk_vbox_new(0, 0);

	table = gtk_table_new(3, 7, 0);
	gtk_table_set_row_spacings(GTK_TABLE(table), 2);
	gtk_table_set_col_spacings(GTK_TABLE(table), 1);

	gtk_container_add(GTK_CONTAINER(w_main), vbox);

	/* menus */
	DPRINT("\tmenus\n");

	DPRINT("\t\tmenu_bar_new\n");
	menu_bar = gtk_menu_bar_new();
	DPRINT("\t\tattach\n");

	DPRINT("\t\tshow\n");
	gtk_widget_show(menu_bar);

	/* file menu */

	menu = gtk_menu_new();

	DPRINT("\t\tloadpl\n");
	menu_item = gtk_menu_item_new_with_label("Open Playlist Editor");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_LIST);
                

	DPRINT("\t\tloadpl\n");
	menu_item = gtk_menu_item_new_with_label("Load Playlist...");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PL_LOAD);

	DPRINT("\t\tsavepl\n");
	menu_item = gtk_menu_item_new_with_label("Save Playlist...");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PL_SAVE);

	DPRINT("\t\tloadmp3\n");
	menu_item = gtk_menu_item_new_with_label("Load MP3...");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PL_ADD);

	DPRINT("\t\tloadmp3\n");
	menu_item = gtk_menu_item_new_with_label("Save WAV...");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_SAVE_WAV);

	DPRINT("\t\tblank\n");
	menu_item = gtk_menu_item_new();
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);

	DPRINT("\t\texit\n");
	menu_item = gtk_menu_item_new_with_label("Options");
	gtk_widget_set_sensitive(menu_item, 0);
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_OPTIONS);

	DPRINT("\t\texit\n");
	menu_item = gtk_menu_item_new_with_label("Exit");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(delete_event), NULL);

	DPRINT("\t\tfile\n");
	menu_item = gtk_menu_item_new_with_label("File");
	gtk_widget_show(menu_item);

	DPRINT("\t\tset_submenu\n");
	gtk_menu_item_set_submenu(GTK_MENU_ITEM(menu_item), menu);

	DPRINT("\t\tappend\n");
	gtk_menu_bar_append(GTK_MENU_BAR(menu_bar), menu_item);

	/* options menu */

	menu = gtk_menu_new();

	DPRINT("\t\trepeat\n");
	menu_item = gtk_check_menu_item_new_with_label("Silent");
	gtk_check_menu_item_set_show_toggle(GTK_CHECK_MENU_ITEM(menu_item), 1);
	gtk_check_menu_item_set_state(GTK_CHECK_MENU_ITEM(menu_item), !A_AUDIO_PLAY);
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "toggled", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_SILENT);

	DPRINT("\t\trepeat\n");
	menu_item = gtk_check_menu_item_new_with_label("Save to WAV");
	gtk_check_menu_item_set_show_toggle(GTK_CHECK_MENU_ITEM(menu_item), 1);
	gtk_check_menu_item_set_state(GTK_CHECK_MENU_ITEM(menu_item), options[OPT_SAVEALL]);
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "toggled", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_SAVEALL);

	DPRINT("\t\trepeat\n");
	menu_item = gtk_check_menu_item_new_with_label("Repeat Playlist");
	gtk_check_menu_item_set_show_toggle(GTK_CHECK_MENU_ITEM(menu_item), 1);
	gtk_check_menu_item_set_state(GTK_CHECK_MENU_ITEM(menu_item), options[OPT_REPEAT]);
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "toggled", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_REPEAT);

	DPRINT("\t\trandom\n");
	menu_item = gtk_check_menu_item_new_with_label("Random Play");
	gtk_check_menu_item_set_show_toggle(GTK_CHECK_MENU_ITEM(menu_item), 1);
	gtk_check_menu_item_set_state(GTK_CHECK_MENU_ITEM(menu_item), options[OPT_RANDOM]);
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "toggled", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_RANDOM);

	DPRINT("\t\trdownmix\n");
	menu_item = gtk_check_menu_item_new_with_label("Downmix to Mono");
	gtk_check_menu_item_set_show_toggle(GTK_CHECK_MENU_ITEM(menu_item), 1);
	gtk_check_menu_item_set_state(GTK_CHECK_MENU_ITEM(menu_item), A_DOWNMIX);
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "toggled", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_DOWNMIX);

	DPRINT("\t\tremaining\n");
	opt_remaining_menu_item = menu_item = gtk_check_menu_item_new_with_label("Show Remaining Time");
	gtk_check_menu_item_set_show_toggle(GTK_CHECK_MENU_ITEM(menu_item), 1);
	gtk_check_menu_item_set_state(GTK_CHECK_MENU_ITEM(menu_item), options[OPT_REMAINING]);
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "toggled", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & TOG_REMAINING);

	DPRINT("\t\tblank\n");
	menu_item = gtk_menu_item_new();
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);

	DPRINT("\t\tremaining\n");
	menu_item = gtk_menu_item_new_with_label("Save Options");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & MENU_SAVE_OPTS);

	DPRINT("\t\toptions\n");
	menu_item = gtk_menu_item_new_with_label("Options");
	gtk_widget_show(menu_item);

	DPRINT("\t\tset_submenu\n");
	gtk_menu_item_set_submenu(GTK_MENU_ITEM(menu_item), menu);

	DPRINT("\t\tappend\n");
	gtk_menu_bar_append(GTK_MENU_BAR(menu_bar), menu_item);

	/* help menu */

	menu = gtk_menu_new();

	DPRINT("\t\thelp\n");
	menu_item = gtk_menu_item_new_with_label("Usage...");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & MENU_HELP_REPLAY);

	DPRINT("\t\thelp\n");
	menu_item = gtk_menu_item_new_with_label("Main Window...");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & MENU_HELP_MAIN);

	DPRINT("\t\thelp\n");
	menu_item = gtk_menu_item_new_with_label("Playlist Editor...");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & MENU_HELP_PLED);

	DPRINT("\t\thelp\n");
	menu_item = gtk_menu_item_new_with_label("Saving to WAV...");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & MENU_HELP_SAVE);

	DPRINT("\t\tblank\n");
	menu_item = gtk_menu_item_new();
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);

	DPRINT("\t\thelp\n");
	menu_item = gtk_menu_item_new_with_label("About...");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & MENU_HELP_ABOUT);

	DPRINT("\t\toptions\n");
	menu_item = gtk_menu_item_new_with_label("Help");
	gtk_menu_item_right_justify(GTK_MENU_ITEM(menu_item));
	gtk_widget_show(menu_item);

	DPRINT("\t\tset_submenu\n");
	gtk_menu_item_set_submenu(GTK_MENU_ITEM(menu_item), menu);

	DPRINT("\t\tappend\n");
	gtk_menu_bar_append(GTK_MENU_BAR(menu_bar), menu_item);

	/* containers part two */
	DPRINT("\tcontainers part two\n");


	gtk_box_pack_start(GTK_BOX(vbox), menu_bar, 0, 0, 0);
	hbox = gtk_hbox_new(0, 0);
	gtk_box_pack_start(GTK_BOX(vbox), hbox, 1, 1, 5);
	gtk_box_pack_start(GTK_BOX(hbox), table, 1, 1, 7);

	/* playtime label */

	hbox2 = gtk_hbox_new(0, 0);
	gtk_table_attach_defaults(GTK_TABLE(table), hbox2, 0, 6, 0, 1);
	gtk_widget_show(hbox2);

	eventbox = gtk_event_box_new();
	gtk_signal_connect(GTK_OBJECT(eventbox), "button_press_event", GTK_SIGNAL_FUNC(callback_func), (gpointer) &TOG_REMAINING);
	gtk_widget_show(eventbox);

	playtime = gtk_label_new("--:--");
	gtk_widget_show(playtime);

	gtk_container_add(GTK_CONTAINER(eventbox), playtime);
	gtk_box_pack_start(GTK_BOX(hbox2), eventbox, 0, 0, 0);

	/* progress bar */

	DPRINT("\tprogress bar\n");

	adj = GTK_ADJUSTMENT(gtk_adjustment_new(0, 0, 101, 1, 5, 1));
	gtk_signal_connect(GTK_OBJECT(adj), "value_changed", GTK_SIGNAL_FUNC(slider_callback), &(shared->header));

	bar = gtk_hscale_new(adj);
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), bar, "Drag to seek within track", NULL);
	gtk_scale_set_draw_value(GTK_SCALE(bar), 0);
	gtk_widget_show(bar);
	gtk_box_pack_start(GTK_BOX(hbox2), bar, 1, 1, 5);

	/* volume bar */

	DPRINT("\tvolume bar\n");

	v_adj = GTK_ADJUSTMENT(gtk_adjustment_new(0, 0, 101, 1, 5, 1));
	gtk_adjustment_set_value(GTK_ADJUSTMENT(v_adj), 32);
	gtk_signal_connect(GTK_OBJECT(v_adj), "value_changed", GTK_SIGNAL_FUNC(volume_callback), NULL);

	volume_b = gtk_vscale_new(v_adj);
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), volume_b, "PCM mixer volume", NULL);
	gtk_scale_set_draw_value(GTK_SCALE(volume_b), 0);
	gtk_widget_show(volume_b);
	gtk_table_attach(GTK_TABLE(table), volume_b, 6, 7, 0, 3, 0, GTK_FILL | GTK_EXPAND, 5, 0);

	/* total label */

	total = gtk_label_new("--:--");
	gtk_widget_show(total);
	gtk_box_pack_start(GTK_BOX(hbox2), total, 0, 0, 0);

	gtk_table_set_row_spacing(GTK_TABLE(table), 0, 5);
	gtk_widget_show(bar);

	/* buttons */
	DPRINT("\tbuttons\n");

	box = xpm_label_box(prev_green_xpm, 0, 1);
	gtk_widget_show(box);
	box = xpm_label_box(prev_xpm, 0, 0);
	gtk_widget_show(box);
	button[0] = gtk_button_new();
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button[0], "Previous", NULL);
	gtk_widget_set_name(button[0], "button");
	gtk_container_add(GTK_CONTAINER(button[0]), box);

	gtk_signal_connect(GTK_OBJECT(button[0]), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PREV);
	gtk_table_attach_defaults(GTK_TABLE(table), button[0], 0, 1, 1, 2);
	gtk_widget_show(button[0]);

	box = xpm_label_box(play_green_xpm, 1, 1);
	gtk_widget_show(box);
	box = xpm_label_box(play_xpm, 1, 0);
	gtk_widget_show(box);
	button[1] = gtk_button_new();
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button[1], "Play", NULL);
	gtk_widget_set_name(button[1], "button");
	gtk_container_add(GTK_CONTAINER(button[1]), box);

	gtk_signal_connect(GTK_OBJECT(button[1]), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PLAY);
	gtk_table_attach_defaults(GTK_TABLE(table), button[1], 1, 2, 1, 2);
	gtk_widget_show(button[1]);

	box = xpm_label_box(pause_green_xpm, 2, 1);
	gtk_widget_show(box);
	box = xpm_label_box(pause_xpm, 2, 0);
	gtk_widget_show(box);
	button[2] = gtk_button_new();
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button[2], "Pause", NULL);
	gtk_widget_set_name(button[2], "button");
	gtk_container_add(GTK_CONTAINER(button[2]), box);

	gtk_signal_connect(GTK_OBJECT(button[2]), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_PAUSE);
	gtk_table_attach_defaults(GTK_TABLE(table), button[2], 2, 3, 1, 2);
	gtk_widget_show(button[2]);

	box = xpm_label_box(stop_green_xpm, 3, 1);
	gtk_widget_show(box);
	box = xpm_label_box(stop_xpm, 3, 0);
	gtk_widget_show(box);
	button[3] = gtk_button_new();
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button[3], "Stop", NULL);
	gtk_widget_set_name(button[3], "button");
	gtk_container_add(GTK_CONTAINER(button[3]), box);

	gtk_signal_connect(GTK_OBJECT(button[3]), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_STOP);
	gtk_table_attach_defaults(GTK_TABLE(table), button[3], 3, 4, 1, 2);
	gtk_widget_show(button[3]);

	box = xpm_label_box(next_green_xpm, 4, 1);
	gtk_widget_show(box);
	box = xpm_label_box(next_xpm, 4, 0);
	gtk_widget_show(box);
	button[4] = gtk_button_new();
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button[4], "Next", NULL);
	gtk_widget_set_name(button[4], "button");
	gtk_container_add(GTK_CONTAINER(button[4]), box);

	gtk_signal_connect(GTK_OBJECT(button[4]), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_NEXT);
	gtk_table_attach_defaults(GTK_TABLE(table), button[4], 4, 5, 1, 2);
	gtk_widget_show(button[4]);

	box = xpm_label_box(eject_green_xpm, 5, 1);
	gtk_widget_show(box);
	box = xpm_label_box(eject_xpm, 5, 0);
	gtk_widget_show(box);
	button[5] = gtk_button_new();
	gtk_tooltips_set_tip(GTK_TOOLTIPS(tooltips), button[5], "Open Playlist Editor", NULL);
	gtk_widget_set_name(button[5], "button");
	gtk_container_add(GTK_CONTAINER(button[5]), box);

	gtk_signal_connect(GTK_OBJECT(button[5]), "clicked", GTK_SIGNAL_FUNC(button_callback), (gpointer) & BUT_LIST);
	gtk_table_attach_defaults(GTK_TABLE(table), button[5], 5, 6, 1, 2);
	gtk_widget_show(button[5]);

	/* status label */
	DPRINT("\tstatus label\n");

	viewport = gtk_viewport_new (NULL, NULL);

	gtk_widget_set_usize(viewport, 250, 15);
	gtk_viewport_set_shadow_type (GTK_VIEWPORT(viewport), GTK_SHADOW_NONE);
   	gtk_table_attach_defaults(GTK_TABLE(table), viewport, 0, 6, 2, 3);
	gtk_widget_show(viewport);	

	status = gtk_label_new("No Song");
	gtk_container_add (GTK_CONTAINER(viewport), status);
	gtk_widget_show(status);

	DPRINT("\tshow\n");

	gtk_widget_realize(table);
	gtk_widget_show(table);
	gtk_widget_realize(hbox);
	gtk_widget_show(hbox);
	gtk_widget_realize(vbox);
	gtk_widget_show(vbox);
}

/* create a button with an xpm label */

GtkWidget *xpm_label_box(gchar * xpm_data[], gint i, gint j)
{
	GtkWidget *box1;
	GtkStyle *style;

	DPRINT("xpm_label_box()\n");
	box1 = gtk_hbox_new(FALSE, 0);
	gtk_container_border_width(GTK_CONTAINER(box1), 2);

	DPRINT("\tget_style\n");
	style = gtk_widget_get_style(w_main);

	DPRINT("\tpixmap_create\n");
	pixmap[i][j] = gdk_pixmap_create_from_xpm_d(w_main->window, &(mask[i][j]), &style->bg[GTK_STATE_NORMAL], xpm_data);
	DPRINT("\tpixmap_new\n");
	pixmapwid[i] = gtk_pixmap_new(pixmap[i][j], mask[i][j]);

	DPRINT("\tpack\n");
	gtk_box_pack_start(GTK_BOX(box1), pixmapwid[i], TRUE, FALSE, 3);

	DPRINT("\tshow\n");
	gtk_widget_show(pixmapwid[i]);

	return (box1);
}

/* get basename from filename */

gchar *basename2(gchar * path)
{
 	gint i;

	DPRINT("basename2(): ");

	for (i = strlen(path) - 1; i > 0; i--) {
		DPRINT("-");
		if (path[i] == '/') {
			i++;
			DPRINT(" done.\n");
			return (gchar *) (path + i);
		}
	}
	DPRINT(" done.\n");
	return path;
}

/* 137299 */

void show_help_window(gchar * title, gchar * text)
{
	GtkWidget *window;
	GtkWidget *button;
	GtkWidget *label;
	GtkWidget *vbox;

	window = gtk_window_new(GTK_WINDOW_DIALOG);
	gtk_window_set_title(GTK_WINDOW(window), title);

	vbox = gtk_vbox_new(FALSE, 0);
	gtk_container_add(GTK_CONTAINER(window), vbox);
	gtk_widget_show(vbox);

	label = gtk_label_new(text);
	button = gtk_button_new_with_label(" Dismiss ");
	gtk_signal_connect_object(GTK_OBJECT(button), "clicked", GTK_SIGNAL_FUNC(gtk_widget_destroy), (gpointer) window);

	gtk_label_set_justify(GTK_LABEL(label), GTK_JUSTIFY_LEFT);
	gtk_box_pack_start(GTK_BOX(vbox), label, TRUE, TRUE, 10);
	gtk_box_pack_start(GTK_BOX(vbox), button, FALSE, FALSE, 10);
	gtk_widget_show(label);
	gtk_widget_show(button);

	gtk_widget_show(window);
}

void sigusr1_handler(int sig)
{
	signal(SIGUSR1, sigusr1_handler);
	DPRINT("sigusr1_handler()\n");

	if (current == -1)
		return;
	if (playing)
		do_stop();
	do_prev();
}

void sigusr2_handler(int sig)
{
	signal(SIGUSR2, sigusr2_handler);
	DPRINT("sigusr2_handler()\n");

	if (current == -1)
		return;
	if (playing)
		do_stop();
	do_next();
}

void sigchld_handler(int sig)
{
	gchar *title;
	gchar *buffer;
	gchar *entry[5];
	gchar *data2;
	gint i;
	gint status;
	struct stat a;
	gint bitrate;

	signal(SIGCHLD, sigchld_handler);
	DPRINT("sigchld_handler()\n");

	i = waitpid(0, &status, 0);

	gtk_timeout_remove(timeout);
	free(save_as);
	save_as = NULL;
	A_WRITE_TO_FILE = 0;
	A_FORMAT_WAVE = 0;

	/*    close_audio();
	      fclose(in_file); */

	if (gtk_clist_get_cell_type(GTK_CLIST(pll), current, 0) != GTK_CELL_PIXMAP) {
		gtk_clist_set_pixmap(GTK_CLIST(pll), current, 0, p_tickmark, tm_mask);
		songs_left--;
	}

	on_led(3);
	playing = 0;
	if (!shared->stop) {
		do_next();
	}
}

void popup_callback(GtkWidget * widget, GdkEvent * event)
{
	GtkWidget *menu;
	GtkWidget *menu_item;
	GdkEventButton *bevent;

	DPRINT("popup_callback()\n");

	menu = gtk_menu_new();

	DPRINT("\t1\n");
	menu_item = gtk_menu_item_new_with_label("By Name Descending");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	DPRINT("\t.\n");
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & MENU_HELP_REPLAY);

	DPRINT("\t2\n");
	menu_item = gtk_menu_item_new_with_label("By Name Ascending");
	gtk_menu_append(GTK_MENU(menu), menu_item);
	DPRINT("\t.\n");
	gtk_widget_show(menu_item);
	gtk_signal_connect(GTK_OBJECT(menu_item), "activate", GTK_SIGNAL_FUNC(menu_callback), (gpointer) & MENU_HELP_REPLAY);

	DPRINT("\t3\n");
	gtk_widget_show(menu);

	bevent = (GdkEventButton *) event;
	DPRINT("\tpopup\n");
	gtk_menu_popup(GTK_MENU(menu), NULL, NULL, NULL, NULL, bevent->button, bevent->time);
}

void load_options()
{
	FILE *file;
	gchar *name;
	struct stat a;

	name = malloc(4096);
	sprintf(name, "%s/%s", confdir, OPTFILE);
	if (!stat(name, &a)) {
		file = fopen(name, "r");
		fread(options, sizeof(gint), OPT_NUMBER_OF, file);
		fread(&A_DOWNMIX, sizeof(int), 1, file);
		fread(&A_AUDIO_PLAY, sizeof(int), 1, file);
		fclose(file);
	}
	free(name);
}

void callback_func( GtkWidget *widget, GdkEvent  *event, gpointer callback_data )
{
	DPRINT("callback_func()\n");
  
	options[OPT_REMAINING] = !options[OPT_REMAINING];
	gtk_check_menu_item_set_state(GTK_CHECK_MENU_ITEM(opt_remaining_menu_item), options[OPT_REMAINING]);
}

void clear_marks()
{
	gint i;
	
	gtk_clist_freeze(GTK_CLIST(pll));
	for (i = 0; i < pl_index; i++)
		tickmark(CLEAR, i);
	gtk_clist_thaw(GTK_CLIST(pll));
}

void set_marks()
{
	gint i;
	
	gtk_clist_freeze(GTK_CLIST(pll));
	for (i = 0; i < pl_index; i++)
		tickmark(SET, i);
	gtk_clist_thaw(GTK_CLIST(pll));
}

void column_callback(GtkCList * clist, gint column)
{
	if (column == 0 && songs_left != pl_index)
		clear_marks();
	else if (column == 0 && songs_left == pl_index)
		set_marks();
}

void select_row_callback(GtkWidget *widget, gint row, gint column, GdkEventButton *event, gpointer data)
{
	if (loading)
		return;
	if (column == 0)
		tickmark(TOGGLE, row);
}

void on_led(int i)
{
	int j;

	for (j = 0; j < 6; j++) {
		if (leds[j]) {
			gtk_pixmap_set(GTK_PIXMAP(pixmapwid[j]), pixmap[j][0], mask[j][0]);
			leds[j] = 0;
		}
	}

	gtk_pixmap_set(GTK_PIXMAP(pixmapwid[i]), pixmap[i][1], mask[i][1]);
	leds[i] = 1;
}

int tickmark(int set, int num) {
	if (set == CLEAR && gtk_clist_get_cell_type(GTK_CLIST(pll), num, 0) == GTK_CELL_PIXMAP) {
		gtk_clist_set_text(GTK_CLIST(pll), num, 0, "");
		songs_left++;
		return 0;
	} else if (set == SET && gtk_clist_get_cell_type(GTK_CLIST(pll), num, 0) != GTK_CELL_PIXMAP) {
		gtk_clist_set_pixmap(GTK_CLIST(pll), num, 0, p_tickmark, tm_mask);
		songs_left--;
		return 1;
	} else if (set == TOGGLE) {
		if (gtk_clist_get_cell_type(GTK_CLIST(pll), num, 0) == GTK_CELL_PIXMAP) {
			gtk_clist_set_text(GTK_CLIST(pll), num, 0, "");
			songs_left++;
			return 0;
		} else {
			gtk_clist_set_pixmap(GTK_CLIST(pll), num, 0, p_tickmark, tm_mask);
			songs_left--;
			return 1;
		}
	} else if (set == CHECK)
		return gtk_clist_get_cell_type(GTK_CLIST(pll), num, 0) == GTK_CELL_PIXMAP;
}
