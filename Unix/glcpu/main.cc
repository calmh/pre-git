/** Copyright (c) 2000 Jakob Borg
 **
 ** This is the main glcpu program.
 **
 ** This program is free software; you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation; either version 2 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program; if not, write to the Free Software
 ** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 **
 ** $Id: main.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

#include <iostream>
#include <strstream>
#include <string>
#include <list>
#include <vector>
#include <cstdio>

#include <GL/glut.h>
#include <pthread.h>
#include <cc++/thread.h>
#include <cc++/socket.h>

using namespace std;

#include "config.h"
#include "parser.h"

/**
 ** Global constants.
 ** Some of these should be run-time configurable instead.
 **/

const unsigned HISTORY = 20; // consider making this runtime
const double INIT_R = 10;
const double INIT_CX = 0.25 * 3.1415926;
const double INIT_CY = 0.4 * 3.1415926;
const int SIZE = 300;
const int UPDATE_DELAY = 250;
const double TRANS_FACTOR = 0.75;
const string REVISION = "DR6";

/**
 ** Global variables.
 **/

int first, dragging, zooming; // used by the glut functions
list<TCPStream*>* hosts; // connections to all hosts we monitor
Config* options; // options, read from rcfile
vector<vector<int> > vstats; // vectors contaning the statistics to draw
vector<string> vlabels; // vector containing the labels
int nfeeds = 0;	// number of feeds

/**
 ** Prototypes.
 **/

void glut_init(int argc, char *argv[]);
void gl_init();
void draw_stats(const vector<vector<int> >& stats);
void draw_level(int num, int row, int level);
void draw_cube(GLfloat x, GLfloat y, GLfloat z);
void draw_label(int row, string);
void draw_grid(GLdouble x, GLdouble y, GLdouble z, GLdouble width, GLdouble interval);
int get_num_feeds(TCPStream* conn);
list<TCPStream*>* setup_connections();
vector<int>* read_data();
void produce_stats();
template<class T> T average(const vector<T>& data);
void animate(int foo);
void display();
void reshape(int width, int height);
void mouse(int button, int state, int x, int y);
void motion(int x, int y);
string to_str(int v);
string to_str(double v);
int parse_int(string v);
double parse_double(string v);

/**
 ** Initialize stuff and set up periodic polling and graphing.
 **/

int main(int argc, char *argv[])
{
	options = Parser::parse((string) getenv("HOME") + "/.glcpurc");

	if (options->get_value("update_delay") == "")
		options->set_value("update_delay", to_str(UPDATE_DELAY));
	if (options->get_value("trans_factor") == "")
		options->set_value("trans_factor", to_str(TRANS_FACTOR));

	if (options->get_value("verbose") == "yes") { // not likely...
		cout << "* GLcpu " << REVISION << endl
		     << "  Copyright (C) 2000 Jakob Borg" << endl;	
	}
	
	hosts = setup_connections();

	if (nfeeds == 0) {
		cout << endl << "GLcpu has no hosts to monitor." << endl
		     << "Check configuration and that statd is enabled on the hosts." << endl;
		return 0;
	}

	for (int i = 0; i < nfeeds; i++)
		vstats.push_back(*new vector<int>);
	
	glut_init(argc, argv);
	gl_init();
	
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);
	glutMotionFunc(motion);
	glutMouseFunc(mouse);
	glutTimerFunc(parse_int(options->get_value("update_delay")), animate, 0);

	glutMainLoop();
        return 0;
}

/**
 ** Initialize GLUT window
 **/

void glut_init(int argc, char *argv[])
{
	glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH);
        glutInitWindowSize(SIZE, SIZE);
        glutInit(&argc, argv);
 	
        glutCreateWindow(("GLcpu " + REVISION).c_str());
}

/**
 ** Initialize OpenGL to suitable defaults.
 **/

