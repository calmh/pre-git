#include "stdafx.h"

#include <iostream>
#include <math.h>

#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif
#include "network.h"

#define WIDTH	640
#define HEIGHT	480

// lighting values and coordinates
GLfloat ambientLight[] = {0.3f, 0.3f, 0.3f, 1.0f};
GLfloat diffuseLight[] = {0.5f, 0.5f, 0.5f, 1.0f};
GLfloat specular[] = {1.0f, 1.0f, 1.0f, 1.0f};
GLfloat lightPos[] = { 40.0f, 40.0f, 60.0f, 1.0f};
GLfloat specref[] = {0.8f, 0.8f, 0.8f, 1.0f};
GLfloat sphereColor[] = {1.0f, 1.0f, 1.0f};

const int GRADIENT_WIDTH = WIDTH;
const int GRADIENT_HEIGHT = HEIGHT;
GLubyte gradient[GRADIENT_HEIGHT][GRADIENT_WIDTH][3];
GLuint texName;

namespace Threenet_main {
	GLuint textureNum;
	int camera_radius = 4;
	int init = 0;
	int timer = 0;
	double camera_alpha = -M_PI/3, camera_theta = M_PI/3;
	void init_gradient();
	void grid(double size, float alpha);
	void display();
	void initialize();
	void mouse(int x, int y);
	void reshape(int height, int widht);
	void timerCallback(int);
	void texture();
	Network net("network.conf");
}

void Threenet_main::texture() {
	const int size = 64;
	GLubyte tx[size][size][3];
	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			tx[i][j][0] = i/4 % 2 ? 127 : 255;
			tx[i][j][1] = i/4 % 2 ? 127 : 255;
			tx[i][j][2] = i/4 % 2 ? 127 : 255;
		}
	}
	
	glGenTextures(1, &textureNum);
	glBindTexture(GL_TEXTURE_2D, textureNum);
	glTexImage2D(GL_TEXTURE_2D, 0, 3, size, size, 0, GL_RGB, GL_UNSIGNED_BYTE, tx);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
}

void Threenet_main::grid(double size, float alpha) {
	// build "floor"
	for (double f = -size; f <= size; f += 1) {
		glColor4f(0.0f, 0.0f, 0.0f, alpha);
		glBegin(GL_LINES);
		glVertex3f(-size, 0.0, f);
		glVertex3f(size, 0.0, f);
		glEnd();
		glBegin(GL_LINES);
		glVertex3f(f, 0.0, -size);
		glVertex3f(f, 0.0, size);
		glEnd();
		if (f < size) {
			glColor4f(0.0f, 0.0f, 0.0f, alpha/2);
			for (double f1 = f + 0.25; f1 <= f + 0.75; f1 += 0.25) {
				glBegin(GL_LINES);
				glVertex3f(-size, 0.0, f1);
				glVertex3f(size, 0.0, f1);
				glEnd();
				glBegin(GL_LINES);
				glVertex3f(f1, 0.0, -size);
				glVertex3f(f1, 0.0, size);
				glEnd();
			}
		}
	}
/*	glColor4f(0.7f, 0.7f, 0.8f, 0.7);
	glBegin(GL_QUADS);
	glNormal3f(0.0, 1.0, 0.0);                            
	glVertex3f(-size, 0.0, size);                            
	glVertex3f(-size, 0.0, -size);
	glVertex3f( size, 0.0, -size);
	glVertex3f( size, 0.0, size);
	glEnd();*/
}

void Threenet_main::display()
{
	static double lx, ly;
	static double tx, ty;
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	// Save matrix state 
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glBegin(GL_QUADS);
	glNormal3f(0.0, 0.0, 1.0);
	glColor3f(0.5f, 0.5f, 1.0f);
	glVertex3f(-12.0, -9, -20.0);
	glColor3f(0.8f, 0.8f, 1.0f);
	glVertex3f(-12.0, 9, -20.0);
	glColor3f(0.9f, 0.9f, 1.0f);
	glVertex3f(12.0, 9, -20.0);
	glColor3f(0.5f, 0.5f, 1.0f);
	glVertex3f(12.0, -9, -20.0);
	glEnd();
	
	if (timer % 400 == 0) {
		Node n = net.random_node();
		tx = n.x;
		ty = n.y;
	}
	
	lx += (tx - lx) / 100.0;
	ly += (ty - ly) / 100.0;
	
	gluLookAt(camera_radius * cos(camera_alpha), camera_radius * sin(camera_theta), camera_radius * sin(camera_alpha),
		  ly, -0.5f, lx,
		  0.0, 1.0, 0.0);
	
	
/*	(new Node(0.0, 0.0, 5))->draw();
	(new Node(0.5, 0.5, 3))->draw();
	(new Node(-1.0, 1.0, 3))->draw();
	(new Node(-1.0, -.5, 5))->draw();
	(new Link(0.0, 0.0, 0.5, 0.5, 45, 25))->draw(Threenet_main::timer);
	(new Link(0.5, 0.5, -1.0, 1.0, 100, -50))->draw(Threenet_main::timer);
	(new Link(0.5, 0.5, -1.0, -0.5, 1000, 100))->draw(Threenet_main::timer);*/
	
//	glTranslatef(0.0, 0.8, 0.0);
	
//	Torso t;
//	t.draw();
	
	net.draw(timer, camera_alpha);
	grid(6.0, 0.1);
	
	glutSwapBuffers();
}

