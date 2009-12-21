#include <iostream>
#include <vector>
#include <math.h>

int nbr_beep;
static int *visited = new int[11];

class Node
{
	int x;
	int y;
	int sum_dist;
public:
	vector<int> dist;
	Node(int x, int y);
	void calc_dist();
	int get_x();
	int get_y();
};

vector<Node> node_list;

Node::Node(int tx, int ty)
{
	x = tx;
	y = ty;
	sum_dist = 0;
}

void Node::calc_dist()
{
	for (int i=0; i<node_list.size(); i++)
		dist.push_back(abs(x - node_list[i].get_x()) + abs(y - node_list[i].get_y()));
}

int Node::get_x()
{
	return x;
}

int Node::get_y()
{
	return y;
}

int solve(int node, int max = 999999)
{
	visited[node] = 1;
	int min = 999999;
	int one = 0;
	for (int i = 1; i < nbr_beep + 1; i++) {
		if (!visited[i]) {
			one = 1;
			int cost = node_list[node].dist[i] + solve(i);
//			if (cost < max)
//				max = cost;
			if (cost < min) {
				min = cost;
			}
		}
	}
	visited[node] = 0;
	if (one)
		return min;
	else
		return (abs(node_list[node].get_x() - node_list[0].get_x()) + abs(node_list[node].get_y() - node_list[0].get_y()));
}

int main()
{
	int nbr;
	cin >> nbr;

	for (int i=0; i<nbr; i++) {
		int worldx, worldy;
		cin >> worldx >> worldy;
		int startx, starty;
		cin >> startx >> starty;
		cin >> nbr_beep;
		node_list.clear();
		node_list.push_back(Node(startx, starty));
		for (int j=0; j<nbr_beep; j++) {
			int x, y;
			cin >> x >> y;
			node_list.push_back(Node(x, y));
		}

		for (int j = 0; j< nbr_beep + 1; j++) {
			visited[j] = 0;
			node_list[j].calc_dist();
		}

		int s = solve(0);
		cout << "The shortest path has length " << s << endl;
	}
}

