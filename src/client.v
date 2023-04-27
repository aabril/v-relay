import net.websocket


// start_client starts the websocket client, it writes a message to
// the server and prints all the messages received
fn start_client() ! {
	mut ws := websocket.new_client('ws://localhost:30000')!
	defer {
		unsafe {
			ws.free()
		}
	}
	// mut ws := websocket.new_client('wss://echo.websocket.org:443')?
	// use on_open_ref if you want to send any reference object
	ws.on_open(fn (mut ws websocket.Client) ! {
		clog('ws.on_open')
	})
	// use on_error_ref if you want to send any reference object
	ws.on_error(fn (mut ws websocket.Client, err string) ! {
		clog('ws.on_error error: ${err}')
	})
	// use on_close_ref if you want to send any reference object
	ws.on_close(fn (mut ws websocket.Client, code int, reason string) ! {
		clog('ws.on_close')
	})
	// use on_message_ref if you want to send any reference object
	ws.on_message(fn (mut ws websocket.Client, msg &websocket.Message) ! {
		if msg.payload.len > 0 {
			message := msg.payload.bytestr()
			clog('ws.on_message client got type: ${msg.opcode} payload: `${message}`')
		}
	})
	// you can add any pointer reference to use in callback
	// t := TestRef{count: 10}
	// ws.on_message_ref(fn (mut ws websocket.Client, msg &websocket.Message, r &SomeRef) ? {
	// // eprintln('type: $msg.opcode payload:\n$msg.payload ref: $r')
	// }, &r)
	ws.connect() or {
		clog('ws.connect err: ${err}')
		return err
	}
	clog('ws.connect succeeded')
	spawn write_echo(mut ws) // or { println('error on write_echo $err') }
	ws.listen() or {
		clog('ws.listen err: ${err}')
		return err
	}
	clog('ws.listen finished')
}
