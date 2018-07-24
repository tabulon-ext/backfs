PREFIX=/usr/local

BRANCH=$(shell test -d .git && (git branch | grep '^*' | cut -c3-) || echo "unknown")

VERSION=BackFS v0.5\
$(shell test -d .git && echo "\ngit revision" && git log --pretty="format:%h %ai" -n1) branch $(BRANCH)\
\nbuilt $(shell date "+%Y-%m-%d %H:%M:%S %z")\n

DEFINES=-D_FILE_OFFSET_BITS=64 \
	-DFUSE_USE_VERSION=30 \
	-D_POSIX_C_SOURCE=201201 \
	-D_GNU_SOURCE \
	-DBACKFS_VERSION="\"$(VERSION)\"" \
	-DBACKFS_RW

CFLAGS+=-std=c11 -Wall -Wextra -pedantic $(DEFINES) $(shell pkg-config --cflags fuse3)
LDLIBS=$(shell pkg-config --libs fuse3) -lpthread

CFLAGS+= -Wno-format		# we use the Gnu '%m' format all over the place
CFLAGS+= -Wno-sign-compare	# these should get fixed eventually, but there are a lot...
CFLAGS+= -Wno-missing-field-initializers # don't warn about '= {0}' pattern

OBJS = backfs.o fscache.o fsll.o util.o

all: backfs

.SUFFIXES:

%.o: %.c
	@echo "    CC  $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

backfs: $(OBJS)
	@echo "  LINK  $<"
	@$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)
	@echo "Built BackFS for branch: $(BRANCH)" 

clean:
	@echo " CLEAN"
	@rm -f *.o *~ backfs

install: backfs
	echo cp backfs $(PREFIX)/bin
	echo chmod 0755 $(PREFIX)/bin/backfs

# vim: noet sts=8 ts=8 sw=8
