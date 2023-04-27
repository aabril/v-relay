module main

import time
import term
import net.websocket

fn main() {
	spawn start_server()
	time.sleep(100 * time.millisecond)
	start_client()!
}

fn slog(message string) {
	eprintln(term.colorize(term.bright_yellow, message))
}

fn clog(message string) {
	eprintln(term.colorize(term.cyan, message))
}

fn wlog(message string) {
	eprintln(term.colorize(term.bright_blue, message))
}


fn write_echo(mut ws websocket.Client) ! {
	wlog('write_echo, start')
	message := 'echo this'
	for i := 0; i <= 5; i++ {
		// Server will send pings every 30 seconds
		wlog('write_echo, writing message: `${message}` ...')
		ws.write_string(message) or {
			wlog('write_echo, ws.write_string err: ${err}')
			return err
		}
		time.sleep(100 * time.millisecond)
	}
	ws.close(1000, 'normal') or {
		wlog('write_echo, close err: ${err}')
		return err
	}
	wlog('write_echo, done')
}
