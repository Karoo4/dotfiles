function trimvid
    if test (count $argv) -lt 4
        echo "Usage: trimvid <input> <start> <end> <output>"
        echo "Example: trimvid video.mp4 00:01:20 00:02:45 cut.mp4"
        return 1
    end
    
    set input $argv[1]
    set start $argv[2]
    set end $argv[3]
    set output $argv[4]
    
    ffmpeg -i "$input" -ss "$start" -to "$end" -c copy "$output"
end
