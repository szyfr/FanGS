package logging


//= Imports
import "core:bytes"
import "core:fmt"
import "core:os"


//= Global
outputLog : [dynamic]string


//= Procedures

//* Append a string to the end of the log
add_to_log :: proc(input: string) {
	append(&outputLog, input)
}

//* Print log to file
print_log :: proc() {

	buffer: bytes.Buffer = {}

	for i:=0; i<len(outputLog); i+=1 {
		bytes.buffer_write_string(&buffer, outputLog[i])
		bytes.buffer_write_byte(&buffer, '\n')
	}
	bytes.buffer_write_byte(&buffer, 0)

	output := bytes.buffer_to_bytes(&buffer)
	fmt.printf("%s",output)

	os.write_entire_file("data/log.txt", output)

	delete(output)
	delete(outputLog)
}