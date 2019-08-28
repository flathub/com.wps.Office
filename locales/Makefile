.PHONY: all clean dicts

all: dicts

dicts:
	tail -n +2 locales.csv | while IFS=, read -r lang dict_size dict_sha256 dict_name dict_summary dict_license; do \
		$(MAKE) com.wps.Office.spellcheck.$$lang.yml \
			DICT_SIZE="$$dict_size" \
			DICT_SHA256="$$dict_sha256"; \
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

com.wps.Office.spellcheck.%.yml:
	sed \
		-e "s/@LANG@/$*/g" \
		-e "s/@DICT_SHA256@/$(DICT_SHA256)/g" \
		-e "s/@DICT_SIZE@/$(DICT_SIZE)/g" \
		com.wps.Office.spellcheck.@LANG@.yml.in > $@

clean-manifests:
	rm -f com.wps.Office.spellcheck.*.yml

clean-metainfo:
	rm -f com.wps.Office.spellcheck.*.metainfo.xml

clean: clean-manifests clean-metainfo
