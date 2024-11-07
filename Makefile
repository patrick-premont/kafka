# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#Runs the compile and checkstyle error check
.PHONY: compile-validate
compile-validate:
	./retry_zinc ./gradlew clean -PskipSigning=true publishToMavenLocal build -x test --no-daemon --stacktrace -PxmlSpotBugsReport=true 2>&1 | tee build.log
	@error_count=$$(grep -c -E "(ERROR|error:|\[Error\]|FAILED)" build.log); \
	if [ $$error_count -ne 0 ]; then \
		echo "Compile, checkstyle or spotbugs error found"; \
		grep -E "(ERROR|error:|\[Error\]|FAILED)" build.log | while read -r line; do \
			echo "$$line"; \
		done; \
		echo "Number of compile, checkstyle and spotbug errors: $$error_count"; \
		exit $$error_count; \
	else \
		echo "No errors found"; \
	fi

#Check compilation compatibility with Scala 2.12
.PHONY: check-scala-compatibility
check-scala-compatibility:
	./retry_zinc ./gradlew clean build -x test --no-daemon --stacktrace -PxmlSpotBugsReport=true -PscalaVersion=2.12 2>&1 | tee build.log
	@error_count=$$(grep -c -E "(ERROR|error:|\[Error\]|FAILED)" build.log); \
	if [ $$error_count -ne 0 ]; then \
		grep -E "(ERROR|error:|\[Error\]|FAILED)" build.log | while read -r line; do \
			echo "$$line"; \
		done; \
		echo "Number of compile, checkstyle and spotbug errors: $$error_count"; \
		exit $$error_count; \
	else \
		echo "No errors found"; \
	fi
# Below targets are used during kafka packaging for debian.

.PHONY: clean
clean:

.PHONY: distclean
distclean:

%:
	$(MAKE) -f debian/Makefile $@
