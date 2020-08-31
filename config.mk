PROG    = sandbox
VERSION != git describe --tags 2>/dev/null || echo 0.0

CC     = clang
PREFIX = /usr/local
BINDIR = /bin

#-D_XOPEN_SOURCE=700 -D_BSD_SOURCE
CPPFLAGS = -D_POSIX_C_SOURCE=200809L -DVERSION=\"$(VERSION)\"
#-fsanitize=signed-integer-overflow -fsanitize-undefined-trap-on-error
CFLAGS   = -std=c2x -g3 -Wpedantic -Wall -Wextra -O3              \
	-fdiagnostics-color=always -fsanitize=undefined,address,leak  \
	-fstack-protector-all -fno-omit-frame-pointer -fno-common     \
	-Wvla -Wshadow -Wdouble-promotion -Wnull-dereference          \
	-Wconversion -Wfloat-equal -Wformat=2 -Wstrict-aliasing=2     \
	-Wcast-qual -Wdate-time -Wimplicit-fallthrough -Wpacked       \
	-Wmissing-include-dirs -Wnested-externs -Wstack-protector     \
	-Wunused-parameter -Wredundant-decls -Wundef -Winit-self      \
	-Wold-style-definition -Wstrict-prototypes
LDFLAGS  = -fuse-ld=lld                   \
	-Xlinker --error-unresolved-symbols   \
	-Xlinker --color-diagnostics=always
LDLIBS   = -lseccomp