void gl_init()
{
	glClearColor(0, 0, 0, 1);

	glShadeModel(GL_SMOOTH);
	glEnable(GL_DEPTH_TEST);
        glEnable(GL_BLEND);
        glEnable(GL_COLOR_MATERIAL);
        glEnable(GL_LIGHTING);
        glEnable(GL_POLYGON_SMOOTH);
	if (parse_double(options->get_value("trans_factor"))) {
        	glEnable(GL_ALPHA_TEST);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	}
	glDepthMask(GL_TRUE);

	// These values are somewhat experimental. When running on Solaris,
	// the colors get all washed out and gloomy, so a different specular
	// seems to work better.
#ifdef OS_SunOS
	GLfloat specular [] = { .2, .2, .2, .2 };
#else
	GLfloat specular [] = { 1.0, 1.0, 1.0, 1.0 };
#endif
        GLfloat shininess [] = { 100.0 };
        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

        glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, specular);
        glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, shininess);
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, specular);
        glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);

        GLfloat position [] = { 5.0, 1.0, 4.0, .5 };
	glLightfv(GL_LIGHT0, GL_POSITION, position);
        glEnable(GL_LIGHT0);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glFrustum(-0.4, 0.4, -.4, .4, 1.0, 100.0);
	gluLookAt(INIT_R * cos(INIT_CX)*sin(INIT_CY), INIT_R * cos(INIT_CY), INIT_R * sin(INIT_CX)*sin(INIT_CY), 0, 0, 0, 0, 1, 0);
}

/**
 ** Draw all the statistics from a vector.
 **/

void draw_stats(const vector<vector<int> >& stats)
{
	unsigned nrows = stats.size();
	for (unsigned j = 0; j < nrows; j++) {
		draw_label(j, vlabels[j]);
		for (unsigned i = 0; i < stats[j].size(); i++)
			draw_level(i, j, stats[j][i]);
	}

}

/**
 ** Draw a column of cubes at a certain (row, column) coordinate.
 **/

void draw_level(int num, int row, int level)
{
	GLfloat x = (num * 4.5/HISTORY) + .3;
	GLfloat z = (row * 30.0/HISTORY) + .8;
	// maybe we should pack the graphs tighter?

	double tf = parse_double(options->get_value("trans_factor"));
	for (int i = 0; i < level; i++) {
		glColor4f(.7/HISTORY * i, .5 - .5/HISTORY*i, 0, 1 - (tf / nfeeds)*row);
		draw_cube(x, .3 + 4.5/HISTORY*i, z);
	}
}

/**
 ** Draw a single cube at a specified point.
 **/

void draw_cube(GLfloat x, GLfloat y, GLfloat z)
{
	glPushMatrix();
	glTranslatef(x, y, z);
	glutSolidCube(4.0/HISTORY);
	glPopMatrix();
}

/**
 ** Draw a string of text next to a specific row.
 **/

void draw_label(int row, string label)
{
	double scalefactor = 0.003;
	GLfloat z = (row * 30.0/HISTORY) + .8;
	
	glPushMatrix();
	glTranslatef(5, 0, z);
	glScalef(scalefactor, scalefactor, 1);
	glColor3f(1.0, 1.0, 0.2);
	for (string::const_iterator i = label.begin(); i != label.end(); i++) {
		glutStrokeCharacter(GLUT_STROKE_ROMAN, *i);
		glTranslatef(glutStrokeWidth(GLUT_STROKE_ROMAN, *i) * 1.1 * scalefactor, 0, 0);
	}
	glPopMatrix();
}

/**
 ** Draw the green grid-thing.
 ** FIXME: needs to be changed to be able to draw a grid that is wider than
 ** it is high or deep, to accomodate more graphs.
 **/

