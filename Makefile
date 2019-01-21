include .make/Makefile

vignettes/future.apply-1-overview.md.rsp: inst/vignettes-static/future.apply-1-overview.md.rsp.rsp
	$(CD) $(@D); \
	$(R_SCRIPT) -e "R.rsp::rfile" ../$< --postprocess=FALSE
	$(RM) README.md
	$(MAKE) README.md

vigs: vignettes/future.apply-1-overview.md.rsp

future.tests/future.clustermq/%:
	$(R_SCRIPT) -e "options(clustermq.ssh.host='localhost')" -e "options(clustermq.scheduler='$*')" -e "future.tests::check" --args --test-plan=future.clustermq::clustermq --test-timeout=240

future.tests/%:
	$(R_SCRIPT) -e "options(clustermq.scheduler='multicore')" -e "future.tests::check" --args --test-plan=$*

future.tests: future.tests/future.clustermq\:\:clustermq
