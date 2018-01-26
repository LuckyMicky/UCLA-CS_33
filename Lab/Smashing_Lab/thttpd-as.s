	.file	"thttpd.c"
	.text
	.p2align 4,,15
	.type	handle_hup, @function
handle_hup:
.LASANPC4:
.LFB4:
	.cfi_startproc
	movl	$1, got_hup(%rip)
	ret
	.cfi_endproc
.LFE4:
	.size	handle_hup, .-handle_hup
	.section	.rodata
	.align 32
.LC0:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.zero	56
	.text
	.p2align 4,,15
	.type	thttpd_logstats, @function
thttpd_logstats:
.LASANPC35:
.LFB35:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	testq	%rdi, %rdi
	jle	.L4
	movq	stats_bytes(%rip), %r8
	pxor	%xmm2, %xmm2
	movq	stats_connections(%rip), %rdx
	pxor	%xmm1, %xmm1
	pxor	%xmm0, %xmm0
	movl	httpd_conn_count(%rip), %r9d
	cvtsi2ssq	%rdi, %xmm2
	movl	stats_simultaneous(%rip), %ecx
	movl	$.LC0, %esi
	movl	$6, %edi
	cvtsi2ssq	%r8, %xmm1
	movl	$2, %eax
	cvtsi2ssq	%rdx, %xmm0
	divss	%xmm2, %xmm1
	divss	%xmm2, %xmm0
	cvtss2sd	%xmm1, %xmm1
	cvtss2sd	%xmm0, %xmm0
	call	syslog