void Threenet_main::mouse(int x, int y) {
	static int ox, oy;
	if (!init) {
		ox = x;
		oy = y;
		init = 1;
	} else {
		int dx = x - ox;
		int dy = y - oy;
		camera_alpha += dx / 100.0;
		camera_theta += dy / 100.0;
		ox = x;
		oy = y;
	}
	
	glutPostRedisplay();
}

void Threenet_main::reshape(int width, int height)
{
	glViewport(0, 0, width, height);
	// Reset projection matrix stack
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	// apply perspective matrix 
	gluPerspective(45.0f, (float)width/(float)height, 1.0f, 500.0f);
	
	// Reset Model view matrix stack
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glutPostRedisplay();
}

void Threenet_main::initialize()
{
	texture();
	glEnable(GL_TEXTURE_2D);
	
	glPolygonMode(GL_BACK, GL_FILL);
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_ALPHA_TEST);
	glEnable(GL_BLEND);
	glEnable(GL_LIGHTING);
	glEnable(GL_LINE_SMOOTH);
	glHint(GL_LINE_SMOOTH, GL_NICEST);
#ifndef WIN32
	glEnable(GL_POLYGON_SMOOTH);
	glHint(GL_POLYGON_SMOOTH, GL_NICEST);
#endif
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glShadeModel(GL_SMOOTH);
	
	// set up lighting (light positioned at [0, 100, 0])
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientLight);
	glLightfv(GL_LIGHT0, GL_AMBIENT, ambientLight);
	glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuseLight);
	glLightfv(GL_LIGHT0, GL_SPECULAR, specular);
	glLightfv(GL_LIGHT0, GL_POSITION, lightPos);
	glEnable(GL_LIGHT0);
	
	glEnable(GL_COLOR_MATERIAL);
	glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);
	
	// Black background
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f );	
}

void Threenet_main::timerCallback(int val)
{
	int intervalmsec = 50;
	
	//static int adir = 1;
	//double amin = 0.0;
	//double amax = 2.0 * M_PI;
	double astep = 0.002;
	
	static int tdir = 1;
	double tmin = 0.2 * M_PI;
	double tmax = 0.8 * M_PI;
	double tstep = 0.001;
	
	camera_alpha += astep;
	if (camera_alpha > 2.0 * M_PI)
		camera_alpha -= 2.0 * M_PI;
/*		adir = -adir;
	} else if (camera_alpha < amin) {
		camera_alpha = amin;
		adir = -adir;
	}*/

	camera_theta += tdir * tstep;
	if (camera_theta > tmax)
		tdir = -tdir;
	else if (camera_theta < tmin)
		tdir = -tdir;

	init = 0;
	timer++;
	glutPostRedisplay();
	
	glutTimerFunc (intervalmsec, timerCallback, 0);
}

#ifdef WIN32
int _tmain(int argc, _TCHAR* argv[])
#else
int main(int argc, char** argv)
#endif
{
	using namespace Threenet_main;
	
	glutInit(&argc, argv);
	
	glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH);
	glutInitWindowSize(WIDTH, HEIGHT);
	
	if (argc == 2 && string(argv[1]) == string("-f")) {
/*		int w = glutGet(GLUT_SCREEN_WIDTH);
		int h = glutGet(GLUT_SCREEN_HEIGHT);
		char buffer[80];
		sprintf(buffer, "%dx%d:32", w, h);
		glutGameModeString(buffer);*/
		glutEnterGameMode();
	} else {
		glutCreateWindow("Perspektiv Bredband 3D [" __DATE__ " " __TIME__ "]");
	}
	
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);
	glutMotionFunc(mouse);
	
	initialize();
	
	glutTimerFunc (100, timerCallback, 0);
	glutMainLoop();
	return 0;
}
