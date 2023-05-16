compile:
	java -jar ../jtb132di.jar -te minijava.jj
	java -jar ../javacc5.jar minijava-jtb.jj
	javac Main.java

execute:
	java Main ./tests/Example.java

test:
	# ./parsing_test.sh
	# ./offsets_test.sh
	# ./llvm_test.sh

clean:
	rm -f *.class *~ ./*/*.class