.L4:
	movq	$0, stats_connections(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE35:
	.size	thttpd_logstats, .-thttpd_logstats
	.section	.rodata
	.align 32
.LC1:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.zero	58
	.align 32
.LC2:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.zero	34
	.align 32
.LC3:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.zero	63
	.text
	.p2align 4,,15
	.type	update_throttles, @function
update_throttles:
.LASANPC25:
.LFB25:
	.cfi_startproc
	movl	numthrottles(%rip), %r11d
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	testl	%r11d, %r11d
	jle	.L7
	xorl	%ebx, %ebx
	movabsq	$6148914691236517206, %rbp
	jmp	.L22
	.p2align 4,,10
	.p2align 3
.L87:
	movq	%rcx, %rsi
	leaq	(%r9,%r9), %rdx
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L78
	cmpq	%rdx, %r8
	movq	(%rcx), %rcx
	jle	.L15
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movl	$5, %edi
	movl	%ebx, %edx
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	$.LC1, %esi
	xorl	%eax, %eax
	call	syslog
	movq	throttles(%rip), %rcx
	popq	%r9
	.cfi_def_cfa_offset 40
	popq	%r10
	.cfi_def_cfa_offset 32
	addq	%r12, %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L79
.L17:
	movq	24(%rcx), %r8
.L11:
	leaq	16(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L80
	movq	16(%rcx), %r9
	cmpq	%r8, %r9
	jle	.L19
	leaq	40(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L20
	cmpb	$3, %al
	jle	.L81
.L20:
	movl	40(%rcx), %eax
	testl	%eax, %eax
	jne	.L82
.L19:
	addl	$1, %ebx
	cmpl	%ebx, numthrottles(%rip)
	jle	.L7
.L22:
	movslq	%ebx, %rax
	movq	throttles(%rip), %rcx
	leaq	(%rax,%rax,2), %r12
	salq	$4, %r12
	addq	%r12, %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L83
	leaq	32(%rcx), %rdi
	movq	24(%rcx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	addq	%rax, %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L84
	movq	32(%rcx), %rdx
	leaq	8(%rcx), %rdi
	movq	$0, 32(%rcx)
	movq	%rdx, %rsi
	shrq	$63, %rsi
	addq	%rdx, %rsi
	sarq	%rsi
	addq	%rax, %rsi
	movq	%rsi, %rax
	sarq	$63, %rsi
	imulq	%rbp
	movq	%rdi, %rax
	shrq	$3, %rax
	subq	%rsi, %rdx
	cmpb	$0, 2147450880(%rax)
	movq	%rdx, %r8
	movq	%rdx, 24(%rcx)
	jne	.L85
	movq	8(%rcx), %r9
	cmpq	%r9, %rdx
	jle	.L11
	leaq	40(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L12
	cmpb	$3, %al
	jle	.L86
.L12:
	movl	40(%rcx), %eax
	testl	%eax, %eax
	jne	.L87
	addq	$16, %rcx
	movq	%rcx, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L19
	movq	%rcx, %rdi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L7:
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L6
	subl	$1, %eax
	movq	connects(%rip), %rdx
	movq	throttles(%rip), %r10
	leaq	(%rax,%rax,8), %rax
	movq	$-1, %rbx
	salq	$4, %rax
	leaq	64(%rdx), %rsi
	leaq	208(%rdx,%rax), %r11
	jmp	.L34
	.p2align 4,,10
	.p2align 3
.L25:
	addq	$144, %rsi
	cmpq	%r11, %rsi
	je	.L6
.L34:
	leaq	-64(%rsi), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L24
	cmpb	$3, %al
	jle	.L88
.L24:
	movl	-64(%rsi), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L25
	movq	%rsi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L89
	leaq	-8(%rsi), %rdi
	movq	%rbx, (%rsi)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L27
	cmpb	$3, %al
	jle	.L90
.L27:
	movl	-8(%rsi), %eax
	testl	%eax, %eax
	jle	.L25
	subl	$1, %eax
	leaq	-48(%rsi), %r8
	movq	%rbx, %rbp
	leaq	-44(%rsi,%rax,4), %r9
	jmp	.L33
	.p2align 4,,10
	.p2align 3
.L28:
	movslq	(%r8), %rax
	leaq	(%rax,%rax,2), %rcx
	salq	$4, %rcx
	addq	%r10, %rcx
	leaq	8(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L91
	leaq	40(%rcx), %rdi
	movq	8(%rcx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L30
	cmpb	$3, %dl
	jle	.L92
.L30:
	movslq	40(%rcx), %rcx
	cqto
	idivq	%rcx
	cmpq	$-1, %rbp
	je	.L77
	cmpq	%rbp, %rax
	cmovg	%rbp, %rax
.L77:
	addq	$4, %r8
	movq	%rax, (%rsi)
	cmpq	%r9, %r8
	je	.L25
	movq	(%rsi), %rbp
.L33:
	movq	%r8, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%r8, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L28
	testb	%dl, %dl
	je	.L28
	movq	%r8, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L6:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L82:
	.cfi_restore_state
	movq	%rcx, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L93
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movq	(%rcx), %rcx
	movl	%ebx, %edx
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	$.LC3, %esi
	xorl	%eax, %eax
	movl	$5, %edi
	call	syslog
	popq	%rax
	.cfi_def_cfa_offset 40
	popq	%rdx
	.cfi_def_cfa_offset 32
	jmp	.L19
	.p2align 4,,10
	.p2align 3
.L15:
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movl	$.LC2, %esi
	movl	$6, %edi
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	%ebx, %edx
	xorl	%eax, %eax
	call	syslog
	movq	throttles(%rip), %rcx
	popq	%rsi
	.cfi_def_cfa_offset 40
	popq	%r8
	.cfi_def_cfa_offset 32
	addq	%r12, %rcx
	leaq	24(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L17
	call	__asan_report_load8
.L88:
	call	__asan_report_load4
.L90:
	call	__asan_report_load4
.L89:
	movq	%rsi, %rdi
	call	__asan_report_store8
.L81:
	call	__asan_report_load4
.L80:
	call	__asan_report_load8
.L79:
	call	__asan_report_load8
.L78:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L86:
	call	__asan_report_load4
.L85:
	call	__asan_report_load8
.L84:
	call	__asan_report_load8
.L83:
	call	__asan_report_load8
.L93:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L92:
	call	__asan_report_load4
.L91:
	call	__asan_report_load8
	.cfi_endproc
.LFE25:
	.size	update_throttles, .-update_throttles
	.section	.rodata
	.align 32
.LC4:
	.string	"%s: no value required for %s option\n"
	.zero	59
	.text
	.p2align 4,,15
	.type	no_value_required, @function
no_value_required:
.LASANPC14:
.LFB14:
	.cfi_startproc
	testq	%rsi, %rsi
	jne	.L100
	rep ret
.L100:
	movl	$stderr, %eax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	shrq	$3, %rax
	movq	argv0(%rip), %rdx
	cmpb	$0, 2147450880(%rax)
	jne	.L101
	movq	stderr(%rip), %rdi
	movl	$.LC4, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L101:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE14:
	.size	no_value_required, .-no_value_required
	.section	.rodata
	.align 32
.LC5:
	.string	"%s: value required for %s option\n"
	.zero	62
	.text
	.p2align 4,,15
	.type	value_required, @function
value_required:
.LASANPC13:
.LFB13:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.L108
	rep ret
.L108:
	movl	$stderr, %eax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	shrq	$3, %rax
	movq	argv0(%rip), %rdx
	cmpb	$0, 2147450880(%rax)
	jne	.L109
	movq	stderr(%rip), %rdi
	movl	$.LC5, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L109:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE13:
	.size	value_required, .-value_required
	.section	.rodata
	.align 32
.LC6:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor]
	[-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat]
	[-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset]
	[-P P3P] [-M maxage] [-V] [-D]\n"
	.zero	37
	.section	.text.unlikely,"ax",@progbits
	.type	usage, @function
usage:
.LASANPC11:
.LFB11:
	.cfi_startproc
	movl	$stderr, %eax
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L111
	movl	$stderr, %edi
	call	__asan_report_load8
.L111:
	movq	stderr(%rip), %rdi
	movl	$.LC6, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE11:
	.size	usage, .-usage
	.text
	.p2align 4,,15
	.type	wakeup_connection, @function
wakeup_connection:
.LASANPC30:
.LFB30:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, 8(%rsp)
	leaq	8(%rsp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L133
	movq	8(%rsp), %rsi
	leaq	96(%rsi), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L134
	movq	%rsi, %rax
	movq	$0, 96(%rsi)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L116
	cmpb	$3, %al
	jle	.L135
.L116:
	cmpl	$3, (%rsi)
	je	.L136
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L136:
	.cfi_restore_state
	leaq	8(%rsi), %rdi
	movl	$2, (%rsi)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L137
	movq	8(%rsi), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L119
	cmpb	$3, %dl
	jle	.L138
.L119:
	movl	704(%rax), %edi
	movl	$1, %edx
	call	fdwatch_add_fd
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L135:
	.cfi_restore_state
	movq	%rsi, %rdi
	call	__asan_report_load4
.L138:
	call	__asan_report_load4
.L134:
	call	__asan_report_store8
.L133:
	call	__asan_report_load8
.L137:
	call	__asan_report_load8
	.cfi_endproc
.LFE30:
	.size	wakeup_connection, .-wakeup_connection
	.globl	__asan_stack_malloc_1
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC7:
	.string	"1 32 16 2 tv "
	.section	.rodata
	.align 32
.LC8:
	.string	"up %ld seconds, stats for %ld seconds:"
	.zero	57
	.text
	.p2align 4,,15
	.type	logstats, @function
logstats:
.LASANPC34:
.LFB34:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	subq	$104, %rsp
	.cfi_def_cfa_offset 144
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsp, %rbp
	movq	%rbp, %r13
	testl	%eax, %eax
	jne	.L147
.L139:
	movq	%rbp, %r12
	movq	$1102416563, 0(%rbp)
	movq	$.LC7, 8(%rbp)
	shrq	$3, %r12
	testq	%rbx, %rbx
	movq	$.LASANPC34, 16(%rbp)
	movl	$-235802127, 2147450880(%r12)
	movl	$-219021312, 2147450884(%r12)
	movl	$-202116109, 2147450888(%r12)
	je	.L148
.L143:
	movq	%rbx, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L149
	movq	(%rbx), %rax
	movl	$1, %ecx
	movl	$.LC8, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	movq	%rax, %rbx
	subq	start_time(%rip), %rdx
	subq	stats_time(%rip), %rbx
	movq	%rax, stats_time(%rip)
	cmove	%rcx, %rbx
	xorl	%eax, %eax
	movq	%rbx, %rcx
	call	syslog
	movq	%rbx, %rdi
	call	thttpd_logstats
	movq	%rbx, %rdi
	call	httpd_logstats
	movq	%rbx, %rdi
	call	mmc_logstats
	movq	%rbx, %rdi
	call	fdwatch_logstats
	movq	%rbx, %rdi
	call	tmr_logstats
	cmpq	%rbp, %r13
	jne	.L150
	movq	$0, 2147450880(%r12)
	movl	$0, 2147450888(%r12)
.L141:
	addq	$104, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L148:
	.cfi_restore_state
	leaq	32(%rbp), %rbx
	xorl	%esi, %esi
	movq	%rbx, %rdi
	call	gettimeofday
	jmp	.L143
.L150:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, 0(%rbp)
	movl	$-168430091, 2147450888(%r12)
	movq	%rax, 2147450880(%r12)
	jmp	.L141
.L147:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L139
.L149:
	movq	%rbx, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE34:
	.size	logstats, .-logstats
	.p2align 4,,15
	.type	show_stats, @function
show_stats:
.LASANPC33:
.LFB33:
	.cfi_startproc
	movq	%rsi, %rdi
	jmp	logstats
	.cfi_endproc
.LFE33:
	.size	show_stats, .-show_stats
	.p2align 4,,15
	.type	handle_usr2, @function
handle_usr2:
.LASANPC6:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movq	%rax, %rbx
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L153
	testb	%dl, %dl
	jne	.L168
.L153:
	xorl	%edi, %edi
	movl	(%rbx), %ebp
	call	logstats
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L154
	testb	%dl, %dl
	jne	.L169
.L154:
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L169:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	__asan_report_store4
.L168:
	movq	%rbx, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE6:
	.size	handle_usr2, .-handle_usr2
	.p2align 4,,15
	.type	occasional, @function
occasional:
.LASANPC32:
.LFB32:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rsi, %rdi
	call	mmc_cleanup
	call	tmr_cleanup
	movl	$1, watchdog_flag(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE32:
	.size	occasional, .-occasional
	.section	.rodata
	.align 32
.LC9:
	.string	"/tmp"
	.zero	59
	.text
	.p2align 4,,15
	.type	handle_alrm, @function
handle_alrm:
.LASANPC7:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movq	%rax, %rbx
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L173
	testb	%dl, %dl
	jne	.L189
.L173:
	movl	watchdog_flag(%rip), %eax
	movl	(%rbx), %ebp
	testl	%eax, %eax
	je	.L190
	movl	$360, %edi
	movl	$0, watchdog_flag(%rip)
	call	alarm
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rbx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L175
	testb	%dl, %dl
	jne	.L191
.L175:
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L191:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	__asan_report_store4
.L189:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L190:
	movl	$.LC9, %edi
	call	chdir
	call	__asan_handle_no_return
	call	abort
	.cfi_endproc
.LFE7:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata.str1.1
.LC10:
	.string	"1 32 4 6 status "
	.section	.rodata
	.align 32
.LC11:
	.string	"child wait - %m"
	.zero	48
	.text
	.p2align 4,,15
	.type	handle_chld, @function
handle_chld:
.LASANPC3:
.LFB3:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %rbx
	testl	%eax, %eax
	jne	.L241
.L192:
	movq	%rbx, %rbp
	movq	$1102416563, (%rbx)
	movq	$.LC10, 8(%rbx)
	shrq	$3, %rbp
	movq	$.LASANPC3, 16(%rbx)
	leaq	96(%rbx), %r12
	movl	$-235802127, 2147450880(%rbp)
	movl	$-218959356, 2147450884(%rbp)
	movl	$-202116109, 2147450888(%rbp)
	call	__errno_location
	movq	%rax, %r14
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%r14, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L196
	testb	%dl, %dl
	jne	.L242
.L196:
	movq	%r14, %rax
	movl	(%r14), %r15d
	subq	$64, %r12
	shrq	$3, %rax
	xorl	%r13d, %r13d
	movq	%rax, (%rsp)
	movq	%r14, %rax
	andl	$7, %eax
	addl	$3, %eax
	movb	%al, 15(%rsp)
.L197:
	movl	$1, %edx
	movq	%r12, %rsi
	movl	$-1, %edi
	call	waitpid
	testl	%eax, %eax
	je	.L202
	js	.L243
	movq	hs(%rip), %rdx
	testq	%rdx, %rdx
	je	.L197
	leaq	36(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %esi
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%sil, %al
	jl	.L203
	testb	%sil, %sil
	jne	.L244
.L203:
	movl	36(%rdx), %eax
	subl	$1, %eax
	cmovs	%r13d, %eax
	movl	%eax, 36(%rdx)
	jmp	.L197
	.p2align 4,,10
	.p2align 3
.L243:
	movq	(%rsp), %rax
	movzbl	2147450880(%rax), %eax
	cmpb	%al, 15(%rsp)
	jl	.L200
	testb	%al, %al
	jne	.L245
.L200:
	movl	(%r14), %eax
	cmpl	$4, %eax
	je	.L197
	cmpl	$11, %eax
	je	.L197
	cmpl	$10, %eax
	jne	.L246
.L202:
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%r14, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L206
	testb	%dl, %dl
	jne	.L247
.L206:
	leaq	16(%rsp), %rax
	movl	%r15d, (%r14)
	cmpq	%rbx, %rax
	jne	.L248
	movq	$0, 2147450880(%rbp)
	movl	$0, 2147450888(%rbp)
.L194:
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L246:
	.cfi_restore_state
	movl	$.LC11, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L202
.L241:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L192
.L248:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, (%rbx)
	movl	$-168430091, 2147450888(%rbp)
	movq	%rax, 2147450880(%rbp)
	jmp	.L194
.L247:
	movq	%r14, %rdi
	call	__asan_report_store4
.L244:
	call	__asan_report_load4
.L245:
	movq	%r14, %rdi
	call	__asan_report_load4
.L242:
	movq	%r14, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE3:
	.size	handle_chld, .-handle_chld
	.section	.rodata
	.align 32
.LC12:
	.string	"out of memory copying a string"
	.zero	33
	.align 32
.LC13:
	.string	"%s: out of memory copying a string\n"
	.zero	60
	.text
	.p2align 4,,15
	.type	e_strdup, @function
e_strdup:
.LASANPC15:
.LFB15:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	strdup
	testq	%rax, %rax
	je	.L253
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L253:
	.cfi_restore_state
	movl	$.LC12, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L254
	movq	stderr(%rip), %rdi
	movl	$.LC13, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L254:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE15:
	.size	e_strdup, .-e_strdup
	.globl	__asan_stack_malloc_2
	.section	.rodata.str1.1
.LC14:
	.string	"1 32 100 4 line "
	.section	.rodata
	.align 32
.LC15:
	.string	"r"
	.zero	62
	.align 32
.LC16:
	.string	" \t\n\r"
	.zero	59
	.align 32
.LC17:
	.string	"debug"
	.zero	58
	.align 32
.LC18:
	.string	"port"
	.zero	59
	.align 32
.LC19:
	.string	"dir"
	.zero	60
	.align 32
.LC20:
	.string	"chroot"
	.zero	57
	.align 32
.LC21:
	.string	"nochroot"
	.zero	55
	.align 32
.LC22:
	.string	"data_dir"
	.zero	55
	.align 32
.LC23:
	.string	"symlink"
	.zero	56
	.align 32
.LC24:
	.string	"nosymlink"
	.zero	54
	.align 32
.LC25:
	.string	"symlinks"
	.zero	55
	.align 32
.LC26:
	.string	"nosymlinks"
	.zero	53
	.align 32
.LC27:
	.string	"user"
	.zero	59
	.align 32
.LC28:
	.string	"cgipat"
	.zero	57
	.align 32
.LC29:
	.string	"cgilimit"
	.zero	55
	.align 32
.LC30:
	.string	"urlpat"
	.zero	57
	.align 32
.LC31:
	.string	"noemptyreferers"
	.zero	48
	.align 32
.LC32:
	.string	"localpat"
	.zero	55
	.align 32
.LC33:
	.string	"throttles"
	.zero	54
	.align 32
.LC34:
	.string	"host"
	.zero	59
	.align 32
.LC35:
	.string	"logfile"
	.zero	56
	.align 32
.LC36:
	.string	"vhost"
	.zero	58
	.align 32
.LC37:
	.string	"novhost"
	.zero	56
	.align 32
.LC38:
	.string	"globalpasswd"
	.zero	51
	.align 32
.LC39:
	.string	"noglobalpasswd"
	.zero	49
	.align 32
.LC40:
	.string	"pidfile"
	.zero	56
	.align 32
.LC41:
	.string	"charset"
	.zero	56
	.align 32
.LC42:
	.string	"p3p"
	.zero	60
	.align 32
.LC43:
	.string	"max_age"
	.zero	56
	.align 32
.LC44:
	.string	"%s: unknown config option '%s'\n"
	.zero	32
	.text
	.p2align 4,,15
	.type	read_config, @function
read_config:
.LASANPC12:
.LFB12:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$216, %rsp
	.cfi_def_cfa_offset 272
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	leaq	16(%rsp), %r13
	testl	%eax, %eax
	jne	.L359
.L255:
	movq	%r13, %rax
	movq	$1102416563, 0(%r13)
	movq	$.LC14, 8(%r13)
	shrq	$3, %rax
	movq	$.LASANPC12, 16(%r13)
	movl	$.LC15, %esi
	movq	%rax, 8(%rsp)
	movq	%rbx, %rdi
	movl	$-235802127, 2147450880(%rax)
	movl	$-218959356, 2147450896(%rax)
	movl	$-202116109, 2147450900(%rax)
	call	fopen
	testq	%rax, %rax
	movq	%rax, (%rsp)
	je	.L355
	leaq	32(%r13), %r12
	movabsq	$4294977024, %r14
.L259:
	movq	(%rsp), %rdx
	movl	$1000, %esi
	movq	%r12, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L360
	movl	$35, %esi
	movq	%r12, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L260
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	cmpb	%cl, %dl
	jg	.L261
	testb	%dl, %dl
	jne	.L361
.L261:
	movb	$0, (%rax)
.L260:
	movl	$.LC16, %esi
	movq	%r12, %rdi
	call	strspn
	leaq	(%r12,%rax), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L262
	testb	%al, %al
	jne	.L362
	.p2align 4,,10
	.p2align 3
.L262:
	cmpb	$0, (%rbx)
	je	.L259
	movl	$.LC16, %esi
	movq	%rbx, %rdi
	call	strcspn
	addq	%rbx, %rax
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	cmpb	%cl, %dl
	jg	.L264
	testb	%dl, %dl
	jne	.L363
.L264:
	movzbl	(%rax), %edx
	cmpb	$32, %dl
	jbe	.L364
.L304:
	movq	%rax, %r15
	.p2align 4,,10
	.p2align 3
.L265:
	movl	$61, %esi
	movq	%rbx, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L305
	movq	%rax, %rcx
	movq	%rax, %rsi
	leaq	1(%rax), %rbp
	shrq	$3, %rcx
	andl	$7, %esi
	movzbl	2147450880(%rcx), %ecx
	cmpb	%sil, %cl
	jg	.L270
	testb	%cl, %cl
	jne	.L365
.L270:
	movb	$0, (%rax)
.L269:
	movl	$.LC17, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L366
	movl	$.LC18, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L367
	movl	$.LC19, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L368
	movl	$.LC20, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L369
	movl	$.LC21, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L370
	movl	$.LC22, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L371
	movl	$.LC23, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L357
	movl	$.LC24, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L358
	movl	$.LC25, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L357
	movl	$.LC26, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L358
	movl	$.LC27, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L372
	movl	$.LC28, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L373
	movl	$.LC29, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L374
	movl	$.LC30, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L375
	movl	$.LC31, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L376
	movl	$.LC32, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L377
	movl	$.LC33, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L378
	movl	$.LC34, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L379
	movl	$.LC35, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L380
	movl	$.LC36, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L381
	movl	$.LC37, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L382
	movl	$.LC38, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L383
	movl	$.LC39, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L384
	movl	$.LC40, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L385
	movl	$.LC41, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L386
	movl	$.LC42, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L387
	movl	$.LC43, %esi
	movq	%rbx, %rdi
	call	strcasecmp
	testl	%eax, %eax
	jne	.L298
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L272
	.p2align 4,,10
	.p2align 3
.L364:
	btq	%rdx, %r14
	jc	.L268
	jmp	.L304
	.p2align 4,,10
	.p2align 3
.L266:
	movq	%r15, %rax
	movb	$0, -1(%r15)
	movq	%r15, %rcx
	shrq	$3, %rax
	andl	$7, %ecx
	movzbl	2147450880(%rax), %eax
	cmpb	%cl, %al
	jg	.L267
	testb	%al, %al
	jne	.L388
.L267:
	movzbl	(%r15), %ecx
	cmpb	$32, %cl
	ja	.L265
	btq	%rcx, %r14
	movq	%r15, %rax
	jnc	.L265
.L268:
	movq	%rax, %rcx
	movq	%rax, %rsi
	leaq	1(%rax), %r15
	shrq	$3, %rcx
	andl	$7, %esi
	movzbl	2147450880(%rcx), %ecx
	cmpb	%sil, %cl
	jg	.L266
	testb	%cl, %cl
	je	.L266
	movq	%rax, %rdi
	call	__asan_report_store1
	.p2align 4,,10
	.p2align 3
.L366:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, debug(%rip)
.L272:
	movl	$.LC16, %esi
	movq	%r15, %rdi
	call	strspn
	leaq	(%r15,%rax), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L262
	testb	%al, %al
	je	.L262
	movq	%rbx, %rdi
	call	__asan_report_load1
	.p2align 4,,10
	.p2align 3
.L305:
	xorl	%ebp, %ebp
	jmp	.L269
	.p2align 4,,10
	.p2align 3
.L367:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	atoi
	movw	%ax, port(%rip)
	jmp	.L272
.L368:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, dir(%rip)
	jmp	.L272
.L369:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L272
.L370:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L272
.L371:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, data_dir(%rip)
	jmp	.L272
.L357:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, no_symlink_check(%rip)
	jmp	.L272
.L358:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, no_symlink_check(%rip)
	jmp	.L272
.L360:
	movq	(%rsp), %rdi
	call	fclose
	leaq	16(%rsp), %rax
	cmpq	%r13, %rax
	jne	.L389
	movq	8(%rsp), %rax
	pxor	%xmm0, %xmm0
	movups	%xmm0, 2147450880(%rax)
	movq	$0, 2147450896(%rax)
.L257:
	addq	$216, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L372:
	.cfi_restore_state
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, user(%rip)
	jmp	.L272
.L373:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, cgi_pattern(%rip)
	jmp	.L272
.L376:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, no_empty_referers(%rip)
	jmp	.L272
.L375:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, url_pattern(%rip)
	jmp	.L272
.L374:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	atoi
	movl	%eax, cgi_limit(%rip)
	jmp	.L272
.L380:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, logfile(%rip)
	jmp	.L272
.L298:
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L390
	movq	stderr(%rip), %rdi
	movq	%rbx, %rcx
	movl	$.LC44, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L387:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, p3p(%rip)
	jmp	.L272
.L390:
	movl	$stderr, %edi
	call	__asan_report_load8
.L386:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, charset(%rip)
	jmp	.L272
.L385:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, pidfile(%rip)
	jmp	.L272
.L384:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, do_global_passwd(%rip)
	jmp	.L272
.L383:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, do_global_passwd(%rip)
	jmp	.L272
.L382:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$0, do_vhost(%rip)
	jmp	.L272
.L381:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	no_value_required
	movl	$1, do_vhost(%rip)
	jmp	.L272
.L379:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, hostname(%rip)
	jmp	.L272
.L378:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, throttlefile(%rip)
	jmp	.L272
.L377:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	value_required
	movq	%rbp, %rdi
	call	e_strdup
	movq	%rax, local_pattern(%rip)
	jmp	.L272
.L365:
	movq	%rax, %rdi
	call	__asan_report_store1
.L363:
	movq	%rax, %rdi
	call	__asan_report_load1
.L362:
	movq	%rbx, %rdi
	call	__asan_report_load1
.L361:
	movq	%rax, %rdi
	call	__asan_report_store1
.L355:
	movq	%rbx, %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L359:
	movl	$192, %edi
	call	__asan_stack_malloc_2
	testq	%rax, %rax
	cmovne	%rax, %r13
	jmp	.L255
.L389:
	movq	$1172321806, 0(%r13)
	movq	8(%rsp), %rax
	movabsq	$-723401728380766731, %rdi
	movdqa	.LC45(%rip), %xmm0
	movq	%rdi, 2147450896(%rax)
	movups	%xmm0, 2147450880(%rax)
	jmp	.L257
.L388:
	movq	%r15, %rdi
	call	__asan_report_load1
	.cfi_endproc
.LFE12:
	.size	read_config, .-read_config
	.section	.rodata
	.align 32
.LC46:
	.string	"nobody"
	.zero	57
	.align 32
.LC47:
	.string	"iso-8859-1"
	.zero	53
	.align 32
.LC48:
	.string	""
	.zero	63
	.align 32
.LC49:
	.string	"-V"
	.zero	61
	.align 32
.LC50:
	.string	"thttpd/2.27.0 Oct 3, 2014"
	.zero	38
	.align 32
.LC51:
	.string	"-C"
	.zero	61
	.align 32
.LC52:
	.string	"-p"
	.zero	61
	.align 32
.LC53:
	.string	"-d"
	.zero	61
	.align 32
.LC54:
	.string	"-r"
	.zero	61
	.align 32
.LC55:
	.string	"-nor"
	.zero	59
	.align 32
.LC56:
	.string	"-dd"
	.zero	60
	.align 32
.LC57:
	.string	"-s"
	.zero	61
	.align 32
.LC58:
	.string	"-nos"
	.zero	59
	.align 32
.LC59:
	.string	"-u"
	.zero	61
	.align 32
.LC60:
	.string	"-c"
	.zero	61
	.align 32
.LC61:
	.string	"-t"
	.zero	61
	.align 32
.LC62:
	.string	"-h"
	.zero	61
	.align 32
.LC63:
	.string	"-l"
	.zero	61
	.align 32
.LC64:
	.string	"-v"
	.zero	61
	.align 32
.LC65:
	.string	"-nov"
	.zero	59
	.align 32
.LC66:
	.string	"-g"
	.zero	61
	.align 32
.LC67:
	.string	"-nog"
	.zero	59
	.align 32
.LC68:
	.string	"-i"
	.zero	61
	.align 32
.LC69:
	.string	"-T"
	.zero	61
	.align 32
.LC70:
	.string	"-P"
	.zero	61
	.align 32
.LC71:
	.string	"-M"
	.zero	61
	.align 32
.LC72:
	.string	"-D"
	.zero	61
	.text
	.p2align 4,,15
	.type	parse_args, @function
parse_args:
.LASANPC10:
.LFB10:
	.cfi_startproc
	movl	$80, %eax
	cmpl	$1, %edi
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	movl	$0, debug(%rip)
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movw	%ax, port(%rip)
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movl	%edi, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	$0, dir(%rip)
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	$0, data_dir(%rip)
	movl	$0, do_chroot(%rip)
	movl	$0, no_log(%rip)
	movl	$0, no_symlink_check(%rip)
	movl	$0, do_vhost(%rip)
	movl	$0, do_global_passwd(%rip)
	movq	$0, cgi_pattern(%rip)
	movl	$0, cgi_limit(%rip)
	movq	$0, url_pattern(%rip)
	movl	$0, no_empty_referers(%rip)
	movq	$0, local_pattern(%rip)
	movq	$0, throttlefile(%rip)
	movq	$0, hostname(%rip)
	movq	$0, logfile(%rip)
	movq	$0, pidfile(%rip)
	movq	$.LC46, user(%rip)
	movq	$.LC47, charset(%rip)
	movq	$.LC48, p3p(%rip)
	movl	$-1, max_age(%rip)
	jle	.L440
	leaq	8(%rsi), %rdi
	movq	%rsi, %r13
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L465
	movq	8(%rsi), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L394
	testb	%al, %al
	jne	.L466
.L394:
	cmpb	$45, (%rbx)
	jne	.L435
	movl	$1, %ebp
	jmp	.L438
	.p2align 4,,10
	.p2align 3
.L472:
	leal	1(%rbp), %r14d
	cmpl	%r12d, %r14d
	jl	.L467
	movl	$.LC52, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L402
.L401:
	movl	$.LC53, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L402
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L402
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L468
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, dir(%rip)
	.p2align 4,,10
	.p2align 3
.L400:
	addl	$1, %ebp
	cmpl	%ebp, %r12d
	jle	.L392
.L474:
	movslq	%ebp, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L469
	movq	(%rdi), %rbx
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L437
	testb	%al, %al
	jne	.L470
.L437:
	cmpb	$45, (%rbx)
	jne	.L435
.L438:
	movl	$.LC49, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L471
	movl	$.LC51, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L472
	movl	$.LC52, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L401
	leal	1(%rbp), %r14d
	cmpl	%r12d, %r14d
	jge	.L402
	movslq	%r14d, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L473
	movq	(%rdi), %rdi
	movl	%r14d, %ebp
	addl	$1, %ebp
	call	atoi
	cmpl	%ebp, %r12d
	movw	%ax, port(%rip)
	jg	.L474
.L392:
	cmpl	%ebp, %r12d
	jne	.L435
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L402:
	.cfi_restore_state
	movl	$.LC54, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L405
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L400
	.p2align 4,,10
	.p2align 3
.L405:
	movl	$.LC55, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L406
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L400
	.p2align 4,,10
	.p2align 3
.L467:
	movslq	%r14d, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L475
	movq	(%rdi), %rdi
	movl	%r14d, %ebp
	call	read_config
	jmp	.L400
	.p2align 4,,10
	.p2align 3
.L406:
	movl	$.LC56, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L407
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L407
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L476
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, data_dir(%rip)
	jmp	.L400
	.p2align 4,,10
	.p2align 3
.L407:
	movl	$.LC57, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L409
	movl	$0, no_symlink_check(%rip)
	jmp	.L400
.L409:
	movl	$.LC58, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L477
	movl	$.LC59, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L411
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L411
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L478
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, user(%rip)
	jmp	.L400
.L471:
	movl	$.LC50, %edi
	call	puts
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
.L477:
	movl	$1, no_symlink_check(%rip)
	jmp	.L400
.L411:
	movl	$.LC60, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L413
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L413
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L479
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, cgi_pattern(%rip)
	jmp	.L400
.L413:
	movl	$.LC61, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L415
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jl	.L480
	movl	$.LC62, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L418
.L419:
	movl	$.LC64, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L422
	movl	$1, do_vhost(%rip)
	jmp	.L400
.L415:
	movl	$.LC62, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L481
.L418:
	movl	$.LC63, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L419
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L419
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L482
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, logfile(%rip)
	jmp	.L400
.L480:
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L483
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, throttlefile(%rip)
	jmp	.L400
.L481:
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L419
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L484
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, hostname(%rip)
	jmp	.L400
.L440:
	movl	$1, %ebp
	jmp	.L392
.L422:
	movl	$.LC65, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L423
	movl	$0, do_vhost(%rip)
	jmp	.L400
.L423:
	movl	$.LC66, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L424
	movl	$1, do_global_passwd(%rip)
	jmp	.L400
.L424:
	movl	$.LC67, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L425
	movl	$0, do_global_passwd(%rip)
	jmp	.L400
.L425:
	movl	$.LC68, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L426
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L427
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L485
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, pidfile(%rip)
	jmp	.L400
.L426:
	movl	$.LC69, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L429
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L427
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L486
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, charset(%rip)
	jmp	.L400
.L427:
	movl	$.LC70, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L432
.L431:
	movl	$.LC71, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L432
	leal	1(%rbp), %r14d
	cmpl	%r12d, %r14d
	jge	.L432
	movslq	%r14d, %rax
	leaq	0(%r13,%rax,8), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L487
	movq	(%rdi), %rdi
	movl	%r14d, %ebp
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L400
.L429:
	movl	$.LC70, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L431
	leal	1(%rbp), %eax
	cmpl	%r12d, %eax
	jge	.L432
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L488
	movq	(%rdi), %rdx
	movl	%eax, %ebp
	movq	%rdx, p3p(%rip)
	jmp	.L400
.L432:
	movl	$.LC72, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L435
	movl	$1, debug(%rip)
	jmp	.L400
.L485:
	call	__asan_report_load8
.L486:
	call	__asan_report_load8
.L435:
	call	__asan_handle_no_return
	call	usage
.L473:
	call	__asan_report_load8
.L470:
	movq	%rbx, %rdi
	call	__asan_report_load1
.L476:
	call	__asan_report_load8
.L468:
	call	__asan_report_load8
.L475:
	call	__asan_report_load8
.L469:
	call	__asan_report_load8
.L483:
	call	__asan_report_load8
.L466:
	movq	%rbx, %rdi
	call	__asan_report_load1
.L465:
	call	__asan_report_load8
.L479:
	call	__asan_report_load8
.L484:
	call	__asan_report_load8
.L482:
	call	__asan_report_load8
.L478:
	call	__asan_report_load8
.L487:
	call	__asan_report_load8
.L488:
	call	__asan_report_load8
	.cfi_endproc
.LFE10:
	.size	parse_args, .-parse_args
	.globl	__asan_stack_malloc_8
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC73:
	.string	"5 32 8 9 max_limit 96 8 9 min_limit 160 16 2 tv 224 5000 3 buf 5280 5000 7 pattern "
	.globl	__asan_stack_free_8
	.section	.rodata
	.align 32
.LC74:
	.string	"%.80s - %m"
	.zero	53
	.align 32
.LC75:
	.string	" %4900[^ \t] %ld-%ld"
	.zero	44
	.align 32
.LC76:
	.string	" %4900[^ \t] %ld"
	.zero	48
	.align 32
.LC77:
	.string	"unparsable line in %.80s - %.80s"
	.zero	63
	.align 32
.LC78:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.zero	58
	.align 32
.LC79:
	.string	"|/"
	.zero	61
	.align 32
.LC80:
	.string	"out of memory allocating a throttletab"
	.zero	57
	.align 32
.LC81:
	.string	"%s: out of memory allocating a throttletab\n"
	.zero	52
	.text
	.p2align 4,,15
	.type	read_throttlefile, @function
read_throttlefile:
.LASANPC17:
.LFB17:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$10392, %rsp
	.cfi_def_cfa_offset 10448
	leaq	48(%rsp), %rax
	movq	%rdi, 24(%rsp)
	movq	%rax, 40(%rsp)
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	testl	%eax, %eax
	jne	.L578
.L489:
	movq	40(%rsp), %rax
	movl	$.LC15, %esi
	movq	$1102416563, (%rax)
	movq	$.LC73, 8(%rax)
	movq	%rax, %r14
	movq	$.LASANPC17, 16(%rax)
	movq	24(%rsp), %rdi
	shrq	$3, %r14
	movl	$-235802127, 2147450880(%r14)
	movl	$-218959360, 2147450884(%r14)
	leaq	10336(%rax), %rbx
	movl	$-218959118, 2147450888(%r14)
	movl	$-218959360, 2147450892(%r14)
	movl	$-218959118, 2147450896(%r14)
	movl	$-219021312, 2147450900(%r14)
	movl	$-218959118, 2147450904(%r14)
	movl	$-218959360, 2147451532(%r14)
	movl	$-218959118, 2147451536(%r14)
	movl	$-218959360, 2147452164(%r14)
	movl	$-202116109, 2147452168(%r14)
	call	fopen
	testq	%rax, %rax
	movq	%rax, 8(%rsp)
	je	.L579
	movq	40(%rsp), %r15
	xorl	%esi, %esi
	movabsq	$4294977024, %rbp
	leaq	160(%r15), %rdi
	leaq	5280(%r15), %r13
	leaq	224(%r15), %r12
	call	gettimeofday
	leaq	32(%r15), %rsi
	movq	%r13, %rax
	shrq	$3, %rax
	movq	%rsi, (%rsp)
	movq	%rax, 32(%rsp)
	.p2align 4,,10
	.p2align 3
.L527:
	movq	8(%rsp), %rdx
	movl	$5000, %esi
	movq	%r12, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L580
	movl	$35, %esi
	movq	%r12, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L495
	movq	%rax, %rdx
	movq	%rax, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	cmpb	%cl, %dl
	jg	.L496
	testb	%dl, %dl
	jne	.L581
.L496:
	movb	$0, (%rax)
.L495:
	movq	%r12, %rdi
	call	strlen
	cmpl	$0, %eax
	movl	%eax, %esi
	jle	.L497
	subl	$1, %eax
	movslq	%eax, %rdx
	leaq	(%r12,%rdx), %rdi
	movq	%rdi, %rcx
	movq	%rdi, %r8
	shrq	$3, %rcx
	andl	$7, %r8d
	movzbl	2147450880(%rcx), %ecx
	cmpb	%r8b, %cl
	jg	.L498
	testb	%cl, %cl
	jne	.L582
.L498:
	movzbl	-10112(%rbx,%rdx), %ecx
	cmpb	$32, %cl
	jbe	.L583
	.p2align 4,,10
	.p2align 3
.L499:
	leaq	-10240(%rbx), %r15
	movq	(%rsp), %r8
	xorl	%eax, %eax
	movq	%r13, %rdx
	movl	$.LC75, %esi
	movq	%r12, %rdi
	movq	%r15, %rcx
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L504
	movq	(%rsp), %rcx
	xorl	%eax, %eax
	movq	%r13, %rdx
	movl	$.LC76, %esi
	movq	%r12, %rdi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L505
	movq	%r15, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L584
	movq	$0, -10240(%rbx)
.L504:
	movq	32(%rsp), %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L509
	testb	%al, %al
	jle	.L585
.L509:
	cmpb	$47, -5056(%rbx)
	jne	.L511
	jmp	.L586
	.p2align 4,,10
	.p2align 3
.L512:
	leaq	2(%rax), %rsi
	leaq	1(%rax), %rdi
	call	strcpy
.L511:
	movl	$.LC79, %esi
	movq	%r13, %rdi
	call	strstr
	testq	%rax, %rax
	jne	.L512
	movslq	numthrottles(%rip), %rdx
	movl	maxthrottles(%rip), %eax
	cmpl	%eax, %edx
	jl	.L513
	testl	%eax, %eax
	jne	.L514
	movl	$4800, %edi
	movl	$100, maxthrottles(%rip)
	call	malloc
	movq	%rax, throttles(%rip)
.L515:
	testq	%rax, %rax
	je	.L516
	movslq	numthrottles(%rip), %rdx
.L517:
	leaq	(%rdx,%rdx,2), %rdx
	movq	%r13, %rdi
	salq	$4, %rdx
	addq	%rax, %rdx
	movq	%rdx, 16(%rsp)
	call	e_strdup
	movq	16(%rsp), %rdx
	movq	%rdx, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L587
	movq	%rax, (%rdx)
	movslq	numthrottles(%rip), %rax
	movq	(%rsp), %rcx
	movq	%rax, %rdx
	leaq	(%rax,%rax,2), %rax
	shrq	$3, %rcx
	salq	$4, %rax
	addq	throttles(%rip), %rax
	cmpb	$0, 2147450880(%rcx)
	jne	.L588
	leaq	8(%rax), %rdi
	movq	-10304(%rbx), %rcx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L589
	movq	%rcx, 8(%rax)
	movq	%r15, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L590
	leaq	16(%rax), %rdi
	movq	-10240(%rbx), %rcx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L591
	leaq	24(%rax), %rdi
	movq	%rcx, 16(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L592
	leaq	32(%rax), %rdi
	movq	$0, 24(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L593
	leaq	40(%rax), %rdi
	movq	$0, 32(%rax)
	movq	%rdi, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	testb	%cl, %cl
	je	.L526
	cmpb	$3, %cl
	jle	.L594
.L526:
	movl	$0, 40(%rax)
	leal	1(%rdx), %eax
	movl	%eax, numthrottles(%rip)
	jmp	.L527
	.p2align 4,,10
	.p2align 3
.L583:
	btq	%rcx, %rbp
	jnc	.L499
	subl	$2, %esi
	leaq	(%r12,%rdx), %rdi
	movslq	%esi, %rsi
	subq	%rdx, %rsi
	jmp	.L503
	.p2align 4,,10
	.p2align 3
.L500:
	testl	%eax, %eax
	movb	$0, (%rdi)
	je	.L527
	leaq	(%rsi,%rdi), %rdx
	subl	$1, %eax
	movq	%rdx, %rcx
	movq	%rdx, %r8
	shrq	$3, %rcx
	andl	$7, %r8d
	movzbl	2147450880(%rcx), %ecx
	cmpb	%r8b, %cl
	jg	.L502
	testb	%cl, %cl
	jne	.L595
.L502:
	movslq	%eax, %rdx
	movzbl	-10112(%rbx,%rdx), %edx
	cmpb	$32, %dl
	ja	.L499
	subq	$1, %rdi
	btq	%rdx, %rbp
	jnc	.L499
.L503:
	movq	%rdi, %rdx
	movq	%rdi, %rcx
	shrq	$3, %rdx
	andl	$7, %ecx
	movzbl	2147450880(%rdx), %edx
	cmpb	%cl, %dl
	jg	.L500
	testb	%dl, %dl
	je	.L500
	call	__asan_report_store1
	.p2align 4,,10
	.p2align 3
.L505:
	movq	24(%rsp), %rdx
	xorl	%eax, %eax
	movq	%r12, %rcx
	movl	$.LC77, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L596
	movq	24(%rsp), %rcx
	movq	stderr(%rip), %rdi
	movq	%r12, %r8
	movl	$.LC78, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L527
	.p2align 4,,10
	.p2align 3
.L514:
	addl	%eax, %eax
	movq	throttles(%rip), %rdi
	movl	%eax, maxthrottles(%rip)
	cltq
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	call	realloc
	movq	%rax, throttles(%rip)
	jmp	.L515
	.p2align 4,,10
	.p2align 3
.L513:
	movq	throttles(%rip), %rax
	jmp	.L517
.L580:
	movq	8(%rsp), %rdi
	movq	%rax, %r15
	call	fclose
	leaq	48(%rsp), %rax
	cmpq	40(%rsp), %rax
	jne	.L597
	leaq	2147450888(%r14), %rdi
	leaq	2147450880(%r14), %rax
	movq	$0, 2147450880(%r14)
	movq	$0, 2147452164(%r14)
	andq	$-8, %rdi
	subq	%rdi, %rax
	addl	$1292, %eax
	shrl	$3, %eax
	movl	%eax, %ecx
	movq	%r15, %rax
	rep stosq
.L491:
	addq	$10392, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L497:
	.cfi_restore_state
	jne	.L499
	jmp	.L527
	.p2align 4,,10
	.p2align 3
.L586:
	leaq	1(%r13), %rsi
	movq	%r13, %rdi
	call	strcpy
	jmp	.L511
.L594:
	call	__asan_report_store4
.L593:
	call	__asan_report_store8
.L592:
	call	__asan_report_store8
.L591:
	call	__asan_report_store8
.L590:
	movq	%r15, %rdi
	call	__asan_report_load8
.L589:
	call	__asan_report_store8
.L588:
	movq	(%rsp), %rdi
	call	__asan_report_load8
.L587:
	movq	%rdx, %rdi
	call	__asan_report_store8
.L516:
	xorl	%eax, %eax
	movl	$.LC80, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L598
	movq	stderr(%rip), %rdi
	movl	$.LC81, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L585:
	movq	%r13, %rdi
	call	__asan_report_load1
.L598:
	movl	$stderr, %edi
	call	__asan_report_load8
.L584:
	movq	%r15, %rdi
	call	__asan_report_store8
.L582:
	call	__asan_report_load1
.L581:
	movq	%rax, %rdi
	call	__asan_report_store1
.L579:
	movq	24(%rsp), %rbx
	movl	$.LC74, %esi
	movl	$2, %edi
	movq	%rbx, %rdx
	call	syslog
	movq	%rbx, %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L578:
	movl	$10336, %edi
	call	__asan_stack_malloc_8
	testq	%rax, %rax
	cmove	40(%rsp), %rax
	movq	%rax, 40(%rsp)
	jmp	.L489
.L597:
	movq	40(%rsp), %rax
	leaq	48(%rsp), %rdx
	movl	$10336, %esi
	movq	%rax, %rdi
	movq	$1172321806, (%rax)
	call	__asan_stack_free_8
	jmp	.L491
.L596:
	movl	$stderr, %edi
	call	__asan_report_load8
.L595:
	movq	%rdx, %rdi
	call	__asan_report_load1
	.cfi_endproc
.LFE17:
	.size	read_throttlefile, .-read_throttlefile
	.section	.rodata
	.align 32
.LC82:
	.string	"-"
	.zero	62
	.align 32
.LC83:
	.string	"re-opening logfile"
	.zero	45
	.align 32
.LC84:
	.string	"a"
	.zero	62
	.align 32
.LC85:
	.string	"re-opening %.80s - %m"
	.zero	42
	.text
	.p2align 4,,15
	.type	re_open_logfile, @function
re_open_logfile:
.LASANPC8:
.LFB8:
	.cfi_startproc
	movl	no_log(%rip), %eax
	testl	%eax, %eax
	jne	.L611
	cmpq	$0, hs(%rip)
	je	.L611
	movq	logfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L611
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movl	$.LC82, %esi
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	strcmp
	testl	%eax, %eax
	jne	.L614
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L611:
	.cfi_restore 3
	.cfi_restore 6
	rep ret
	.p2align 4,,10
	.p2align 3
.L614:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -24
	.cfi_offset 6, -16
	xorl	%eax, %eax
	movl	$.LC83, %esi
	movl	$5, %edi
	call	syslog
	movq	logfile(%rip), %rdi
	movl	$.LC84, %esi
	call	fopen
	movq	logfile(%rip), %rbp
	movq	%rax, %rbx
	movl	$384, %esi
	movq	%rbp, %rdi
	call	chmod
	testq	%rbx, %rbx
	je	.L603
	testl	%eax, %eax
	jne	.L603
	movq	%rbx, %rdi
	call	fileno
	movl	$2, %esi
	movl	%eax, %edi
	movl	$1, %edx
	xorl	%eax, %eax
	call	fcntl
	movq	hs(%rip), %rdi
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbx, %rsi
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	jmp	httpd_set_logfp
	.p2align 4,,10
	.p2align 3
.L603:
	.cfi_restore_state
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%rbp, %rdx
	movl	$.LC85, %esi
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	movl	$2, %edi
	xorl	%eax, %eax
	jmp	syslog
	.cfi_endproc
.LFE8:
	.size	re_open_logfile, .-re_open_logfile
	.section	.rodata
	.align 32
.LC86:
	.string	"too many connections!"
	.zero	42
	.align 32
.LC87:
	.string	"the connects free list is messed up"
	.zero	60
	.align 32
.LC88:
	.string	"out of memory allocating an httpd_conn"
	.zero	57
	.text
	.p2align 4,,15
	.type	handle_newconnect, @function
handle_newconnect:
.LASANPC19:
.LFB19:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rdi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movl	%esi, %r12d
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %rbp
	shrq	$3, %r13
	subq	$16, %rsp
	.cfi_def_cfa_offset 64
	movl	num_connects(%rip), %eax
.L639:
	cmpl	%eax, max_connects(%rip)
	jle	.L690
	movslq	first_free_connect(%rip), %rax
	cmpl	$-1, %eax
	je	.L618
	leaq	(%rax,%rax,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L619
	cmpb	$3, %al
	jle	.L691
.L619:
	movl	(%rbx), %eax
	testl	%eax, %eax
	jne	.L618
	leaq	8(%rbx), %r14
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L692
	movq	8(%rbx), %rdx
	testq	%rdx, %rdx
	je	.L693
.L622:
	movq	hs(%rip), %rdi
	movl	%r12d, %esi
	call	httpd_get_conn
	testl	%eax, %eax
	je	.L626
	cmpl	$2, %eax
	je	.L641
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L627
	cmpb	$3, %al
	jle	.L694
.L627:
	leaq	4(%rbx), %rdi
	movl	$1, (%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L628
	testb	%dl, %dl
	jne	.L695
.L628:
	addl	$1, num_connects(%rip)
	cmpb	$0, 2147450880(%r13)
	movl	4(%rbx), %eax
	movl	$-1, 4(%rbx)
	movl	%eax, first_free_connect(%rip)
	jne	.L696
	leaq	88(%rbx), %rdi
	movq	0(%rbp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L697
	leaq	96(%rbx), %rdi
	movq	%rax, 88(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L698
	leaq	104(%rbx), %rdi
	movq	$0, 96(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L699
	leaq	136(%rbx), %rdi
	movq	$0, 104(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L700
	leaq	56(%rbx), %rdi
	movq	$0, 136(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L634
	cmpb	$3, %al
	jle	.L701
.L634:
	movq	%r14, %rax
	movl	$0, 56(%rbx)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L702
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L636
	cmpb	$3, %dl
	jle	.L703
.L636:
	movl	704(%rax), %edi
	call	httpd_set_ndelay
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L704
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L638
	cmpb	$3, %dl
	jle	.L705
.L638:
	movl	704(%rax), %edi
	xorl	%edx, %edx
	movq	%rbx, %rsi
	call	fdwatch_add_fd
	addq	$1, stats_connections(%rip)
	movl	num_connects(%rip), %eax
	cmpl	stats_simultaneous(%rip), %eax
	jle	.L639
	movl	%eax, stats_simultaneous(%rip)
	jmp	.L639
	.p2align 4,,10
	.p2align 3
.L641:
	movl	$1, %eax
.L615:
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L626:
	.cfi_restore_state
	movq	%rbp, %rdi
	movl	%eax, 12(%rsp)
	call	tmr_run
	movl	12(%rsp), %eax
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L693:
	.cfi_restore_state
	movl	$720, %edi
	call	malloc
	testq	%rax, %rax
	movq	%rax, %rdx
	movq	%rax, 8(%rbx)
	je	.L706
	movq	%rax, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	testb	%cl, %cl
	je	.L624
	cmpb	$3, %cl
	jle	.L707
.L624:
	movl	$0, (%rax)
	addl	$1, httpd_conn_count(%rip)
	jmp	.L622
	.p2align 4,,10
	.p2align 3
.L690:
	xorl	%eax, %eax
	movl	$.LC86, %esi
	movl	$4, %edi
	call	syslog
	movq	%rbp, %rdi
	call	tmr_run
	xorl	%eax, %eax
	jmp	.L615
.L618:
	movl	$2, %edi
	movl	$.LC87, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L706:
	movl	$2, %edi
	movl	$.LC88, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L707:
	movq	%rax, %rdi
	call	__asan_report_store4
.L696:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L697:
	call	__asan_report_store8
.L694:
	movq	%rbx, %rdi
	call	__asan_report_store4
.L695:
	call	__asan_report_load4
.L704:
	movq	%r14, %rdi
	call	__asan_report_load8
.L705:
	call	__asan_report_load4
.L698:
	call	__asan_report_store8
.L699:
	call	__asan_report_store8
.L700:
	call	__asan_report_store8
.L701:
	call	__asan_report_store4
.L702:
	movq	%r14, %rdi
	call	__asan_report_load8
.L703:
	call	__asan_report_load4
.L692:
	movq	%r14, %rdi
	call	__asan_report_load8
.L691:
	movq	%rbx, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE19:
	.size	handle_newconnect, .-handle_newconnect
	.section	.rodata
	.align 32
.LC89:
	.string	"throttle sending count was negative - shouldn't happen!"
	.zero	40
	.text
	.p2align 4,,15
	.type	check_throttles, @function
check_throttles:
.LASANPC23:
.LFB23:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	leaq	56(%rdi), %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	movq	%rbp, %rax
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L709
	cmpb	$3, %al
	jle	.L788
.L709:
	leaq	72(%rbx), %rax
	movl	$0, 56(%rbx)
	movq	%rax, (%rsp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L789
	leaq	64(%rbx), %r13
	movq	$-1, %rax
	movq	%rax, 72(%rbx)
	movq	%r13, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L790
	movq	%rax, 64(%rbx)
	movl	numthrottles(%rip), %eax
	testl	%eax, %eax
	jle	.L712
	leaq	8(%rbx), %rax
	xorl	%r14d, %r14d
	movq	%rax, %r12
	movq	%rax, 8(%rsp)
	shrq	$3, %r12
	jmp	.L736
	.p2align 4,,10
	.p2align 3
.L804:
	addl	$1, %ecx
	movslq	%ecx, %r11
.L723:
	movq	%rbp, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L727
	cmpb	$3, %dl
	jle	.L791
.L727:
	movslq	56(%rbx), %rdx
	leal	1(%rdx), %r8d
	leaq	16(%rbx,%rdx,4), %r10
	movl	%r8d, 56(%rbx)
	movq	%r10, %r8
	shrq	$3, %r8
	movzbl	2147450880(%r8), %r15d
	movq	%r10, %r8
	andl	$7, %r8d
	addl	$3, %r8d
	cmpb	%r15b, %r8b
	jl	.L728
	testb	%r15b, %r15b
	jne	.L792
.L728:
	movl	%r14d, 16(%rbx,%rdx,4)
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L729
	cmpb	$3, %dl
	jle	.L793
.L729:
	cqto
	movl	%ecx, 40(%rsi)
	idivq	%r11
	movq	%r13, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L794
	movq	64(%rbx), %rdx
	cmpq	$-1, %rdx
	je	.L786
	cmpq	%rax, %rdx
	cmovle	%rdx, %rax
.L786:
	movq	%rax, 64(%rbx)
	movq	(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L795
	movq	72(%rbx), %rax
	cmpq	$-1, %rax
	je	.L787
	cmpq	%r9, %rax
	cmovge	%rax, %r9
.L787:
	movq	%r9, 72(%rbx)
.L716:
	addl	$1, %r14d
	cmpl	%r14d, numthrottles(%rip)
	jle	.L712
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L735
	cmpb	$3, %al
	jle	.L796
.L735:
	cmpl	$9, 56(%rbx)
	jg	.L712
.L736:
	cmpb	$0, 2147450880(%r12)
	jne	.L797
	movq	8(%rbx), %rax
	leaq	240(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L798
	movq	240(%rax), %rsi
	movslq	%r14d, %rax
	movq	throttles(%rip), %rdi
	leaq	(%rax,%rax,2), %r15
	salq	$4, %r15
	addq	%r15, %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L799
	movq	(%rdi), %rdi
	call	match
	testl	%eax, %eax
	je	.L716
	movq	throttles(%rip), %rsi
	addq	%r15, %rsi
	leaq	24(%rsi), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L800
	leaq	8(%rsi), %rdi
	movq	24(%rsi), %rdx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L801
	movq	8(%rsi), %rax
	leaq	(%rax,%rax), %rcx
	cmpq	%rcx, %rdx
	jg	.L738
	leaq	16(%rsi), %rdi
	movq	%rdi, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L802
	movq	16(%rsi), %r9
	cmpq	%r9, %rdx
	jl	.L738
	leaq	40(%rsi), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L721
	cmpb	$3, %dl
	jle	.L803
.L721:
	movl	40(%rsi), %ecx
	testl	%ecx, %ecx
	jns	.L804
	xorl	%eax, %eax
	movl	$.LC89, %esi
	movl	$3, %edi
	call	syslog
	movq	throttles(%rip), %rsi
	addq	%r15, %rsi
	leaq	40(%rsi), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L724
	cmpb	$3, %al
	jle	.L805
.L724:
	leaq	8(%rsi), %rax
	movl	$0, 40(%rsi)
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L806
	leaq	16(%rsi), %rcx
	movq	8(%rsi), %rax
	movq	%rcx, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L807
	movq	16(%rsi), %r9
	movl	$1, %r11d
	movl	$1, %ecx
	jmp	.L723
	.p2align 4,,10
	.p2align 3
.L712:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movl	$1, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L738:
	.cfi_restore_state
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L805:
	.cfi_restore_state
	call	__asan_report_store4
.L795:
	movq	(%rsp), %rdi
	call	__asan_report_load8
.L794:
	movq	%r13, %rdi
	call	__asan_report_load8
.L796:
	movq	%rbp, %rdi
	call	__asan_report_load4
.L802:
	call	__asan_report_load8
.L801:
	call	__asan_report_load8
.L800:
	call	__asan_report_load8
.L793:
	call	__asan_report_store4
.L792:
	movq	%r10, %rdi
	call	__asan_report_store4
.L791:
	movq	%rbp, %rdi
	call	__asan_report_load4
.L803:
	call	__asan_report_load4
.L799:
	call	__asan_report_load8
.L798:
	call	__asan_report_load8
.L797:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L790:
	movq	%r13, %rdi
	call	__asan_report_store8
.L789:
	movq	(%rsp), %rdi
	call	__asan_report_store8
.L788:
	movq	%rbp, %rdi
	call	__asan_report_store4
.L807:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L806:
	movq	%rax, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE23:
	.size	check_throttles, .-check_throttles
	.p2align 4,,15
	.type	shut_down, @function
shut_down:
.LASANPC18:
.LFB18:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$120, %rsp
	.cfi_def_cfa_offset 176
	movl	__asan_option_detect_stack_use_after_return(%rip), %edx
	leaq	16(%rsp), %rbp
	testl	%edx, %edx
	jne	.L865
.L808:
	leaq	32(%rbp), %rbx
	movq	%rbp, %r12
	movq	$1102416563, 0(%rbp)
	shrq	$3, %r12
	movq	$.LC7, 8(%rbp)
	movq	$.LASANPC18, 16(%rbp)
	xorl	%esi, %esi
	movq	%rbx, %rdi
	movl	$-235802127, 2147450880(%r12)
	movl	$-219021312, 2147450884(%r12)
	movl	$-202116109, 2147450888(%r12)
	call	gettimeofday
	movq	%rbx, %rdi
	call	logstats
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L812
	xorl	%r15d, %r15d
	movq	%rbx, 8(%rsp)
	jmp	.L820
	.p2align 4,,10
	.p2align 3
.L815:
	testq	%rdi, %rdi
	je	.L817
	call	httpd_destroy_conn
	addq	connects(%rip), %rbx
	leaq	8(%rbx), %r14
	movq	%r14, %r13
	shrq	$3, %r13
	cmpb	$0, 2147450880(%r13)
	jne	.L866
	movq	8(%rbx), %rdi
	call	free
	subl	$1, httpd_conn_count(%rip)
	cmpb	$0, 2147450880(%r13)
	jne	.L867
	movq	$0, 8(%rbx)
.L817:
	addl	$1, %r15d
	cmpl	%r15d, max_connects(%rip)
	jle	.L812
.L820:
	movslq	%r15d, %rax
	movq	connects(%rip), %rdi
	leaq	(%rax,%rax,8), %rbx
	salq	$4, %rbx
	addq	%rbx, %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L813
	cmpb	$3, %al
	jle	.L868
.L813:
	leaq	8(%rdi), %rax
	movl	(%rdi), %edx
	movq	%rax, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L869
	testl	%edx, %edx
	movq	8(%rdi), %rdi
	je	.L815
	movq	8(%rsp), %rsi
	call	httpd_close_conn
	movq	connects(%rip), %rax
	addq	%rbx, %rax
	leaq	8(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L870
	movq	8(%rax), %rdi
	jmp	.L815
	.p2align 4,,10
	.p2align 3
.L812:
	movq	hs(%rip), %rbx
	testq	%rbx, %rbx
	je	.L821
	leaq	72(%rbx), %rdi
	movq	$0, hs(%rip)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L822
	cmpb	$3, %al
	jle	.L871
.L822:
	movl	72(%rbx), %edi
	cmpl	$-1, %edi
	jne	.L872
.L823:
	leaq	76(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L824
	testb	%dl, %dl
	jne	.L873
.L824:
	movl	76(%rbx), %edi
	cmpl	$-1, %edi
	jne	.L874
.L825:
	movq	%rbx, %rdi
	call	httpd_terminate
.L821:
	call	mmc_destroy
	call	tmr_destroy
	movq	connects(%rip), %rdi
	call	free
	movq	throttles(%rip), %rdi
	testq	%rdi, %rdi
	je	.L811
	call	free
.L811:
	leaq	16(%rsp), %rax
	cmpq	%rbp, %rax
	jne	.L875
	movq	$0, 2147450880(%r12)
	movl	$0, 2147450888(%r12)
.L810:
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L872:
	.cfi_restore_state
	call	fdwatch_del_fd
	jmp	.L823
	.p2align 4,,10
	.p2align 3
.L874:
	call	fdwatch_del_fd
	jmp	.L825
.L875:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, 0(%rbp)
	movl	$-168430091, 2147450888(%r12)
	movq	%rax, 2147450880(%r12)
	jmp	.L810
.L865:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L808
.L868:
	call	__asan_report_load4
.L870:
	call	__asan_report_load8
.L867:
	movq	%r14, %rdi
	call	__asan_report_store8
.L866:
	movq	%r14, %rdi
	call	__asan_report_load8
.L869:
	movq	%rax, %rdi
	call	__asan_report_load8
.L873:
	call	__asan_report_load4
.L871:
	call	__asan_report_load4
	.cfi_endproc
.LFE18:
	.size	shut_down, .-shut_down
	.section	.rodata
	.align 32
.LC90:
	.string	"exiting"
	.zero	56
	.text
	.p2align 4,,15
	.type	handle_usr1, @function
handle_usr1:
.LASANPC5:
.LFB5:
	.cfi_startproc
	movl	num_connects(%rip), %eax
	testl	%eax, %eax
	je	.L881
	movl	$1, got_usr1(%rip)
	ret
	.p2align 4,,10
	.p2align 3
.L881:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	shut_down
	movl	$5, %edi
	movl	$.LC90, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
	.cfi_endproc
.LFE5:
	.size	handle_usr1, .-handle_usr1
	.section	.rodata
	.align 32
.LC91:
	.string	"exiting due to signal %d"
	.zero	39
	.text
	.p2align 4,,15
	.type	handle_term, @function
handle_term:
.LASANPC2:
.LFB2:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	%edi, %ebx
	call	shut_down
	movl	$5, %edi
	movl	%ebx, %edx
	movl	$.LC91, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE2:
	.size	handle_term, .-handle_term
	.p2align 4,,15
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LASANPC36:
.LFB36:
	.cfi_startproc
	leaq	56(%rdi), %rdx
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L885
	cmpb	$3, %al
	jle	.L910
.L885:
	movl	56(%rdi), %eax
	testl	%eax, %eax
	jle	.L884
	subl	$1, %eax
	movq	throttles(%rip), %r8
	leaq	16(%rdi), %rdx
	leaq	20(%rdi,%rax,4), %rsi
	.p2align 4,,10
	.p2align 3
.L889:
	movq	%rdx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdx, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L887
	testb	%cl, %cl
	jne	.L911
.L887:
	movslq	(%rdx), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r8, %rax
	leaq	40(%rax), %rdi
	movq	%rdi, %rcx
	shrq	$3, %rcx
	movzbl	2147450880(%rcx), %ecx
	testb	%cl, %cl
	je	.L888
	cmpb	$3, %cl
	jle	.L912
.L888:
	addq	$4, %rdx
	subl	$1, 40(%rax)
	cmpq	%rsi, %rdx
	jne	.L889
.L884:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L910:
	.cfi_restore_state
	movq	%rdx, %rdi
	call	__asan_report_load4
.L912:
	call	__asan_report_load4
.L911:
	movq	%rdx, %rdi
	call	__asan_report_load4
	.cfi_endproc
.LFE36:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.p2align 4,,15
	.type	really_clear_connection, @function
really_clear_connection:
.LASANPC28:
.LFB28:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	leaq	8(%rdi), %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rbp, %rax
	shrq	$3, %rax
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	cmpb	$0, 2147450880(%rax)
	jne	.L953
	movq	%rdi, %rbx
	movq	8(%rdi), %rdi
	leaq	200(%rdi), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L954
	movq	200(%rdi), %rax
	addq	%rax, stats_bytes(%rip)
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L916
	cmpb	$3, %al
	jle	.L955
.L916:
	cmpl	$3, (%rbx)
	jne	.L956
.L917:
	leaq	104(%rbx), %r12
	call	httpd_close_conn
	movq	%r12, %rbp
	movq	%rbx, %rdi
	shrq	$3, %rbp
	call	clear_throttles.isra.0
	cmpb	$0, 2147450880(%rbp)
	jne	.L957
	movq	104(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L921
	call	tmr_cancel
	cmpb	$0, 2147450880(%rbp)
	jne	.L958
	movq	$0, 104(%rbx)
.L921:
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L923
	cmpb	$3, %al
	jle	.L959
.L923:
	leaq	4(%rbx), %rdi
	movl	$0, (%rbx)
	movl	first_free_connect(%rip), %ecx
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L924
	testb	%dl, %dl
	jne	.L960
.L924:
	movl	%ecx, 4(%rbx)
	subq	connects(%rip), %rbx
	movabsq	$-8198552921648689607, %rax
	subl	$1, num_connects(%rip)
	sarq	$4, %rbx
	imulq	%rax, %rbx
	movl	%ebx, first_free_connect(%rip)
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L956:
	.cfi_restore_state
	leaq	704(%rdi), %rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L918
	cmpb	$3, %al
	jle	.L961
.L918:
	movl	704(%rdi), %edi
	movq	%rsi, 8(%rsp)
	call	fdwatch_del_fd
	movq	%rbp, %rax
	movq	8(%rsp), %rsi
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L962
	movq	8(%rbx), %rdi
	jmp	.L917
.L960:
	call	__asan_report_store4
.L959:
	movq	%rbx, %rdi
	call	__asan_report_store4
.L955:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L961:
	movq	%rdx, %rdi
	call	__asan_report_load4
.L962:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L958:
	movq	%r12, %rdi
	call	__asan_report_store8
.L957:
	movq	%r12, %rdi
	call	__asan_report_load8
.L954:
	movq	%rax, %rdi
	call	__asan_report_load8
.L953:
	movq	%rbp, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE28:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata
	.align 32
.LC92:
	.string	"replacing non-null linger_timer!"
	.zero	63
	.align 32
.LC93:
	.string	"tmr_create(linger_clear_connection) failed"
	.zero	53
	.text
	.p2align 4,,15
	.type	clear_connection, @function
clear_connection:
.LASANPC27:
.LFB27:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	leaq	96(%rdi), %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%r13, %r12
	shrq	$3, %r12
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	cmpb	$0, 2147450880(%r12)
	jne	.L1036
	movq	%rdi, %rbx
	movq	96(%rdi), %rdi
	movq	%rsi, %rbp
	testq	%rdi, %rdi
	je	.L965
	call	tmr_cancel
	cmpb	$0, 2147450880(%r12)
	jne	.L1037
	movq	$0, 96(%rbx)
.L965:
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L967
	cmpb	$3, %al
	jle	.L1038
.L967:
	movl	(%rbx), %ecx
	cmpl	$4, %ecx
	je	.L1039
	leaq	8(%rbx), %r12
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1040
	movq	8(%rbx), %rax
	leaq	556(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L975
	testb	%sil, %sil
	jne	.L1041
.L975:
	movl	556(%rax), %edx
	testl	%edx, %edx
	je	.L973
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L976
	cmpb	$3, %dl
	jle	.L1042
.L976:
	cmpl	$3, %ecx
	movl	704(%rax), %edi
	jne	.L1043
.L977:
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L980
	cmpb	$3, %al
	jle	.L1044
.L980:
	movl	$4, (%rbx)
	movl	$1, %esi
	call	shutdown
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1045
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L982
	cmpb	$3, %dl
	jle	.L1046
.L982:
	movl	704(%rax), %edi
	leaq	104(%rbx), %r12
	xorl	%edx, %edx
	movq	%rbx, %rsi
	call	fdwatch_add_fd
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1047
	cmpq	$0, 104(%rbx)
	je	.L984
	movl	$.LC92, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L984:
	xorl	%r8d, %r8d
	movq	%rbx, %rdx
	movl	$500, %ecx
	movl	$linger_clear_connection, %esi
	movq	%rbp, %rdi
	call	tmr_create
	movq	%r12, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1048
	testq	%rax, %rax
	movq	%rax, 104(%rbx)
	je	.L1049
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1043:
	.cfi_restore_state
	call	fdwatch_del_fd
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1050
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L979
	cmpb	$3, %dl
	jle	.L1051
.L979:
	movl	704(%rax), %edi
	jmp	.L977
	.p2align 4,,10
	.p2align 3
.L1039:
	leaq	104(%rbx), %r13
	movq	%r13, %r12
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L1052
	movq	104(%rbx), %rdi
	call	tmr_cancel
	cmpb	$0, 2147450880(%r12)
	jne	.L1053
	leaq	8(%rbx), %rdi
	movq	$0, 104(%rbx)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1054
	movq	8(%rbx), %rdx
	leaq	556(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L972
	testb	%cl, %cl
	jne	.L1055
.L972:
	movl	$0, 556(%rdx)
.L973:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	jmp	really_clear_connection
.L1038:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	__asan_report_load4
.L1041:
	call	__asan_report_load4
.L1046:
	call	__asan_report_load4
.L1044:
	movq	%rbx, %rdi
	call	__asan_report_store4
.L1042:
	call	__asan_report_load4
.L1055:
	call	__asan_report_store4
.L1051:
	call	__asan_report_load4
.L1049:
	movl	$2, %edi
	movl	$.LC93, %esi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1048:
	movq	%r12, %rdi
	call	__asan_report_store8
.L1037:
	movq	%r13, %rdi
	call	__asan_report_store8
.L1045:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1054:
	call	__asan_report_load8
.L1052:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1053:
	movq	%r13, %rdi
	call	__asan_report_store8
.L1036:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1040:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1047:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1050:
	movq	%r12, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE27:
	.size	clear_connection, .-clear_connection
	.p2align 4,,15
	.type	finish_connection, @function
finish_connection:
.LASANPC26:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	addq	$8, %rdi
	movq	%rdi, %rax
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1059
	movq	8(%rbx), %rdi
	movq	%rsi, %rbp
	call	httpd_write_response
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	clear_connection
.L1059:
	.cfi_restore_state
	call	__asan_report_load8
	.cfi_endproc
.LFE26:
	.size	finish_connection, .-finish_connection
	.p2align 4,,15
	.type	handle_read, @function
handle_read:
.LASANPC20:
.LFB20:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rdi, %rbp
	addq	$8, %rdi
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rax
	shrq	$3, %rax
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	cmpb	$0, 2147450880(%rax)
	jne	.L1178
	movq	8(%rbp), %rbx
	leaq	160(%rbx), %r12
	movq	%r12, %r15
	shrq	$3, %r15
	cmpb	$0, 2147450880(%r15)
	jne	.L1179
	leaq	152(%rbx), %r14
	movq	%rsi, %r13
	movq	160(%rbx), %rsi
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1180
	movq	152(%rbx), %rdx
	leaq	144(%rbx), %rcx
	cmpq	%rdx, %rsi
	jb	.L1064
	cmpq	$5000, %rdx
	ja	.L1181
	leaq	144(%rbx), %rcx
	addq	$1000, %rdx
	movq	%r14, %rsi
	movq	%rax, 8(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, (%rsp)
	call	httpd_realloc_str
	movq	8(%rsp), %rax
	movq	(%rsp), %rcx
	cmpb	$0, 2147450880(%rax)
	jne	.L1182
	cmpb	$0, 2147450880(%r15)
	movq	152(%rbx), %rdx
	jne	.L1183
	movq	160(%rbx), %rsi
.L1064:
	movq	%rcx, %rax
	subq	%rsi, %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1184
	leaq	704(%rbx), %r14
	addq	144(%rbx), %rsi
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1071
	cmpb	$3, %al
	jle	.L1185
.L1071:
	movl	704(%rbx), %edi
	call	read
	testl	%eax, %eax
	je	.L1186
	jns	.L1075
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1076
	testb	%cl, %cl
	jne	.L1187
.L1076:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1060
	cmpl	$11, %eax
	je	.L1060
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1188
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1086
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1181:
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1189
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1190
.L1086:
	movq	httpd_err400title(%rip), %rdx
	movl	$.LC48, %r9d
	movl	$400, %esi
	movq	%r9, %rcx
	movq	%rbx, %rdi
	call	httpd_send_err
.L1177:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%r13, %rsi
	movq	%rbp, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L1186:
	.cfi_restore_state
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1191
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1086
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1075:
	movq	%r12, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1192
	cltq
	addq	%rax, 160(%rbx)
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1193
	leaq	88(%rbp), %rdi
	movq	0(%r13), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1194
	movq	%rax, 88(%rbp)
	movq	%rbx, %rdi
	call	httpd_got_request
	testl	%eax, %eax
	jne	.L1195
.L1060:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1195:
	.cfi_restore_state
	cmpl	$2, %eax
	jne	.L1175
	movl	$httpd_err400form, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1196
	movl	$httpd_err400title, %eax
	movq	httpd_err400form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	je	.L1086
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
	.p2align 4,,10
	.p2align 3
.L1175:
	movq	%rbx, %rdi
	call	httpd_parse_request
	testl	%eax, %eax
	js	.L1177
	movq	%rbp, %rdi
	call	check_throttles
	testl	%eax, %eax
	je	.L1197
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	httpd_start_request
	testl	%eax, %eax
	js	.L1177
	leaq	528(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1093
	cmpb	$3, %al
	jle	.L1198
.L1093:
	movl	528(%rbx), %eax
	testl	%eax, %eax
	je	.L1094
	leaq	536(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1199
	leaq	136(%rbp), %rdi
	movq	536(%rbx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1200
	leaq	544(%rbx), %rdi
	movq	%rax, 136(%rbp)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1201
	leaq	128(%rbp), %rdi
	movq	544(%rbx), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	addq	$1, %rax
	cmpb	$0, 2147450880(%rdx)
	jne	.L1202
.L1103:
	movq	%rax, 128(%rbp)
.L1099:
	leaq	712(%rbx), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1203
	cmpq	$0, 712(%rbx)
	je	.L1204
	leaq	136(%rbp), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1205
	movq	%rdi, %rdx
	movq	136(%rbp), %rax
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1206
	cmpq	128(%rbp), %rax
	jge	.L1177
	movq	%rbp, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1115
	cmpb	$3, %al
	jle	.L1207
.L1115:
	movq	%r13, %rax
	movl	$2, 0(%rbp)
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1208
	leaq	80(%rbp), %rdi
	movq	0(%r13), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1209
	leaq	112(%rbp), %rdi
	movq	%rax, 80(%rbp)
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1210
	movq	%r14, %rax
	movq	$0, 112(%rbp)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1119
	cmpb	$3, %al
	jle	.L1211
.L1119:
	movl	704(%rbx), %edi
	call	fdwatch_del_fd
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1120
	cmpb	$3, %al
	jle	.L1212
.L1120:
	movl	704(%rbx), %edi
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movq	%rbp, %rsi
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	movl	$1, %edx
	jmp	fdwatch_add_fd
	.p2align 4,,10
	.p2align 3
.L1197:
	.cfi_restore_state
	leaq	208(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1213
	movl	$httpd_err503form, %eax
	movq	208(%rbx), %r9
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1214
	movl	$httpd_err503title, %eax
	movq	httpd_err503form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1215
	movq	httpd_err503title(%rip), %rdx
	movl	$.LC48, %ecx
	movl	$503, %esi
	movq	%rbx, %rdi
	call	httpd_send_err
	jmp	.L1177
.L1185:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1187:
	movq	%rax, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1094:
	leaq	192(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1216
	movq	192(%rbx), %rax
	leaq	128(%rbp), %rdi
	testq	%rax, %rax
	js	.L1217
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	je	.L1103
	call	__asan_report_store8
	.p2align 4,,10
	.p2align 3
.L1204:
	leaq	56(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1106
	cmpb	$3, %al
	jle	.L1218
.L1106:
	leaq	200(%rbx), %rdi
	movl	56(%rbp), %eax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1219
	testl	%eax, %eax
	movq	200(%rbx), %rsi
	jle	.L1108
	subl	$1, %eax
	movq	throttles(%rip), %r9
	leaq	16(%rbp), %rdi
	leaq	20(%rbp,%rax,4), %r8
	.p2align 4,,10
	.p2align 3
.L1111:
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1109
	testb	%dl, %dl
	jne	.L1220
.L1109:
	movslq	(%rdi), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r9, %rax
	leaq	32(%rax), %rdx
	movq	%rdx, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1221
	addq	$4, %rdi
	addq	%rsi, 32(%rax)
	cmpq	%r8, %rdi
	jne	.L1111
.L1108:
	leaq	136(%rbp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1222
	movq	%rsi, 136(%rbp)
	jmp	.L1177
.L1217:
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1223
	movq	$0, 128(%rbp)
	jmp	.L1099
.L1221:
	movq	%rdx, %rdi
	call	__asan_report_load8
.L1223:
	call	__asan_report_store8
.L1219:
	call	__asan_report_load8
.L1220:
	call	__asan_report_load4
.L1214:
	movl	$httpd_err503form, %edi
	call	__asan_report_load8
.L1213:
	call	__asan_report_load8
.L1205:
	movq	%rax, %rdi
	call	__asan_report_load8
.L1218:
	call	__asan_report_load4
.L1188:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1196:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1189:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1190:
	movl	$httpd_err400title, %edi
	call	__asan_report_load8
.L1183:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1182:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1193:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1194:
	call	__asan_report_store8
.L1192:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1191:
	movl	$httpd_err400form, %edi
	call	__asan_report_load8
.L1179:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1178:
	call	__asan_report_load8
.L1180:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1184:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L1215:
	movl	$httpd_err503title, %edi
	call	__asan_report_load8
.L1199:
	call	__asan_report_load8
.L1198:
	call	__asan_report_load4
.L1207:
	movq	%rbp, %rdi
	call	__asan_report_store4
.L1209:
	call	__asan_report_store8
.L1208:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1210:
	call	__asan_report_store8
.L1212:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1203:
	movq	%rax, %rdi
	call	__asan_report_load8
.L1202:
	call	__asan_report_store8
.L1201:
	call	__asan_report_load8
.L1200:
	call	__asan_report_store8
.L1206:
	call	__asan_report_load8
.L1211:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1216:
	call	__asan_report_load8
.L1222:
	call	__asan_report_store8
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata
	.align 32
.LC94:
	.string	"%.80s connection timed out reading"
	.zero	61
	.align 32
.LC95:
	.string	"%.80s connection timed out sending"
	.zero	61
	.text
	.p2align 4,,15
	.type	idle, @function
idle:
.LASANPC29:
.LFB29:
	.cfi_startproc
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L1251
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rsi, %r15
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	$httpd_err408form, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rsi, %rbp
	xorl	%r14d, %r14d
	shrq	$3, %r15
	shrq	$3, %r12
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	$httpd_err408title, %r13d
	jmp	.L1241
	.p2align 4,,10
	.p2align 3
.L1259:
	jl	.L1227
	cmpl	$3, %eax
	jg	.L1227
	cmpb	$0, 2147450880(%r15)
	jne	.L1254
	leaq	88(%rbx), %rdi
	movq	0(%rbp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1255
	subq	88(%rbx), %rax
	cmpq	$299, %rax
	jg	.L1256
.L1227:
	addl	$1, %r14d
	cmpl	%r14d, max_connects(%rip)
	jle	.L1257
.L1241:
	movslq	%r14d, %rax
	leaq	(%rax,%rax,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1226
	cmpb	$3, %al
	jle	.L1258
.L1226:
	movl	(%rbx), %eax
	cmpl	$1, %eax
	jne	.L1259
	cmpb	$0, 2147450880(%r15)
	jne	.L1260
	leaq	88(%rbx), %rdi
	movq	0(%rbp), %rax
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1261
	subq	88(%rbx), %rax
	cmpq	$59, %rax
	jle	.L1227
	leaq	8(%rbx), %r9
	movq	%r9, %rcx
	shrq	$3, %rcx
	cmpb	$0, 2147450880(%rcx)
	jne	.L1262
	movq	8(%rbx), %rax
	movq	%rcx, 8(%rsp)
	movq	%r9, (%rsp)
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC94, %esi
	movq	%rax, %rdx
	movl	$6, %edi
	xorl	%eax, %eax
	call	syslog
	cmpb	$0, 2147450880(%r12)
	movq	(%rsp), %r9
	movq	8(%rsp), %rcx
	jne	.L1263
	movq	%r13, %rax
	movq	httpd_err408form(%rip), %r8
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1264
	cmpb	$0, 2147450880(%rcx)
	movq	httpd_err408title(%rip), %rdx
	jne	.L1265
	movq	8(%rbx), %rdi
	movl	$.LC48, %r9d
	movl	$408, %esi
	movq	%r9, %rcx
	addl	$1, %r14d
	call	httpd_send_err
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	cmpl	%r14d, max_connects(%rip)
	jg	.L1241
.L1257:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1256:
	.cfi_restore_state
	leaq	8(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1266
	movq	8(%rbx), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC95, %esi
	movq	%rax, %rdx
	movl	$6, %edi
	xorl	%eax, %eax
	call	syslog
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L1227
	.p2align 4,,10
	.p2align 3
.L1251:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	rep ret
.L1258:
	.cfi_def_cfa_offset 80
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	movq	%rbx, %rdi
	call	__asan_report_load4
.L1266:
	call	__asan_report_load8
.L1265:
	movq	%r9, %rdi
	call	__asan_report_load8
.L1264:
	movl	$httpd_err408title, %edi
	call	__asan_report_load8
.L1263:
	movl	$httpd_err408form, %edi
	call	__asan_report_load8
.L1262:
	movq	%r9, %rdi
	call	__asan_report_load8
.L1261:
	call	__asan_report_load8
.L1260:
	movq	%rbp, %rdi
	call	__asan_report_load8
.L1255:
	call	__asan_report_load8
.L1254:
	movq	%rbp, %rdi
	call	__asan_report_load8
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.section	.rodata.str1.1
.LC96:
	.string	"1 32 32 2 iv "
	.section	.rodata
	.align 32
.LC97:
	.string	"replacing non-null wakeup_timer!"
	.zero	63
	.align 32
.LC98:
	.string	"tmr_create(wakeup_connection) failed"
	.zero	59
	.align 32
.LC99:
	.string	"write - %m sending %.80s"
	.zero	39
	.text
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LASANPC21:
.LFB21:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rdi, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$152, %rsp
	.cfi_def_cfa_offset 208
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsi, (%rsp)
	leaq	48(%rsp), %rbp
	testl	%eax, %eax
	jne	.L1419
.L1267:
	leaq	8(%r13), %rcx
	movq	%rbp, %rbx
	movq	$1102416563, 0(%rbp)
	shrq	$3, %rbx
	movq	$.LC96, 8(%rbp)
	movq	$.LASANPC21, 16(%rbp)
	movq	%rcx, %rdx
	movl	$-235802127, 2147450880(%rbx)
	movl	$-202116109, 2147450888(%rbx)
	shrq	$3, %rdx
	leaq	96(%rbp), %rax
	movq	%rcx, 8(%rsp)
	cmpb	$0, 2147450880(%rdx)
	jne	.L1420
	leaq	64(%r13), %rdx
	movq	8(%r13), %rcx
	movq	%rdx, 16(%rsp)
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1421
	movq	64(%r13), %rsi
	movl	$1000000000, %edx
	cmpq	$-1, %rsi
	je	.L1273
	leaq	3(%rsi), %rdx
	testq	%rsi, %rsi
	cmovns	%rsi, %rdx
	sarq	$2, %rdx
.L1273:
	leaq	472(%rcx), %r11
	movq	%r11, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1422
	cmpq	$0, 472(%rcx)
	jne	.L1275
	leaq	128(%r13), %r14
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1423
	leaq	136(%r13), %r15
	movq	128(%r13), %rax
	movq	%r15, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1424
	movq	136(%r13), %rsi
	leaq	712(%rcx), %rdi
	subq	%rsi, %rax
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1425
	leaq	704(%rcx), %r12
	addq	712(%rcx), %rsi
	movq	%r12, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %edi
	testb	%dil, %dil
	je	.L1279
	cmpb	$3, %dil
	jle	.L1426
.L1279:
	movl	704(%rcx), %edi
	movq	%r11, 32(%rsp)
	movq	%rcx, 24(%rsp)
	call	write
	testl	%eax, %eax
	movq	24(%rsp), %rcx
	movq	32(%rsp), %r11
	js	.L1427
.L1290:
	je	.L1336
	movq	(%rsp), %rdx
	movq	(%rsp), %rdi
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1428
	movq	(%rdi), %rdx
	leaq	88(%r13), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1429
	movq	%rdx, 88(%r13)
	movq	%r11, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1430
	movq	472(%rcx), %rdx
	testq	%rdx, %rdx
	jne	.L1307
.L1418:
	movslq	%eax, %rdx
.L1308:
	movq	%r15, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1431
	movq	8(%rsp), %rax
	movq	136(%r13), %r10
	shrq	$3, %rax
	addq	%rdx, %r10
	cmpb	$0, 2147450880(%rax)
	movq	%r10, 136(%r13)
	jne	.L1432
	movq	8(%r13), %rax
	leaq	200(%rax), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1433
	movq	200(%rax), %r9
	leaq	56(%r13), %rdi
	addq	%rdx, %r9
	movq	%r9, 200(%rax)
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1314
	cmpb	$3, %al
	jle	.L1434
.L1314:
	movl	56(%r13), %eax
	testl	%eax, %eax
	jle	.L1315
	subl	$1, %eax
	movq	throttles(%rip), %r15
	leaq	16(%r13), %rdi
	leaq	20(%r13,%rax,4), %r11
	.p2align 4,,10
	.p2align 3
.L1318:
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %esi
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%sil, %al
	jl	.L1316
	testb	%sil, %sil
	jne	.L1435
.L1316:
	movslq	(%rdi), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%r15, %rax
	leaq	32(%rax), %rsi
	movq	%rsi, %r8
	shrq	$3, %r8
	cmpb	$0, 2147450880(%r8)
	jne	.L1436
	addq	$4, %rdi
	addq	%rdx, 32(%rax)
	cmpq	%r11, %rdi
	jne	.L1318
.L1315:
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1437
	cmpq	128(%r13), %r10
	jge	.L1438
	leaq	112(%r13), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1439
	movq	112(%r13), %rax
	cmpq	$100, %rax
	jg	.L1440
.L1322:
	movq	16(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1441
	movq	64(%r13), %rsi
	cmpq	$-1, %rsi
	je	.L1270
	movq	(%rsp), %rax
	leaq	80(%r13), %rdi
	movq	(%rax), %r14
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1442
	subq	80(%r13), %r14
	je	.L1339
	movq	%r9, %rax
	cqto
	idivq	%r14
	movq	%rax, %r9
.L1325:
	cmpq	%r9, %rsi
	jge	.L1270
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1326
	cmpb	$3, %al
	jg	.L1326
	movq	%r13, %rdi
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L1275:
	leaq	368(%rcx), %rdi
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1443
	leaq	-64(%rax), %r8
	movq	368(%rcx), %rsi
	movq	%r8, %rdi
	shrq	$3, %rdi
	cmpb	$0, 2147450880(%rdi)
	jne	.L1444
	leaq	8(%r8), %rdi
	movq	%rsi, -64(%rax)
	movq	472(%rcx), %rsi
	movq	%rdi, %r12
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L1445
	leaq	712(%rcx), %rdi
	movq	%rsi, -56(%rax)
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1446
	leaq	136(%r13), %r15
	movq	712(%rcx), %rsi
	movq	%r15, %rdi
	shrq	$3, %rdi
	cmpb	$0, 2147450880(%rdi)
	jne	.L1447
	leaq	16(%r8), %rdi
	movq	136(%r13), %r12
	movq	%rdi, %r14
	shrq	$3, %r14
	addq	%r12, %rsi
	cmpb	$0, 2147450880(%r14)
	jne	.L1448
	leaq	128(%r13), %r14
	movq	%rsi, -48(%rax)
	movq	%r14, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1449
	movq	128(%r13), %rsi
	leaq	24(%r8), %rdi
	subq	%r12, %rsi
	cmpq	%rdx, %rsi
	cmovbe	%rsi, %rdx
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1450
	leaq	704(%rcx), %r12
	movq	%rdx, -40(%rax)
	movq	%r12, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1289
	cmpb	$3, %al
	jle	.L1451
.L1289:
	movl	704(%rcx), %edi
	movq	%r8, %rsi
	movl	$2, %edx
	movq	%r11, 40(%rsp)
	movq	%rcx, 32(%rsp)
	movq	%r8, 24(%rsp)
	call	writev
	movq	24(%rsp), %r8
	movq	40(%rsp), %r11
	movq	32(%rsp), %rcx
	shrq	$3, %r8
	testl	%eax, %eax
	movl	$-117901064, 2147450880(%r8)
	jns	.L1290
.L1427:
	movq	%rcx, 8(%rsp)
	call	__errno_location
	movq	%rax, %rdx
	movq	8(%rsp), %rcx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L1291
	testb	%sil, %sil
	jne	.L1452
.L1291:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1270
	cmpl	$11, %eax
	je	.L1336
	cmpl	$32, %eax
	setne	%sil
	cmpl	$22, %eax
	setne	%dl
	testb	%dl, %sil
	je	.L1301
	cmpl	$104, %eax
	jne	.L1453
.L1301:
	movq	(%rsp), %rsi
	movq	%r13, %rdi
	call	clear_connection
	jmp	.L1270
	.p2align 4,,10
	.p2align 3
.L1336:
	leaq	112(%r13), %r14
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1454
	movq	%r13, %rax
	addq	$100, 112(%r13)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1295
	cmpb	$3, %al
	jle	.L1455
.L1295:
	movq	%r12, %rax
	movl	$3, 0(%r13)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1296
	cmpb	$3, %al
	jle	.L1456
.L1296:
	movl	704(%rcx), %edi
	leaq	96(%r13), %r12
	call	fdwatch_del_fd
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1457
	cmpq	$0, 96(%r13)
	je	.L1298
	movl	$.LC97, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1298:
	movq	%r14, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1458
	movq	112(%r13), %rcx
	movq	(%rsp), %rdi
	xorl	%r8d, %r8d
	movq	%r13, %rdx
	movl	$wakeup_connection, %esi
	call	tmr_create
	movq	%r12, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1459
.L1300:
	testq	%rax, %rax
	movq	%rax, 96(%r13)
	je	.L1460
.L1270:
	leaq	48(%rsp), %rax
	cmpq	%rbp, %rax
	jne	.L1461
	movq	$0, 2147450880(%rbx)
	movl	$0, 2147450888(%rbx)
.L1269:
	addq	$152, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1307:
	.cfi_restore_state
	movslq	%eax, %rsi
	cmpq	%rsi, %rdx
	ja	.L1462
	movq	$0, 472(%rcx)
	subl	%edx, %eax
	jmp	.L1418
	.p2align 4,,10
	.p2align 3
.L1440:
	subq	$100, %rax
	movq	%rax, 112(%r13)
	jmp	.L1322
	.p2align 4,,10
	.p2align 3
.L1326:
	movq	%r12, %rax
	movl	$3, 0(%r13)
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1327
	cmpb	$3, %al
	jg	.L1327
	movq	%r12, %rdi
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1327:
	movl	704(%rcx), %edi
	call	fdwatch_del_fd
	movq	8(%rsp), %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1463
	movq	8(%r13), %rax
	leaq	200(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1464
	movq	16(%rsp), %rdx
	movq	200(%rax), %rax
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1465
	cqto
	leaq	96(%r13), %r12
	idivq	64(%r13)
	subl	%r14d, %eax
	movl	%eax, %r14d
	movq	%r12, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1466
	cmpq	$0, 96(%r13)
	je	.L1332
	movl	$.LC97, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L1332:
	testl	%r14d, %r14d
	movl	$500, %ecx
	jle	.L1333
	movslq	%r14d, %rax
	imulq	$1000, %rax, %rcx
.L1333:
	movq	(%rsp), %rdi
	xorl	%r8d, %r8d
	movq	%r13, %rdx
	movl	$wakeup_connection, %esi
	call	tmr_create
	movq	%r12, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	je	.L1300
	movq	%r12, %rdi
	call	__asan_report_store8
	.p2align 4,,10
	.p2align 3
.L1438:
	movq	(%rsp), %rsi
	movq	%r13, %rdi
	call	finish_connection
	jmp	.L1270
	.p2align 4,,10
	.p2align 3
.L1339:
	movl	$1, %r14d
	jmp	.L1325
	.p2align 4,,10
	.p2align 3
.L1462:
	leaq	368(%rcx), %rdi
	subl	%eax, %edx
	movslq	%edx, %r8
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1467
	movq	368(%rcx), %rdi
	movq	%r8, %rdx
	movq	%rcx, 32(%rsp)
	movq	%r8, 24(%rsp)
	addq	%rdi, %rsi
	call	memmove
	movq	24(%rsp), %r8
	movq	32(%rsp), %rcx
	xorl	%edx, %edx
	movq	%r8, 472(%rcx)
	jmp	.L1308
	.p2align 4,,10
	.p2align 3
.L1453:
	leaq	208(%rcx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1468
	movq	208(%rcx), %rdx
	movl	$.LC99, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1301
.L1434:
	call	__asan_report_load4
.L1452:
	movq	%rax, %rdi
	call	__asan_report_load4
.L1455:
	movq	%r13, %rdi
	call	__asan_report_store4
.L1456:
	movq	%r12, %rdi
	call	__asan_report_load4
.L1451:
	movq	%r12, %rdi
	call	__asan_report_load4
.L1425:
	call	__asan_report_load8
.L1424:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1423:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1450:
	call	__asan_report_store8
.L1449:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1448:
	call	__asan_report_store8
.L1447:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1446:
	call	__asan_report_load8
.L1445:
	call	__asan_report_store8
.L1444:
	movq	%r8, %rdi
	call	__asan_report_store8
.L1443:
	call	__asan_report_load8
.L1426:
	movq	%r12, %rdi
	call	__asan_report_load4
.L1461:
	movabsq	$-723401728380766731, %rax
	movq	$1172321806, 0(%rbp)
	movl	$-168430091, 2147450888(%rbx)
	movq	%rax, 2147450880(%rbx)
	jmp	.L1269
.L1419:
	movl	$96, %edi
	call	__asan_stack_malloc_1
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L1267
.L1460:
	movl	$2, %edi
	movl	$.LC98, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1459:
	movq	%r12, %rdi
	call	__asan_report_store8
.L1466:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1465:
	movq	16(%rsp), %rdi
	call	__asan_report_load8
.L1464:
	call	__asan_report_load8
.L1463:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L1428:
	call	__asan_report_load8
.L1429:
	call	__asan_report_store8
.L1430:
	movq	%r11, %rdi
	call	__asan_report_load8
.L1441:
	movq	16(%rsp), %rdi
	call	__asan_report_load8
.L1442:
	call	__asan_report_load8
.L1420:
	movq	%rcx, %rdi
	call	__asan_report_load8
.L1468:
	call	__asan_report_load8
.L1467:
	call	__asan_report_load8
.L1436:
	movq	%rsi, %rdi
	call	__asan_report_load8
.L1437:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1457:
	movq	%r12, %rdi
	call	__asan_report_load8
.L1458:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1454:
	movq	%r14, %rdi
	call	__asan_report_load8
.L1422:
	movq	%r11, %rdi
	call	__asan_report_load8
.L1421:
	movq	16(%rsp), %rdi
	call	__asan_report_load8
.L1431:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1432:
	movq	8(%rsp), %rdi
	call	__asan_report_load8
.L1433:
	call	__asan_report_load8
.L1439:
	call	__asan_report_load8
.L1435:
	call	__asan_report_load4
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LASANPC31:
.LFB31:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, 8(%rsp)
	leaq	8(%rsp), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1473
	movq	8(%rsp), %rdi
	leaq	104(%rdi), %rax
	movq	%rax, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1474
	movq	$0, 104(%rdi)
	call	really_clear_connection
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L1473:
	.cfi_restore_state
	call	__asan_report_load8
.L1474:
	movq	%rax, %rdi
	call	__asan_report_store8
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.globl	__asan_stack_malloc_7
	.section	.rodata.str1.1
.LC100:
	.string	"1 32 4096 3 buf "
	.globl	__asan_stack_free_7
	.text
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LASANPC22:
.LFB22:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rdi, %r14
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rsi, %r13
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$4160, %rsp
	.cfi_def_cfa_offset 4208
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rsp, %rbp
	movq	%rbp, %r12
	testl	%eax, %eax
	jne	.L1498
.L1475:
	leaq	8(%r14), %rdi
	movq	%rbp, %rbx
	movq	$1102416563, 0(%rbp)
	shrq	$3, %rbx
	movq	$.LC100, 8(%rbp)
	movq	$.LASANPC22, 16(%rbp)
	movq	%rdi, %rax
	movl	$-235802127, 2147450880(%rbx)
	movl	$-202116109, 2147451396(%rbx)
	shrq	$3, %rax
	leaq	4160(%rbp), %rsi
	cmpb	$0, 2147450880(%rax)
	jne	.L1499
	movq	8(%r14), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1480
	cmpb	$3, %dl
	jle	.L1500
.L1480:
	movl	704(%rax), %edi
	subq	$4128, %rsi
	movl	$4096, %edx
	call	read
	testl	%eax, %eax
	js	.L1501
	je	.L1484
.L1478:
	cmpq	%rbp, %r12
	jne	.L1502
	leaq	2147450888(%rbx), %rdi
	leaq	2147450880(%rbx), %rcx
	xorl	%eax, %eax
	movq	$0, 2147450880(%rbx)
	movq	$0, 2147451392(%rbx)
	andq	$-8, %rdi
	subq	%rdi, %rcx
	addl	$520, %ecx
	shrl	$3, %ecx
	rep stosq
.L1477:
	addq	$4160, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L1501:
	.cfi_restore_state
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1482
	testb	%cl, %cl
	jne	.L1503
.L1482:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1478
	cmpl	$11, %eax
	je	.L1478
.L1484:
	movq	%r13, %rsi
	movq	%r14, %rdi
	call	really_clear_connection
	jmp	.L1478
.L1500:
	call	__asan_report_load4
.L1503:
	movq	%rax, %rdi
	call	__asan_report_load4
.L1498:
	movl	$4160, %edi
	call	__asan_stack_malloc_7
	testq	%rax, %rax
	cmovne	%rax, %rbp
	jmp	.L1475
.L1502:
	movq	$1172321806, 0(%rbp)
	movq	%r12, %rdx
	movl	$4160, %esi
	movq	%rbp, %rdi
	call	__asan_stack_free_7
	jmp	.L1477
.L1499:
	call	__asan_report_load8
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.8
	.align 8
.LC101:
	.string	"3 32 8 2 ai 96 10 7 portstr 160 48 5 hints "
	.section	.rodata
	.align 32
.LC102:
	.string	"%d"
	.zero	61
	.align 32
.LC103:
	.string	"getaddrinfo %.80s - %.80s"
	.zero	38
	.align 32
.LC104:
	.string	"%s: getaddrinfo %s - %s\n"
	.zero	39
	.align 32
.LC105:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.zero	57
	.text
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LASANPC37:
.LFB37:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%rsi, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rcx, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$296, %rsp
	.cfi_def_cfa_offset 352
	movl	__asan_option_detect_stack_use_after_return(%rip), %eax
	movq	%rdi, (%rsp)
	movq	%rdx, 8(%rsp)
	leaq	32(%rsp), %rbx
	testl	%eax, %eax
	jne	.L1600
.L1504:
	movq	%rbx, %rbp
	leaq	160(%rbx), %r15
	leaq	164(%rbx), %rdi
	shrq	$3, %rbp
	movq	$1102416563, (%rbx)
	movq	$.LC101, 8(%rbx)
	movq	$.LASANPC37, 16(%rbx)
	xorl	%esi, %esi
	movl	$-235802127, 2147450880(%rbp)
	movl	$-218959360, 2147450884(%rbp)
	movl	$-218959118, 2147450888(%rbp)
	movl	$44, %edx
	movl	$-219020800, 2147450892(%rbp)
	movl	$-218959118, 2147450896(%rbp)
	leaq	256(%rbx), %r12
	movl	$-219021312, 2147450904(%rbp)
	movl	$-202116109, 2147450908(%rbp)
	call	memset
	movq	%r15, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1508
	cmpb	$3, %al
	jle	.L1601
.L1508:
	leaq	-96(%r12), %r10
	movl	$1, -96(%r12)
	leaq	8(%r10), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1509
	cmpb	$3, %al
	jle	.L1602
.L1509:
	movzwl	port(%rip), %ecx
	leaq	-160(%r12), %r9
	movl	$.LC102, %edx
	movl	$10, %esi
	xorl	%eax, %eax
	movq	%r10, 24(%rsp)
	movq	%r9, %rdi
	movq	%r9, 16(%rsp)
	movl	$1, -88(%r12)
	leaq	-224(%r12), %r15
	call	snprintf
	movq	24(%rsp), %r10
	movq	16(%rsp), %r9
	movq	%r15, %rcx
	movq	hostname(%rip), %rdi
	movq	%r10, %rdx
	movq	%r9, %rsi
	call	getaddrinfo
	testl	%eax, %eax
	jne	.L1603
	movq	%r15, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1604
	movq	-224(%r12), %rax
	xorl	%r15d, %r15d
	xorl	%r9d, %r9d
	testq	%rax, %rax
	jne	.L1513
	jmp	.L1605
	.p2align 4,,10
	.p2align 3
.L1609:
	cmpl	$10, %edx
	jne	.L1517
	testq	%r9, %r9
	cmove	%rax, %r9
.L1517:
	leaq	40(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	cmpb	$0, 2147450880(%rdx)
	jne	.L1606
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L1607
.L1513:
	leaq	4(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %esi
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%sil, %dl
	jl	.L1516
	testb	%sil, %sil
	jne	.L1608
.L1516:
	movl	4(%rax), %edx
	cmpl	$2, %edx
	jne	.L1609
	testq	%r15, %r15
	cmove	%rax, %r15
	jmp	.L1517
	.p2align 4,,10
	.p2align 3
.L1607:
	testq	%r9, %r9
	je	.L1610
	leaq	16(%r9), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1524
	cmpb	$3, %al
	jle	.L1611
.L1524:
	movl	16(%r9), %r8d
	cmpq	$128, %r8
	ja	.L1599
	movq	8(%rsp), %rdi
	movl	$128, %edx
	xorl	%esi, %esi
	movq	%r9, 16(%rsp)
	call	memset
	movq	16(%rsp), %r9
	leaq	24(%r9), %rdi
	movl	16(%r9), %edx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1612
	movq	24(%r9), %rsi
	movq	8(%rsp), %rdi
	call	memmove
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1527
	cmpb	$3, %al
	jle	.L1613
.L1527:
	movl	$1, 0(%r13)
.L1523:
	testq	%r15, %r15
	je	.L1515
	leaq	16(%r15), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1531
	cmpb	$3, %al
	jle	.L1614
.L1531:
	movl	16(%r15), %r8d
	cmpq	$128, %r8
	ja	.L1599
	movq	(%rsp), %rdi
	movl	$128, %edx
	xorl	%esi, %esi
	call	memset
	leaq	24(%r15), %rdi
	movl	16(%r15), %edx
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1615
	movq	24(%r15), %rsi
	movq	(%rsp), %rdi
	call	memmove
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1534
	cmpb	$3, %al
	jle	.L1616
.L1534:
	movl	$1, (%r14)
.L1530:
	movq	-224(%r12), %rdi
	call	freeaddrinfo
	leaq	32(%rsp), %rax
	cmpq	%rbx, %rax
	jne	.L1617
	pxor	%xmm0, %xmm0
	movups	%xmm0, 2147450880(%rbp)
	movups	%xmm0, 2147450896(%rbp)
.L1506:
	addq	$296, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L1605:
	.cfi_restore_state
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1514
	cmpb	$3, %al
	jle	.L1618
.L1514:
	movl	$0, 0(%r13)
.L1515:
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1529
	cmpb	$3, %al
	jle	.L1619
.L1529:
	movl	$0, (%r14)
	jmp	.L1530
.L1610:
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1522
	cmpb	$3, %al
	jle	.L1620
.L1522:
	movl	$0, 0(%r13)
	jmp	.L1523
.L1617:
	movdqa	.LC45(%rip), %xmm0
	movq	$1172321806, (%rbx)
	movups	%xmm0, 2147450880(%rbp)
	movups	%xmm0, 2147450896(%rbp)
	jmp	.L1506
.L1603:
	movl	%eax, %edi
	movl	%eax, (%rsp)
	call	gai_strerror
	movq	hostname(%rip), %rdx
	movq	%rax, %rcx
	movl	$.LC103, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	(%rsp), %r9d
	movl	%r9d, %edi
	call	gai_strerror
	movl	$stderr, %esi
	movq	%rax, %r8
	movq	hostname(%rip), %rcx
	shrq	$3, %rsi
	movq	argv0(%rip), %rdx
	cmpb	$0, 2147450880(%rsi)
	jne	.L1621
	movq	stderr(%rip), %rdi
	movl	$.LC104, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1600:
	movl	$256, %edi
	call	__asan_stack_malloc_2
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L1504
.L1618:
	movq	%r13, %rdi
	call	__asan_report_store4
.L1619:
	movq	%r14, %rdi
	call	__asan_report_store4
.L1601:
	movq	%r15, %rdi
	call	__asan_report_store4
.L1615:
	call	__asan_report_load8
.L1606:
	call	__asan_report_load8
.L1612:
	call	__asan_report_load8
.L1599:
	movq	hostname(%rip), %rdx
	movl	$2, %edi
	movl	$128, %ecx
	movl	$.LC105, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1614:
	call	__asan_report_load4
.L1616:
	movq	%r14, %rdi
	call	__asan_report_store4
.L1613:
	movq	%r13, %rdi
	call	__asan_report_store4
.L1604:
	movq	%r15, %rdi
	call	__asan_report_load8
.L1602:
	call	__asan_report_store4
.L1608:
	call	__asan_report_load4
.L1611:
	call	__asan_report_load4
.L1620:
	movq	%r13, %rdi
	call	__asan_report_store4
.L1621:
	movl	$stderr, %edi
	call	__asan_report_load8
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.rodata.str1.8
	.align 8
.LC106:
	.string	"6 32 4 5 gotv4 96 4 5 gotv6 160 16 2 tv 224 128 3 sa4 384 128 3 sa6 544 4097 3 cwd "
	.section	.rodata
	.align 32
.LC107:
	.string	"can't find any valid address"
	.zero	35
	.align 32
.LC108:
	.string	"%s: can't find any valid address\n"
	.zero	62
	.align 32
.LC109:
	.string	"unknown user - '%.80s'"
	.zero	41
	.align 32
.LC110:
	.string	"%s: unknown user - '%s'\n"
	.zero	39
	.align 32
.LC111:
	.string	"/dev/null"
	.zero	54
	.align 32
.LC112:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.zero	61
	.align 32
.LC113:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.zero	56
	.align 32
.LC114:
	.string	"fchown logfile - %m"
	.zero	44
	.align 32
.LC115:
	.string	"fchown logfile"
	.zero	49
	.align 32
.LC116:
	.string	"chdir - %m"
	.zero	53
	.align 32
.LC117:
	.string	"chdir"
	.zero	58
	.align 32
.LC118:
	.string	"/"
	.zero	62
	.align 32
.LC119:
	.string	"daemon - %m"
	.zero	52
	.align 32
.LC120:
	.string	"w"
	.zero	62
	.align 32
.LC121:
	.string	"%d\n"
	.zero	60
	.align 32
.LC122:
	.string	"fdwatch initialization failure"
	.zero	33
	.align 32
.LC123:
	.string	"chroot - %m"
	.zero	52
	.align 32
.LC124:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.zero	54
	.align 32
.LC125:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.zero	49
	.align 32
.LC126:
	.string	"chroot chdir - %m"
	.zero	46
	.align 32
.LC127:
	.string	"chroot chdir"
	.zero	51
	.align 32
.LC128:
	.string	"data_dir chdir - %m"
	.zero	44
	.align 32
.LC129:
	.string	"data_dir chdir"
	.zero	49
	.align 32
.LC130:
	.string	"tmr_create(occasional) failed"
	.zero	34
	.align 32
.LC131:
	.string	"tmr_create(idle) failed"
	.zero	40
	.align 32
.LC132:
	.string	"tmr_create(update_throttles) failed"
	.zero	60
	.align 32
.LC133:
	.string	"tmr_create(show_stats) failed"
	.zero	34
	.align 32
.LC134:
	.string	"setgroups - %m"
	.zero	49
	.align 32
.LC135:
	.string	"setgid - %m"
	.zero	52
	.align 32
.LC136:
	.string	"initgroups - %m"
	.zero	48
	.align 32
.LC137:
	.string	"setuid - %m"
	.zero	52
	.align 32
.LC138:
	.string	"started as root without requesting chroot(), warning only"
	.zero	38
	.align 32
.LC139:
	.string	"out of memory allocating a connecttab"
	.zero	58
	.align 32
.LC140:
	.string	"fdwatch - %m"
	.zero	51
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LASANPC9:
.LFB9:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	%edi, %r14d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movq	%rsi, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$4776, %rsp
	.cfi_def_cfa_offset 4832
	movl	__asan_option_detect_stack_use_after_return(%rip), %edx
	leaq	64(%rsp), %rbx
	testl	%edx, %edx
	jne	.L1926
.L1622:
	movq	%rbx, %rax
	movq	$1102416563, (%rbx)
	movq	$.LC106, 8(%rbx)
	shrq	$3, %rax
	movq	$.LASANPC9, 16(%rbx)
	leaq	4704(%rbx), %rbp
	movl	$-235802127, 2147450880(%rax)
	movl	$-218959356, 2147450884(%rax)
	movl	$-218959118, 2147450888(%rax)
	movl	$-218959356, 2147450892(%rax)
	movl	$-218959118, 2147450896(%rax)
	movl	$-219021312, 2147450900(%rax)
	movl	$-218959118, 2147450904(%rax)
	movl	$-218959118, 2147450924(%rax)
	movl	$-218959118, 2147450944(%rax)
	movl	$-218959359, 2147451460(%rax)
	movl	$-202116109, 2147451464(%rax)
	movq	%r13, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1927
	movq	0(%r13), %r12
	movl	$47, %esi
	leaq	384(%rbx), %r15
	movq	%r12, %rdi
	movq	%r12, argv0(%rip)
	call	strrchr
	leaq	1(%rax), %rdx
	testq	%rax, %rax
	movl	$9, %esi
	cmovne	%rdx, %r12
	movl	$24, %edx
	movq	%r12, %rdi
	call	openlog
	movq	%r13, %rsi
	movl	%r14d, %edi
	leaq	32(%rbx), %r13
	leaq	96(%rbx), %r14
	addq	$224, %rbx
	call	parse_args
	call	tzset
	movq	%r14, %rcx
	movq	%r15, %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	lookup_hostname.constprop.1
	movq	%r13, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1628
	cmpb	$3, %al
	jle	.L1928
.L1628:
	movl	-4672(%rbp), %eax
	testl	%eax, %eax
	jne	.L1629
	movq	%r14, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1630
	cmpb	$3, %al
	jle	.L1929
.L1630:
	cmpl	$0, -4608(%rbp)
	je	.L1930
.L1629:
	movq	throttlefile(%rip), %rdi
	movl	$0, numthrottles(%rip)
	movl	$0, maxthrottles(%rip)
	movq	$0, throttles(%rip)
	testq	%rdi, %rdi
	je	.L1632
	call	read_throttlefile
.L1632:
	call	getuid
	testl	%eax, %eax
	movl	$32767, 20(%rsp)
	movl	$32767, 40(%rsp)
	je	.L1931
.L1633:
	movq	logfile(%rip), %r12
	testq	%r12, %r12
	je	.L1733
	movl	$.LC111, %esi
	movq	%r12, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L1639
	movl	$1, no_log(%rip)
	movq	$0, 8(%rsp)
.L1638:
	movq	dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1647
	call	chdir
	testl	%eax, %eax
	js	.L1932
.L1647:
	leaq	-4160(%rbp), %r12
	movl	$4096, %esi
	movq	%r12, %rdi
	call	getcwd
	movq	%r12, %rdi
	call	strlen
	leaq	-1(%rax), %rdx
	leaq	(%r12,%rdx), %rdi
	movq	%rdi, %rcx
	movq	%rdi, %rsi
	shrq	$3, %rcx
	andl	$7, %esi
	movzbl	2147450880(%rcx), %ecx
	cmpb	%sil, %cl
	jg	.L1648
	testb	%cl, %cl
	jne	.L1933
.L1648:
	cmpb	$47, -4160(%rdx,%rbp)
	je	.L1649
	leaq	(%r12,%rax), %rdi
	movl	$2, %edx
	movl	$.LC118, %esi
	call	memcpy
.L1649:
	cmpl	$0, debug(%rip)
	jne	.L1650
	movl	$stdin, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1934
	movq	stdin(%rip), %rdi
	call	fclose
	movl	$stdout, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1935
	movq	stdout(%rip), %rdi
	cmpq	8(%rsp), %rdi
	je	.L1653
	call	fclose
.L1653:
	movl	$stderr, %eax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1936
	movq	stderr(%rip), %rdi
	call	fclose
	movl	$1, %esi
	movl	$1, %edi
	call	daemon
	testl	%eax, %eax
	movl	$.LC119, %esi
	js	.L1922
.L1655:
	movq	pidfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1656
	movl	$.LC120, %esi
	call	fopen
	testq	%rax, %rax
	je	.L1937
	movq	%rax, 24(%rsp)
	call	getpid
	movq	24(%rsp), %rcx
	movl	%eax, %edx
	movl	$.LC121, %esi
	xorl	%eax, %eax
	movq	%rcx, %rdi
	call	fprintf
	movq	24(%rsp), %rcx
	movq	%rcx, %rdi
	call	fclose
.L1656:
	call	fdwatch_get_nfiles
	testl	%eax, %eax
	movl	%eax, max_connects(%rip)
	js	.L1938
	subl	$10, %eax
	cmpl	$0, do_chroot(%rip)
	movl	%eax, max_connects(%rip)
	jne	.L1939
.L1659:
	movq	data_dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L1664
	call	chdir
	testl	%eax, %eax
	js	.L1940
.L1664:
	movl	$handle_term, %esi
	movl	$15, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_term, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_chld, %esi
	movl	$17, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$1, %esi
	movl	$13, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_hup, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr1, %esi
	movl	$10, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr2, %esi
	movl	$12, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_alrm, %esi
	movl	$14, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$360, %edi
	movl	$0, got_hup(%rip)
	movl	$0, got_usr1(%rip)
	movl	$0, watchdog_flag(%rip)
	call	alarm
	call	tmr_init
	movl	do_global_passwd(%rip), %eax
	movq	%r14, %rdx
	movl	no_empty_referers(%rip), %r11d
	shrq	$3, %rdx
	movq	local_pattern(%rip), %r10
	movq	url_pattern(%rip), %rdi
	movzbl	2147450880(%rdx), %edx
	movl	cgi_limit(%rip), %r9d
	movl	%eax, 24(%rsp)
	movl	do_vhost(%rip), %eax
	movq	cgi_pattern(%rip), %r8
	movzwl	port(%rip), %ecx
	movl	%eax, 32(%rsp)
	movl	no_symlink_check(%rip), %eax
	testb	%dl, %dl
	movl	%eax, 44(%rsp)
	movl	no_log(%rip), %eax
	movl	%eax, 48(%rsp)
	movl	max_age(%rip), %eax
	movl	%eax, 52(%rsp)
	movq	p3p(%rip), %rax
	movq	%rax, 56(%rsp)
	movq	charset(%rip), %rax
	je	.L1665
	cmpb	$3, %dl
	jle	.L1941
.L1665:
	cmpl	$0, -4608(%rbp)
	movl	$0, %edx
	movq	%r13, %rsi
	cmovne	%r15, %rdx
	shrq	$3, %rsi
	movzbl	2147450880(%rsi), %esi
	testb	%sil, %sil
	je	.L1667
	cmpb	$3, %sil
	jle	.L1942
.L1667:
	cmpl	$0, -4672(%rbp)
	movl	$0, %esi
	pushq	%r11
	.cfi_def_cfa_offset 4840
	pushq	%r10
	.cfi_def_cfa_offset 4848
	pushq	%rdi
	.cfi_def_cfa_offset 4856
	movq	hostname(%rip), %rdi
	cmovne	%rbx, %rsi
	movl	48(%rsp), %ebx
	pushq	%rbx
	.cfi_def_cfa_offset 4864
	movl	64(%rsp), %ebx
	pushq	%rbx
	.cfi_def_cfa_offset 4872
	movl	84(%rsp), %ebx
	pushq	%rbx
	.cfi_def_cfa_offset 4880
	pushq	56(%rsp)
	.cfi_def_cfa_offset 4888
	movl	104(%rsp), %ebx
	pushq	%rbx
	.cfi_def_cfa_offset 4896
	pushq	%r12
	.cfi_def_cfa_offset 4904
	movl	124(%rsp), %ebx
	pushq	%rbx
	.cfi_def_cfa_offset 4912
	pushq	136(%rsp)
	.cfi_def_cfa_offset 4920
	pushq	%rax
	.cfi_def_cfa_offset 4928
	call	httpd_initialize
	addq	$96, %rsp
	.cfi_def_cfa_offset 4832
	testq	%rax, %rax
	movq	%rax, hs(%rip)
	je	.L1923
	movl	$JunkClientData, %ebx
	movq	%rbx, %r12
	shrq	$3, %r12
	cmpb	$0, 2147450880(%r12)
	jne	.L1943
	movq	JunkClientData(%rip), %rdx
	movl	$occasional, %esi
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$120000, %ecx
	call	tmr_create
	testq	%rax, %rax
	movl	$.LC130, %esi
	je	.L1924
	cmpb	$0, 2147450880(%r12)
	jne	.L1944
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$5000, %ecx
	movl	$idle, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L1945
	cmpl	$0, numthrottles(%rip)
	jle	.L1674
	cmpb	$0, 2147450880(%r12)
	jne	.L1946
	movq	JunkClientData(%rip), %rdx
	movl	$update_throttles, %esi
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$2000, %ecx
	call	tmr_create
	testq	%rax, %rax
	movl	$.LC132, %esi
	je	.L1924
.L1674:
	shrq	$3, %rbx
	cmpb	$0, 2147450880(%rbx)
	jne	.L1947
	movq	JunkClientData(%rip), %rdx
	movl	$show_stats, %esi
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$3600000, %ecx
	call	tmr_create
	testq	%rax, %rax
	movl	$.LC133, %esi
	je	.L1924
	xorl	%edi, %edi
	call	time
	movq	$0, stats_connections(%rip)
	movq	%rax, stats_time(%rip)
	movq	%rax, start_time(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	call	getuid
	testl	%eax, %eax
	je	.L1948
.L1679:
	movslq	max_connects(%rip), %r12
	movq	%r12, %rbx
	imulq	$144, %r12, %r12
	movq	%r12, %rdi
	call	malloc
	testq	%rax, %rax
	movq	%rax, connects(%rip)
	je	.L1685
	movq	%rax, %rdx
	xorl	%ecx, %ecx
	jmp	.L1686
.L1690:
	movq	%rdx, %rsi
	shrq	$3, %rsi
	movzbl	2147450880(%rsi), %esi
	testb	%sil, %sil
	je	.L1687
	cmpb	$3, %sil
	jle	.L1949
.L1687:
	leaq	4(%rdx), %rdi
	addl	$1, %ecx
	movl	$0, (%rdx)
	movq	%rdi, %rsi
	shrq	$3, %rsi
	movzbl	2147450880(%rsi), %r8d
	movq	%rdi, %rsi
	andl	$7, %esi
	addl	$3, %esi
	cmpb	%r8b, %sil
	jl	.L1688
	testb	%r8b, %r8b
	jne	.L1950
.L1688:
	leaq	8(%rdx), %rdi
	movl	%ecx, 4(%rdx)
	movq	%rdi, %rsi
	shrq	$3, %rsi
	cmpb	$0, 2147450880(%rsi)
	jne	.L1951
	movq	$0, 8(%rdx)
	addq	$144, %rdx
.L1686:
	cmpl	%ecx, %ebx
	jg	.L1690
	leaq	-144(%rax,%r12), %rdx
	leaq	4(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1691
	testb	%cl, %cl
	jne	.L1952
.L1691:
	movq	hs(%rip), %rax
	movl	$-1, 4(%rdx)
	movl	$0, first_free_connect(%rip)
	movl	$0, num_connects(%rip)
	movl	$0, httpd_conn_count(%rip)
	testq	%rax, %rax
	je	.L1693
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1694
	cmpb	$3, %dl
	jle	.L1953
.L1694:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1695
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
	movq	hs(%rip), %rax
.L1695:
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1696
	testb	%cl, %cl
	jne	.L1954
.L1696:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1693
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
.L1693:
	subq	$4544, %rbp
	movq	%rbp, %rdi
	call	tmr_prepare_timeval
.L1698:
	cmpl	$0, terminate(%rip)
	je	.L1731
	cmpl	$0, num_connects(%rip)
	jle	.L1955
.L1731:
	movl	got_hup(%rip), %eax
	testl	%eax, %eax
	jne	.L1956
.L1699:
	movq	%rbp, %rdi
	call	tmr_mstimeout
	movq	%rax, %rdi
	call	fdwatch
	testl	%eax, %eax
	movl	%eax, %ebx
	jns	.L1700
	call	__errno_location
	movq	%rax, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rax, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1701
	testb	%cl, %cl
	jne	.L1957
.L1701:
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L1698
	cmpl	$11, %eax
	je	.L1698
	movl	$.LC140, %esi
	movl	$3, %edi
	jmp	.L1925
.L1639:
	movl	$.LC82, %esi
	movq	%r12, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L1640
	movl	$stdout, %eax
	movq	stdout(%rip), %rcx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	movq	%rcx, 8(%rsp)
	je	.L1638
	movl	$stdout, %edi
	call	__asan_report_load8
.L1938:
	movl	$.LC122, %esi
.L1922:
	movl	$2, %edi
.L1925:
	xorl	%eax, %eax
	call	syslog
.L1923:
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1650:
	call	setsid
	jmp	.L1655
.L1931:
	movq	user(%rip), %rdi
	call	getpwnam
	testq	%rax, %rax
	je	.L1958
	leaq	16(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1636
	cmpb	$3, %dl
	jle	.L1959
.L1636:
	leaq	20(%rax), %rdi
	movl	16(%rax), %ecx
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movl	%ecx, 40(%rsp)
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1637
	testb	%cl, %cl
	jne	.L1960
.L1637:
	movl	20(%rax), %eax
	movl	%eax, 20(%rsp)
	jmp	.L1633
.L1733:
	movq	$0, 8(%rsp)
	jmp	.L1638
.L1930:
	xorl	%eax, %eax
	movl	$.LC107, %esi
	movl	$3, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1961
	movq	stderr(%rip), %rdi
	movl	$.LC108, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1640:
	movq	%r12, %rdi
	movl	$.LC84, %esi
	call	fopen
	movq	logfile(%rip), %r12
	movl	$384, %esi
	movq	%rax, 8(%rsp)
	movq	%r12, %rdi
	call	chmod
	cmpq	$0, 8(%rsp)
	je	.L1736
	testl	%eax, %eax
	jne	.L1736
	movq	%r12, %rax
	movq	%r12, %rdx
	shrq	$3, %rax
	andl	$7, %edx
	movzbl	2147450880(%rax), %eax
	cmpb	%dl, %al
	jg	.L1644
	testb	%al, %al
	je	.L1644
	movq	%r12, %rdi
	call	__asan_report_load1
.L1644:
	cmpb	$47, (%r12)
	jne	.L1962
.L1645:
	movq	8(%rsp), %rdi
	call	fileno
	movl	$1, %edx
	movl	%eax, %edi
	movl	$2, %esi
	xorl	%eax, %eax
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L1638
	movq	8(%rsp), %rdi
	call	fileno
	movl	20(%rsp), %edx
	movl	40(%rsp), %esi
	movl	%eax, %edi
	call	fchown
	testl	%eax, %eax
	jns	.L1638
	movl	$.LC114, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC115, %edi
	call	perror
	jmp	.L1638
.L1937:
	movq	pidfile(%rip), %rdx
	movl	$2, %edi
	movl	$.LC74, %esi
	xorl	%eax, %eax
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1945:
	movl	$.LC131, %esi
.L1924:
	movl	$2, %edi
	call	syslog
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1939:
	movq	%r12, %rdi
	call	chroot
	testl	%eax, %eax
	js	.L1963
	movq	logfile(%rip), %rcx
	testq	%rcx, %rcx
	je	.L1661
	movl	$.LC82, %esi
	movq	%rcx, %rdi
	movq	%rcx, 24(%rsp)
	call	strcmp
	testl	%eax, %eax
	je	.L1661
	movq	%r12, %rdi
	call	strlen
	movq	24(%rsp), %rcx
	movq	%rax, %rdx
	movq	%r12, %rsi
	movq	%rax, 32(%rsp)
	movq	%rcx, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L1662
	movq	24(%rsp), %rcx
	movq	32(%rsp), %r8
	leaq	-1(%rcx,%r8), %rsi
	movq	%rcx, %rdi
	call	strcpy
.L1661:
	movl	$2, %edx
	movl	$.LC118, %esi
	movq	%r12, %rdi
	call	memcpy
	movq	%r12, %rdi
	call	chdir
	testl	%eax, %eax
	jns	.L1659
	movl	$.LC126, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC127, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1932:
	movl	$.LC116, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC117, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1940:
	movl	$.LC128, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC129, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1948:
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	setgroups
	testl	%eax, %eax
	movl	$.LC134, %esi
	js	.L1922
	movl	20(%rsp), %edi
	call	setgid
	testl	%eax, %eax
	movl	$.LC135, %esi
	js	.L1922
	movl	20(%rsp), %esi
	movq	user(%rip), %rdi
	call	initgroups
	testl	%eax, %eax
	js	.L1964
.L1682:
	movl	40(%rsp), %edi
	call	setuid
	testl	%eax, %eax
	movl	$.LC137, %esi
	js	.L1922
	cmpl	$0, do_chroot(%rip)
	jne	.L1679
	movl	$.LC138, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1679
.L1962:
	xorl	%eax, %eax
	movl	$.LC112, %esi
	movl	$4, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1965
	movq	stderr(%rip), %rdi
	movl	$.LC113, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L1645
.L1928:
	movq	%r13, %rdi
	call	__asan_report_load4
.L1929:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1942:
	movq	%r13, %rdi
	call	__asan_report_load4
.L1960:
	call	__asan_report_load4
.L1959:
	call	__asan_report_load4
.L1941:
	movq	%r14, %rdi
	call	__asan_report_load4
.L1700:
	movq	%rbp, %rdi
	call	tmr_prepare_timeval
	testl	%ebx, %ebx
	je	.L1966
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L1717
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1708
	testb	%cl, %cl
	jne	.L1967
.L1708:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1709
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L1710
.L1714:
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L1717
.L1709:
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1715
	cmpb	$3, %dl
	jle	.L1968
.L1715:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1717
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L1717
	movq	hs(%rip), %rax
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1716
	cmpb	$3, %dl
	jle	.L1969
.L1716:
	movl	72(%rax), %esi
	movq	%rbp, %rdi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L1698
.L1717:
	call	fdwatch_get_next_client_data
	cmpq	$-1, %rax
	movq	%rax, %rbx
	je	.L1970
	testq	%rbx, %rbx
	je	.L1717
	leaq	8(%rbx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1971
	movq	8(%rbx), %rax
	leaq	704(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1719
	cmpb	$3, %dl
	jle	.L1972
.L1719:
	movl	704(%rax), %edi
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L1973
	movq	%rbx, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %eax
	testb	%al, %al
	je	.L1722
	cmpb	$3, %al
	jle	.L1974
.L1722:
	movl	(%rbx), %eax
	cmpl	$2, %eax
	je	.L1723
	cmpl	$4, %eax
	je	.L1724
	subl	$1, %eax
	jne	.L1717
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	handle_read
	jmp	.L1717
.L1973:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L1717
.L1958:
	movq	user(%rip), %rdx
	movl	$.LC109, %esi
	movl	$2, %edi
	call	syslog
	movl	$stderr, %eax
	movq	user(%rip), %rcx
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1975
	movq	stderr(%rip), %rdi
	movl	$.LC110, %esi
	xorl	%eax, %eax
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1956:
	call	re_open_logfile
	movl	$0, got_hup(%rip)
	jmp	.L1699
.L1970:
	movq	%rbp, %rdi
	call	tmr_run
	movl	got_usr1(%rip), %eax
	testl	%eax, %eax
	je	.L1698
	cmpl	$0, terminate(%rip)
	jne	.L1698
	movq	hs(%rip), %rax
	movl	$1, terminate(%rip)
	testq	%rax, %rax
	je	.L1698
	leaq	72(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %edx
	testb	%dl, %dl
	je	.L1727
	cmpb	$3, %dl
	jle	.L1976
.L1727:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L1728
	call	fdwatch_del_fd
	movq	hs(%rip), %rax
.L1728:
	leaq	76(%rax), %rdi
	movq	%rdi, %rdx
	shrq	$3, %rdx
	movzbl	2147450880(%rdx), %ecx
	movq	%rdi, %rdx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jl	.L1729
	testb	%cl, %cl
	jne	.L1977
.L1729:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L1730
	call	fdwatch_del_fd
.L1730:
	movq	hs(%rip), %rdi
	call	httpd_unlisten
	jmp	.L1698
.L1736:
	movq	%r12, %rdx
	movl	$.LC74, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movq	logfile(%rip), %rdi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1963:
	movl	$.LC123, %esi
	xorl	%eax, %eax
	movl	$2, %edi
	call	syslog
	movl	$.LC20, %edi
	call	perror
	call	__asan_handle_no_return
	movl	$1, %edi
	call	exit
.L1724:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	handle_linger
	jmp	.L1717
.L1723:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	handle_send
	jmp	.L1717
.L1662:
	xorl	%eax, %eax
	movl	$.LC124, %esi
	movl	$4, %edi
	call	syslog
	movl	$stderr, %eax
	movq	argv0(%rip), %rdx
	shrq	$3, %rax
	cmpb	$0, 2147450880(%rax)
	jne	.L1978
	movq	stderr(%rip), %rdi
	movl	$.LC125, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L1661
.L1966:
	movq	%rbp, %rdi
	call	tmr_run
	jmp	.L1698
.L1685:
	movl	$.LC139, %esi
	jmp	.L1922
.L1710:
	movq	hs(%rip), %rdx
	leaq	76(%rdx), %rdi
	movq	%rdi, %rax
	shrq	$3, %rax
	movzbl	2147450880(%rax), %ecx
	movq	%rdi, %rax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jl	.L1712
	testb	%cl, %cl
	jne	.L1979
.L1712:
	movl	76(%rdx), %esi
	movq	%rbp, %rdi
	call	handle_newconnect
	testl	%eax, %eax
	je	.L1714
	jmp	.L1698
.L1955:
	call	shut_down
	movl	$5, %edi
	movl	$.LC90, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	xorl	%edi, %edi
	call	exit
.L1964:
	movl	$.LC136, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L1682
.L1926:
	movl	$4704, %edi
	call	__asan_stack_malloc_7
	testq	%rax, %rax
	cmovne	%rax, %rbx
	jmp	.L1622
.L1927:
	movq	%r13, %rdi
	call	__asan_report_load8
.L1977:
	call	__asan_report_load4
.L1949:
	movq	%rdx, %rdi
	call	__asan_report_store4
.L1951:
	call	__asan_report_store8
.L1950:
	call	__asan_report_store4
.L1954:
	call	__asan_report_load4
.L1944:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L1947:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L1946:
	movl	$JunkClientData, %edi
	call	__asan_report_load8
.L1968:
	call	__asan_report_load4
.L1969:
	call	__asan_report_load4
.L1967:
	call	__asan_report_load4
.L1978:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1952:
	call	__asan_report_store4
.L1953:
	call	__asan_report_load4
.L1936:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1935:
	movl	$stdout, %edi
	call	__asan_report_load8
.L1961:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1943:
	movq	%rbx, %rdi
	call	__asan_report_load8
.L1933:
	call	__asan_report_load1
.L1934:
	movl	$stdin, %edi
	call	__asan_report_load8
.L1971:
	call	__asan_report_load8
.L1976:
	call	__asan_report_load4
.L1974:
	movq	%rbx, %rdi
	call	__asan_report_load4
.L1965:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1957:
	movq	%rax, %rdi
	call	__asan_report_load4
.L1975:
	movl	$stderr, %edi
	call	__asan_report_load8
.L1972:
	call	__asan_report_load4
.L1979:
	call	__asan_report_load4
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.bss
	.align 32
	.type	watchdog_flag, @object
	.size	watchdog_flag, 4
watchdog_flag:
	.zero	64
	.align 32
	.type	got_usr1, @object
	.size	got_usr1, 4
got_usr1:
	.zero	64
	.align 32
	.type	got_hup, @object
	.size	got_hup, 4
got_hup:
	.zero	64
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,8,8
	.comm	stats_connections,8,8
	.comm	stats_time,8,8
	.comm	start_time,8,8
	.globl	terminate
	.align 32
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	64
	.align 32
	.type	hs, @object
	.size	hs, 8
hs:
	.zero	64
	.align 32
	.type	httpd_conn_count, @object
	.size	httpd_conn_count, 4
httpd_conn_count:
	.zero	64
	.align 32
	.type	first_free_connect, @object
	.size	first_free_connect, 4
first_free_connect:
	.zero	64
	.align 32
	.type	max_connects, @object
	.size	max_connects, 4
max_connects:
	.zero	64
	.align 32
	.type	num_connects, @object
	.size	num_connects, 4
num_connects:
	.zero	64
	.align 32
	.type	connects, @object
	.size	connects, 8
connects:
	.zero	64
	.align 32
	.type	maxthrottles, @object
	.size	maxthrottles, 4
maxthrottles:
	.zero	64
	.align 32
	.type	numthrottles, @object
	.size	numthrottles, 4
numthrottles:
	.zero	64
	.align 32
	.type	throttles, @object
	.size	throttles, 8
throttles:
	.zero	64
	.align 32
	.type	max_age, @object
	.size	max_age, 4
max_age:
	.zero	64
	.align 32
	.type	p3p, @object
	.size	p3p, 8
p3p:
	.zero	64
	.align 32
	.type	charset, @object
	.size	charset, 8
charset:
	.zero	64
	.align 32
	.type	user, @object
	.size	user, 8
user:
	.zero	64
	.align 32
	.type	pidfile, @object
	.size	pidfile, 8
pidfile:
	.zero	64
	.align 32
	.type	hostname, @object
	.size	hostname, 8
hostname:
	.zero	64
	.align 32
	.type	throttlefile, @object
	.size	throttlefile, 8
throttlefile:
	.zero	64
	.align 32
	.type	logfile, @object
	.size	logfile, 8
logfile:
	.zero	64
	.align 32
	.type	local_pattern, @object
	.size	local_pattern, 8
local_pattern:
	.zero	64
	.align 32
	.type	no_empty_referers, @object
	.size	no_empty_referers, 4
no_empty_referers:
	.zero	64
	.align 32
	.type	url_pattern, @object
	.size	url_pattern, 8
url_pattern:
	.zero	64
	.align 32
	.type	cgi_limit, @object
	.size	cgi_limit, 4
cgi_limit:
	.zero	64
	.align 32
	.type	cgi_pattern, @object
	.size	cgi_pattern, 8
cgi_pattern:
	.zero	64
	.align 32
	.type	do_global_passwd, @object
	.size	do_global_passwd, 4
do_global_passwd:
	.zero	64
	.align 32
	.type	do_vhost, @object
	.size	do_vhost, 4
do_vhost:
	.zero	64
	.align 32
	.type	no_symlink_check, @object
	.size	no_symlink_check, 4
no_symlink_check:
	.zero	64
	.align 32
	.type	no_log, @object
	.size	no_log, 4
no_log:
	.zero	64
	.align 32
	.type	do_chroot, @object
	.size	do_chroot, 4
do_chroot:
	.zero	64
	.align 32
	.type	data_dir, @object
	.size	data_dir, 8
data_dir:
	.zero	64
	.align 32
	.type	dir, @object
	.size	dir, 8
dir:
	.zero	64
	.align 32
	.type	port, @object
	.size	port, 2
port:
	.zero	64
	.align 32
	.type	debug, @object
	.size	debug, 4
debug:
	.zero	64
	.align 32
	.type	argv0, @object
	.size	argv0, 8
argv0:
	.zero	64
	.section	.rodata.str1.1
.LC141:
	.string	"thttpd.c"
	.data
	.align 16
	.type	.LASANLOC1, @object
	.size	.LASANLOC1, 16
.LASANLOC1:
	.quad	.LC141
	.long	135
	.long	40
	.align 16
	.type	.LASANLOC2, @object
	.size	.LASANLOC2, 16
.LASANLOC2:
	.quad	.LC141
	.long	135
	.long	30
	.align 16
	.type	.LASANLOC3, @object
	.size	.LASANLOC3, 16
.LASANLOC3:
	.quad	.LC141
	.long	135
	.long	21
	.globl	__odr_asan.terminate
	.bss
	.type	__odr_asan.terminate, @object
	.size	__odr_asan.terminate, 1
__odr_asan.terminate:
	.zero	1
	.data
	.align 16
	.type	.LASANLOC4, @object
	.size	.LASANLOC4, 16
.LASANLOC4:
	.quad	.LC141
	.long	129
	.long	5
	.align 16
	.type	.LASANLOC5, @object
	.size	.LASANLOC5, 16
.LASANLOC5:
	.quad	.LC141
	.long	128
	.long	22
	.align 16
	.type	.LASANLOC6, @object
	.size	.LASANLOC6, 16
.LASANLOC6:
	.quad	.LC141
	.long	118
	.long	12
	.align 16
	.type	.LASANLOC7, @object
	.size	.LASANLOC7, 16
.LASANLOC7:
	.quad	.LC141
	.long	117
	.long	40
	.align 16
	.type	.LASANLOC8, @object
	.size	.LASANLOC8, 16
.LASANLOC8:
	.quad	.LC141
	.long	117
	.long	26
	.align 16
	.type	.LASANLOC9, @object
	.size	.LASANLOC9, 16
.LASANLOC9:
	.quad	.LC141
	.long	117
	.long	12
	.align 16
	.type	.LASANLOC10, @object
	.size	.LASANLOC10, 16
.LASANLOC10:
	.quad	.LC141
	.long	116
	.long	20
	.align 16
	.type	.LASANLOC11, @object
	.size	.LASANLOC11, 16
.LASANLOC11:
	.quad	.LC141
	.long	96
	.long	26
	.align 16
	.type	.LASANLOC12, @object
	.size	.LASANLOC12, 16
.LASANLOC12:
	.quad	.LC141
	.long	96
	.long	12
	.align 16
	.type	.LASANLOC13, @object
	.size	.LASANLOC13, 16
.LASANLOC13:
	.quad	.LC141
	.long	95
	.long	21
	.align 16
	.type	.LASANLOC14, @object
	.size	.LASANLOC14, 16
.LASANLOC14:
	.quad	.LC141
	.long	85
	.long	12
	.align 16
	.type	.LASANLOC15, @object
	.size	.LASANLOC15, 16
.LASANLOC15:
	.quad	.LC141
	.long	84
	.long	14
	.align 16
	.type	.LASANLOC16, @object
	.size	.LASANLOC16, 16
.LASANLOC16:
	.quad	.LC141
	.long	83
	.long	14
	.align 16
	.type	.LASANLOC17, @object
	.size	.LASANLOC17, 16
.LASANLOC17:
	.quad	.LC141
	.long	82
	.long	14
	.align 16
	.type	.LASANLOC18, @object
	.size	.LASANLOC18, 16
.LASANLOC18:
	.quad	.LC141
	.long	81
	.long	14
	.align 16
	.type	.LASANLOC19, @object
	.size	.LASANLOC19, 16
.LASANLOC19:
	.quad	.LC141
	.long	80
	.long	14
	.align 16
	.type	.LASANLOC20, @object
	.size	.LASANLOC20, 16
.LASANLOC20:
	.quad	.LC141
	.long	79
	.long	14
	.align 16
	.type	.LASANLOC21, @object
	.size	.LASANLOC21, 16
.LASANLOC21:
	.quad	.LC141
	.long	78
	.long	14
	.align 16
	.type	.LASANLOC22, @object
	.size	.LASANLOC22, 16
.LASANLOC22:
	.quad	.LC141
	.long	77
	.long	14
	.align 16
	.type	.LASANLOC23, @object
	.size	.LASANLOC23, 16
.LASANLOC23:
	.quad	.LC141
	.long	76
	.long	12
	.align 16
	.type	.LASANLOC24, @object
	.size	.LASANLOC24, 16
.LASANLOC24:
	.quad	.LC141
	.long	75
	.long	14
	.align 16
	.type	.LASANLOC25, @object
	.size	.LASANLOC25, 16
.LASANLOC25:
	.quad	.LC141
	.long	74
	.long	12
	.align 16
	.type	.LASANLOC26, @object
	.size	.LASANLOC26, 16
.LASANLOC26:
	.quad	.LC141
	.long	73
	.long	14
	.align 16
	.type	.LASANLOC27, @object
	.size	.LASANLOC27, 16
.LASANLOC27:
	.quad	.LC141
	.long	72
	.long	59
	.align 16
	.type	.LASANLOC28, @object
	.size	.LASANLOC28, 16
.LASANLOC28:
	.quad	.LC141
	.long	72
	.long	49
	.align 16
	.type	.LASANLOC29, @object
	.size	.LASANLOC29, 16
.LASANLOC29:
	.quad	.LC141
	.long	72
	.long	31
	.align 16
	.type	.LASANLOC30, @object
	.size	.LASANLOC30, 16
.LASANLOC30:
	.quad	.LC141
	.long	72
	.long	23
	.align 16
	.type	.LASANLOC31, @object
	.size	.LASANLOC31, 16
.LASANLOC31:
	.quad	.LC141
	.long	72
	.long	12
	.align 16
	.type	.LASANLOC32, @object
	.size	.LASANLOC32, 16
.LASANLOC32:
	.quad	.LC141
	.long	71
	.long	14
	.align 16
	.type	.LASANLOC33, @object
	.size	.LASANLOC33, 16
.LASANLOC33:
	.quad	.LC141
	.long	70
	.long	14
	.align 16
	.type	.LASANLOC34, @object
	.size	.LASANLOC34, 16
.LASANLOC34:
	.quad	.LC141
	.long	69
	.long	23
	.align 16
	.type	.LASANLOC35, @object
	.size	.LASANLOC35, 16
.LASANLOC35:
	.quad	.LC141
	.long	68
	.long	12
	.align 16
	.type	.LASANLOC36, @object
	.size	.LASANLOC36, 16
.LASANLOC36:
	.quad	.LC141
	.long	67
	.long	14
	.section	.rodata.str1.1
.LC142:
	.string	"watchdog_flag"
.LC143:
	.string	"got_usr1"
.LC144:
	.string	"got_hup"
.LC145:
	.string	"terminate"
.LC146:
	.string	"hs"
.LC147:
	.string	"httpd_conn_count"
.LC148:
	.string	"first_free_connect"
.LC149:
	.string	"max_connects"
.LC150:
	.string	"num_connects"
.LC151:
	.string	"connects"
.LC152:
	.string	"maxthrottles"
.LC153:
	.string	"numthrottles"
.LC154:
	.string	"hostname"
.LC155:
	.string	"throttlefile"
.LC156:
	.string	"local_pattern"
.LC157:
	.string	"no_empty_referers"
.LC158:
	.string	"url_pattern"
.LC159:
	.string	"cgi_limit"
.LC160:
	.string	"cgi_pattern"
.LC161:
	.string	"do_global_passwd"
.LC162:
	.string	"do_vhost"
.LC163:
	.string	"no_symlink_check"
.LC164:
	.string	"no_log"
.LC165:
	.string	"do_chroot"
.LC166:
	.string	"argv0"
.LC167:
	.string	"*.LC95"
.LC168:
	.string	"*.LC116"
.LC169:
	.string	"*.LC38"
.LC170:
	.string	"*.LC83"
.LC171:
	.string	"*.LC136"
.LC172:
	.string	"*.LC79"
.LC173:
	.string	"*.LC80"
.LC174:
	.string	"*.LC1"
.LC175:
	.string	"*.LC128"
.LC176:
	.string	"*.LC131"
.LC177:
	.string	"*.LC69"
.LC178:
	.string	"*.LC34"
.LC179:
	.string	"*.LC60"
.LC180:
	.string	"*.LC76"
.LC181:
	.string	"*.LC62"
.LC182:
	.string	"*.LC82"
.LC183:
	.string	"*.LC54"
.LC184:
	.string	"*.LC123"
.LC185:
	.string	"*.LC129"
.LC186:
	.string	"*.LC35"
.LC187:
	.string	"*.LC20"
.LC188:
	.string	"*.LC31"
.LC189:
	.string	"*.LC135"
.LC190:
	.string	"*.LC55"
.LC191:
	.string	"*.LC44"
.LC192:
	.string	"*.LC103"
.LC193:
	.string	"*.LC28"
.LC194:
	.string	"*.LC6"
.LC195:
	.string	"*.LC3"
.LC196:
	.string	"*.LC107"
.LC197:
	.string	"*.LC105"
.LC198:
	.string	"*.LC75"
.LC199:
	.string	"*.LC77"
.LC200:
	.string	"*.LC115"
.LC201:
	.string	"*.LC30"
.LC202:
	.string	"*.LC39"
.LC203:
	.string	"*.LC49"
.LC204:
	.string	"*.LC56"
.LC205:
	.string	"*.LC40"
.LC206:
	.string	"*.LC118"
.LC207:
	.string	"*.LC61"
.LC208:
	.string	"*.LC29"
.LC209:
	.string	"*.LC0"
.LC210:
	.string	"*.LC84"
.LC211:
	.string	"*.LC137"
.LC212:
	.string	"*.LC121"
.LC213:
	.string	"*.LC11"
.LC214:
	.string	"*.LC46"
.LC215:
	.string	"*.LC47"
.LC216:
	.string	"*.LC102"
.LC217:
	.string	"*.LC127"
.LC218:
	.string	"*.LC42"
.LC219:
	.string	"*.LC98"
.LC220:
	.string	"*.LC18"
.LC221:
	.string	"*.LC24"
.LC222:
	.string	"*.LC126"
.LC223:
	.string	"*.LC109"
.LC224:
	.string	"*.LC110"
.LC225:
	.string	"*.LC140"
.LC226:
	.string	"*.LC19"
.LC227:
	.string	"*.LC50"
.LC228:
	.string	"*.LC72"
.LC229:
	.string	"*.LC88"
.LC230:
	.string	"*.LC66"
.LC231:
	.string	"*.LC63"
.LC232:
	.string	"*.LC64"
.LC233:
	.string	"*.LC113"
.LC234:
	.string	"*.LC15"
.LC235:
	.string	"*.LC120"
.LC236:
	.string	"*.LC119"
.LC237:
	.string	"*.LC78"
.LC238:
	.string	"*.LC122"
.LC239:
	.string	"*.LC4"
.LC240:
	.string	"*.LC124"
.LC241:
	.string	"*.LC16"
.LC242:
	.string	"*.LC67"
.LC243:
	.string	"*.LC21"
.LC244:
	.string	"*.LC41"
.LC245:
	.string	"*.LC65"
.LC246:
	.string	"*.LC25"
.LC247:
	.string	"*.LC85"
.LC248:
	.string	"*.LC32"
.LC249:
	.string	"*.LC48"
.LC250:
	.string	"*.LC117"
.LC251:
	.string	"*.LC125"
.LC252:
	.string	"*.LC104"
.LC253:
	.string	"*.LC99"
.LC254:
	.string	"*.LC138"
.LC255:
	.string	"*.LC94"
.LC256:
	.string	"*.LC74"
.LC257:
	.string	"*.LC8"
.LC258:
	.string	"*.LC133"
.LC259:
	.string	"*.LC70"
.LC260:
	.string	"*.LC81"
.LC261:
	.string	"*.LC53"
.LC262:
	.string	"*.LC68"
.LC263:
	.string	"*.LC57"
.LC264:
	.string	"*.LC134"
.LC265:
	.string	"*.LC89"
.LC266:
	.string	"*.LC139"
.LC267:
	.string	"*.LC2"
.LC268:
	.string	"*.LC92"
.LC269:
	.string	"*.LC5"
.LC270:
	.string	"*.LC93"
.LC271:
	.string	"*.LC132"
.LC272:
	.string	"*.LC97"
.LC273:
	.string	"*.LC90"
.LC274:
	.string	"*.LC22"
.LC275:
	.string	"*.LC58"
.LC276:
	.string	"*.LC9"
.LC277:
	.string	"*.LC114"
.LC278:
	.string	"*.LC111"
.LC279:
	.string	"*.LC86"
.LC280:
	.string	"*.LC33"
.LC281:
	.string	"*.LC130"
.LC282:
	.string	"*.LC43"
.LC283:
	.string	"*.LC26"
.LC284:
	.string	"*.LC87"
.LC285:
	.string	"*.LC91"
.LC286:
	.string	"*.LC51"
.LC287:
	.string	"*.LC71"
.LC288:
	.string	"*.LC37"
.LC289:
	.string	"*.LC52"
.LC290:
	.string	"*.LC59"
.LC291:
	.string	"*.LC36"
.LC292:
	.string	"*.LC27"
.LC293:
	.string	"*.LC12"
.LC294:
	.string	"*.LC13"
.LC295:
	.string	"*.LC108"
.LC296:
	.string	"*.LC23"
.LC297:
	.string	"*.LC112"
.LC298:
	.string	"*.LC17"
	.data
	.align 32
	.type	.LASAN0, @object
	.size	.LASAN0, 10752
.LASAN0:
	.quad	watchdog_flag
	.quad	4
	.quad	64
	.quad	.LC142
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC1
	.quad	0
	.quad	got_usr1
	.quad	4
	.quad	64
	.quad	.LC143
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC2
	.quad	0
	.quad	got_hup
	.quad	4
	.quad	64
	.quad	.LC144
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC3
	.quad	0
	.quad	terminate
	.quad	4
	.quad	64
	.quad	.LC145
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC4
	.quad	__odr_asan.terminate
	.quad	hs
	.quad	8
	.quad	64
	.quad	.LC146
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC5
	.quad	0
	.quad	httpd_conn_count
	.quad	4
	.quad	64
	.quad	.LC147
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC6
	.quad	0
	.quad	first_free_connect
	.quad	4
	.quad	64
	.quad	.LC148
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC7
	.quad	0
	.quad	max_connects
	.quad	4
	.quad	64
	.quad	.LC149
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC8
	.quad	0
	.quad	num_connects
	.quad	4
	.quad	64
	.quad	.LC150
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC9
	.quad	0
	.quad	connects
	.quad	8
	.quad	64
	.quad	.LC151
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC10
	.quad	0
	.quad	maxthrottles
	.quad	4
	.quad	64
	.quad	.LC152
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC11
	.quad	0
	.quad	numthrottles
	.quad	4
	.quad	64
	.quad	.LC153
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC12
	.quad	0
	.quad	throttles
	.quad	8
	.quad	64
	.quad	.LC33
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC13
	.quad	0
	.quad	max_age
	.quad	4
	.quad	64
	.quad	.LC43
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC14
	.quad	0
	.quad	p3p
	.quad	8
	.quad	64
	.quad	.LC42
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC15
	.quad	0
	.quad	charset
	.quad	8
	.quad	64
	.quad	.LC41
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC16
	.quad	0
	.quad	user
	.quad	8
	.quad	64
	.quad	.LC27
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC17
	.quad	0
	.quad	pidfile
	.quad	8
	.quad	64
	.quad	.LC40
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC18
	.quad	0
	.quad	hostname
	.quad	8
	.quad	64
	.quad	.LC154
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC19
	.quad	0
	.quad	throttlefile
	.quad	8
	.quad	64
	.quad	.LC155
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC20
	.quad	0
	.quad	logfile
	.quad	8
	.quad	64
	.quad	.LC35
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC21
	.quad	0
	.quad	local_pattern
	.quad	8
	.quad	64
	.quad	.LC156
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC22
	.quad	0
	.quad	no_empty_referers
	.quad	4
	.quad	64
	.quad	.LC157
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC23
	.quad	0
	.quad	url_pattern
	.quad	8
	.quad	64
	.quad	.LC158
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC24
	.quad	0
	.quad	cgi_limit
	.quad	4
	.quad	64
	.quad	.LC159
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC25
	.quad	0
	.quad	cgi_pattern
	.quad	8
	.quad	64
	.quad	.LC160
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC26
	.quad	0
	.quad	do_global_passwd
	.quad	4
	.quad	64
	.quad	.LC161
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC27
	.quad	0
	.quad	do_vhost
	.quad	4
	.quad	64
	.quad	.LC162
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC28
	.quad	0
	.quad	no_symlink_check
	.quad	4
	.quad	64
	.quad	.LC163
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC29
	.quad	0
	.quad	no_log
	.quad	4
	.quad	64
	.quad	.LC164
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC30
	.quad	0
	.quad	do_chroot
	.quad	4
	.quad	64
	.quad	.LC165
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC31
	.quad	0
	.quad	data_dir
	.quad	8
	.quad	64
	.quad	.LC22
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC32
	.quad	0
	.quad	dir
	.quad	8
	.quad	64
	.quad	.LC19
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC33
	.quad	0
	.quad	port
	.quad	2
	.quad	64
	.quad	.LC18
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC34
	.quad	0
	.quad	debug
	.quad	4
	.quad	64
	.quad	.LC17
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC35
	.quad	0
	.quad	argv0
	.quad	8
	.quad	64
	.quad	.LC166
	.quad	.LC141
	.quad	0
	.quad	.LASANLOC36
	.quad	0
	.quad	.LC95
	.quad	35
	.quad	96
	.quad	.LC167
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC116
	.quad	11
	.quad	64
	.quad	.LC168
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC38
	.quad	13
	.quad	64
	.quad	.LC169
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC83
	.quad	19
	.quad	64
	.quad	.LC170
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC136
	.quad	16
	.quad	64
	.quad	.LC171
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC79
	.quad	3
	.quad	64
	.quad	.LC172
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC80
	.quad	39
	.quad	96
	.quad	.LC173
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC1
	.quad	70
	.quad	128
	.quad	.LC174
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC128
	.quad	20
	.quad	64
	.quad	.LC175
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC131
	.quad	24
	.quad	64
	.quad	.LC176
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC69
	.quad	3
	.quad	64
	.quad	.LC177
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC34
	.quad	5
	.quad	64
	.quad	.LC178
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC60
	.quad	3
	.quad	64
	.quad	.LC179
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC76
	.quad	16
	.quad	64
	.quad	.LC180
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC62
	.quad	3
	.quad	64
	.quad	.LC181
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC82
	.quad	2
	.quad	64
	.quad	.LC182
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC54
	.quad	3
	.quad	64
	.quad	.LC183
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC123
	.quad	12
	.quad	64
	.quad	.LC184
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC129
	.quad	15
	.quad	64
	.quad	.LC185
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC35
	.quad	8
	.quad	64
	.quad	.LC186
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC20
	.quad	7
	.quad	64
	.quad	.LC187
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC31
	.quad	16
	.quad	64
	.quad	.LC188
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC135
	.quad	12
	.quad	64
	.quad	.LC189
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC55
	.quad	5
	.quad	64
	.quad	.LC190
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC44
	.quad	32
	.quad	64
	.quad	.LC191
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC103
	.quad	26
	.quad	64
	.quad	.LC192
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC28
	.quad	7
	.quad	64
	.quad	.LC193
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC6
	.quad	219
	.quad	256
	.quad	.LC194
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC3
	.quad	65
	.quad	128
	.quad	.LC195
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC107
	.quad	29
	.quad	64
	.quad	.LC196
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC105
	.quad	39
	.quad	96
	.quad	.LC197
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC75
	.quad	20
	.quad	64
	.quad	.LC198
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC77
	.quad	33
	.quad	96
	.quad	.LC199
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC115
	.quad	15
	.quad	64
	.quad	.LC200
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC30
	.quad	7
	.quad	64
	.quad	.LC201
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC39
	.quad	15
	.quad	64
	.quad	.LC202
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC49
	.quad	3
	.quad	64
	.quad	.LC203
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC56
	.quad	4
	.quad	64
	.quad	.LC204
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC40
	.quad	8
	.quad	64
	.quad	.LC205
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC118
	.quad	2
	.quad	64
	.quad	.LC206
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC61
	.quad	3
	.quad	64
	.quad	.LC207
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC29
	.quad	9
	.quad	64
	.quad	.LC208
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC0
	.quad	104
	.quad	160
	.quad	.LC209
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC84
	.quad	2
	.quad	64
	.quad	.LC210
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC137
	.quad	12
	.quad	64
	.quad	.LC211
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC121
	.quad	4
	.quad	64
	.quad	.LC212
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC11
	.quad	16
	.quad	64
	.quad	.LC213
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC46
	.quad	7
	.quad	64
	.quad	.LC214
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC47
	.quad	11
	.quad	64
	.quad	.LC215
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC102
	.quad	3
	.quad	64
	.quad	.LC216
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC127
	.quad	13
	.quad	64
	.quad	.LC217
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC42
	.quad	4
	.quad	64
	.quad	.LC218
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC98
	.quad	37
	.quad	96
	.quad	.LC219
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC18
	.quad	5
	.quad	64
	.quad	.LC220
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC24
	.quad	10
	.quad	64
	.quad	.LC221
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC126
	.quad	18
	.quad	64
	.quad	.LC222
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC109
	.quad	23
	.quad	64
	.quad	.LC223
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC110
	.quad	25
	.quad	64
	.quad	.LC224
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC140
	.quad	13
	.quad	64
	.quad	.LC225
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC19
	.quad	4
	.quad	64
	.quad	.LC226
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC50
	.quad	26
	.quad	64
	.quad	.LC227
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC72
	.quad	3
	.quad	64
	.quad	.LC228
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC88
	.quad	39
	.quad	96
	.quad	.LC229
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC66
	.quad	3
	.quad	64
	.quad	.LC230
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC63
	.quad	3
	.quad	64
	.quad	.LC231
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC64
	.quad	3
	.quad	64
	.quad	.LC232
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC113
	.quad	72
	.quad	128
	.quad	.LC233
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC15
	.quad	2
	.quad	64
	.quad	.LC234
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC120
	.quad	2
	.quad	64
	.quad	.LC235
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC119
	.quad	12
	.quad	64
	.quad	.LC236
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC78
	.quad	38
	.quad	96
	.quad	.LC237
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC122
	.quad	31
	.quad	64
	.quad	.LC238
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC4
	.quad	37
	.quad	96
	.quad	.LC239
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC124
	.quad	74
	.quad	128
	.quad	.LC240
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC16
	.quad	5
	.quad	64
	.quad	.LC241
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC67
	.quad	5
	.quad	64
	.quad	.LC242
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC21
	.quad	9
	.quad	64
	.quad	.LC243
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC41
	.quad	8
	.quad	64
	.quad	.LC244
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC65
	.quad	5
	.quad	64
	.quad	.LC245
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC25
	.quad	9
	.quad	64
	.quad	.LC246
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC85
	.quad	22
	.quad	64
	.quad	.LC247
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC32
	.quad	9
	.quad	64
	.quad	.LC248
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC48
	.quad	1
	.quad	64
	.quad	.LC249
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC117
	.quad	6
	.quad	64
	.quad	.LC250
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC125
	.quad	79
	.quad	128
	.quad	.LC251
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC104
	.quad	25
	.quad	64
	.quad	.LC252
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC99
	.quad	25
	.quad	64
	.quad	.LC253
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC138
	.quad	58
	.quad	96
	.quad	.LC254
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC94
	.quad	35
	.quad	96
	.quad	.LC255
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC74
	.quad	11
	.quad	64
	.quad	.LC256
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC8
	.quad	39
	.quad	96
	.quad	.LC257
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC133
	.quad	30
	.quad	64
	.quad	.LC258
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC70
	.quad	3
	.quad	64
	.quad	.LC259
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC81
	.quad	44
	.quad	96
	.quad	.LC260
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC53
	.quad	3
	.quad	64
	.quad	.LC261
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC68
	.quad	3
	.quad	64
	.quad	.LC262
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC57
	.quad	3
	.quad	64
	.quad	.LC263
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC134
	.quad	15
	.quad	64
	.quad	.LC264
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC89
	.quad	56
	.quad	96
	.quad	.LC265
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC139
	.quad	38
	.quad	96
	.quad	.LC266
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC2
	.quad	62
	.quad	96
	.quad	.LC267
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC92
	.quad	33
	.quad	96
	.quad	.LC268
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC5
	.quad	34
	.quad	96
	.quad	.LC269
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC93
	.quad	43
	.quad	96
	.quad	.LC270
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC132
	.quad	36
	.quad	96
	.quad	.LC271
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC97
	.quad	33
	.quad	96
	.quad	.LC272
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC90
	.quad	8
	.quad	64
	.quad	.LC273
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC22
	.quad	9
	.quad	64
	.quad	.LC274
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC58
	.quad	5
	.quad	64
	.quad	.LC275
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC9
	.quad	5
	.quad	64
	.quad	.LC276
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC114
	.quad	20
	.quad	64
	.quad	.LC277
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC111
	.quad	10
	.quad	64
	.quad	.LC278
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC86
	.quad	22
	.quad	64
	.quad	.LC279
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC33
	.quad	10
	.quad	64
	.quad	.LC280
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC130
	.quad	30
	.quad	64
	.quad	.LC281
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC43
	.quad	8
	.quad	64
	.quad	.LC282
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC26
	.quad	11
	.quad	64
	.quad	.LC283
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC87
	.quad	36
	.quad	96
	.quad	.LC284
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC91
	.quad	25
	.quad	64
	.quad	.LC285
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC51
	.quad	3
	.quad	64
	.quad	.LC286
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC71
	.quad	3
	.quad	64
	.quad	.LC287
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC37
	.quad	8
	.quad	64
	.quad	.LC288
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC52
	.quad	3
	.quad	64
	.quad	.LC289
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC59
	.quad	3
	.quad	64
	.quad	.LC290
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC36
	.quad	6
	.quad	64
	.quad	.LC291
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC27
	.quad	5
	.quad	64
	.quad	.LC292
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC12
	.quad	31
	.quad	64
	.quad	.LC293
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC13
	.quad	36
	.quad	96
	.quad	.LC294
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC108
	.quad	34
	.quad	96
	.quad	.LC295
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC23
	.quad	8
	.quad	64
	.quad	.LC296
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC112
	.quad	67
	.quad	128
	.quad	.LC297
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.quad	.LC17
	.quad	6
	.quad	64
	.quad	.LC298
	.quad	.LC141
	.quad	0
	.quad	0
	.quad	0
	.section	.text.exit,"ax",@progbits
	.p2align 4,,15
	.type	_GLOBAL__sub_D_00099_0_terminate, @function
_GLOBAL__sub_D_00099_0_terminate:
.LFB38:
	.cfi_startproc
	movl	$168, %esi
	movl	$.LASAN0, %edi
	jmp	__asan_unregister_globals
	.cfi_endproc
.LFE38:
	.size	_GLOBAL__sub_D_00099_0_terminate, .-_GLOBAL__sub_D_00099_0_terminate
	.section	.fini_array.00099,"aw"
	.align 8
	.quad	_GLOBAL__sub_D_00099_0_terminate
	.section	.text.startup
	.p2align 4,,15
	.type	_GLOBAL__sub_I_00099_1_terminate, @function
_GLOBAL__sub_I_00099_1_terminate:
.LFB39:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	__asan_init
	call	__asan_version_mismatch_check_v8
	movl	$168, %esi
	movl	$.LASAN0, %edi
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	jmp	__asan_register_globals
	.cfi_endproc
.LFE39:
	.size	_GLOBAL__sub_I_00099_1_terminate, .-_GLOBAL__sub_I_00099_1_terminate
	.section	.init_array.00099,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_00099_1_terminate
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC45:
	.quad	-723401728380766731
	.quad	-723401728380766731
	.ident	"GCC: (GNU) 7.2.0"
	.section	.note.GNU-stack,"",@progbits
