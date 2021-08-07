DICTS_URL ?= http://download.services.openoffice.org/files/contrib/dictionaries

.PHONY: all clean dicts

data/%.url:
	mkdir -p $(@D)
	echo $(DICTS_URL)/$*.zip > $@

data/%.zip: data/%.url
	wget $(shell cat $<) -O $@

data/%.size: data/%.zip
	stat --format='%s' $< > $@

data/%.sha256: data/%.zip
	sha256sum $< | awk '{ print $$1 }' > $@

all: dicts

dicts:
	tail -n +2 locales.csv | while IFS=, read -r lang dict_name dict_summary dict_license; do \
		$(MAKE) com.wps.Office.spellcheck.$$lang.yml && \
		$(MAKE) com.wps.Office.spellcheck.$$lang.metainfo.xml \
			DICT_NAME="$$dict_name" \
			DICT_SUMMARY="$$dict_summary" \
			DICT_LICENSE="$$dict_license"; \
	done

com.wps.Office.spellcheck.%.metainfo.xml:
	sed \
		-e "s/@LANG@/$*/g" \
		-e "s/@DICT_NAME@/$(DICT_NAME)/g" \
		-e "s/@DICT_SUMMARY@/$(DICT_SUMMARY)/g" \
		-e "s/@DICT_LICENSE@/$(DICT_LICENSE)/g" \
		com.wps.Office.spellcheck.@LANG@.metainfo.xml.in > $@

com.wps.Office.spellcheck.%.yml: data/%.url data/%.size data/%.sha256
	sed \
		-e "s/@LANG@/$*/g" \
		-e "s|@DICT_URL@|$(shell cat data/$*.url)|g" \
		-e "s/@DICT_SHA256@/$(shell cat data/$*.sha256)/g" \
		-e "s/@DICT_SIZE@/$(shell cat data/$*.size)/g" \
		com.wps.Office.spellcheck.@LANG@.yml.in > $@

clean-manifests:
	rm -f com.wps.Office.spellcheck.*.yml

clean-metainfo:
	rm -f com.wps.Office.spellcheck.*.metainfo.xml

clean: clean-manifests clean-metainfo
