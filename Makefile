CC := g++
CFLAGS := -g -Wall -Wextra -std=c++2a
LDFLAGS :=
LIBS :=
INCLUDE :=
SRC_DIR := ./src
OBJ_DIR := ./obj
SOURCES := $(shell ls $(SRC_DIR)/*.cpp)
OBJS := $(subst $(SRC_DIR),$(OBJ_DIR), $(SOURCES:.cpp=.o)) 
TARGET := oyainput
SUPERUSER := root
VERSION := 1.2
INST_LIB_DIR := /usr/local/lib/oyainput$(VERSION)
INST_BIN_DIR := /usr/local/bin


$(TARGET): $(OBJS) $(LIBS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@if [ ! -d $(OBJ_DIR) ]; \
		then echo "mkdir -p $(OBJ_DIR)" ; \
		mkdir -p $(OBJ_DIR); fi
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $<


all: $(TARGET)
	chown $(SUPERUSER) $(TARGET)
	chmod u+s $(TARGET)

install:
	chown $(SUPERUSER) $(TARGET)
	chmod u+s $(TARGET)	
	@if [ ! -e $(INST_LIB_DIR) ]; then \
		echo "mkdir -p $(INST_LIB_DIR)" ; \
		mkdir -p $(INST_LIB_DIR) ; fi
	cp -f $(TARGET) $(INST_LIB_DIR)/
	chown $(SUPERUSER) $(INST_LIB_DIR)/$(TARGET)
	chmod u+s $(INST_LIB_DIR)/$(TARGET)	
	ln -s -f $(INST_LIB_DIR)/$(TARGET) $(INST_BIN_DIR)/$(TARGET)
	@echo "install success."

clean:
	$(RM) $(OBJS) $(TARGET) 
	@if [ -e $(OBJ_DIR) ]; then \
		echo "rmdir $(OBJ_DIR)"; \
		rmdir $(OBJ_DIR); fi
	@echo "clean success."

uninstall:
	@if [ -e $(INST_BIN_DIR)/$(TARGET) ]; then \
		echo "rm -f $(INST_BIN_DIR)/$(TARGET)" ; \
		rm -f $(INST_BIN_DIR)/$(TARGET) ; fi
	@if [ -e $(INST_LIB_DIR) ]; then \
		echo "rm -Rf $(INST_LIB_DIR)" ; \
		rm -Rf $(INST_LIB_DIR) ; fi
	@echo "uninstall success."

