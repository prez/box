/* see LICENSE file for copyright and license details */
#include <err.h>
#include <assert.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <sys/prctl.h>
#include <linux/seccomp.h>

#include <seccomp.h>

bool
sandbox_seccomp_supp(void)
{
	return prctl(PR_GET_SECCOMP, 0, 0, 0, 0) != -1
		&& prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, NULL, 0, 0) == -1;
}

bool
sandbox_seccomp_prime(scmp_filter_ctx ctx)
{
	int syscalls[] = {
		SCMP_SYS(read),
		SCMP_SYS(write),
		SCMP_SYS(sigreturn),
		SCMP_SYS(exit_group)
	};
	bool st = false;
	for (size_t i = 0; i != sizeof(syscalls)/sizeof(syscalls[0]); i++) {
		st = st || seccomp_rule_add(ctx, SCMP_ACT_ALLOW, syscalls[i], 0);
	}
	return st;
}

void
sandbox_seccomp(void)
{
	scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_KILL);
	if (!sandbox_seccomp_supp()
		|| NULL == ctx
		|| sandbox_seccomp_prime(ctx)
		|| seccomp_load(ctx)) {
		err(EXIT_FAILURE, "seccomp");
	}
	seccomp_release(ctx);
}

void
sandbox(void)
{
	sandbox_seccomp();
}

int
main(void)
{
	sandbox();
	pid_t pid = getpid();
	printf("notreached, pid: %d\n", pid);
}
