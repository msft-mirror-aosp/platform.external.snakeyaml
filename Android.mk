# Copyright (C) 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Build support for snakeyaml within the Android Open Source Project
# See https://source.android.com/source/building.html for more information
#

LOCAL_PATH := $(call my-dir)

# List of all files that need to be patched (see src/patches/android)
snakeyaml_need_patch_src_files := \
            src/main/java/org/yaml/snakeyaml/extensions/compactnotation/CompactConstructor.java \
            src/main/java/org/yaml/snakeyaml/constructor/Constructor.java \
            src/main/java/org/yaml/snakeyaml/introspector/PropertyUtils.java \
            src/main/java/org/yaml/snakeyaml/representer/Representer.java
# List of all files that are unsupported on android (see pom.xml)
snakeyaml_unsupported_android_src_files := \
            src/main/java/org/yaml/snakeyaml/introspector/MethodProperty.java
snakeyaml_src_files_unfiltered := $(call all-java-files-under, src/main)
# We omit the list of files that need to be patched because those are included by LOCAL_GENERATED_SOURCES instead.
snakeyaml_src_files := $(filter-out $(snakeyaml_need_patch_src_files) $(snakeyaml_unsupported_android_src_files),$(snakeyaml_src_files_unfiltered))

# Host-side Java build
include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(snakeyaml_src_files_unfiltered)
LOCAL_MODULE := snakeyaml-host
include $(BUILD_HOST_JAVA_LIBRARY)

# Host-side Dalvik build
include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(snakeyaml_src_files)
LOCAL_MODULE := snakeyaml-hostdex
LOCAL_MODULE_CLASS := JAVA_LIBRARIES

# Apply all of the Android patches in src/patches/android by running patch-android-src script on them.
intermediates:= $(local-generated-sources-dir)
GEN := $(addprefix $(intermediates)/, $(snakeyaml_need_patch_src_files)) # List of all files that need to be patched.
$(GEN) : PRIVATE_PATH := $(LOCAL_PATH)
$(GEN) : PRIVATE_CUSTOM_TOOL = $(PRIVATE_PATH)/patch-android-src $(PRIVATE_PATH)/ $< $@
$(GEN): $(intermediates)/%.java : $(LOCAL_PATH)/%.java $(LOCAL_PATH)/patch-android-src
	$(transform-generated-source)
LOCAL_GENERATED_SOURCES += $(GEN)

include $(BUILD_HOST_DALVIK_JAVA_LIBRARY)

# TODO: Consider adding tests.
