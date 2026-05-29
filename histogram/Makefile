HIP_PATH?= /opt/rocm/hip
HIPCC=$(HIP_PATH)/bin/hipcc

BIN_DIR?= ./bin
IMAGE_HEADER?= lena_gray_bmp.h
SRC_FILES=$(wildcard *.cpp)
BIN_FILES=$(patsubst %.cpp,$(BIN_DIR)/%.bin,$(SRC_FILES))

all: $(BIN_FILES)

$(IMAGE_HEADER): lena_gray.bmp
	xxd -i $< > $@

$(BIN_DIR)/%.bin: %.cpp $(IMAGE_HEADER) $(BIN_DIR)
	$(HIPCC) $(CXXFLAGS) $< -o $@

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean:
	rm -rf $(BIN_DIR) $(IMAGE_HEADER)

.PHONY: all clean
