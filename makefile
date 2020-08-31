# see LICENSE file for copyright and license details
.POSIX:
.SUFFIXES:

include config.mk

COMPONENTS = seccomp
all: sandbox
seccomp.o: seccomp.c config.mk

sandbox: $(COMPONENTS:=.o) config.mk
	$(CC) -o $@ $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $(COMPONENTS:=.o) $(LDLIBS)

clean:
	rm -f $(PROG) $(PROG).core $(PROG).su core $(COMPONENTS:=.o)

gitignore:
	rm -f .gitignore
	{ printf '*.o\n'; printf '%s\n' $(PROG); } > .$@

.SUFFIXES: .c .o
.c.o:
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
