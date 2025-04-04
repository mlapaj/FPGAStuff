.global reset_vector

reset_vector:

.global _start
.type _start,@function

_start:


	/* Initialize global pointer */
	.option push
	.option norelax
	la gp, __global_pointer$
	.option pop

	/* Initialize stack pointer */
	la t0, _stack
	mv sp, t0


    call main
1:
    j 1b


