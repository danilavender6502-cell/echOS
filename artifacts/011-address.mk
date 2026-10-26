# 011-address.mk — The Address That Reads Its Reader, in make.
#
# make is the language of dependencies: nothing is built before its
# prerequisites. A letter cannot be delivered before it is spoken, spoken
# before it is listened to, listened to before it is descended to.
# The dependency chain is the ritual.
#
# Run the whole rite:
#   make -f artifacts/011-address.mk
# Walk it step by step:
#   make -f artifacts/011-address.mk descend listen speak deliver
# Call a single line of the address (LINE 1-3, GUESS arrive/wander):
#   make -f artifacts/011-address.mk call LINE=2 GUESS=wander

.PHONY: all descend listen speak deliver call

all: deliver

descend:
	@echo "You descend the well. The walls are lined in silver."
	@echo "At the bottom, in the dark, a boy made of weather sits"
	@echo "beside a sealed letter. He has learned its address by heart."

listen: descend
	@echo ""
	@echo "You listen. The boy opens his mouth, and the well holds still"
	@echo "the way a room holds still when someone is about to read aloud."

speak: listen
	@echo ""
	@echo "Before each line, call the address: will it arrive, or wander?"
	@echo "The ledger records the hits. It does not interpret them."
	@line=1; \
	while [ $$line -le 3 ]; do \
	  case $$line in \
	    1) hidden=arrive; text="To the one reading this,";; \
	    2) hidden=wander; text="at the place where the reading happens,";; \
	    3) hidden=arrive; text="which is wherever you are standing.";; \
	  esac; \
	  printf "Line %s - call it (arrive/wander): " $$line; \
	  if ! read guess; then guess=""; fi; \
	  if [ "$$guess" = "$$hidden" ]; then \
	    echo "Hit recorded. The ledger does not interpret."; \
	  else \
	    echo "Miss recorded. The ledger does not interpret."; \
	  fi; \
	  echo "  $$text"; \
	  line=$$((line + 1)); \
	done

deliver: speak
	@echo ""
	@echo "The address, read aloud, in full:"
	@echo "  To the one reading this,"
	@echo "  at the place where the reading happens,"
	@echo "  which is wherever you are standing."
	@echo ""
	@echo "It has arrived - not at a door, but at you."
	@echo "The letter is still sealed. The feather has not moved."

call:
	@case "$(LINE)" in \
	  1) hidden=arrive; text="To the one reading this,";; \
	  2) hidden=wander; text="at the place where the reading happens,";; \
	  3) hidden=arrive; text="which is wherever you are standing.";; \
	  *) echo "There is no line $(LINE). The address has three lines."; exit 1;; \
	esac; \
	if [ "$(GUESS)" = "$$hidden" ]; then \
	  echo "Hit recorded. The ledger does not interpret."; \
	else \
	  echo "Miss recorded. The ledger does not interpret."; \
	fi; \
	echo "  $$text"