void draw_grid(GLdouble x, GLdouble y, GLdouble z, GLdouble width, GLdouble interval)
{
	for (GLdouble f = 0; f <= width; f += interval) {
		glColor3f(0, 0.5, 0);

		glBegin(GL_LINES);
                glVertex3f(x, y, z + f);
                glVertex3f(x + width, y, z + f);
		glVertex3f(x, y + f, z);
                glVertex3f(x + width, y + f, z);
		
                glVertex3f(x, y, z + f);
                glVertex3f(x, y + width, z + f);
                glVertex3f(x + f, y, z);
                glVertex3f(x + f, y + width, z);

                glVertex3f(x + f, y, z);
                glVertex3f(x + f, y, z + width);
                glVertex3f(x, y + f, z);
                glVertex3f(x, y + f, z + width);
		glEnd();
	}
}

/**
 ** Gather new stats and redraw. Called periodically.
 **/

void animate(int foo)
{
	produce_stats();
	glutPostRedisplay();

	glutTimerFunc(parse_int(options->get_value("update_delay")),  animate, 0);
}

/**
 ** Calculate the average in a vector of numbers. (Type needs to support + and / operations)
 **/

template<class T>
T average(const vector<T>& data)
{
	T avg = 0;
	for (unsigned i = 0; i < data.size(); i++)
		avg += data[i];
	return avg / data.size();
}

/**
 ** Get the number of feeds available from a connection.
 ** Semi-ugly.
 **/

int get_num_feeds(TCPStream* conn)
{
	int nfeeds = -1, foo;
	
	*conn << "DATA" << endl;
	*conn >> nfeeds;
	if (nfeeds != -1)
		for (int i = 0; i < nfeeds; i++)
			*conn >> foo;
	return nfeeds;
}

/**
 ** Setup connections.
 ** Fetches list of wanted hosts from options and returns a list of connections.
 **/

list<TCPStream*>* setup_connections()
{
	list<TCPStream*>* foo = new list<TCPStream*>;
	string param = options->get_value("hosts");
	unsigned oldpos = 0;
	unsigned pos = param.find_first_of(":\n");

	// iterate over the :-separated list and process all hosts
	while (pos != oldpos) {
		string host = param.substr(0, pos);
		param = param.substr(pos+1);

		try { // failure to connect causes exception
			TCPStream* bar = new TCPStream(*new InetHostAddress(host.c_str()), 7687);
			if (options->get_value("verbose") == "yes")
				cout << "Connection to " + host + " established." << endl;
			int newfeeds = get_num_feeds(bar);
			if (newfeeds == -1)
				cout << "Protocol error when talking to " + host << "." << endl;
			else {
				foo->push_back(bar);
				nfeeds += newfeeds;
				if (newfeeds > 1) {
					for (int i = 0; i < newfeeds; i++)
						vlabels.push_back(host + ":" + to_str(i));
				} else
					vlabels.push_back(host);
			}
			
		} catch (...) {
			cout << "Connection to " + host + " failed." << endl;
		}
		
		oldpos = pos;
		pos = param.find_first_of(":\n");
	}

	return foo;
}

/**
 ** Gather raw statistics from all streams.
 **/

vector<int>* read_data()
{
	static vector<int>* data = new vector<int>;
	
	data->clear();
	list<TCPStream*>::const_iterator i = hosts->begin();
	for(;i != hosts->end(); i++) {
		int n;
		**i << "DATA" << endl;
		**i >> n;
		for (int j = 0; j < n; j++) {
			int d;
			**i >> d;
			data->push_back((d < 0) ? 0 : d);
		}
	}

	return data;
}

/**
 ** Gather stats and do average smoothing on them.
 **/

void produce_stats()
{
	const unsigned NAVG = 5;
	static bool init = false;
	vector<int>* data;
	static vector<vector<int> > oldstats;

	// create the raw data vectors if necessary
	if (!init) {
		for (int i = 0; i < nfeeds; i++)
			oldstats.push_back(*new vector<int>);
		init = true;
	}


	data = read_data();

	// pop the oldest element in raw data vectors if necessary, and add the newest data
	vector<vector<int> >::iterator i;
	vector<vector<int> >::iterator i_end = oldstats.end();
	vector<int>::iterator j;
	for (i = oldstats.begin(), j = data->begin();
	     i != i_end; i++, j++) {
		if (i->size() == NAVG)
			i->erase(i->begin());
		i->push_back(*j);
	}
	
	// pop & add the latest smoothed value to the statistics vectors.
	vector<vector<int> >::iterator k;
	vector<vector<int> >::iterator l;
	vector<vector<int> >::iterator k_end = oldstats.end();
	vector<vector<int> >::iterator l_end = vstats.end();
	for (l = vstats.begin(), k = oldstats.begin();
	     l != l_end && k != k_end; l++, k++) {
		if (l->size() == HISTORY)
			l->erase(l->begin());
		l->push_back(average(*k));
	}
}

