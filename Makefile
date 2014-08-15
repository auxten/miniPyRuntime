.PHONY: all makelib compile rm_config clean move check compile_static

all: download compile compile_static pack

download:
	#wget -qO - 'http://downloads.egenix.com/python/egenix-pyrun-1.1.0.tar.gz?baseurl=http%3A%2F%2Fdownloads.egenix.com%2Fpython%2F&product=egenix-pyrun&version=1.1.0&archive=tar.gz&dummy=' | tar xz
	tar xzvf egenix-pyrun-1.1.0.tar.gz
	#wget -qO - 'http://upx.sourceforge.net/download/upx-3.08-amd64_linux.tar.bz2' | tar xj
	tar xjvf upx-3.08-amd64_linux.tar.bz2
	mv upx-3.08-amd64_linux/upx .
	#wget -q 'http://pypi.python.org/packages/source/d/distribute/distribute-0.6.32.tar.gz'

compile:
	cd egenix-pyrun-1.1.0/PyRun/ &&\
	make distribution

compile_static:
	cd egenix-pyrun-1.1.0/PyRun/Runtime &&\
	gcc -pthread  -Xlinker -export-dynamic *.o ../tmp-2.7-ucs2/lib/python2.7/config/libpython2.7.a -L/usr/lib64 -L/usr/lib     /usr/lib64/libssl.a /usr/lib64/libcrypto.a  -L/usr/kerberos/lib64 -lkrb5 -lkrb5support -lk5crypto  -L../tmp-2.7-ucs2/lib -lz -L/usr/lib64 -L/usr/lib /usr/lib64/libssl.a /usr/lib64/libcrypto.a  -DMODULE_NAME='"sqlite3"' -DSQLITE_OMIT_LOAD_EXTENSION  -L../tmp-2.7-ucs2/lib -lsqlite3  -lbz2  -lpthread -ldl  -lutil -lm  -o pyrun2.7 
	cp egenix-pyrun-1.1.0/PyRun/Runtime/pyrun2.7 egenix-pyrun-1.1.0/PyRun/build-2.7-ucs2/dist/bin

pack:
	rm -rf dist
	cp -r egenix-pyrun-1.1.0/PyRun/build-2.7-ucs2/dist dist
	cp distribute-0.6.32.tar.gz dist/
	cp distribute_setup.py dist/
	cp install-minipy dist/
	strip dist/bin/pyrun2.7
	rm dist/lib/python2.7/lib-dynload/audioop.so
	rm dist/lib/python2.7/lib-dynload/linuxaudiodev.so
	rm dist/lib/python2.7/lib-dynload/ossaudiodev.so
	strip dist/lib/python2.7/lib-dynload/*.so
	./upx -9 dist/bin/pyrun2.7
	mv dist/bin/pyrun2.7 dist/bin/python2.7
	rm dist/bin/pyrun
	rm dist/bin/pyrun2.7-debug
	ln -s python2.7 dist/bin/python
	
	cd dist &&\
	tar czvfo miniPyPack.tgz bin include lib distribute-*.tar.gz distribute_setup.py &&\
	tar czvfo miniPy.tgz miniPyPack.tgz install-minipy

