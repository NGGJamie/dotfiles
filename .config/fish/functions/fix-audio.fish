function fix-audio
	pactl load-module module-loopback;
	sleep 1;
	pactl unload-module module-loopback;
end
