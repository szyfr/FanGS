package logging


//= Imports
import "core:bytes"
import "core:fmt"
import "core:time"
import "core:strings"
import "core:os"


//= Procedures
//* Initializes logs
create_log :: proc() {
	if os.exists("data/log.txt") do os.remove("data/log.txt")
	now := time.now()

	bytBuffer : bytes.Buffer
	strBuffer : strings.Builder

	fmt.sbprintf(&strBuffer, "LOG: %i/%i/%i", time.year(now), time.month(now), time.day(now))
	bytes.buffer_write_string(&bytBuffer, strings.to_string(strBuffer))

	os.write_entire_file("data/log.txt", bytes.buffer_to_bytes(&bytBuffer))

	bytes.buffer_destroy(&bytBuffer)
//	strings.builder_destroy(&strBuffer)
}

//* Append a string to the end of the log
add_to_log :: proc(input : string) {
	data, result := os.read_entire_file("data/log.txt")
	if !result do return

	buffer : bytes.Buffer
	bytes.buffer_init(&buffer, data)
	bytes.buffer_write_byte(&buffer, '\n')

	builder : strings.Builder
	hour, min, sec := time.clock_from_time(time.now())
	fmt.sbprintf(&builder, "[%i:%i:%i]", hour, min, sec)
	bytes.buffer_write_string(&buffer, strings.to_string(builder))

	bytes.buffer_write_string(&buffer, input)

	os.write_entire_file("data/log.txt", bytes.buffer_to_bytes(&buffer))
}