/*
 *  main.cpp
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/main.cc#3 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#include <math.h>

#ifdef OS_DARWIN
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

#define WIDTH	800
#define HEIGHT	600

// lighting values and coordinates
GLfloat ambientLight[] = {0.3f, 0.3f, 0.3f, 1.0f};
GLfloat diffuseLight[] = {0.5f, 0.5f, 0.5f, 1.0f};
GLfloat specular[] = {1.0f, 1.0f, 1.0f, 1.0f};
GLfloat lightPos[] = { 40.0f, 40.0f, 60.0f, 1.0f};
GLfloat specref[] = {0.8f, 0.8f, 0.8f, 1.0f};
GLfloat sphereColor[] = {1.0f, 1.0f, 1.0f};

#include "arm.h"
#include "torso.h"

namespace Human_main {
    int camera_radius = 3;
    double camera_alpha = -M_PI/3, camera_theta = M_PI/3;
    void grid(double size);
    void display();
    void initialize();
    void mouse(int x, int y);
    void reshape(int height, int widht);
}

void Human_main::grid(double size) {
	// build "floor"
	glColor3f(0.0f, 0.9f, 0.0f);
	glBegin(GL_LINES);
	glVertex3f(0.0, size, 0.0);
	glVertex3f(0.0, 0.0, 0.0);
	glEnd();
	for (double f = -size; f <= size; f += 1) {
		if (fabs(0 - f) < 1e-4)
			glColor3f(0.0f, 0.9f, 0.0f);
		else
			glColor3f(0.0f, 0.4f, 0.0f);
		glBegin(GL_LINES);
		glVertex3f(-size, 0.0, f);
		glVertex3f(size, 0.0, f);
		glEnd();
		glBegin(GL_LINES);
		glVertex3f(f, 0.0, -size);
		glVertex3f(f, 0.0, size);
		glEnd();
		glColor3f(0.0f, 0.2f, 0.0f);
		if (f < size) {
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
}

void Human_main::display()
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	// Save matrix state 
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	gluLookAt(camera_radius * cos(camera_alpha), camera_radius * sin(camera_theta), camera_radius * sin(camera_alpha),
		  0.0, 0.75, 0.0,
		  0.0, 1.0, 0.0);
	
	grid(3.0);
		
	glTranslatef(0.0, 0.8, 0.0);
	
	Torso t;
	t.draw();
	
	glutSwapBuffers();
}

void Human_main::mouse(int x, int y) {
	static int ox, oy, init = 0;
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

void Human_main::reshape(int width, int height)
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

void Human_main::initialize()
{
	glPolygonMode(GL_BACK, GL_FILL);
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_ALPHA_TEST);
	glEnable(GL_BLEND);
	glEnable(GL_LIGHTING);
	glEnable(GL_POLYGON_SMOOTH);
	
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

int main(int argc, char** argv)
{
    using namespace Human_main;
    
	glutInit(&argc, argv);
	
	glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH);
	glutInitWindowSize(WIDTH, HEIGHT);
	
	glutCreateWindow("Model");
	
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);
	glutMotionFunc(mouse);
	
	initialize();
	
	glutMainLoop();
	return 0;
}

