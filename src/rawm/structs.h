/* Copyright (c), Niclas Meyer <niclas@countingsort.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at https://mozilla.org/MPL/2.0/.
 */

#ifndef STRUCTS_H
#define STRUCTS_H

#include <inttypes.h>
#include <stdbool.h>

typedef struct {
	uint64_t id;
} client;

typedef struct dequeue dequeue;
struct dequeue {
	dequeue *next;
	dequeue *prev;

	client *client;
};

typedef struct tree tree;
struct tree {
	tree *parent;

	tree *left; // NULL if leaf
	union {
		tree *right;
		client *client; // NULL if empty window
	};

	bool is_vertical;
};

#endif /* STRUCTS_H */