/**
 ** Redraw window with the current statistics
 **/

void display()
{
	glMatrixMode(GL_MODELVIEW);

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glPushMatrix();

	glTranslatef(-2.5, -2.5, -2.5);
	draw_grid(0, 0, 0, 5, .2);
	draw_stats(vstats);
	
	glPopMatrix();
	glutSwapBuffers();
}

/**
 ** Handle reshape-event.
 **/

void reshape(int width, int height)
{
        glViewport(0, 0, (GLint)width, (GLint)height);
        glClear(GL_COLOR_BUFFER_BIT);
	glutPostRedisplay();
}

/**
 ** Handle mouse click.
 **/

void mouse(int button, int state, int x, int y)
{
  	if (button == 0 && state == 0) {
  		first = dragging = 1;
  		glutSetCursor(GLUT_CURSOR_CYCLE);
  	} else if (button == 0 && state == 1) {
  		dragging = 0;
  		glutSetCursor(GLUT_CURSOR_INHERIT);
  	}
  	if (button == 1 && state == 0) {
  		first = zooming = 1;
  		glutSetCursor(GLUT_CURSOR_UP_DOWN);
  	} else if (button == 1 && state == 1) {
  		zooming = 0;
  		glutSetCursor(GLUT_CURSOR_INHERIT);
  	}
}

/**
 ** Handle mouse drag.
 **/

void motion(int x, int y)
{
  	static int ox = 0, oy = 0;
  	static double cx = INIT_CX, cy = INIT_CY;
  	static double r = INIT_R;

  	if (first) {
  		ox = x;
  		oy = y;
  		first = 0;
  	} else if (dragging) {
  		cx += (x - ox) / 50.0;
  		cy += (y - oy) / 50.0;
		
  		glMatrixMode(GL_PROJECTION);
  		glLoadIdentity();
  		glFrustum(-0.4, 0.4, -.4, .4, 1.0, 100.0);
  		gluLookAt(r * cos(cx)*sin(cy), r * cos(cy), r * sin(cx)*sin(cy), 0, 0, 0, 0, 1, 0);
  		glutPostRedisplay();
	
  		ox = x;
  		oy = y;
  	} else if (zooming) {
  		r += (y - oy) / 50.0;
		
  		glMatrixMode(GL_PROJECTION);
  		glLoadIdentity();
  		glFrustum(-0.4, 0.4, -.4, .4, 1.0, 100.0);
  		gluLookAt(r * cos(cx)*sin(cy), r * cos(cy), r * sin(cx)*sin(cy), 0, 0, 0, 0, 1, 0);
  		glutPostRedisplay();
		
  		oy = y;
  	}
}

/**
 ** Convert whatever->string.
 ** The template-based version with strstream was very borken (strstream buggy)
 **/

string to_str(int v)
{
  char *tmp = new char[20];
  sprintf(tmp, "%d", v);
  return string(tmp);
}

string to_str(double v)
{
  char *tmp = new char[20];
  sprintf(tmp, "%f", v);
  return string(tmp);
}

/**
 ** Grab an int from a string.
 **/

int parse_int(string v)
{
        istrstream tmp1(v.c_str());
        int tmp2;
        tmp1 >> tmp2;
        return tmp2;
}

/**
 ** Grab an int from a string.
 **/

double parse_double(string v)
{
        istrstream tmp1(v.c_str());
        double tmp2;
        tmp1 >> tmp2;
        return tmp2;
}
