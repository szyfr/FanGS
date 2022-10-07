package logging


//= Imports
import "core:bytes"
import "core:fmt"
import "core:time"
import "core:strings"
import "core:os"


//= Constants
LOG_LOCATION :: "log.txt"


//= Procedures

//* Initializes logs
create_log :: proc() {
	//* If log already exists, delete it
	if os.exists(LOG_LOCATION) do os.remove(LOG_LOCATION)

	now            := time.now()
	hour, min, sec := time.clock_from_time(time.now())
	bytBuffer      :  bytes.Buffer
	strBuffer      :  strings.Builder

	//* Generate string and convert to byte array
	fmt.sbprintf(
		&strBuffer,
		"Creation Date: %i/%i/%i | %v:%v:%v | UTC",
		time.year(now), time.month(now), time.day(now),
		hour, min, sec,
	)
	bytes.buffer_write_string(&bytBuffer, strings.to_string(strBuffer))

	//* Save byte array to file
	os.write_entire_file(LOG_LOCATION, bytes.buffer_to_bytes(&bytBuffer))

	//* Clean up buffer
	bytes.buffer_destroy(&bytBuffer)
}

//* Append a string to the end of the log
add_to_log :: proc(input : string) {
	//* Check for log
	data, result := os.read_entire_file(LOG_LOCATION)
	if !result do return

	//* Initialize buffer
	buffer : bytes.Buffer
	bytes.buffer_init(&buffer, data)
	bytes.buffer_write_byte(&buffer, '\n')

	//* Get current time
	builder : strings.Builder
	hour, min, sec := time.clock_from_time(time.now())

	//* Concatanate strings
	fmt.sbprintf(&builder, "[%i:%i:%i]", hour, min, sec)
	bytes.buffer_write_string(&buffer, strings.to_string(builder))
	bytes.buffer_write_string(&buffer, input)

	//* Append to file
	os.write_entire_file(LOG_LOCATION, bytes.buffer_to_bytes(&buffer))
}